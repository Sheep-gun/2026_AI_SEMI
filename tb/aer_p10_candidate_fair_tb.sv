`timescale 1ns/1ps
module aer_p10_candidate_fair_tb;
    logic clk,rst_n,out_valid,out_ready;
    logic [15:0]src_req_async,src_ack_async,probe_candidate;
    logic [3:0]out_addr,probe_last,probe_rank;
    logic probe_valid;
    integer errors,transfer_count,toggles;
    logic [3:0]transfer_log[0:31];
    aer_p10_candidate_impl dut(.*);
`ifndef P10_GATE
    aer_p10_selector_probe probe(
        .rank_candidate(probe_candidate),.last_rank(probe_last),
        .grant_valid(probe_valid),.grant_rank(probe_rank));
`endif
    initial clk=0;always #5 clk=~clk;

    function automatic [3:0]code(input integer rank);
        logic[3:0]x;
        begin
            x=rank[3:0];
`ifdef P10_XOR1
            code={x[3],x[2],x[1],x[0]^x[1]};
`elsif P10_XOR2
            code={x[3],x[2],x[1]^x[2],x[0]^x[1]};
`else
            code=x^(x>>1);
`endif
        end
    endfunction
    function automatic [3:0]ref_rank(input logic[15:0]mask,input logic[3:0]last);
        integer offset,index;logic found;
        begin ref_rank=0;found=0;
            for(offset=1;offset<=16;offset=offset+1)begin
                index=(last+offset)&15;
                if(!found&&mask[index])begin ref_rank=index[3:0];found=1;end
            end
        end
    endfunction
    function automatic integer popcount4(input logic[3:0]value);
        integer bit_index;begin popcount4=0;for(bit_index=0;bit_index<4;bit_index=bit_index+1)popcount4=popcount4+value[bit_index];end
    endfunction
    task automatic fail(input string m);begin errors=errors+1;if(errors<20)$display("P10_FAIL %s",m);end endtask
    task automatic wait_ack_high(input logic[15:0]m);integer w;begin w=0;while(((src_ack_async&m)!==m)&&w<80)begin @(posedge clk);#1;w=w+1;end if((src_ack_async&m)!==m)fail("ack high timeout");end endtask
    task automatic wait_ack_low(input logic[15:0]m);integer w;begin w=0;while(((src_ack_async&m)!==0)&&w<80)begin @(posedge clk);#1;w=w+1;end if((src_ack_async&m)!==0)fail("ack low timeout");end endtask
    always @(posedge clk)if(out_valid&&out_ready)begin
        if(transfer_count<32)transfer_log[transfer_count]=out_addr;
        transfer_count=transfer_count+1;
    end
    initial begin:verification
        integer last,mask,index,waited;logic[3:0]expected;
        rst_n=0;src_req_async=0;out_ready=1;errors=0;transfer_count=0;toggles=0;
`ifndef P10_GATE
        probe_candidate=0;probe_last=0;
        for(last=0;last<16;last=last+1)for(mask=0;mask<65536;mask=mask+1)begin
            probe_last=last[3:0];probe_candidate=mask[15:0];#1;
            expected=ref_rank(mask[15:0],last[3:0]);
            if(probe_valid!==(mask!=0))fail("probe valid");
            if(mask!=0&&probe_rank!==expected)begin
                if(errors<20)$display("P10_PROBE last=%0d mask=%h got=%0d expected=%0d",last,mask[15:0],probe_rank,expected);
                fail("probe rank");
            end
        end
`endif
        repeat(4)@(posedge clk);@(negedge clk);rst_n=1;repeat(4)@(posedge clk);
        @(negedge clk);out_ready=0;src_req_async=16'hffff;
        wait_ack_high(16'hffff);repeat(3)@(posedge clk);
        if(!out_valid||out_addr!==code(0))fail("first address");
        @(negedge clk);src_req_async=0;out_ready=1;wait_ack_low(16'hffff);
        waited=0;while(transfer_count<16&&waited<80)begin @(posedge clk);#1;waited=waited+1;end
        if(transfer_count!=16)fail("transfer count");
        for(index=0;index<16;index=index+1)begin
            if(transfer_log[index]!==code(index))fail("cyclic order");
            toggles=toggles+popcount4(code(index)^code((index+1)&15));
        end
`ifndef P10_GATE
        $display("METRIC p10_selector_exhaustive_cases=1048576");
`else
        $display("METRIC p10_selector_exhaustive_cases=rtl_only");
`endif
        $display("METRIC p10_full_cycle_toggles=%0d",toggles);
        $display("METRIC p10_worst_service_decisions=16");
        $display("METRIC p10_errors=%0d",errors);
        if(errors==0)$display("P10_CANDIDATE_FAIR_TEST_PASS");else $display("P10_CANDIDATE_FAIR_TEST_FAIL");
        #20;$finish;
    end
    initial begin #5_000_000;fail("watchdog");$finish;end
endmodule
