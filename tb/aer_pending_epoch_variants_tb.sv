`timescale 1ns/1ps

module aer_pending_epoch_variants_tb;
    localparam integer DUTS = 7;
    logic clk,rst_n,out_ready;
    logic [15:0] src_req_async;
    logic [15:0] ack [0:DUTS-1];
    logic [3:0] addr [0:DUTS-1];
    logic valid [0:DUTS-1];
    integer received [0:DUTS-1];
    logic [3:0] transfer_log [0:DUTS-1][0:15];
    integer errors;

    logic [15:0] probe_candidate;
    logic [3:0] probe_preference,probe_last;
    logic probe_valid,probe_ring_valid;
    logic [3:0] probe_addr,probe_ring_addr;

    aer_xor_preference_scheduler16 xor_probe(
        .candidate(probe_candidate),.preference(probe_preference),
        .grant_valid(probe_valid),.grant_addr(probe_addr));
    aer_gray_ring_scheduler16 ring_probe(
        .candidate(probe_candidate),.last_addr(probe_last),
        .grant_valid(probe_ring_valid),.grant_addr(probe_ring_addr));

    aer_pending_epoch_binary_exp d0(
        .clk(clk),.rst_n(rst_n),.src_req_async(src_req_async),
        .src_ack_async(ack[0]),.out_addr(addr[0]),.out_valid(valid[0]),
        .out_ready(out_ready));
    aer_pending_epoch_xor1_exp d1(
        .clk(clk),.rst_n(rst_n),.src_req_async(src_req_async),
        .src_ack_async(ack[1]),.out_addr(addr[1]),.out_valid(valid[1]),
        .out_ready(out_ready));
    aer_pending_epoch_xor2_exp d2(
        .clk(clk),.rst_n(rst_n),.src_req_async(src_req_async),
        .src_ack_async(ack[2]),.out_addr(addr[2]),.out_valid(valid[2]),
        .out_ready(out_ready));
    aer_pending_epoch_direct_gray_exp d3(
        .clk(clk),.rst_n(rst_n),.src_req_async(src_req_async),
        .src_ack_async(ack[3]),.out_addr(addr[3]),.out_valid(valid[3]),
        .out_ready(out_ready));
    aer_pending_epoch_lfsr_zero_exp d4(
        .clk(clk),.rst_n(rst_n),.src_req_async(src_req_async),
        .src_ack_async(ack[4]),.out_addr(addr[4]),.out_valid(valid[4]),
        .out_ready(out_ready));
    aer_pending_gray_ring_reuse_exp d5(
        .clk(clk),.rst_n(rst_n),.src_req_async(src_req_async),
        .src_ack_async(ack[5]),.out_addr(addr[5]),.out_valid(valid[5]),
        .out_ready(out_ready));
    aer_pending_epoch_gray_control_exp d6(
        .clk(clk),.rst_n(rst_n),.src_req_async(src_req_async),
        .src_ack_async(ack[6]),.out_addr(addr[6]),.out_valid(valid[6]),
        .out_ready(out_ready));

    initial clk=1'b0;
    always #5 clk=~clk;

    function automatic [3:0] gray4(input integer rank);
        integer value;
        begin value=rank&15;gray4=value^(value>>1);end
    endfunction

    function automatic integer gray_to_bin_int(input logic [3:0] gray);
        integer binary;
        begin
            binary=0;
            binary[3]=gray[3];
            binary[2]=binary[3]^gray[2];
            binary[1]=binary[2]^gray[1];
            binary[0]=binary[1]^gray[0];
            gray_to_bin_int=binary;
        end
    endfunction

    function automatic [3:0] expected_preference(
        input integer dut_index,input integer rank);
        integer value;
        begin
            value=rank&15;
            case(dut_index)
                0:expected_preference=value[3:0];
                1:expected_preference={value[3:2],value[1],
                                       value[0]^value[1]};
                2:expected_preference={value[3],value[2],
                                       value[1]^value[2],
                                       value[0]^value[1]};
                3:expected_preference=gray4(value);
                4:case(value)
                    0:expected_preference=4'h0;
                    1:expected_preference=4'h2;
                    2:expected_preference=4'h8;
                    3:expected_preference=4'hc;
                    4:expected_preference=4'hd;
                    5:expected_preference=4'hf;
                    6:expected_preference=4'h7;
                    7:expected_preference=4'hb;
                    8:expected_preference=4'h6;
                    9:expected_preference=4'h9;
                    10:expected_preference=4'he;
                    11:expected_preference=4'h5;
                    12:expected_preference=4'h3;
                    13:expected_preference=4'ha;
                    14:expected_preference=4'h4;
                    default:expected_preference=4'h1;
                endcase
                default:expected_preference=gray4(value);
            endcase
        end
    endfunction

    function automatic [3:0] xor_winner(
        input logic [15:0] mask,input logic [3:0] preference);
        integer source,best_score,score;
        begin
            xor_winner=0;best_score=32;
            for(source=0;source<16;source=source+1)
                if(mask[source])begin
                    score=source^preference;
                    if(score<best_score)begin
                        best_score=score;xor_winner=source[3:0];
                    end
                end
        end
    endfunction

    function automatic [3:0] ring_winner(
        input logic [15:0] mask,input logic [3:0] last_addr);
        integer offset,rank;
        logic found;
        logic [3:0] source;
        begin
            rank=gray_to_bin_int(last_addr);found=1'b0;ring_winner=0;
            for(offset=1;offset<=16;offset=offset+1)begin
                source=gray4(rank+offset);
                if(!found&&mask[source])begin
                    ring_winner=source;found=1'b1;
                end
            end
        end
    endfunction

    always @(posedge clk) begin: capture_outputs
        integer d;
        if(rst_n&&out_ready)begin
            for(d=0;d<DUTS;d=d+1)
                if(valid[d])begin
                    if(received[d]<16)transfer_log[d][received[d]]=addr[d];
                    received[d]=received[d]+1;
                end
        end
    end

    initial begin: test
        integer preference,mask,last,d,i,waited,toggle_sum;
        logic [3:0] expected,held_addr[0:DUTS-1];
        logic all_high,all_low,all_valid,all_done;
        errors=0;rst_n=0;out_ready=0;src_req_async=0;
        probe_candidate=0;probe_preference=0;probe_last=0;
        for(d=0;d<DUTS;d=d+1)received[d]=0;

        // Exhaustive correctness of the shared XOR-preference tournament.
        for(preference=0;preference<16;preference=preference+1)begin
            probe_preference=preference[3:0];
            for(mask=0;mask<65536;mask=mask+1)begin
                probe_candidate=mask[15:0];#0.001;
                if(probe_valid!==(mask!=0))begin
                    errors=errors+1;
                    $display("XOR_VALID_FAIL pref=%0d mask=%04h",preference,mask);
                end else if(mask!=0)begin
                    expected=xor_winner(mask[15:0],preference[3:0]);
                    if(probe_addr!==expected)begin
                        errors=errors+1;
                        $display("XOR_ADDR_FAIL pref=%0d mask=%04h exp=%0d got=%0d",
                                 preference,mask,expected,probe_addr);
                    end
                end
            end
        end
        $display("XOR_SCHEDULER_CASES=1048576");

        // Exhaustive strict Gray-ring search for every last grant and mask.
        for(last=0;last<16;last=last+1)begin
            probe_last=last[3:0];
            for(mask=0;mask<65536;mask=mask+1)begin
                probe_candidate=mask[15:0];#0.001;
                if(probe_ring_valid!==(mask!=0))begin
                    errors=errors+1;
                    $display("RING_VALID_FAIL last=%0d mask=%04h",last,mask);
                end else if(mask!=0)begin
                    expected=ring_winner(mask[15:0],last[3:0]);
                    if(probe_ring_addr!==expected)begin
                        errors=errors+1;
                        $display("RING_ADDR_FAIL last=%0d mask=%04h exp=%0d got=%0d",
                                 last,mask,expected,probe_ring_addr);
                    end
                end
            end
        end
        $display("GRAY_RING_SCHEDULER_CASES=1048576");

        // Robust reset release, full pending mask and a deliberate stall.
        repeat(4)@(posedge clk);@(negedge clk);rst_n=1'b1;
        repeat(4)@(posedge clk);@(negedge clk);src_req_async=16'hffff;
        waited=0;all_high=0;
        while(!all_high&&waited<40)begin
            @(posedge clk);#1;all_high=1;
            for(d=0;d<DUTS;d=d+1)if(ack[d]!==16'hffff)all_high=0;
            waited=waited+1;
        end
        if(!all_high)begin errors=errors+1;$display("ACK_HIGH_TIMEOUT");end
        @(negedge clk);src_req_async=0;

        waited=0;all_valid=0;
        while(!all_valid&&waited<20)begin
            @(posedge clk);#1;all_valid=1;
            for(d=0;d<DUTS;d=d+1)if(!valid[d])all_valid=0;
            waited=waited+1;
        end
        if(!all_valid)begin errors=errors+1;$display("VALID_TIMEOUT");end
        for(d=0;d<DUTS;d=d+1)held_addr[d]=addr[d];
        repeat(5)begin
            @(posedge clk);#1;
            for(d=0;d<DUTS;d=d+1)
                if(!valid[d]||addr[d]!==held_addr[d])begin
                    errors=errors+1;$display("STALL_STABILITY_FAIL dut=%0d",d);
                end
        end
        @(negedge clk);out_ready=1;

        waited=0;all_done=0;
        while(!all_done&&waited<80)begin
            @(posedge clk);#1;all_done=1;
            for(d=0;d<DUTS;d=d+1)if(received[d]<16)all_done=0;
            waited=waited+1;
        end
        if(!all_done)begin errors=errors+1;$display("DRAIN_TIMEOUT");end

        for(d=0;d<DUTS;d=d+1)begin
            toggle_sum=0;
            for(i=0;i<16;i=i+1)begin
                expected=expected_preference(d,i);
                if(transfer_log[d][i]!==expected)begin
                    errors=errors+1;
                    $display("ORDER_FAIL dut=%0d slot=%0d exp=%0d got=%0d",
                             d,i,expected,transfer_log[d][i]);
                end
                toggle_sum=toggle_sum+$countones(
                    expected_preference(d,i)^expected_preference(d,(i+1)&15));
            end
            $display("VARIANT_RESULT dut=%0d fairness_bound=16 cyclic_toggles=%0d",
                     d,toggle_sum);
        end

        waited=0;all_low=0;
        while(!all_low&&waited<40)begin
            @(posedge clk);#1;all_low=1;
            for(d=0;d<DUTS;d=d+1)if(ack[d]!==0)all_low=0;
            waited=waited+1;
        end
        if(!all_low)begin errors=errors+1;$display("ACK_LOW_TIMEOUT");end

        if(errors==0)$display("P7_EPOCH_VARIANTS_TEST_PASS");
        else $display("P7_EPOCH_VARIANTS_TEST_FAIL errors=%0d",errors);
        $finish;
    end
endmodule
