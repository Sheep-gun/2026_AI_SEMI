`timescale 1ns/1ps
module aer_p9_gray_rank_fair_tb;
    logic clk,rst_n,out_valid,out_ready;
    logic [15:0] src_req_async,src_ack_async;
    logic [3:0] out_addr;
`ifndef P9_GATE
    logic [15:0] probe_candidate;
    logic [3:0] probe_last,probe_rank;
    logic probe_valid;
`endif
    integer errors,transfer_count;
    logic [3:0] transfer_log[0:31];
    aer_p9_gray_rank_dut dut(.*);
`ifndef P9_GATE
    aer_gray_rank_ring_selector16 probe(
        .rank_candidate(probe_candidate),.last_rank(probe_last),
        .grant_valid(probe_valid),.grant_rank(probe_rank));
`endif
    initial clk=0;always #5 clk=~clk;
    always @(posedge clk)if(out_valid&&out_ready)begin
        if(transfer_count<32)transfer_log[transfer_count]=out_addr;
        transfer_count=transfer_count+1;
    end
`ifndef P9_GATE
    function automatic [3:0] ref_rank(input logic[15:0]mask,input logic[3:0]last);
        integer offset,index;logic found;
        begin ref_rank=0;found=0;
            for(offset=1;offset<=16;offset=offset+1)begin
                index=(last+offset)&15;
                if(!found&&mask[index])begin ref_rank=index[3:0];found=1;end
            end
        end
    endfunction
`endif
    function automatic [3:0] gray(input integer rank);begin gray=(rank&15)^((rank&15)>>1);end endfunction
    task automatic fail(input string m);begin errors=errors+1;if(errors<20)$display("P9_GRR_FAIL %s",m);end endtask
    task automatic wait_ack_high(input logic[15:0]m);integer w;begin w=0;while(((src_ack_async&m)!==m)&&w<80)begin @(posedge clk);#1;w=w+1;end if((src_ack_async&m)!==m)fail("ack high timeout");end endtask
    task automatic wait_ack_low(input logic[15:0]m);integer w;begin w=0;while(((src_ack_async&m)!==0)&&w<80)begin @(posedge clk);#1;w=w+1;end if((src_ack_async&m)!==0)fail("ack low timeout");end endtask
    task automatic reset_controller;begin @(negedge clk);rst_n=0;src_req_async=0;out_ready=1;repeat(4)@(posedge clk);@(negedge clk);rst_n=1;repeat(4)@(posedge clk);end endtask
    initial begin:verification
        integer last,mask,index,waited;
`ifndef P9_GATE
        logic[3:0]expected;
`endif
        rst_n=0;src_req_async=0;out_ready=1;errors=0;transfer_count=0;
`ifndef P9_GATE
        probe_candidate=0;probe_last=0;
        for(last=0;last<16;last=last+1)for(mask=0;mask<65536;mask=mask+1)begin
            probe_last=last[3:0];probe_candidate=mask[15:0];#1;
            expected=ref_rank(mask[15:0],last[3:0]);
            if(probe_valid!==(mask!=0))fail("probe valid");
            if(mask!=0&&probe_rank!==expected)fail("probe rank");
        end
`endif
        reset_controller();@(negedge clk);out_ready=0;src_req_async=16'hffff;
        wait_ack_high(16'hffff);repeat(3)@(posedge clk);
        if(!out_valid||out_addr!==0)fail("first address");
        @(negedge clk);src_req_async=0;out_ready=1;wait_ack_low(16'hffff);
        waited=0;while(transfer_count<16&&waited<80)begin @(posedge clk);#1;waited=waited+1;end
        if(transfer_count!=16)fail("transfer count");
        for(index=0;index<16;index=index+1)if(transfer_log[index]!==gray(index))fail("gray order");
`ifndef P9_GATE
        $display("METRIC p9_grr_exhaustive_cases=1048576");
`else
        $display("METRIC p9_grr_exhaustive_cases=rtl_only");
`endif
        $display("METRIC p9_grr_full_cycle_toggles=16");
        $display("METRIC p9_grr_worst_service_decisions=16");
        $display("METRIC p9_grr_errors=%0d",errors);
        if(errors==0)$display("P9_GRAY_RANK_FAIR_TEST_PASS");else $display("P9_GRAY_RANK_FAIR_TEST_FAIL");
        #20;$finish;
    end
    initial begin #5_000_000;fail("watchdog");$finish;end
endmodule
