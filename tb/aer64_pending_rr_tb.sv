`timescale 1ns/1ps
module aer64_pending_rr_tb;
    logic clk,rst_n,out_ready;
    logic [63:0]src_req_async;
    logic [63:0]ack_grouped,ack_iprra;
    logic [5:0]addr_grouped,addr_iprra;
    logic valid_grouped,valid_iprra;
    logic [63:0]probe_mask;
    logic [5:0]probe_last,probe_grouped,probe_iprra;
    logic probe_valid_grouped,probe_valid_iprra;
    integer errors,transfers,min_gap,max_gap,last_transfer_cycle,cycle_count;
    integer expected_addr;
    logic check_full_order;

    aer64_pending_grouped_rr grouped_dut(
        .clk,.rst_n,.src_req_async,.src_ack_async(ack_grouped),
        .out_addr(addr_grouped),.out_valid(valid_grouped),.out_ready);
    aer64_pending_iprra_rr iprra_dut(
        .clk,.rst_n,.src_req_async,.src_ack_async(ack_iprra),
        .out_addr(addr_iprra),.out_valid(valid_iprra),.out_ready);
    aer64_grouped_ring_selector grouped_probe(
        .candidate(probe_mask),.last_rank(probe_last),
        .grant_valid(probe_valid_grouped),.grant_rank(probe_grouped));
    aer64_iprra_ring_selector iprra_probe(
        .candidate(probe_mask),.last_rank(probe_last),
        .grant_valid(probe_valid_iprra),.grant_rank(probe_iprra));

    initial clk=0;always #5 clk=~clk;
    always @(posedge clk)begin
        cycle_count=cycle_count+1;
        if({ack_grouped,valid_grouped,addr_grouped}!=={ack_iprra,valid_iprra,addr_iprra})begin
            errors=errors+1;if(errors<20)$display("AER64_FAIL lockstep cycle=%0d",cycle_count);
        end
        if(valid_grouped&&out_ready)begin
            if(check_full_order)begin
                if(addr_grouped!==expected_addr[5:0])begin
                    errors=errors+1;
                    if(errors<20)$display("AER64_FAIL full backlog got=%0d expected=%0d",addr_grouped,expected_addr);
                end
                expected_addr=expected_addr+1;
            end
            if(last_transfer_cycle>=0)begin
                if(cycle_count-last_transfer_cycle<min_gap)min_gap=cycle_count-last_transfer_cycle;
                if(cycle_count-last_transfer_cycle>max_gap)max_gap=cycle_count-last_transfer_cycle;
            end
            last_transfer_cycle=cycle_count;
            transfers=transfers+1;
        end
    end

    function automatic [5:0]ref_winner(input logic[63:0]mask,input logic[5:0]last);
        integer off,index;logic found;
        begin ref_winner='0;found=0;
            for(off=1;off<=64;off=off+1)begin
                index=(last+off)&63;
                if(!found&&mask[index])begin ref_winner=index[5:0];found=1;end
            end
        end
    endfunction
    task automatic fail(input string msg);begin errors=errors+1;if(errors<20)$display("AER64_FAIL %s",msg);end endtask
    task automatic reset_duts;begin
        @(negedge clk);rst_n=0;src_req_async=0;out_ready=1;
        repeat(4)@(posedge clk);@(negedge clk);rst_n=1;repeat(4)@(posedge clk);
    end endtask
    task automatic wait_ack_high(input logic[63:0]mask);integer w;begin
        w=0;while(((ack_grouped&mask)!==mask)&&w<160)begin @(posedge clk);#1;w=w+1;end
        if((ack_grouped&mask)!==mask)fail("ack high timeout");
    end endtask
    task automatic wait_ack_low(input logic[63:0]mask);integer w;begin
        w=0;while(((ack_grouped&mask)!==0)&&w<160)begin @(posedge clk);#1;w=w+1;end
        if((ack_grouped&mask)!==0)fail("ack low timeout");
    end endtask

    initial begin:run
        integer last,trial,source,base_transfer,waited;
        logic[63:0]mask;
        logic[5:0]ref_idx;
        rst_n=0;src_req_async=0;out_ready=1;errors=0;transfers=0;
        min_gap=999;max_gap=0;last_transfer_cycle=-1;cycle_count=0;
        expected_addr=0;check_full_order=0;
        probe_mask=0;probe_last=0;

        // Selector equivalence: empty/full, every one-hot request, and 32,768
        // deterministic random masks across all last-grant positions.
        for(last=0;last<64;last=last+1)begin
            probe_last=last[5:0];probe_mask='0;#1;
            if(probe_valid_grouped||probe_valid_iprra)fail("empty selector valid");
            probe_mask='1;#1;ref_idx=ref_winner(probe_mask,probe_last);
            if(probe_grouped!==ref_idx||probe_iprra!==ref_idx)fail("full selector mismatch");
            for(source=0;source<64;source=source+1)begin
                probe_mask=64'b1<<source;#1;ref_idx=ref_winner(probe_mask,probe_last);
                if(probe_grouped!==ref_idx||probe_iprra!==ref_idx)fail("onehot selector mismatch");
            end
            for(trial=0;trial<512;trial=trial+1)begin
                mask={$urandom,$urandom};if(mask==0)mask=64'h1;
                probe_mask=mask;#1;ref_idx=ref_winner(mask,probe_last);
                if(probe_valid_grouped!==1||probe_valid_iprra!==1||
                   probe_grouped!==ref_idx||probe_iprra!==ref_idx)fail("random selector mismatch");
            end
        end

        reset_duts();
        // Receiver stall: accept all 64 events while holding one stable output.
        @(negedge clk);out_ready=0;src_req_async='1;
        wait_ack_high('1);repeat(5)@(posedge clk);#1;
        if(!valid_grouped||addr_grouped!==0)fail("stalled first address");
        repeat(6)begin @(posedge clk);#1;if(!valid_grouped||addr_grouped!==0)fail("stall stability");end
        base_transfer=transfers;expected_addr=0;check_full_order=1;
        @(negedge clk);src_req_async=0;out_ready=1;wait_ack_low('1);
        waited=0;
        while(transfers-base_transfer<64&&waited<180)begin
            @(posedge clk);#1;waited=waited+1;
        end
        check_full_order=0;
        if(transfers-base_transfer!=64)fail("full backlog count");

        // Sparse/restart batch crosses the 63->0 ring boundary.
        @(negedge clk);src_req_async=64'h8000000000000025;
        wait_ack_high(64'h8000000000000025);
        @(negedge clk);src_req_async=0;wait_ack_low(64'h8000000000000025);
        waited=0;while(waited<40)begin @(posedge clk);#1;waited=waited+1;end

        $display("METRIC aer64_selector_cases=%0d",64*(2+64+512));
        $display("METRIC aer64_transfers=%0d",transfers);
        $display("METRIC aer64_min_gap=%0d",min_gap);
        $display("METRIC aer64_max_gap=%0d",max_gap);
        $display("METRIC aer64_state_ff_expected=265");
        $display("METRIC aer64_errors=%0d",errors);
        if(errors==0)$display("AER64_PENDING_RR_TEST_PASS");
        else $display("AER64_PENDING_RR_TEST_FAIL");
        #20;$finish;
    end
    initial begin #10_000_000;fail("watchdog");$finish;end
endmodule
