`timescale 1ns/1ps

module aer_p8_pareto_order_tb;
    logic clk=0,rst_n=0,out_ready=0;
    logic [15:0] req=0,ack_x2,ack_ring;
    logic [3:0] addr_x2,addr_ring;
    logic valid_x2,valid_ring;
    logic [3:0] log_x2[0:15],log_ring[0:15];
    integer count_x2=0,count_ring=0,errors=0;

    aer_pending_xor2_sparse_reset x2(
        .clk(clk),.rst_n(rst_n),.src_req_async(req),
        .src_ack_async(ack_x2),.out_addr(addr_x2),
        .out_valid(valid_x2),.out_ready(out_ready));
    aer_pending_gray_ring_sparse_reset ring(
        .clk(clk),.rst_n(rst_n),.src_req_async(req),
        .src_ack_async(ack_ring),.out_addr(addr_ring),
        .out_valid(valid_ring),.out_ready(out_ready));

    always #5 clk=~clk;
    always @(posedge clk)begin
        if(rst_n&&out_ready)begin
            if(valid_x2)begin
                if(count_x2<16)log_x2[count_x2]=addr_x2;
                count_x2=count_x2+1;
            end
            if(valid_ring)begin
                if(count_ring<16)log_ring[count_ring]=addr_ring;
                count_ring=count_ring+1;
            end
        end
    end

    function automatic [3:0] expected_x2(input integer rank);
        integer value;
        begin
            value=rank&15;
            expected_x2={value[3],value[2],value[1]^value[2],
                         value[0]^value[1]};
        end
    endfunction

    function automatic [3:0] expected_ring(input integer rank);
        integer value;
        begin value=rank&15;expected_ring=value^(value>>1);end
    endfunction

    initial begin:test
        integer waited,index;
        logic [3:0] held_x2,held_ring;
        // Leave enough reset clocks for both resetless synchronizer stages to
        // contain clean zero samples before robust core release.
        repeat(12)@(posedge clk);
        @(negedge clk);rst_n=1;
        repeat(4)@(posedge clk);
        @(negedge clk);req=16'hffff;
        waited=0;
        while(((ack_x2!==16'hffff)||(ack_ring!==16'hffff))&&waited<40)begin
            @(posedge clk);#1;waited=waited+1;
        end
        if((ack_x2!==16'hffff)||(ack_ring!==16'hffff))begin
            errors=errors+1;$display("P8_PARETO_ACK_HIGH_TIMEOUT");
        end
        @(negedge clk);req=0;

        waited=0;
        while((!valid_x2||!valid_ring)&&waited<20)begin
            @(posedge clk);#1;waited=waited+1;
        end
        held_x2=addr_x2;held_ring=addr_ring;
        repeat(5)begin
            @(posedge clk);#1;
            if(!valid_x2||addr_x2!==held_x2)begin
                errors=errors+1;$display("P8_X2_STALL_FAIL");
            end
            if(!valid_ring||addr_ring!==held_ring)begin
                errors=errors+1;$display("P8_RING_STALL_FAIL");
            end
        end
        @(negedge clk);out_ready=1;

        waited=0;
        while((count_x2<16||count_ring<16)&&waited<80)begin
            @(posedge clk);#1;waited=waited+1;
        end
        if(count_x2!=16||count_ring!=16)begin
            errors=errors+1;
            $display("P8_PARETO_COUNT_FAIL x2=%0d ring=%0d",count_x2,count_ring);
        end
        for(index=0;index<16;index=index+1)begin
            if(log_x2[index]!==expected_x2(index))begin
                errors=errors+1;
                $display("P8_X2_ORDER_FAIL slot=%0d exp=%0d got=%0d",
                         index,expected_x2(index),log_x2[index]);
            end
            if(log_ring[index]!==expected_ring(index))begin
                errors=errors+1;
                $display("P8_RING_ORDER_FAIL slot=%0d exp=%0d got=%0d",
                         index,expected_ring(index),log_ring[index]);
            end
        end
        waited=0;
        while((ack_x2!==0||ack_ring!==0)&&waited<40)begin
            @(posedge clk);#1;waited=waited+1;
        end
        if(ack_x2!==0||ack_ring!==0)begin
            errors=errors+1;$display("P8_PARETO_ACK_LOW_TIMEOUT");
        end
        if(errors==0)$display("P8_PARETO_ORDER_TEST_PASS x2_toggles=18 ring_toggles=16");
        else $display("P8_PARETO_ORDER_TEST_FAIL errors=%0d",errors);
        $finish;
    end
endmodule
