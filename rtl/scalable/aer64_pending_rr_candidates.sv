`timescale 1ns/1ps

// 64-source (8x8 logical sensor) strict-cyclic selector.
// Search order is the numeric ring last+1 ... 63,0 ... last.
module aer64_grouped_ring_selector (
    input  logic [63:0] candidate,
    input  logic [5:0]  last_rank,
    output logic         grant_valid,
    output logic [5:0]   grant_rank
);
    logic [2:0] last_row,last_col,next_row;
    logic [7:0] row_valid,start_row_req,tail_mask,tail_req,selected_row_req;
    logic [3:0] tail_pick,row_pick,col_pick;

    function automatic [3:0] fp8(input logic [7:0] request);
        logic [2:0] index;
        begin
            if(request[0])index=3'd0;
            else if(request[1])index=3'd1;
            else if(request[2])index=3'd2;
            else if(request[3])index=3'd3;
            else if(request[4])index=3'd4;
            else if(request[5])index=3'd5;
            else if(request[6])index=3'd6;
            else index=3'd7;
            fp8={|request,index};
        end
    endfunction

    function automatic [3:0] rr8(
        input logic [7:0] request,input logic [2:0] first_index
    );
        logic [2:0] index;
        begin
            case(first_index)
                3'd0:if(request[0])index=0;else if(request[1])index=1;else if(request[2])index=2;else if(request[3])index=3;else if(request[4])index=4;else if(request[5])index=5;else if(request[6])index=6;else index=7;
                3'd1:if(request[1])index=1;else if(request[2])index=2;else if(request[3])index=3;else if(request[4])index=4;else if(request[5])index=5;else if(request[6])index=6;else if(request[7])index=7;else index=0;
                3'd2:if(request[2])index=2;else if(request[3])index=3;else if(request[4])index=4;else if(request[5])index=5;else if(request[6])index=6;else if(request[7])index=7;else if(request[0])index=0;else index=1;
                3'd3:if(request[3])index=3;else if(request[4])index=4;else if(request[5])index=5;else if(request[6])index=6;else if(request[7])index=7;else if(request[0])index=0;else if(request[1])index=1;else index=2;
                3'd4:if(request[4])index=4;else if(request[5])index=5;else if(request[6])index=6;else if(request[7])index=7;else if(request[0])index=0;else if(request[1])index=1;else if(request[2])index=2;else index=3;
                3'd5:if(request[5])index=5;else if(request[6])index=6;else if(request[7])index=7;else if(request[0])index=0;else if(request[1])index=1;else if(request[2])index=2;else if(request[3])index=3;else index=4;
                3'd6:if(request[6])index=6;else if(request[7])index=7;else if(request[0])index=0;else if(request[1])index=1;else if(request[2])index=2;else if(request[3])index=3;else if(request[4])index=4;else index=5;
                default:if(request[7])index=7;else if(request[0])index=0;else if(request[1])index=1;else if(request[2])index=2;else if(request[3])index=3;else if(request[4])index=4;else if(request[5])index=5;else index=6;
            endcase
            rr8={|request,index};
        end
    endfunction

    always_comb begin
        last_row=last_rank[5:3];
        last_col=last_rank[2:0];
        next_row=last_row+1'b1;
        row_valid[0]=|candidate[7:0];
        row_valid[1]=|candidate[15:8];
        row_valid[2]=|candidate[23:16];
        row_valid[3]=|candidate[31:24];
        row_valid[4]=|candidate[39:32];
        row_valid[5]=|candidate[47:40];
        row_valid[6]=|candidate[55:48];
        row_valid[7]=|candidate[63:56];
        case(last_row)
            0:start_row_req=candidate[7:0];1:start_row_req=candidate[15:8];
            2:start_row_req=candidate[23:16];3:start_row_req=candidate[31:24];
            4:start_row_req=candidate[39:32];5:start_row_req=candidate[47:40];
            6:start_row_req=candidate[55:48];default:start_row_req=candidate[63:56];
        endcase
        case(last_col)
            0:tail_mask=8'b11111110;1:tail_mask=8'b11111100;
            2:tail_mask=8'b11111000;3:tail_mask=8'b11110000;
            4:tail_mask=8'b11100000;5:tail_mask=8'b11000000;
            6:tail_mask=8'b10000000;default:tail_mask=8'b00000000;
        endcase
        tail_req=start_row_req&tail_mask;
        tail_pick=fp8(tail_req);
        row_pick=rr8(row_valid,next_row);
        case(row_pick[2:0])
            0:selected_row_req=candidate[7:0];1:selected_row_req=candidate[15:8];
            2:selected_row_req=candidate[23:16];3:selected_row_req=candidate[31:24];
            4:selected_row_req=candidate[39:32];5:selected_row_req=candidate[47:40];
            6:selected_row_req=candidate[55:48];default:selected_row_req=candidate[63:56];
        endcase
        col_pick=fp8(selected_row_req);
        grant_valid=|candidate;
        grant_rank=tail_pick[3]?{last_row,tail_pick[2:0]}:
                                {row_pick[2:0],col_pick[2:0]};
    end
endmodule

// 64-source Improved Parallel Round-Robin Arbiter style selector.
// Each tree node computes its local choice in parallel; the final grant is the
// AND of the six path choices. The head vector is decoded from the same 6-bit
// output/last-grant register used by the grouped candidate.
module aer64_iprra_ring_selector (
    input  logic [63:0] candidate,
    input  logic [5:0]  last_rank,
    output logic         grant_valid,
    output logic [5:0]   grant_rank
);
    logic [63:0] head,grant_onehot;
    logic [5:0] head_rank;
    logic [31:0] s1_l1,s0_l1,gl_l1,gr_l1;
    logic [15:0] s1_l2,s0_l2,gl_l2,gr_l2;
    logic [7:0] s1_l3,s0_l3,gl_l3,gr_l3;
    logic [3:0] s1_l4,s0_l4,gl_l4,gr_l4;
    logic [1:0] s1_l5,s0_l5,gl_l5,gr_l5;
    logic s1_root,s0_root,gl_root,gr_root;
    integer i;

    function automatic [1:0] combine_state(
        input logic ls1,input logic ls0,input logic rs1,input logic rs0
    );
        begin
            combine_state[1]=ls1|rs1;
            combine_state[0]=rs0|(ls0&~rs1);
        end
    endfunction

    function automatic [1:0] local_branch(
        input logic ls1,input logic ls0,input logic rs1,input logic rs0
    );
        logic go_left,go_right;
        begin
            go_left=(ls0&~rs0)|(ls0&~rs1)|(ls1&~rs0);
            go_right=(~ls1&~ls0)|(~ls0&rs0)|(rs1&rs0);
            local_branch={go_left,go_right};
        end
    endfunction

    always_comb begin
        head_rank=last_rank+1'b1;
        head='0;
        head[head_rank]=1'b1;
        for(i=0;i<32;i=i+1)begin
            {s1_l1[i],s0_l1[i]}=combine_state(head[2*i],candidate[2*i],head[2*i+1],candidate[2*i+1]);
            {gl_l1[i],gr_l1[i]}=local_branch(head[2*i],candidate[2*i],head[2*i+1],candidate[2*i+1]);
        end
        for(i=0;i<16;i=i+1)begin
            {s1_l2[i],s0_l2[i]}=combine_state(s1_l1[2*i],s0_l1[2*i],s1_l1[2*i+1],s0_l1[2*i+1]);
            {gl_l2[i],gr_l2[i]}=local_branch(s1_l1[2*i],s0_l1[2*i],s1_l1[2*i+1],s0_l1[2*i+1]);
        end
        for(i=0;i<8;i=i+1)begin
            {s1_l3[i],s0_l3[i]}=combine_state(s1_l2[2*i],s0_l2[2*i],s1_l2[2*i+1],s0_l2[2*i+1]);
            {gl_l3[i],gr_l3[i]}=local_branch(s1_l2[2*i],s0_l2[2*i],s1_l2[2*i+1],s0_l2[2*i+1]);
        end
        for(i=0;i<4;i=i+1)begin
            {s1_l4[i],s0_l4[i]}=combine_state(s1_l3[2*i],s0_l3[2*i],s1_l3[2*i+1],s0_l3[2*i+1]);
            {gl_l4[i],gr_l4[i]}=local_branch(s1_l3[2*i],s0_l3[2*i],s1_l3[2*i+1],s0_l3[2*i+1]);
        end
        for(i=0;i<2;i=i+1)begin
            {s1_l5[i],s0_l5[i]}=combine_state(s1_l4[2*i],s0_l4[2*i],s1_l4[2*i+1],s0_l4[2*i+1]);
            {gl_l5[i],gr_l5[i]}=local_branch(s1_l4[2*i],s0_l4[2*i],s1_l4[2*i+1],s0_l4[2*i+1]);
        end
        {s1_root,s0_root}=combine_state(s1_l5[0],s0_l5[0],s1_l5[1],s0_l5[1]);
        {gl_root,gr_root}=local_branch(s1_l5[0],s0_l5[0],s1_l5[1],s0_l5[1]);
        grant_onehot='0;
        for(i=0;i<64;i=i+1)begin
            grant_onehot[i]=candidate[i]
                &(i[5]?gr_root:gl_root)
                &(i[4]?gr_l5[i>>5]:gl_l5[i>>5])
                &(i[3]?gr_l4[i>>4]:gl_l4[i>>4])
                &(i[2]?gr_l3[i>>3]:gl_l3[i>>3])
                &(i[1]?gr_l2[i>>2]:gl_l2[i>>2])
                &(i[0]?gr_l1[i>>1]:gl_l1[i>>1]);
        end
        grant_valid=|candidate;
        grant_rank[0]=|(grant_onehot&64'hAAAAAAAAAAAAAAAA);
        grant_rank[1]=|(grant_onehot&64'hCCCCCCCCCCCCCCCC);
        grant_rank[2]=|(grant_onehot&64'hF0F0F0F0F0F0F0F0);
        grant_rank[3]=|(grant_onehot&64'hFF00FF00FF00FF00);
        grant_rank[4]=|(grant_onehot&64'hFFFF0000FFFF0000);
        grant_rank[5]=|(grant_onehot&64'hFFFFFFFF00000000);
    end
endmodule

module aer64_pending_rr_core #(
    parameter integer SELECTOR_STYLE=0 // 0=8x8 grouped, 1=IPRRA tree
)(
    input  logic        clk,
    input  logic        rst_n,
    input  logic [63:0] src_req_async,
    output logic [63:0] src_ack_async,
    output logic [5:0]  out_addr,
    output logic        out_valid,
    input  logic        out_ready
);
    (* ASYNC_REG = "TRUE" *) logic [1:0] reset_release_q;
    (* ASYNC_REG = "TRUE" *) logic [63:0] req_meta_q,req_sync_q;
    logic core_rst_n;
    logic [63:0] ack_q,ack_d,pending_q,pending_d,accept_mask,accepted_pending;
    logic [5:0] out_rank_q,out_rank_d,selected_rank;
    logic out_valid_q,out_valid_d,grant_valid,can_load_output;

    always_ff @(posedge clk or negedge rst_n)begin
        if(!rst_n)reset_release_q<=2'b00;
        else reset_release_q<={reset_release_q[0],1'b1};
    end
    assign core_rst_n=reset_release_q[1];

    generate
        if(SELECTOR_STYLE==1)begin:iprra
            aer64_iprra_ring_selector selector(
                .candidate(accepted_pending),.last_rank(out_rank_q),
                .grant_valid(grant_valid),.grant_rank(selected_rank));
        end else begin:grouped
            aer64_grouped_ring_selector selector(
                .candidate(accepted_pending),.last_rank(out_rank_q),
                .grant_valid(grant_valid),.grant_rank(selected_rank));
        end
    endgenerate

    always_comb begin
        accept_mask=req_sync_q&~ack_q&~pending_q;
        accepted_pending=pending_q|accept_mask;
        ack_d=(ack_q&req_sync_q)|accept_mask;
        pending_d=accepted_pending;
        out_rank_d=out_rank_q;
        out_valid_d=out_valid_q;
        can_load_output=!out_valid_q||out_ready;
        if(can_load_output)begin
            if(grant_valid)begin
                out_valid_d=1'b1;
                out_rank_d=selected_rank;
                pending_d[selected_rank]=1'b0;
            end else out_valid_d=1'b0;
        end
    end

    always_ff @(posedge clk)begin
        req_meta_q<=src_req_async;
        req_sync_q<=req_meta_q;
    end
    always_ff @(posedge clk)begin
        if(!core_rst_n)begin
            ack_q<='0;
            pending_q<='0;
            out_rank_q<=6'h3f;
            out_valid_q<=1'b0;
        end else begin
            ack_q<=ack_d;
            pending_q<=pending_d;
            out_rank_q<=out_rank_d;
            out_valid_q<=out_valid_d;
        end
    end
    assign src_ack_async=ack_q&{64{core_rst_n}};
    assign out_addr=out_rank_q;
    assign out_valid=out_valid_q&core_rst_n;
endmodule

module aer64_pending_grouped_rr(
    input logic clk,input logic rst_n,input logic[63:0]src_req_async,
    output logic[63:0]src_ack_async,output logic[5:0]out_addr,
    output logic out_valid,input logic out_ready
);
    aer64_pending_rr_core #(.SELECTOR_STYLE(0)) core(.*);
endmodule

module aer64_pending_iprra_rr(
    input logic clk,input logic rst_n,input logic[63:0]src_req_async,
    output logic[63:0]src_ack_async,output logic[5:0]out_addr,
    output logic out_valid,input logic out_ready
);
    aer64_pending_rr_core #(.SELECTOR_STYLE(1)) core(.*);
endmodule
