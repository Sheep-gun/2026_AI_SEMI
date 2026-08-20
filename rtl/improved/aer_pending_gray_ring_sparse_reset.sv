`timescale 1ns/1ps

// P8-GR: sparse-reset P8 transport with strict reflected-Gray round-robin.
// out_addr_q doubles as the last-grant pointer, removing the separate four-bit
// epoch register.  It is therefore the only payload register that must retain
// a deterministic reset (Gray rank 15/source address 8).  Request synchronizer
// stages remain resetless and the ACK/pending/valid core keeps robust reset.
module aer_pending_gray_ring_sparse_reset (
    input  logic        clk,
    input  logic        rst_n,
    input  logic [15:0] src_req_async,
    output logic [15:0] src_ack_async,
    output logic [3:0]  out_addr,
    output logic        out_valid,
    input  logic        out_ready
);
    (* ASYNC_REG = "TRUE" *) logic [1:0] reset_release_q;
    (* ASYNC_REG = "TRUE" *) logic [15:0] req_meta_q,req_sync_q;
    logic core_rst_n;
    logic [15:0] ack_q,ack_d,pending_q,pending_d,candidate;
    logic [3:0] out_addr_q,out_addr_d,selected_addr;
    logic out_valid_q,out_valid_d,grant_valid,can_load_output;
    logic [4:0] selection;
    integer source_index;

    function automatic [2:0] fp4(input logic [3:0] req);
        logic [1:0] index;
        begin
            if(req[0])index=0;else if(req[1])index=1;
            else if(req[2])index=2;else index=3;
            fp4={|req,index};
        end
    endfunction

    function automatic [2:0] rr4(
        input logic [3:0] req,input logic [1:0] ptr);
        logic [1:0] index;
        begin
            case(ptr)
                0:if(req[0])index=0;else if(req[1])index=1;
                  else if(req[2])index=2;else index=3;
                1:if(req[1])index=1;else if(req[2])index=2;
                  else if(req[3])index=3;else index=0;
                2:if(req[2])index=2;else if(req[3])index=3;
                  else if(req[0])index=0;else index=1;
                default:if(req[3])index=3;else if(req[0])index=0;
                        else if(req[1])index=1;else index=2;
            endcase
            rr4={|req,index};
        end
    endfunction

    // Searches cyclic Gray rank strictly after the actual last grant.  The
    // 4x4 grouped form avoids a 16-bit arithmetic mask/carry chain.
    function automatic [4:0] gray_ring_select(
        input logic [15:0] mask,input logic [3:0] last);
        logic [15:0] rank_req;
        logic [3:0] last_rank,start_rank,start_req,tail_mask,tail_req;
        logic [3:0] group_v,selected_req,grant_rank,grant_source;
        logic [1:0] start_group,start_lane,next_group;
        logic [2:0] tail_pick,group_pick,lane_pick;
        begin
            // Gray rank -> source address:
            // 0,1,3,2,6,7,5,4,12,13,15,14,10,11,9,8.
            rank_req[0]=mask[0];rank_req[1]=mask[1];
            rank_req[2]=mask[3];rank_req[3]=mask[2];
            rank_req[4]=mask[6];rank_req[5]=mask[7];
            rank_req[6]=mask[5];rank_req[7]=mask[4];
            rank_req[8]=mask[12];rank_req[9]=mask[13];
            rank_req[10]=mask[15];rank_req[11]=mask[14];
            rank_req[12]=mask[10];rank_req[13]=mask[11];
            rank_req[14]=mask[9];rank_req[15]=mask[8];

            last_rank[3]=last[3];
            last_rank[2]=last[3]^last[2];
            last_rank[1]=last[3]^last[2]^last[1];
            last_rank[0]=last[3]^last[2]^last[1]^last[0];
            start_rank=last_rank+1'b1;
            start_group=start_rank[3:2];start_lane=start_rank[1:0];
            next_group=start_group+1'b1;

            group_v[0]=|rank_req[3:0];group_v[1]=|rank_req[7:4];
            group_v[2]=|rank_req[11:8];group_v[3]=|rank_req[15:12];
            case(start_group)
                0:start_req=rank_req[3:0];1:start_req=rank_req[7:4];
                2:start_req=rank_req[11:8];default:start_req=rank_req[15:12];
            endcase
            case(start_lane)
                0:tail_mask=4'b1111;1:tail_mask=4'b1110;
                2:tail_mask=4'b1100;default:tail_mask=4'b1000;
            endcase
            tail_req=start_req&tail_mask;
            tail_pick=fp4(tail_req);
            group_pick=rr4(group_v,next_group);
            case(group_pick[1:0])
                0:selected_req=rank_req[3:0];1:selected_req=rank_req[7:4];
                2:selected_req=rank_req[11:8];default:selected_req=rank_req[15:12];
            endcase
            lane_pick=fp4(selected_req);
            grant_rank=tail_pick[2]?{start_group,tail_pick[1:0]}:
                                      {group_pick[1:0],lane_pick[1:0]};
            grant_source=grant_rank^(grant_rank>>1);
            gray_ring_select={|mask,grant_source};
        end
    endfunction

    always_ff @(posedge clk or negedge rst_n)begin
        if(!rst_n)reset_release_q<=2'b00;
        else reset_release_q<={reset_release_q[0],1'b1};
    end
    assign core_rst_n=reset_release_q[1];

    always_comb begin
        ack_d=ack_q;pending_d=pending_q;out_addr_d=out_addr_q;
        out_valid_d=out_valid_q;
        for(source_index=0;source_index<16;source_index=source_index+1)begin
            if(ack_q[source_index])begin
                if(!req_sync_q[source_index])ack_d[source_index]=1'b0;
            end else if(req_sync_q[source_index]&&!pending_d[source_index])begin
                pending_d[source_index]=1'b1;
                ack_d[source_index]=1'b1;
            end
        end

        candidate=pending_d;
        selection=gray_ring_select(candidate,out_addr_q);
        grant_valid=selection[4];selected_addr=selection[3:0];
        can_load_output=!out_valid_q||out_ready;
        if(can_load_output)begin
            if(grant_valid)begin
                out_valid_d=1'b1;
                out_addr_d=selected_addr;
                pending_d[selected_addr]=1'b0;
            end else out_valid_d=1'b0;
        end
    end

    always_ff @(posedge clk)begin
        req_meta_q<=src_req_async;
        req_sync_q<=req_meta_q;
    end

    always_ff @(posedge clk or negedge core_rst_n)begin
        if(!core_rst_n)begin
            ack_q<='0;pending_q<='0;out_addr_q<=4'h8;out_valid_q<=1'b0;
        end else begin
            ack_q<=ack_d;pending_q<=pending_d;
            out_addr_q<=out_addr_d;out_valid_q<=out_valid_d;
        end
    end

    assign src_ack_async=ack_q;
    assign out_addr=out_addr_q;
    assign out_valid=out_valid_q;
endmodule
