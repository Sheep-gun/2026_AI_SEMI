`timescale 1ns/1ps

// P10 research candidates keep the complete P9-GRR protocol/state contract.
// Only two combinational choices are swept:
//   * grouped cyclic selector versus the parallel tree search inspired by
//     Zheng/Yang's IPRRA;
//   * reflected Gray versus lower-XOR invertible cyclic source orderings.

module aer_rank_grouped_ring_selector16 (
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

// Improved Parallel Round-Robin Arbiter (IPRRA)-style tree.
// Every internal node computes its local left/right decision in parallel.
// The final one-hot grant is the AND of four already-computed path decisions,
// overlapping the request up-trace and grant down-trace.
module aer_rank_iprra_ring_selector16 (
    input  logic [15:0] rank_candidate,
    input  logic [3:0]  last_rank,
    output logic         grant_valid,
    output logic [3:0]   grant_rank
);
    logic [15:0] head;
    logic [3:0] head_rank;
    logic [7:0] s1_l1,s0_l1,gl_l1,gr_l1;
    logic [3:0] s1_l2,s0_l2,gl_l2,gr_l2;
    logic [1:0] s1_l3,s0_l3,gl_l3,gr_l3;
    logic s1_root,s0_root,gl_root,gr_root;
    logic [15:0] grant_onehot;
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
        head=16'b0;
        head[head_rank]=1'b1;

        for(i=0;i<8;i=i+1)begin
            {s1_l1[i],s0_l1[i]}=combine_state(
                head[2*i],rank_candidate[2*i],
                head[2*i+1],rank_candidate[2*i+1]);
            {gl_l1[i],gr_l1[i]}=local_branch(
                head[2*i],rank_candidate[2*i],
                head[2*i+1],rank_candidate[2*i+1]);
        end
        for(i=0;i<4;i=i+1)begin
            {s1_l2[i],s0_l2[i]}=combine_state(
                s1_l1[2*i],s0_l1[2*i],s1_l1[2*i+1],s0_l1[2*i+1]);
            {gl_l2[i],gr_l2[i]}=local_branch(
                s1_l1[2*i],s0_l1[2*i],s1_l1[2*i+1],s0_l1[2*i+1]);
        end
        for(i=0;i<2;i=i+1)begin
            {s1_l3[i],s0_l3[i]}=combine_state(
                s1_l2[2*i],s0_l2[2*i],s1_l2[2*i+1],s0_l2[2*i+1]);
            {gl_l3[i],gr_l3[i]}=local_branch(
                s1_l2[2*i],s0_l2[2*i],s1_l2[2*i+1],s0_l2[2*i+1]);
        end
        {s1_root,s0_root}=combine_state(
            s1_l3[0],s0_l3[0],s1_l3[1],s0_l3[1]);
        {gl_root,gr_root}=local_branch(
            s1_l3[0],s0_l3[0],s1_l3[1],s0_l3[1]);

        grant_onehot=16'b0;
        for(i=0;i<16;i=i+1)begin
            grant_onehot[i]=rank_candidate[i]
                &(i[3]?gr_root:gl_root)
                &(i[2]?gr_l3[i>>3]:gl_l3[i>>3])
                &(i[1]?gr_l2[i>>2]:gl_l2[i>>2])
                &(i[0]?gr_l1[i>>1]:gl_l1[i>>1]);
        end
        grant_valid=|rank_candidate;
        grant_rank[0]=|{grant_onehot[15],grant_onehot[13],grant_onehot[11],grant_onehot[9],
                        grant_onehot[7],grant_onehot[5],grant_onehot[3],grant_onehot[1]};
        grant_rank[1]=|{grant_onehot[15:14],grant_onehot[11:10],
                        grant_onehot[7:6],grant_onehot[3:2]};
        grant_rank[2]=|{grant_onehot[15:12],grant_onehot[7:4]};
        grant_rank[3]=|grant_onehot[15:8];
    end
endmodule

module aer_pending_rank_reuse_core #(
    parameter integer CODE_STYLE=0,     // 0=Gray, 1=one-XOR, 2=two-XOR
    parameter integer SELECTOR_STYLE=0  // 0=grouped, 1=IPRRA tree
)(
    input  logic        clk,
    input  logic        rst_n,
    input  logic [15:0] src_req_async,
    output logic [15:0] src_ack_async,
    output logic [3:0]  out_addr,
    output logic        out_valid,
    input  logic        out_ready
);
    function automatic [3:0] rank_to_source(input logic [3:0] rank);
        begin
            case(CODE_STYLE)
                1:rank_to_source={rank[3],rank[2],rank[1],rank[0]^rank[1]};
                2:rank_to_source={rank[3],rank[2],rank[1]^rank[2],rank[0]^rank[1]};
                default:rank_to_source=rank^(rank>>1);
            endcase
        end
    endfunction

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
    genvar rank_index;

    generate
        for(rank_index=0;rank_index<16;rank_index=rank_index+1)begin:rank_wiring
            assign req_rank[rank_index]=req_sync_q[rank_to_source(rank_index)];
            assign ack_source[rank_to_source(rank_index)]=ack_rank_q[rank_index];
        end
        if(SELECTOR_STYLE==1)begin:iprra_selector
            aer_rank_iprra_ring_selector16 selector(
                .rank_candidate(accepted_pending_rank),.last_rank(out_rank_q),
                .grant_valid(grant_valid),.grant_rank(selected_rank));
        end else begin:grouped_selector
            aer_rank_grouped_ring_selector16 selector(
                .rank_candidate(accepted_pending_rank),.last_rank(out_rank_q),
                .grant_valid(grant_valid),.grant_rank(selected_rank));
        end
    endgenerate

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
    assign out_addr=rank_to_source(out_rank_q);
    assign out_valid=out_valid_q&core_rst_n;
endmodule

module aer_pending_gray_rank_iprra_sync_core_reset(
    input logic clk,input logic rst_n,input logic [15:0] src_req_async,
    output logic [15:0] src_ack_async,output logic [3:0] out_addr,
    output logic out_valid,input logic out_ready
);
    aer_pending_rank_reuse_core #(.CODE_STYLE(0),.SELECTOR_STYLE(1)) core(.*);
endmodule

module aer_pending_xor1_rank_reuse_sync_core_reset(
    input logic clk,input logic rst_n,input logic [15:0] src_req_async,
    output logic [15:0] src_ack_async,output logic [3:0] out_addr,
    output logic out_valid,input logic out_ready
);
    function automatic [3:0] rank_to_source(input logic [3:0] rank);
        begin rank_to_source={rank[3],rank[2],rank[1],rank[0]^rank[1]}; end
    endfunction

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
    logic [15:0] accept_rank,accepted_pending_rank,ack_source;
    logic [3:0] out_rank_q,out_rank_d,selected_rank;
    logic out_valid_q,out_valid_d,grant_valid,can_load_output;
    genvar rank_index;

    generate
        for(rank_index=0;rank_index<16;rank_index=rank_index+1)begin:rank_wiring
            assign req_rank[rank_index]=req_sync_q[rank_to_source(rank_index)];
            assign ack_source[rank_to_source(rank_index)]=ack_rank_q[rank_index];
        end
    endgenerate
    aer_rank_grouped_ring_selector16 selector(
        .rank_candidate(accepted_pending_rank),.last_rank(out_rank_q),
        .grant_valid(grant_valid),.grant_rank(selected_rank));

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
    assign out_addr=rank_to_source(out_rank_q);
    assign out_valid=out_valid_q&core_rst_n;
endmodule

module aer_pending_xor2_rank_reuse_sync_core_reset(
    input logic clk,input logic rst_n,input logic [15:0] src_req_async,
    output logic [15:0] src_ack_async,output logic [3:0] out_addr,
    output logic out_valid,input logic out_ready
);
    aer_pending_rank_reuse_core #(.CODE_STYLE(2),.SELECTOR_STYLE(0)) core(.*);
endmodule
