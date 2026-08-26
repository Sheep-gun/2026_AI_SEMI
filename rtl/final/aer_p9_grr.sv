`timescale 1ns/1ps

// P9-GRR: strict reflected-Gray round-robin with only one four-bit state.
// The register holds a binary Gray-rank, not the externally visible address.
// A fixed wire permutation maps source candidates into rank order and a
// three-XOR encoder drives the address bus.  Thus no Gray-to-binary feedback
// converter is needed and the rank register doubles as the output register.
module aer_gray_rank_ring_selector16 (
    input  logic [15:0] rank_candidate,
    input  logic [3:0]  last_rank,
    output logic         grant_valid,
    output logic [3:0]   grant_rank
);
    logic [1:0] last_group,last_lane,next_group;
    logic [3:0] group_valid,start_group_req,tail_mask,tail_req;
    logic [3:0] selected_group_req;
    logic [2:0] tail_pick,group_pick,lane_pick;

    function automatic [2:0] fp4(input logic [3:0] request);
        logic [1:0] index;
        begin
            if(request[0])index=2'd0;
            else if(request[1])index=2'd1;
            else if(request[2])index=2'd2;
            else index=2'd3;
            fp4={|request,index};
        end
    endfunction

    function automatic [2:0] rr4(
        input logic [3:0] request,input logic [1:0] first_index
    );
        logic [1:0] index;
        begin
            case(first_index)
                2'd0:if(request[0])index=0;else if(request[1])index=1;
                     else if(request[2])index=2;else index=3;
                2'd1:if(request[1])index=1;else if(request[2])index=2;
                     else if(request[3])index=3;else index=0;
                2'd2:if(request[2])index=2;else if(request[3])index=3;
                     else if(request[0])index=0;else index=1;
                default:if(request[3])index=3;else if(request[0])index=0;
                     else if(request[1])index=1;else index=2;
            endcase
            rr4={|request,index};
        end
    endfunction

    always_comb begin
        last_group=last_rank[3:2];
        last_lane=last_rank[1:0];
        next_group=last_group+1'b1;
        group_valid[0]=|rank_candidate[3:0];
        group_valid[1]=|rank_candidate[7:4];
        group_valid[2]=|rank_candidate[11:8];
        group_valid[3]=|rank_candidate[15:12];
        case(last_group)
            0:start_group_req=rank_candidate[3:0];
            1:start_group_req=rank_candidate[7:4];
            2:start_group_req=rank_candidate[11:8];
            default:start_group_req=rank_candidate[15:12];
        endcase
        case(last_lane)
            0:tail_mask=4'b1110;
            1:tail_mask=4'b1100;
            2:tail_mask=4'b1000;
            default:tail_mask=4'b0000;
        endcase
        tail_req=start_group_req&tail_mask;
        tail_pick=fp4(tail_req);
        group_pick=rr4(group_valid,next_group);
        case(group_pick[1:0])
            0:selected_group_req=rank_candidate[3:0];
            1:selected_group_req=rank_candidate[7:4];
            2:selected_group_req=rank_candidate[11:8];
            default:selected_group_req=rank_candidate[15:12];
        endcase
        lane_pick=fp4(selected_group_req);
        grant_valid=|rank_candidate;
        grant_rank=tail_pick[2]?{last_group,tail_pick[1:0]}:
                                {group_pick[1:0],lane_pick[1:0]};
    end
endmodule

module aer_pending_gray_rank_reuse_sync_core_reset (
    input  logic        clk,
    input  logic        rst_n,
    input  logic [15:0] src_req_async,
    output logic [15:0] src_ack_async,
    output logic [3:0]  out_addr,
    output logic        out_valid,
    input  logic        out_ready
);
    (* ASYNC_REG = "TRUE" *) logic [1:0] reset_release_q;
    logic core_rst_n;
    always_ff @(posedge clk or negedge rst_n)begin
        if(!rst_n)reset_release_q<=2'b00;
        else reset_release_q<={reset_release_q[0],1'b1};
    end
    assign core_rst_n=reset_release_q[1];

    (* ASYNC_REG = "TRUE" *) logic [15:0] req_meta_q,req_sync_q;
    logic [15:0] req_rank;
    logic [15:0] ack_rank_q,ack_rank_d;
    logic [15:0] pending_rank_q,pending_rank_d;
    logic [15:0] accept_rank,accepted_pending_rank;
    logic [15:0] ack_source;
    logic [3:0] out_rank_q,out_rank_d,selected_rank;
    logic out_valid_q,out_valid_d,grant_valid,can_load_output;

    // Rank-indexing the protocol storage makes the fixed Gray permutation pure
    // wiring.  In particular, clearing the granted pending bit no longer needs
    // selected-rank -> source-address XOR logic on the feedback path.
    // rank -> source Gray address:
    // 0,1,3,2,6,7,5,4,12,13,15,14,10,11,9,8.
    always_comb begin
        req_rank[0]=req_sync_q[0];
        req_rank[1]=req_sync_q[1];
        req_rank[2]=req_sync_q[3];
        req_rank[3]=req_sync_q[2];
        req_rank[4]=req_sync_q[6];
        req_rank[5]=req_sync_q[7];
        req_rank[6]=req_sync_q[5];
        req_rank[7]=req_sync_q[4];
        req_rank[8]=req_sync_q[12];
        req_rank[9]=req_sync_q[13];
        req_rank[10]=req_sync_q[15];
        req_rank[11]=req_sync_q[14];
        req_rank[12]=req_sync_q[10];
        req_rank[13]=req_sync_q[11];
        req_rank[14]=req_sync_q[9];
        req_rank[15]=req_sync_q[8];

        ack_source[0]=ack_rank_q[0];
        ack_source[1]=ack_rank_q[1];
        ack_source[2]=ack_rank_q[3];
        ack_source[3]=ack_rank_q[2];
        ack_source[4]=ack_rank_q[7];
        ack_source[5]=ack_rank_q[6];
        ack_source[6]=ack_rank_q[4];
        ack_source[7]=ack_rank_q[5];
        ack_source[8]=ack_rank_q[15];
        ack_source[9]=ack_rank_q[14];
        ack_source[10]=ack_rank_q[12];
        ack_source[11]=ack_rank_q[13];
        ack_source[12]=ack_rank_q[8];
        ack_source[13]=ack_rank_q[9];
        ack_source[14]=ack_rank_q[11];
        ack_source[15]=ack_rank_q[10];
    end

    aer_gray_rank_ring_selector16 selector(
        .rank_candidate(accepted_pending_rank),.last_rank(out_rank_q),
        .grant_valid(grant_valid),.grant_rank(selected_rank)
    );

    always_comb begin
        accept_rank=req_rank&~ack_rank_q&~pending_rank_q;
        accepted_pending_rank=pending_rank_q|accept_rank;
        ack_rank_d=(ack_rank_q&req_rank)|accept_rank;
        pending_rank_d=accepted_pending_rank;
        out_rank_d=out_rank_q;
        out_valid_d=out_valid_q;
        can_load_output=!out_valid_q||out_ready;
        if(can_load_output)begin
            if(grant_valid)begin
                out_valid_d=1'b1;
                out_rank_d=selected_rank;
                pending_rank_d[selected_rank]=1'b0;
            end else out_valid_d=1'b0;
        end
    end

    always_ff @(posedge clk)begin
        req_meta_q<=src_req_async;
        req_sync_q<=req_meta_q;
    end

    always_ff @(posedge clk)begin
        if(!core_rst_n)begin
            ack_rank_q<='0;
            pending_rank_q<='0;
            out_rank_q<=4'hf;
            out_valid_q<=1'b0;
        end else begin
            ack_rank_q<=ack_rank_d;
            pending_rank_q<=pending_rank_d;
            out_rank_q<=out_rank_d;
            out_valid_q<=out_valid_d;
        end
    end

    assign src_ack_async=ack_source&{16{core_rst_n}};
    assign out_addr=out_rank_q^(out_rank_q>>1);
    assign out_valid=out_valid_q&core_rst_n;
endmodule
