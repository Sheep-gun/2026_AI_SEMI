`timescale 1ns/1ps

module aer_pending_gray_epoch_fair_tb;
    localparam integer TIMEOUT_CYCLES = 160;
    localparam integer RANDOM_TRIALS = 64;

    logic clk;
    logic rst_n;
    logic [15:0] src_req_async;
    logic [15:0] src_ack_async;
    logic [3:0] out_addr;
    logic out_valid;
    logic out_ready;

    integer cycle_count;
    integer transfer_count;
    integer error_count;
    logic [3:0] transfer_log [0:63];
    logic [3:0] last_transfer_addr;
    logic previous_valid;
    logic previous_ready;
    logic [3:0] previous_addr;

    aer_pending_gray_epoch_frozen_wrapper dut (
        .clk(clk),
        .rst_n(rst_n),
        .src_req_async(src_req_async),
        .src_ack_async(src_ack_async),
        .out_addr(out_addr),
        .out_valid(out_valid),
        .out_ready(out_ready)
    );

    initial clk = 1'b0;
    always #5 clk = ~clk;

    task automatic report_error(input string message);
        begin
            error_count = error_count + 1;
            $display("P7_ASSERT_FAIL cycle=%0d message=%s", cycle_count, message);
        end
    endtask

    function automatic [3:0] gray_address(input integer epoch);
        integer value;
        begin
            value = epoch & 15;
            gray_address = value ^ (value >> 1);
        end
    endfunction

    function automatic [3:0] expected_winner(
        input logic [15:0] request_mask,
        input integer epoch
    );
        integer source;
        integer distance;
        integer best_distance;
        logic [3:0] preference;
        begin
            preference = gray_address(epoch);
            expected_winner = 4'd0;
            best_distance = 32;
            for (source = 0; source < 16; source = source + 1) begin
                if (request_mask[source]) begin
                    distance = source ^ preference;
                    if (distance < best_distance) begin
                        best_distance = distance;
                        expected_winner = source[3:0];
                    end
                end
            end
        end
    endfunction

    function automatic [31:0] lfsr_next(input logic [31:0] state);
        begin
            lfsr_next = {state[30:0], state[31] ^ state[21] ^ state[1] ^ state[0]};
        end
    endfunction

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cycle_count = 0;
            transfer_count = 0;
            last_transfer_addr = 4'd0;
            previous_valid = 1'b0;
            previous_ready = 1'b0;
            previous_addr = 4'd0;
        end else begin
            cycle_count = cycle_count + 1;

            if (previous_valid && !previous_ready) begin
                if (!out_valid)
                    report_error("out_valid dropped while receiver was stalled");
                if (out_addr !== previous_addr)
                    report_error("out_addr changed while receiver was stalled");
            end

            if (out_valid && out_ready) begin
                last_transfer_addr = out_addr;
                if (transfer_count < 64)
                    transfer_log[transfer_count] = out_addr;
                transfer_count = transfer_count + 1;
            end

            previous_valid = out_valid;
            previous_ready = out_ready;
            previous_addr = out_addr;
        end
    end

    task automatic reset_controller;
        begin
            @(negedge clk);
            rst_n = 1'b0;
            src_req_async = '0;
            out_ready = 1'b1;
            repeat (4) @(posedge clk);
            @(negedge clk);
            rst_n = 1'b1;
            // Two clocks release reset; the third is the first active core edge.
            repeat (4) @(posedge clk);
        end
    endtask

    task automatic wait_ack_mask_high(
        input logic [15:0] mask,
        output bit success
    );
        integer waited;
        begin
            waited = 0;
            success = 1'b0;
            while ((((src_ack_async & mask) !== mask)) && (waited < TIMEOUT_CYCLES)) begin
                @(posedge clk);
                #1;
                waited = waited + 1;
            end
            if ((src_ack_async & mask) === mask)
                success = 1'b1;
            else
                report_error($sformatf("ACK-high timeout mask=%04h ack=%04h", mask, src_ack_async));
        end
    endtask

    task automatic wait_ack_mask_low(
        input logic [15:0] mask,
        output bit success
    );
        integer waited;
        begin
            waited = 0;
            success = 1'b0;
            while ((((src_ack_async & mask) !== 16'h0000)) && (waited < TIMEOUT_CYCLES)) begin
                @(posedge clk);
                #1;
                waited = waited + 1;
            end
            if ((src_ack_async & mask) === 16'h0000)
                success = 1'b1;
            else
                report_error($sformatf("ACK-low timeout mask=%04h ack=%04h", mask, src_ack_async));
        end
    endtask

    task automatic issue_mask(
        input logic [15:0] mask,
        output bit success
    );
        bit high_ok;
        bit low_ok;
        begin
            success = 1'b0;
            if (mask == 16'h0000) begin
                report_error("issue_mask received an empty mask");
            end else begin
                @(negedge clk);
                src_req_async = src_req_async | mask;
                wait_ack_mask_high(mask, high_ok);
                @(negedge clk);
                src_req_async = src_req_async & ~mask;
                wait_ack_mask_low(mask, low_ok);
                success = high_ok && low_ok;
            end
        end
    endtask

    task automatic wait_next_transfer(
        output logic [3:0] address,
        output bit success
    );
        integer start_count;
        integer waited;
        begin
            start_count = transfer_count;
            waited = 0;
            success = 1'b0;
            while ((transfer_count == start_count) && (waited < TIMEOUT_CYCLES)) begin
                @(posedge clk);
                #1;
                waited = waited + 1;
            end
            if (transfer_count > start_count) begin
                address = last_transfer_addr;
                success = 1'b1;
            end else begin
                address = 4'hx;
                report_error("output transfer timeout");
            end
        end
    endtask

    task automatic send_single_and_drain(input integer source, output bit success);
        logic [3:0] observed;
        bit issue_ok;
        bit transfer_ok;
        integer count_before;
        begin
            count_before = transfer_count;
            issue_mask(16'h0001 << source, issue_ok);
            if (transfer_count == count_before)
                wait_next_transfer(observed, transfer_ok);
            else begin
                observed = last_transfer_addr;
                transfer_ok = 1'b1;
            end
            if (transfer_ok && (observed !== source[3:0])) begin
                report_error($sformatf("single-source mismatch expected=%0d got=%0d", source, observed));
                transfer_ok = 1'b0;
            end
            success = issue_ok && transfer_ok;
        end
    endtask

    task automatic advance_epoch(input integer grant_count, output bit success);
        integer grant_index;
        bit one_ok;
        begin
            success = 1'b1;
            for (grant_index = 0; grant_index < grant_count; grant_index = grant_index + 1) begin
                send_single_and_drain((grant_index * 5 + 2) & 15, one_ok);
                if (!one_ok)
                    success = 1'b0;
            end
        end
    endtask

    initial begin : verification
        integer index;
        integer trial;
        integer epoch_under_test;
        integer dummy_grants;
        integer grants_until_target;
        integer base_count;
        logic [15:0] random_mask;
        logic [31:0] rng_state;
        logic [3:0] observed;
        logic [3:0] expected;
        bit operation_ok;
        bit advance_ok;
        bit transfer_ok;

        rst_n = 1'b0;
        src_req_async = '0;
        out_ready = 1'b1;
        error_count = 0;
        rng_state = 32'h6d2b_79f5;

        // Exact full-backlog Gray order.
        reset_controller();
        $display("TEST_START p7_full_backlog_gray_order");
        issue_mask(16'hffff, operation_ok);
        index = 0;
        while ((transfer_count < 16) && (index < TIMEOUT_CYCLES)) begin
            @(posedge clk);
            #1;
            index = index + 1;
        end
        if (transfer_count != 16) begin
            report_error($sformatf("full backlog timeout transfers=%0d", transfer_count));
        end else begin
            for (index = 0; index < 16; index = index + 1) begin
                if (transfer_log[index] !== gray_address(index))
                    report_error($sformatf(
                        "Gray order mismatch slot=%0d expected=%0d got=%0d",
                        index, gray_address(index), transfer_log[index]
                    ));
            end
        end
        $write("METRIC p7_full_order=");
        for (index = 0; index < 16; index = index + 1)
            $write("%0d%s", transfer_log[index], (index == 15) ? "\n" : ",");

        // Worst-position fairness test.  The blocker consumes epoch 0, so a
        // full pending mask starts at epoch 1 and source 0 is exact preference
        // only at the sixteenth following grant.
        reset_controller();
        $display("TEST_START p7_starvation_bound");
        @(negedge clk);
        out_ready = 1'b0;
        issue_mask(16'h0080, operation_ok);
        issue_mask(16'hffff, operation_ok);
        base_count = transfer_count;
        @(negedge clk);
        out_ready = 1'b1;
        wait_next_transfer(observed, transfer_ok);
        if (transfer_ok && (observed !== 4'd7))
            report_error($sformatf("blocker mismatch expected=7 got=%0d", observed));

        grants_until_target = 0;
        observed = 4'hf;
        while ((observed !== 4'd0) && (grants_until_target < 17)) begin
            wait_next_transfer(observed, transfer_ok);
            if (!transfer_ok)
                grants_until_target = 17;
            else
                grants_until_target = grants_until_target + 1;
        end
        if (grants_until_target > 16)
            report_error($sformatf("starvation bound exceeded grants=%0d", grants_until_target));
        if (grants_until_target != 16)
            report_error($sformatf("worst-position test expected 16 grants got=%0d", grants_until_target));
        $display("METRIC p7_worst_position_grants=%0d", grants_until_target);

        // Frozen random masks.  A stalled blocker creates a stable arbitration
        // epoch while every bit in random_mask is acknowledged into pending_q.
        $display("TEST_START p7_random_frozen_masks trials=%0d", RANDOM_TRIALS);
        for (trial = 0; trial < RANDOM_TRIALS; trial = trial + 1) begin
            reset_controller();
            rng_state = lfsr_next(rng_state);
            epoch_under_test = rng_state[19:16];
            rng_state = lfsr_next(rng_state);
            random_mask = rng_state[15:0];
            if (random_mask == 16'h0000)
                random_mask = 16'h0001 << rng_state[23:20];

            // The blocker itself advances the epoch once.
            dummy_grants = (epoch_under_test + 15) & 15;
            advance_epoch(dummy_grants, advance_ok);

            @(negedge clk);
            out_ready = 1'b0;
            issue_mask(16'h8000, operation_ok);
            issue_mask(random_mask, operation_ok);
            expected = expected_winner(random_mask, epoch_under_test);

            @(negedge clk);
            out_ready = 1'b1;
            wait_next_transfer(observed, transfer_ok);
            if (transfer_ok && (observed !== 4'd15))
                report_error($sformatf("trial=%0d blocker expected=15 got=%0d", trial, observed));
            wait_next_transfer(observed, transfer_ok);
            if (transfer_ok && (observed !== expected))
                report_error($sformatf(
                    "trial=%0d epoch=%0d mask=%04h expected=%0d got=%0d",
                    trial, epoch_under_test, random_mask, expected, observed
                ));
        end

        $display("METRIC p7_random_trials=%0d", RANDOM_TRIALS);
        $display("METRIC p7_errors=%0d", error_count);
        if (error_count == 0)
            $display("P7_GRAY_EPOCH_FAIR_TEST_PASS");
        else
            $display("P7_GRAY_EPOCH_FAIR_TEST_FAIL");
        #20;
        $finish;
    end

    initial begin : global_watchdog
        #2_000_000;
        report_error("global simulation watchdog expired");
        $display("P7_GRAY_EPOCH_FAIR_TEST_FAIL");
        $finish;
    end
endmodule
