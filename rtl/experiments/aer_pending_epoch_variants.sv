`timescale 1ns/1ps

// Experimental P7 scheduler-state variants.  The proven P7-GE RTL remains
// untouched; these tops keep its pending/early-ACK/registered-output contract
// and vary only the four-bit preference sequence.

module aer_xor_preference_scheduler16 (
    input  logic [15:0] candidate,
    input  logic [3:0]  preference,
    output logic         grant_valid,
    output logic [3:0]   grant_addr
);
    logic [7:0] pair_valid;
    logic [3:0] quarter_valid;
    logic [1:0] half_valid;
    logic b3, b2, b1, b0;
    integer pair_index;

    always_comb begin
        for (pair_index = 0; pair_index < 8; pair_index = pair_index + 1)
            pair_valid[pair_index] = candidate[2*pair_index] |
                                     candidate[(2*pair_index)+1];
        quarter_valid[0] = pair_valid[0] | pair_valid[1];
        quarter_valid[1] = pair_valid[2] | pair_valid[3];
        quarter_valid[2] = pair_valid[4] | pair_valid[5];
        quarter_valid[3] = pair_valid[6] | pair_valid[7];
        half_valid[0] = quarter_valid[0] | quarter_valid[1];
        half_valid[1] = quarter_valid[2] | quarter_valid[3];

        b3 = half_valid[preference[3]] ? preference[3] : ~preference[3];
        b2 = quarter_valid[{b3,preference[2]}] ? preference[2] :
                                                      ~preference[2];
        b1 = pair_valid[{b3,b2,preference[1]}] ? preference[1] :
                                                   ~preference[1];
        b0 = candidate[{b3,b2,b1,preference[0]}] ? preference[0] :
                                                     ~preference[0];
        grant_addr = {b3,b2,b1,b0};
        grant_valid = half_valid[0] | half_valid[1];
    end
endmodule

module aer_pending_epoch_family #(
    // 0: binary, 1: one-XOR G2, 2: two-XOR G3,
    // 3: directly registered reflected Gray, 4: 15-state LFSR plus zero,
    // 5: P7-equivalent binary counter followed by a full Gray encoder.
    parameter integer SEQUENCE = 0,
    parameter bit ROBUST_RESET = 1'b1
) (
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

    generate
        if (ROBUST_RESET) begin : g_robust_reset
            always_ff @(posedge clk or negedge rst_n) begin
                if (!rst_n)
                    reset_release_q <= 2'b00;
                else
                    reset_release_q <= {reset_release_q[0],1'b1};
            end
            assign core_rst_n = reset_release_q[1];
        end else begin : g_raw_reset
            always_comb reset_release_q = 2'b11;
            assign core_rst_n = rst_n;
        end
    endgenerate

    (* ASYNC_REG = "TRUE" *) logic [15:0] req_meta_q;
    (* ASYNC_REG = "TRUE" *) logic [15:0] req_sync_q;
    logic [15:0] ack_q, ack_d;
    logic [15:0] pending_q, pending_d;
    logic [15:0] candidate;
    logic [3:0] state_q, state_d, preference;
    logic [3:0] selected_addr;
    logic grant_valid;
    logic [4:0] selection;
    logic [3:0] out_addr_q, out_addr_d;
    logic out_valid_q, out_valid_d;
    logic can_load_output;
    integer source_index;

    function automatic [3:0] gray_successor(input logic [3:0] gray);
        logic parity;
        logic [3:0] toggle_mask;
        begin
            parity = ^gray;
            toggle_mask[0] = ~parity;
            toggle_mask[1] = parity & gray[0];
            toggle_mask[2] = parity & ~gray[0] & gray[1];
            toggle_mask[3] = parity & ~gray[0] & ~gray[1];
            gray_successor = gray ^ toggle_mask;
        end
    endfunction

    // A one-XOR primitive linear recurrence has a 15-state nonzero cycle.
    // Zero is inserted between states 1 and 2, producing a 16-state bijection.
    function automatic [3:0] lfsr_zero_successor(input logic [3:0] state);
        logic [3:0] linear_next;
        begin
            linear_next = {state[3] ^ state[1],state[3],state[0],state[2]};
            if (state == 4'h0)
                lfsr_zero_successor = 4'h2;
            else if (state == 4'h1)
                lfsr_zero_successor = 4'h0;
            else
                lfsr_zero_successor = linear_next;
        end
    endfunction

    function automatic [4:0] xor_tree_select(
        input logic [15:0] mask,input logic [3:0] pref);
        logic [7:0] pair_v;
        logic [3:0] quarter_v;
        logic [1:0] half_v;
        logic s3,s2,s1,s0;
        integer pair;
        begin
            for(pair=0;pair<8;pair=pair+1)
                pair_v[pair]=mask[2*pair]|mask[(2*pair)+1];
            quarter_v[0]=pair_v[0]|pair_v[1];
            quarter_v[1]=pair_v[2]|pair_v[3];
            quarter_v[2]=pair_v[4]|pair_v[5];
            quarter_v[3]=pair_v[6]|pair_v[7];
            half_v[0]=quarter_v[0]|quarter_v[1];
            half_v[1]=quarter_v[2]|quarter_v[3];
            s3=half_v[pref[3]]?pref[3]:~pref[3];
            s2=quarter_v[{s3,pref[2]}]?pref[2]:~pref[2];
            s1=pair_v[{s3,s2,pref[1]}]?pref[1]:~pref[1];
            s0=mask[{s3,s2,s1,pref[0]}]?pref[0]:~pref[0];
            xor_tree_select={|mask,s3,s2,s1,s0};
        end
    endfunction

    always_comb begin
        case (SEQUENCE)
            0: preference = state_q;
            // Lower two binary counter bits are converted to two-bit Gray.
            1: preference = {state_q[3:2],state_q[1],
                             state_q[0] ^ state_q[1]};
            // Lower three bits use reflected Gray; bit three stays binary.
            2: preference = {state_q[3],state_q[2],
                             state_q[1] ^ state_q[2],
                             state_q[0] ^ state_q[1]};
            5: preference = state_q ^ (state_q >> 1);
            default: preference = state_q;
        endcase
    end

    // The OR term preserves P7 cut-through without feeding the selected grant
    // back into the scheduler during the same combinational evaluation.
    assign candidate = pending_q | (req_sync_q & ~ack_q);

    always_comb begin
        ack_d = ack_q;
        pending_d = pending_q;
        state_d = state_q;
        out_addr_d = out_addr_q;
        out_valid_d = out_valid_q;
        selection = xor_tree_select(candidate,preference);
        grant_valid = selection[4];
        selected_addr = selection[3:0];

        for (source_index = 0; source_index < 16; source_index = source_index + 1) begin
            if (ack_q[source_index]) begin
                if (!req_sync_q[source_index])
                    ack_d[source_index] = 1'b0;
            end else if (req_sync_q[source_index] && !pending_d[source_index]) begin
                pending_d[source_index] = 1'b1;
                ack_d[source_index] = 1'b1;
            end
        end

        can_load_output = !out_valid_q || out_ready;
        if (can_load_output) begin
            if (grant_valid) begin
                out_valid_d = 1'b1;
                out_addr_d = selected_addr;
                pending_d[selected_addr] = 1'b0;
                if (SEQUENCE == 3)
                    state_d = gray_successor(state_q);
                else if (SEQUENCE == 4)
                    state_d = lfsr_zero_successor(state_q);
                else
                    state_d = state_q + 1'b1;
            end else begin
                out_valid_d = 1'b0;
            end
        end
    end

    always_ff @(posedge clk or negedge core_rst_n) begin
        if (!core_rst_n) begin
            req_meta_q <= '0;
            req_sync_q <= '0;
            ack_q <= '0;
            pending_q <= '0;
            state_q <= '0;
            out_addr_q <= '0;
            out_valid_q <= 1'b0;
        end else begin
            req_meta_q <= src_req_async;
            req_sync_q <= req_meta_q;
            ack_q <= ack_d;
            pending_q <= pending_d;
            state_q <= state_d;
            out_addr_q <= out_addr_d;
            out_valid_q <= out_valid_d;
        end
    end

    assign src_ack_async = ack_q;
    assign out_addr = out_addr_q;
    assign out_valid = out_valid_q;
endmodule

module aer_pending_epoch_binary_exp (
    input logic clk,input logic rst_n,input logic [15:0] src_req_async,
    output logic [15:0] src_ack_async,output logic [3:0] out_addr,
    output logic out_valid,input logic out_ready
);
    aer_pending_epoch_family #(.SEQUENCE(0),.ROBUST_RESET(1'b1)) implementation (.*);
endmodule

module aer_pending_epoch_xor1_exp (
    input logic clk,input logic rst_n,input logic [15:0] src_req_async,
    output logic [15:0] src_ack_async,output logic [3:0] out_addr,
    output logic out_valid,input logic out_ready
);
    aer_pending_epoch_family #(.SEQUENCE(1),.ROBUST_RESET(1'b1)) implementation (.*);
endmodule

module aer_pending_epoch_xor2_exp (
    input logic clk,input logic rst_n,input logic [15:0] src_req_async,
    output logic [15:0] src_ack_async,output logic [3:0] out_addr,
    output logic out_valid,input logic out_ready
);
    aer_pending_epoch_family #(.SEQUENCE(2),.ROBUST_RESET(1'b1)) implementation (.*);
endmodule

module aer_pending_epoch_direct_gray_exp (
    input logic clk,input logic rst_n,input logic [15:0] src_req_async,
    output logic [15:0] src_ack_async,output logic [3:0] out_addr,
    output logic out_valid,input logic out_ready
);
    aer_pending_epoch_family #(.SEQUENCE(3),.ROBUST_RESET(1'b1)) implementation (.*);
endmodule

module aer_pending_epoch_lfsr_zero_exp (
    input logic clk,input logic rst_n,input logic [15:0] src_req_async,
    output logic [15:0] src_ack_async,output logic [3:0] out_addr,
    output logic out_valid,input logic out_ready
);
    aer_pending_epoch_family #(.SEQUENCE(4),.ROBUST_RESET(1'b1)) implementation (.*);
endmodule

module aer_pending_epoch_gray_control_exp (
    input logic clk,input logic rst_n,input logic [15:0] src_req_async,
    output logic [15:0] src_ack_async,output logic [3:0] out_addr,
    output logic out_valid,input logic out_ready
);
    aer_pending_epoch_family #(.SEQUENCE(5),.ROBUST_RESET(1'b1)) implementation (.*);
endmodule

// Strict cyclic round-robin in reflected-Gray rank order.  Unlike simply
// feeding successor(out_addr) to the XOR tournament, this policy cannot get
// trapped on a subset: every search starts after the actual last grant.
module aer_gray_ring_scheduler16 (
    input  logic [15:0] candidate,
    input  logic [3:0]  last_addr,
    output logic         grant_valid,
    output logic [3:0]   grant_addr
);
    logic [15:0] rank_req;
    logic [3:0] last_rank, start_rank;
    logic [1:0] start_group, start_lane, next_group;
    logic [3:0] start_group_req, tail_mask, tail_req;
    logic [3:0] group_valid, selected_group_req;
    logic [2:0] tail_pick, group_pick, lane_pick;
    logic [3:0] grant_rank;

    function automatic [3:0] gray_to_bin(input logic [3:0] gray);
        begin
            gray_to_bin[3] = gray[3];
            gray_to_bin[2] = gray[3] ^ gray[2];
            gray_to_bin[1] = gray[3] ^ gray[2] ^ gray[1];
            gray_to_bin[0] = gray[3] ^ gray[2] ^ gray[1] ^ gray[0];
        end
    endfunction

    function automatic [3:0] bin_to_gray(input logic [3:0] binary);
        begin
            bin_to_gray = binary ^ (binary >> 1);
        end
    endfunction

    function automatic [2:0] fp4(input logic [3:0] req);
        logic [1:0] index;
        begin
            if (req[0]) index=2'd0;
            else if (req[1]) index=2'd1;
            else if (req[2]) index=2'd2;
            else index=2'd3;
            fp4={|req,index};
        end
    endfunction

    function automatic [2:0] rr4(input logic [3:0] req,input logic [1:0] ptr);
        logic [1:0] index;
        begin
            case (ptr)
                2'd0: if(req[0])index=0;else if(req[1])index=1;
                      else if(req[2])index=2;else index=3;
                2'd1: if(req[1])index=1;else if(req[2])index=2;
                      else if(req[3])index=3;else index=0;
                2'd2: if(req[2])index=2;else if(req[3])index=3;
                      else if(req[0])index=0;else index=1;
                default: if(req[3])index=3;else if(req[0])index=0;
                         else if(req[1])index=1;else index=2;
            endcase
            rr4={|req,index};
        end
    endfunction

    always_comb begin
        rank_req[0]=candidate[0];   rank_req[1]=candidate[1];
        rank_req[2]=candidate[3];   rank_req[3]=candidate[2];
        rank_req[4]=candidate[6];   rank_req[5]=candidate[7];
        rank_req[6]=candidate[5];   rank_req[7]=candidate[4];
        rank_req[8]=candidate[12];  rank_req[9]=candidate[13];
        rank_req[10]=candidate[15]; rank_req[11]=candidate[14];
        rank_req[12]=candidate[10]; rank_req[13]=candidate[11];
        rank_req[14]=candidate[9];  rank_req[15]=candidate[8];

        last_rank=gray_to_bin(last_addr);
        start_rank=last_rank+1'b1;
        start_group=start_rank[3:2];
        start_lane=start_rank[1:0];
        next_group=start_group+1'b1;

        group_valid[0]=|rank_req[3:0];
        group_valid[1]=|rank_req[7:4];
        group_valid[2]=|rank_req[11:8];
        group_valid[3]=|rank_req[15:12];
        case(start_group)
            0:start_group_req=rank_req[3:0];
            1:start_group_req=rank_req[7:4];
            2:start_group_req=rank_req[11:8];
            default:start_group_req=rank_req[15:12];
        endcase
        case(start_lane)
            0:tail_mask=4'b1111;
            1:tail_mask=4'b1110;
            2:tail_mask=4'b1100;
            default:tail_mask=4'b1000;
        endcase
        tail_req=start_group_req&tail_mask;
        tail_pick=fp4(tail_req);
        group_pick=rr4(group_valid,next_group);
        case(group_pick[1:0])
            0:selected_group_req=rank_req[3:0];
            1:selected_group_req=rank_req[7:4];
            2:selected_group_req=rank_req[11:8];
            default:selected_group_req=rank_req[15:12];
        endcase
        lane_pick=fp4(selected_group_req);
        grant_rank=tail_pick[2] ? {start_group,tail_pick[1:0]} :
                                  {group_pick[1:0],lane_pick[1:0]};
        grant_valid=|candidate;
        grant_addr=bin_to_gray(grant_rank);
    end
endmodule

module aer_pending_gray_ring_reuse_exp (
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
    logic [15:0] ack_q,ack_d;
    logic [15:0] pending_q,pending_d,candidate;
    logic [3:0] out_addr_q,out_addr_d,selected_addr;
    logic out_valid_q,out_valid_d,grant_valid,can_load_output;
    logic [4:0] selection;
    integer source_index;

    function automatic [2:0] local_fp4(input logic [3:0] req);
        logic [1:0] index;
        begin
            if(req[0])index=0;else if(req[1])index=1;
            else if(req[2])index=2;else index=3;
            local_fp4={|req,index};
        end
    endfunction

    function automatic [2:0] local_rr4(
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
            local_rr4={|req,index};
        end
    endfunction

    function automatic [4:0] ring_tree_select(
        input logic [15:0] mask,input logic [3:0] last);
        logic [15:0] rank_req;
        logic [3:0] last_rank,start_rank,start_req,tail_mask,tail_req;
        logic [3:0] group_v,selected_req,grant_rank,grant_source;
        logic [1:0] start_group,start_lane,next_group;
        logic [2:0] tail_pick,group_pick,lane_pick;
        begin
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
            tail_pick=local_fp4(tail_req);
            group_pick=local_rr4(group_v,next_group);
            case(group_pick[1:0])
                0:selected_req=rank_req[3:0];1:selected_req=rank_req[7:4];
                2:selected_req=rank_req[11:8];default:selected_req=rank_req[15:12];
            endcase
            lane_pick=local_fp4(selected_req);
            grant_rank=tail_pick[2]?{start_group,tail_pick[1:0]}:
                                      {group_pick[1:0],lane_pick[1:0]};
            grant_source=grant_rank^(grant_rank>>1);
            ring_tree_select={|mask,grant_source};
        end
    endfunction

    always_ff @(posedge clk or negedge rst_n) begin
        if(!rst_n) reset_release_q<=2'b00;
        else reset_release_q<={reset_release_q[0],1'b1};
    end
    assign core_rst_n=reset_release_q[1];

    assign candidate=pending_q|(req_sync_q&~ack_q);

    always_comb begin
        ack_d=ack_q;pending_d=pending_q;out_addr_d=out_addr_q;
        out_valid_d=out_valid_q;
        selection=ring_tree_select(candidate,out_addr_q);
        grant_valid=selection[4];selected_addr=selection[3:0];
        for(source_index=0;source_index<16;source_index=source_index+1) begin
            if(ack_q[source_index]) begin
                if(!req_sync_q[source_index])ack_d[source_index]=1'b0;
            end else if(req_sync_q[source_index]&&!pending_d[source_index]) begin
                pending_d[source_index]=1'b1;
                ack_d[source_index]=1'b1;
            end
        end
        can_load_output=!out_valid_q||out_ready;
        if(can_load_output) begin
            if(grant_valid) begin
                out_valid_d=1'b1;
                out_addr_d=selected_addr;
                pending_d[selected_addr]=1'b0;
            end else out_valid_d=1'b0;
        end
    end

    always_ff @(posedge clk or negedge core_rst_n) begin
        if(!core_rst_n) begin
            req_meta_q<='0;req_sync_q<='0;ack_q<='0;pending_q<='0;
            // Rank 15; the first search starts at rank 0/source 0.
            out_addr_q<=4'h8;out_valid_q<=1'b0;
        end else begin
            req_meta_q<=src_req_async;req_sync_q<=req_meta_q;
            ack_q<=ack_d;pending_q<=pending_d;
            out_addr_q<=out_addr_d;out_valid_q<=out_valid_d;
        end
    end
    assign src_ack_async=ack_q;
    assign out_addr=out_addr_q;
    assign out_valid=out_valid_q;
endmodule
