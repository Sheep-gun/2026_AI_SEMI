`timescale 1ns/1ps

module aer_pending_gray_epoch_fallthrough_tb;
    localparam integer TIMEOUT_CYCLES = 200;

    logic clk;
    logic rst_n;
    logic [15:0] req_base, req_ft;
    logic [15:0] ack_base, ack_ft;
    logic [3:0] addr_base, addr_ft;
    logic valid_base, valid_ft;
    logic ready_base, ready_ft;

    integer cycle_count;
    integer errors;
    integer offered_ft [0:15];
    integer received_ft [0:15];
    integer received_total_ft;
    integer ft_first_cycle;
    integer base_first_cycle;
    integer phase_transfer_count;
    integer phase_last_cycle;
    integer phase_min_gap;
    integer phase_max_gap;
    bit measure_phase;
    logic previous_valid_ft, previous_ready_ft;
    logic [3:0] previous_addr_ft;

    aer_pending_gray_epoch #(.ROBUST_RESET(1'b1)) base (
        .clk(clk), .rst_n(rst_n), .src_req_async(req_base),
        .src_ack_async(ack_base), .out_addr(addr_base),
        .out_valid(valid_base), .out_ready(ready_base)
    );

    aer_pending_gray_epoch_fallthrough #(.ROBUST_RESET(1'b1)) ft (
        .clk(clk), .rst_n(rst_n), .src_req_async(req_ft),
        .src_ack_async(ack_ft), .out_addr(addr_ft),
        .out_valid(valid_ft), .out_ready(ready_ft)
    );

    initial clk = 1'b0;
    always #5 clk = ~clk;

    task automatic fail(input string message);
        begin
            errors = errors + 1;
            $display("P7_FT_ASSERT_FAIL cycle=%0d message=%s", cycle_count, message);
        end
    endtask

    always @(posedge clk or negedge rst_n) begin : monitors
        integer source;
        integer gap;
        if (!rst_n) begin
            cycle_count = 0;
            received_total_ft = 0;
            ft_first_cycle = -1;
            base_first_cycle = -1;
            previous_valid_ft = 1'b0;
            previous_ready_ft = 1'b0;
            previous_addr_ft = 4'd0;
            for (source = 0; source < 16; source = source + 1)
                received_ft[source] = 0;
        end else begin
            cycle_count = cycle_count + 1;

            if (previous_valid_ft && !previous_ready_ft) begin
                if (!valid_ft)
                    fail("fall-through valid dropped during stall");
                if (addr_ft !== previous_addr_ft)
                    fail("fall-through address changed during stall");
            end

            if (valid_base && ready_base && (base_first_cycle < 0))
                base_first_cycle = cycle_count;

            if (valid_ft && ready_ft) begin
                if (ft_first_cycle < 0)
                    ft_first_cycle = cycle_count;
                source = addr_ft;
                if (received_ft[source] >= offered_ft[source])
                    fail($sformatf("duplicate or phantom FT output source=%0d", source));
                else begin
                    received_ft[source] = received_ft[source] + 1;
                    received_total_ft = received_total_ft + 1;
                end

                if (measure_phase) begin
                    if (phase_transfer_count > 0) begin
                        gap = cycle_count - phase_last_cycle;
                        if (gap < phase_min_gap) phase_min_gap = gap;
                        if (gap > phase_max_gap) phase_max_gap = gap;
                    end
                    phase_last_cycle = cycle_count;
                    phase_transfer_count = phase_transfer_count + 1;
                end
            end

            previous_valid_ft = valid_ft;
            previous_ready_ft = ready_ft;
            previous_addr_ft = addr_ft;
        end
    end

    task automatic reset_both;
        integer source;
        begin
            @(negedge clk);
            rst_n = 1'b0;
            req_base = '0;
            req_ft = '0;
            ready_base = 1'b1;
            ready_ft = 1'b1;
            measure_phase = 1'b0;
            phase_transfer_count = 0;
            phase_last_cycle = 0;
            phase_min_gap = 32'h7fff_ffff;
            phase_max_gap = 0;
            for (source = 0; source < 16; source = source + 1)
                offered_ft[source] = 0;
            repeat (4) @(posedge clk);
            @(negedge clk);
            rst_n = 1'b1;
            repeat (4) @(posedge clk);
        end
    endtask

    task automatic wait_ack_state(
        input bit select_ft,
        input logic [15:0] mask,
        input bit high_state,
        output bit success
    );
        integer waited;
        begin
            waited = 0;
            success = 1'b0;
            while ((waited < TIMEOUT_CYCLES) &&
                   (high_state
                        ? ((((select_ft ? ack_ft : ack_base) & mask)) !== mask)
                        : ((((select_ft ? ack_ft : ack_base) & mask)) !== 16'h0000))) begin
                @(posedge clk);
                #1;
                waited = waited + 1;
            end
            if (high_state
                    ? ((((select_ft ? ack_ft : ack_base) & mask)) === mask)
                    : ((((select_ft ? ack_ft : ack_base) & mask)) === 16'h0000))
                success = 1'b1;
            else
                fail($sformatf("ACK timeout high=%0d mask=%04h ack=%04h",
                    high_state, mask, select_ft ? ack_ft : ack_base));
        end
    endtask

    task automatic issue_ft_mask(input logic [15:0] mask, output bit success);
        integer source;
        bit high_ok, low_ok;
        begin
            for (source = 0; source < 16; source = source + 1)
                if (mask[source]) offered_ft[source] = offered_ft[source] + 1;
            @(negedge clk);
            req_ft = req_ft | mask;
            wait_ack_state(1'b1, mask, 1'b1, high_ok);
            @(negedge clk);
            req_ft = req_ft & ~mask;
            wait_ack_state(1'b1, mask, 1'b0, low_ok);
            success = high_ok && low_ok;
        end
    endtask

    task automatic wait_ft_received(input integer expected, output bit success);
        integer waited;
        begin
            waited = 0;
            while ((received_total_ft < expected) && (waited < TIMEOUT_CYCLES)) begin
                @(posedge clk);
                #1;
                waited = waited + 1;
            end
            success = received_total_ft >= expected;
            if (!success)
                fail($sformatf("FT receive timeout expected=%0d got=%0d",
                    expected, received_total_ft));
        end
    endtask

    initial begin : test_sequence
        integer source;
        integer stable_cycles;
        integer stalled_received;
        bit ok;
        bit ack_base_high_ok, ack_base_low_ok;
        bit ack_ft_high_ok, ack_ft_low_ok;

        rst_n = 1'b0;
        req_base = '0;
        req_ft = '0;
        ready_base = 1'b1;
        ready_ft = 1'b1;
        errors = 0;
        measure_phase = 1'b0;
        for (source = 0; source < 16; source = source + 1)
            offered_ft[source] = 0;

        // Identical single requests prove the direct path saves exactly one
        // clock relative to the registered P7 output.
        reset_both();
        $display("TEST_START p7_ft_single_latency_delta");
        offered_ft[5] = offered_ft[5] + 1;
        @(negedge clk);
        req_base[5] = 1'b1;
        req_ft[5] = 1'b1;
        wait_ack_state(1'b0, 16'h0020, 1'b1, ack_base_high_ok);
        wait_ack_state(1'b1, 16'h0020, 1'b1, ack_ft_high_ok);
        @(negedge clk);
        req_base[5] = 1'b0;
        req_ft[5] = 1'b0;
        wait_ack_state(1'b0, 16'h0020, 1'b0, ack_base_low_ok);
        wait_ack_state(1'b1, 16'h0020, 1'b0, ack_ft_low_ok);
        wait_ft_received(1, ok);
        while ((base_first_cycle < 0) && (cycle_count < TIMEOUT_CYCLES)) begin
            @(posedge clk);
            #1;
        end
        if (base_first_cycle < 0)
            fail("base output transfer timeout");
        else if ((base_first_cycle - ft_first_cycle) != 1)
            fail($sformatf("latency delta expected=1 base=%0d ft=%0d",
                base_first_cycle, ft_first_cycle));
        $display("METRIC p7_ft_latency_reduction_cycles=%0d",
            base_first_cycle - ft_first_cycle);

        // Receiver stall: no transfer is allowed, valid/address must remain
        // stable, and all four early-ACK events must drain exactly once later.
        reset_both();
        $display("TEST_START p7_ft_stall_hold");
        @(negedge clk);
        ready_ft = 1'b0;
        issue_ft_mask(16'h8882, ok);
        stalled_received = received_total_ft;
        stable_cycles = 0;
        while ((stable_cycles < 12) && (errors == 0)) begin
            @(posedge clk);
            #1;
            stable_cycles = stable_cycles + 1;
        end
        if (received_total_ft != stalled_received)
            fail("an FT transfer occurred while ready was low");
        @(negedge clk);
        ready_ft = 1'b1;
        wait_ft_received(4, ok);
        for (source = 0; source < 16; source = source + 1)
            if (received_ft[source] != offered_ft[source])
                fail($sformatf("stall drain mismatch source=%0d offered=%0d received=%0d",
                    source, offered_ft[source], received_ft[source]));

        // A full pending mask must transfer one event on every clock once the
        // synchronizer has delivered it; no output bubble is permitted.
        reset_both();
        $display("TEST_START p7_ft_saturation");
        measure_phase = 1'b1;
        issue_ft_mask(16'hffff, ok);
        wait_ft_received(16, ok);
        measure_phase = 1'b0;
        if (phase_transfer_count != 16)
            fail($sformatf("saturation transfer count=%0d", phase_transfer_count));
        if ((phase_min_gap != 1) || (phase_max_gap != 1))
            fail($sformatf("saturation gaps min=%0d max=%0d",
                phase_min_gap, phase_max_gap));
        for (source = 0; source < 16; source = source + 1)
            if (received_ft[source] != 1)
                fail($sformatf("saturation source=%0d received=%0d", source, received_ft[source]));

        $display("METRIC p7_ft_saturation_events=%0d", phase_transfer_count);
        $display("METRIC p7_ft_saturation_min_gap=%0d", phase_min_gap);
        $display("METRIC p7_ft_saturation_max_gap=%0d", phase_max_gap);
        $display("METRIC p7_ft_errors=%0d", errors);
        if (errors == 0)
            $display("P7_GRAY_EPOCH_FALLTHROUGH_TEST_PASS");
        else
            $display("P7_GRAY_EPOCH_FALLTHROUGH_TEST_FAIL");
        #20;
        $finish;
    end

    initial begin : watchdog
        #500_000;
        fail("global FT watchdog expired");
        $display("P7_GRAY_EPOCH_FALLTHROUGH_TEST_FAIL");
        $finish;
    end
endmodule
