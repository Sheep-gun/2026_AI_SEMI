`timescale 1ns/1ps
module aer_source_resident_tb;
    localparam integer N=16,MAXE=32;
    logic clk,rst_n,out_valid,out_ready;
    logic [15:0] src_req_async,src_ack_async;
    logic [3:0] out_addr;
    integer cycle_count,offered,accepted,received,errors;
    integer issue_cycle[0:15],issue_head[0:15],issue_tail[0:15];
    integer issue_fifo[0:15][0:MAXE-1],received_by_source[0:15];
    integer total_latency,max_latency,hotspot_latency;
    bit hotspot_measure;
    integer address_toggle_count;
    logic [3:0] last_output_addr;
    integer sat_events,sat_start,sat_elapsed,sat_last,sat_gap_sum,sat_min_gap,sat_max_gap;
    bit sat_measure;
    logic prev_valid,prev_ready;logic[3:0]prev_addr;

    aer_source_resident_dut dut(.clk(clk),.rst_n(rst_n),.src_req_async(src_req_async),
        .src_ack_async(src_ack_async),.out_addr(out_addr),.out_valid(out_valid),.out_ready(out_ready));
    initial clk=0;always #5 clk=~clk;
    task automatic fail(input string m);begin errors++;$display("SR_ASSERT_FAIL cycle=%0d %s",cycle_count,m);end endtask
    function automatic integer popcount4(input logic[3:0]v);integer k;begin popcount4=0;for(k=0;k<4;k=k+1)popcount4+=v[k];end endfunction
    task automatic issue_event(input integer s,input integer gap_ns);integer deadline;begin
        if(gap_ns>0)#(gap_ns);wait(rst_n===1'b1);
        deadline=cycle_count+5000;
        while((src_req_async[s]!==0||src_ack_async[s]!==0)&&cycle_count<deadline)#1;
        if(cycle_count>=deadline)fail($sformatf("source %0d did not return to zero",s));
        issue_cycle[s]=cycle_count;offered++;src_req_async[s]=1;
        deadline=cycle_count+5000;
        while(src_ack_async[s]!==1&&rst_n&&cycle_count<deadline)#1;
        if(rst_n&&src_ack_async[s]!==1)begin
            fail($sformatf("source %0d ACK-rise timeout",s));src_req_async[s]=0;
        end else if(rst_n)begin
            #1 src_req_async[s]=0;deadline=cycle_count+5000;
            while(src_ack_async[s]!==0&&rst_n&&cycle_count<deadline)#1;
            if(rst_n&&src_ack_async[s]!==0)fail($sformatf("source %0d ACK-fall timeout",s));
        end
        else src_req_async[s]=0;
    end endtask
    task automatic issue_stream(input integer s,input integer c,input integer gap);integer j;begin
        for(j=0;j<c;j=j+1)issue_event(s,gap);
    end endtask
    task automatic wait_received(input integer exp,input integer timeout,input string phase);integer d;begin
        d=cycle_count+timeout;while(received<exp&&cycle_count<d)@(posedge clk);
        if(received!=exp)fail($sformatf("%s timeout exp=%0d got=%0d",phase,exp,received));
    end endtask

    genvar gs;generate for(gs=0;gs<16;gs=gs+1)begin:g_ack
        always @(posedge src_ack_async[gs])if(rst_n)begin
            issue_fifo[gs][issue_tail[gs]]=issue_cycle[gs];issue_tail[gs]++;accepted++;
        end
    end endgenerate

    always @(posedge clk or negedge rst_n)begin:score
        integer s,lat,gap;
        if(!rst_n)begin cycle_count<=0;prev_valid<=0;prev_ready<=0;prev_addr<=0;end
        else begin
            cycle_count<=cycle_count+1;
            if(prev_valid&&!prev_ready)begin
                if(!out_valid)fail("valid dropped during stall");
                if(out_addr!==prev_addr)fail("address changed during stall");
            end
            if(out_valid&&out_ready)begin
                s=out_addr;
                if(issue_head[s]>=issue_tail[s])fail($sformatf("phantom source=%0d",s));
                else begin
                    lat=cycle_count-issue_fifo[s][issue_head[s]];issue_head[s]++;
                    if(received>0)address_toggle_count+=popcount4(out_addr^last_output_addr);
                    last_output_addr=out_addr;
                    received_by_source[s]++;received++;total_latency+=lat;
                    if(lat>max_latency)max_latency=lat;
                    if(hotspot_measure&&s==15)hotspot_latency=lat;
                    if(sat_measure)begin
                        if(sat_events>0)begin gap=cycle_count-sat_last;sat_gap_sum+=gap;
                            if(gap<sat_min_gap)sat_min_gap=gap;if(gap>sat_max_gap)sat_max_gap=gap;end
                        sat_last=cycle_count;sat_events++;
                    end
                end
            end
            prev_valid<=out_valid;prev_ready<=out_ready;prev_addr<=out_addr;
        end
    end

    initial begin:test
        integer s,exp,pending_count;
        rst_n=0;src_req_async=0;out_ready=1;offered=0;accepted=0;received=0;errors=0;
        total_latency=0;max_latency=0;hotspot_latency=0;hotspot_measure=0;address_toggle_count=0;last_output_addr=0;sat_measure=0;sat_events=0;
        sat_start=0;sat_elapsed=0;sat_last=0;sat_gap_sum=0;sat_min_gap=32'h7fffffff;sat_max_gap=0;
        prev_valid=0;prev_ready=0;prev_addr=0;cycle_count=0;
        for(s=0;s<16;s=s+1)begin issue_head[s]=0;issue_tail[s]=0;issue_cycle[s]=0;received_by_source[s]=0;end
        repeat(4)@(posedge clk);@(negedge clk);rst_n=1;repeat(3)@(posedge clk);

        $display("TEST_START sr_single");exp=received+1;issue_event(5,2);wait_received(exp,100,"single");
        $display("TEST_START sr_simultaneous");exp=received+16;
        fork issue_event(0,1);issue_event(1,1);issue_event(2,1);issue_event(3,1);
             issue_event(4,1);issue_event(5,1);issue_event(6,1);issue_event(7,1);
             issue_event(8,1);issue_event(9,1);issue_event(10,1);issue_event(11,1);
             issue_event(12,1);issue_event(13,1);issue_event(14,1);issue_event(15,1);join
        wait_received(exp,300,"simultaneous");
        $display("TEST_START sr_burst");exp=received+8;issue_stream(5,8,0);wait_received(exp,300,"burst");
        $display("TEST_START sr_stall");@(negedge clk);out_ready=0;exp=received+4;
        fork
            begin fork issue_event(2,1);issue_event(7,2);issue_event(11,3);issue_event(15,4);join end
            begin repeat(12)@(posedge clk);@(negedge clk);out_ready=1;end
        join
        wait_received(exp,250,"stall");
        $display("TEST_START sr_saturation");exp=received+64;sat_measure=1;sat_start=cycle_count;
        fork issue_stream(0,4,0);issue_stream(1,4,0);issue_stream(2,4,0);issue_stream(3,4,0);
             issue_stream(4,4,0);issue_stream(5,4,0);issue_stream(6,4,0);issue_stream(7,4,0);
             issue_stream(8,4,0);issue_stream(9,4,0);issue_stream(10,4,0);issue_stream(11,4,0);
             issue_stream(12,4,0);issue_stream(13,4,0);issue_stream(14,4,0);issue_stream(15,4,0);join
        wait_received(exp,1200,"saturation");sat_elapsed=cycle_count-sat_start;sat_measure=0;
        $display("TEST_START sr_hotspot");exp=received+13;hotspot_measure=1;
        fork issue_stream(0,12,0);issue_event(15,1);join wait_received(exp,500,"hotspot");hotspot_measure=0;
        $display("TEST_START sr_reset_held");exp=received+1;@(negedge clk);rst_n=0;src_req_async[7]=1;
        issue_cycle[7]=0;offered++;repeat(3)@(posedge clk);@(negedge clk);rst_n=1;
        wait(src_ack_async[7]===1);#1 src_req_async[7]=0;wait(src_ack_async[7]===0);wait_received(exp,150,"reset");
        $display("TEST_START sr_independent");exp=received+32;
        fork issue_stream(0,2,1);issue_stream(1,2,2);issue_stream(2,2,3);issue_stream(3,2,4);
             issue_stream(4,2,5);issue_stream(5,2,1);issue_stream(6,2,2);issue_stream(7,2,3);
             issue_stream(8,2,4);issue_stream(9,2,5);issue_stream(10,2,1);issue_stream(11,2,2);
             issue_stream(12,2,3);issue_stream(13,2,4);issue_stream(14,2,5);issue_stream(15,2,1);join
        wait_received(exp,900,"independent");
        pending_count=0;for(s=0;s<16;s=s+1)pending_count+=issue_tail[s]-issue_head[s];
        if(pending_count!=0)fail($sformatf("undrained=%0d",pending_count));
        if(offered!=accepted||accepted!=received)fail($sformatf("counts %0d/%0d/%0d",offered,accepted,received));
        $display("METRIC sr_events_offered=%0d",offered);$display("METRIC sr_events_received=%0d",received);
        $display("METRIC sr_avg_latency_x1000=%0d",total_latency*1000/received);
        $display("METRIC sr_max_latency=%0d",max_latency);$display("METRIC sr_hotspot_latency=%0d",hotspot_latency);
        $display("METRIC sr_address_toggles=%0d",address_toggle_count);
        $display("METRIC sr_saturation_events=%0d",sat_events);$display("METRIC sr_saturation_elapsed=%0d",sat_elapsed);
        $display("METRIC sr_saturation_min_gap=%0d",sat_min_gap);$display("METRIC sr_saturation_max_gap=%0d",sat_max_gap);
        $display("METRIC sr_errors=%0d",errors);
        if(errors==0)$display("SOURCE_RESIDENT_TEST_PASS");else $display("SOURCE_RESIDENT_TEST_FAIL");
        #20;$finish;
    end
endmodule
