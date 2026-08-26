`timescale 1ns/1ps

// Contract-fair AER comparison.
//
// Demand arrivals are fixed by this testbench and therefore do not move when
// a DUT delays ACK.  Each source owns an external demand FIFO and drives the
// four-phase request only when its wire is idle.  This separates:
//   demand -> REQ : waiting outside the controller;
//   REQ -> ACK    : time the upstream source must hold its request;
//   ACK -> output : storage/elasticity inside the controller;
//   demand -> output: end-to-end latency seen by the application.
module aer_contract_fairness_tb;
    localparam integer N = 16;
    localparam integer MAX_EVENTS_PER_SOURCE = 32;
    localparam integer MAX_TOTAL_EVENTS = 128;
    localparam integer NUM_PHASES = 4;
    localparam integer PH_SPARSE = 0;
    localparam integer PH_STALL = 1;
    localparam integer PH_SATURATION = 2;
    localparam integer PH_HOTSPOT = 3;

    logic clk = 1'b0;
    logic rst_n = 1'b0;
    logic [15:0] src_req_async = '0;
    logic [15:0] src_ack_async;
    logic [3:0] out_addr;
    logic out_valid;
    logic out_ready = 1'b1;

    integer demand_tail [0:N-1];
    integer issue_head [0:N-1];
    integer output_head [0:N-1];
    integer current_event [0:N-1];
    integer event_phase [0:N-1][0:MAX_EVENTS_PER_SOURCE-1];
    integer demand_time_ns [0:N-1][0:MAX_EVENTS_PER_SOURCE-1];
    integer req_time_ns [0:N-1][0:MAX_EVENTS_PER_SOURCE-1];
    integer ack_time_ns [0:N-1][0:MAX_EVENTS_PER_SOURCE-1];
    integer rearm_time_ns [0:N-1][0:MAX_EVENTS_PER_SOURCE-1];
    integer output_time_ns [0:N-1][0:MAX_EVENTS_PER_SOURCE-1];

    integer transfer_addr [0:MAX_TOTAL_EVENTS-1];
    integer transfer_phase [0:MAX_TOTAL_EVENTS-1];
    integer phase_demands [0:NUM_PHASES-1];
    integer phase_first_output_ns [0:NUM_PHASES-1];
    integer phase_last_output_ns [0:NUM_PHASES-1];
    integer phase_output_count [0:NUM_PHASES-1];

    integer demand_total;
    integer transfer_total;
    integer protocol_error [0:N-1];
    integer scoreboard_errors;
    integer stall_release_time_ns;
    integer stall_req_high_at_release;
    integer measurement_start_time_ns;
    integer measurement_end_time_ns;

    logic prev_out_valid;
    logic prev_out_ready;
    logic [3:0] prev_out_addr;

    aer_contract_fairness_dut dut (
        .clk(clk), .rst_n(rst_n),
        .src_req_async(src_req_async), .src_ack_async(src_ack_async),
        .out_addr(out_addr), .out_valid(out_valid), .out_ready(out_ready)
    );

    always #5 clk = ~clk;

    function automatic integer popcount4(input logic [3:0] value);
        integer bit_index;
        begin
            popcount4 = 0;
            for (bit_index = 0; bit_index < 4; bit_index = bit_index + 1)
                popcount4 = popcount4 + value[bit_index];
        end
    endfunction

    function automatic integer popcount16(input logic [15:0] value);
        integer bit_index;
        begin
            popcount16 = 0;
            for (bit_index = 0; bit_index < 16; bit_index = bit_index + 1)
                popcount16 = popcount16 + value[bit_index];
        end
    endfunction

    task automatic report_error(input string message);
        begin
            scoreboard_errors = scoreboard_errors + 1;
            $display("FAIR_ASSERT_FAIL time_ns=%0t message=%s", $time, message);
        end
    endtask

    task automatic enqueue_demand(input integer source, input integer phase_id);
        integer event_index;
        begin
            event_index = demand_tail[source];
            if (event_index >= MAX_EVENTS_PER_SOURCE) begin
                report_error($sformatf("demand FIFO overflow source=%0d", source));
            end else begin
                event_phase[source][event_index] = phase_id;
                demand_time_ns[source][event_index] = $time;
                demand_tail[source] = event_index + 1;
                demand_total = demand_total + 1;
                phase_demands[phase_id] = phase_demands[phase_id] + 1;
            end
        end
    endtask

    task automatic wait_for_transfers(
        input integer expected,
        input integer timeout_cycles,
        input string phase_name
    );
        integer waited;
        begin
            waited = 0;
            while ((transfer_total < expected) && (waited < timeout_cycles)) begin
                @(posedge clk);
                waited = waited + 1;
            end
            if (transfer_total != expected)
                report_error($sformatf("%s timeout expected=%0d received=%0d",
                                       phase_name, expected, transfer_total));
        end
    endtask

    task automatic wait_for_link_idle(input integer timeout_cycles);
        integer waited;
        begin
            waited = 0;
            while (((src_req_async !== '0) || (src_ack_async !== '0)
                    || out_valid) && (waited < timeout_cycles)) begin
                @(posedge clk);
                waited = waited + 1;
            end
            if ((src_req_async !== '0) || (src_ack_async !== '0) || out_valid)
                report_error("link did not return idle");
        end
    endtask

    // One protocol driver owns the complete request vector.  New demand can
    // accumulate independently, but a source presents at most one request at
    // a time, as required by both DUT contracts.
    always @(negedge clk or negedge rst_n) begin : source_driver
        integer source;
        integer event_index;
        if (!rst_n) begin
            src_req_async <= '0;
            for (source = 0; source < N; source = source + 1)
                current_event[source] = -1;
        end else begin
            for (source = 0; source < N; source = source + 1) begin
                if (src_req_async[source] && src_ack_async[source]) begin
                    src_req_async[source] <= 1'b0;
                end else if (!src_req_async[source] && !src_ack_async[source]
                             && (issue_head[source] < demand_tail[source])) begin
                    event_index = issue_head[source];
                    current_event[source] = event_index;
                    issue_head[source] = event_index + 1;
                    req_time_ns[source][event_index] = $time;
                    src_req_async[source] <= 1'b1;
                end
            end
        end
    end

    genvar source_gen;
    generate
        for (source_gen = 0; source_gen < N; source_gen = source_gen + 1) begin : g_handshake_monitor
            always @(posedge src_ack_async[source_gen]) begin : ack_rise_monitor
                integer event_index;
                if (rst_n) begin
                    event_index = current_event[source_gen];
                    if ((event_index < 0) || (event_index >= demand_tail[source_gen])) begin
                        protocol_error[source_gen] = protocol_error[source_gen] + 1;
                        $display("FAIR_ASSERT_FAIL time_ns=%0t unexpected ACK rise source=%0d event=%0d",
                                 $time, source_gen, event_index);
                    end else if (ack_time_ns[source_gen][event_index] >= 0) begin
                        protocol_error[source_gen] = protocol_error[source_gen] + 1;
                        $display("FAIR_ASSERT_FAIL time_ns=%0t duplicate ACK rise source=%0d event=%0d",
                                 $time, source_gen, event_index);
                    end else begin
                        ack_time_ns[source_gen][event_index] = $time;
                    end
                end
            end

            always @(negedge src_ack_async[source_gen]) begin : ack_fall_monitor
                integer event_index;
                if (rst_n) begin
                    event_index = current_event[source_gen];
                    if ((event_index < 0) || (ack_time_ns[source_gen][event_index] < 0)) begin
                        protocol_error[source_gen] = protocol_error[source_gen] + 1;
                        $display("FAIR_ASSERT_FAIL time_ns=%0t unexpected ACK fall source=%0d event=%0d",
                                 $time, source_gen, event_index);
                    end else begin
                        rearm_time_ns[source_gen][event_index] = $time;
                    end
                end
            end
        end
    endgenerate

    // A transfer is counted only on valid && ready.  This avoids treating an
    // address parked in the elastic output register during a stall as service.
    always @(posedge clk or negedge rst_n) begin : output_monitor
        integer source;
        integer event_index;
        integer phase_id;
        if (!rst_n) begin
            prev_out_valid <= 1'b0;
            prev_out_ready <= 1'b0;
            prev_out_addr <= '0;
        end else begin
            if (prev_out_valid && !prev_out_ready) begin
                if (!out_valid)
                    report_error("out_valid dropped while receiver stalled");
                if (out_addr !== prev_out_addr)
                    report_error("out_addr changed while receiver stalled");
            end

            if (out_valid && out_ready) begin
                source = out_addr;
                if ((source < 0) || (source >= N)) begin
                    report_error($sformatf("out-of-range address=%0d", source));
                end else begin
                    event_index = output_head[source];
                    if (event_index >= issue_head[source]) begin
                        report_error($sformatf("phantom output source=%0d event=%0d",
                                               source, event_index));
                    end else if (transfer_total >= MAX_TOTAL_EVENTS) begin
                        report_error("transfer trace overflow");
                    end else begin
                        phase_id = event_phase[source][event_index];
                        output_time_ns[source][event_index] = $time;
                        output_head[source] = event_index + 1;
                        transfer_addr[transfer_total] = source;
                        transfer_phase[transfer_total] = phase_id;
                        transfer_total = transfer_total + 1;
                        if (phase_output_count[phase_id] == 0)
                            phase_first_output_ns[phase_id] = $time;
                        phase_last_output_ns[phase_id] = $time;
                        phase_output_count[phase_id] = phase_output_count[phase_id] + 1;
                    end
                end
            end

            prev_out_valid <= out_valid;
            prev_out_ready <= out_ready;
            prev_out_addr <= out_addr;
        end
    end

    task automatic print_metrics;
        integer source;
        integer event_index;
        integer phase_id;
        integer trace_index;
        integer errors;
        integer event_count [0:NUM_PHASES-1];
        integer sum_demand_to_req [0:NUM_PHASES-1];
        integer sum_req_to_ack [0:NUM_PHASES-1];
        integer sum_ack_to_out [0:NUM_PHASES-1];
        integer sum_req_to_out [0:NUM_PHASES-1];
        integer sum_demand_to_out [0:NUM_PHASES-1];
        integer sum_req_to_rearm [0:NUM_PHASES-1];
        integer max_demand_to_req [0:NUM_PHASES-1];
        integer max_req_to_ack [0:NUM_PHASES-1];
        integer max_req_to_out [0:NUM_PHASES-1];
        integer max_demand_to_out [0:NUM_PHASES-1];
        integer phase_toggles [0:NUM_PHASES-1];
        integer total_toggles;
        integer bit_toggles [0:3];
        integer total_line_busy_ns;
        integer pre_release_acks;
        integer not_presented_at_release;
        integer value;
        begin
            errors = scoreboard_errors;
            total_toggles = 0;
            total_line_busy_ns = 0;
            pre_release_acks = 0;
            not_presented_at_release = 0;
            for (phase_id = 0; phase_id < NUM_PHASES; phase_id = phase_id + 1) begin
                event_count[phase_id] = 0;
                sum_demand_to_req[phase_id] = 0;
                sum_req_to_ack[phase_id] = 0;
                sum_ack_to_out[phase_id] = 0;
                sum_req_to_out[phase_id] = 0;
                sum_demand_to_out[phase_id] = 0;
                sum_req_to_rearm[phase_id] = 0;
                max_demand_to_req[phase_id] = 0;
                max_req_to_ack[phase_id] = 0;
                max_req_to_out[phase_id] = 0;
                max_demand_to_out[phase_id] = 0;
                phase_toggles[phase_id] = 0;
            end
            for (trace_index = 0; trace_index < 4; trace_index = trace_index + 1)
                bit_toggles[trace_index] = 0;

            for (source = 0; source < N; source = source + 1) begin
                errors = errors + protocol_error[source];
                for (event_index = 0; event_index < demand_tail[source]; event_index = event_index + 1) begin
                    phase_id = event_phase[source][event_index];
                    event_count[phase_id] = event_count[phase_id] + 1;
                    if ((req_time_ns[source][event_index] < 0)
                        || (ack_time_ns[source][event_index] < 0)
                        || (rearm_time_ns[source][event_index] < 0)
                        || (output_time_ns[source][event_index] < 0)) begin
                        errors = errors + 1;
                        $display("FAIR_ASSERT_FAIL incomplete event source=%0d index=%0d times=%0d/%0d/%0d/%0d",
                                 source, event_index,
                                 req_time_ns[source][event_index],
                                 ack_time_ns[source][event_index],
                                 rearm_time_ns[source][event_index],
                                 output_time_ns[source][event_index]);
                    end else begin
                        value = req_time_ns[source][event_index] - demand_time_ns[source][event_index];
                        sum_demand_to_req[phase_id] = sum_demand_to_req[phase_id] + value;
                        if (value > max_demand_to_req[phase_id]) max_demand_to_req[phase_id] = value;

                        value = ack_time_ns[source][event_index] - req_time_ns[source][event_index];
                        sum_req_to_ack[phase_id] = sum_req_to_ack[phase_id] + value;
                        if (value > max_req_to_ack[phase_id]) max_req_to_ack[phase_id] = value;

                        value = output_time_ns[source][event_index] - ack_time_ns[source][event_index];
                        sum_ack_to_out[phase_id] = sum_ack_to_out[phase_id] + value;

                        value = output_time_ns[source][event_index] - req_time_ns[source][event_index];
                        sum_req_to_out[phase_id] = sum_req_to_out[phase_id] + value;
                        if (value > max_req_to_out[phase_id]) max_req_to_out[phase_id] = value;

                        value = output_time_ns[source][event_index] - demand_time_ns[source][event_index];
                        sum_demand_to_out[phase_id] = sum_demand_to_out[phase_id] + value;
                        if (value > max_demand_to_out[phase_id]) max_demand_to_out[phase_id] = value;

                        value = rearm_time_ns[source][event_index] - req_time_ns[source][event_index];
                        sum_req_to_rearm[phase_id] = sum_req_to_rearm[phase_id] + value;
                        total_line_busy_ns = total_line_busy_ns + value;

                        if (phase_id == PH_STALL) begin
                            if (ack_time_ns[source][event_index] < stall_release_time_ns)
                                pre_release_acks = pre_release_acks + 1;
                            if (req_time_ns[source][event_index] >= stall_release_time_ns)
                                not_presented_at_release = not_presented_at_release + 1;
                        end
                    end
                end
            end

            for (trace_index = 1; trace_index < transfer_total; trace_index = trace_index + 1) begin
                value = transfer_addr[trace_index] ^ transfer_addr[trace_index-1];
                total_toggles = total_toggles + popcount4(value[3:0]);
                for (source = 0; source < 4; source = source + 1)
                    bit_toggles[source] = bit_toggles[source] + ((value >> source) & 1);
                if (transfer_phase[trace_index] == transfer_phase[trace_index-1])
                    phase_toggles[transfer_phase[trace_index]] =
                        phase_toggles[transfer_phase[trace_index]] + popcount4(value[3:0]);
            end

            if (demand_total != transfer_total) begin
                errors = errors + 1;
                $display("FAIR_ASSERT_FAIL demand/transfer mismatch %0d/%0d",
                         demand_total, transfer_total);
            end
            for (phase_id = 0; phase_id < NUM_PHASES; phase_id = phase_id + 1)
                if (event_count[phase_id] != phase_demands[phase_id]) begin
                    errors = errors + 1;
                    $display("FAIR_ASSERT_FAIL phase=%0d event count %0d/%0d",
                             phase_id, event_count[phase_id], phase_demands[phase_id]);
                end

            $display("FAIR_METRIC events=%0d", transfer_total);
            $display("FAIR_METRIC address_toggles=%0d", total_toggles);
            $display("FAIR_METRIC address_toggles_per_transition_x1000=%0d",
                     (transfer_total > 1) ? (total_toggles * 1000 / (transfer_total - 1)) : 0);
            $display("FAIR_METRIC address_bit_toggles_b0_b1_b2_b3=%0d,%0d,%0d,%0d",
                     bit_toggles[0], bit_toggles[1], bit_toggles[2], bit_toggles[3]);
            $display("FAIR_METRIC total_source_line_busy_ns=%0d", total_line_busy_ns);
            $display("FAIR_METRIC avg_busy_sources_x1000=%0d",
                     (measurement_end_time_ns > measurement_start_time_ns)
                         ? total_line_busy_ns * 1000
                           / (measurement_end_time_ns - measurement_start_time_ns) : 0);
            $display("FAIR_METRIC stall_pre_release_acks=%0d", pre_release_acks);
            $display("FAIR_METRIC stall_not_presented_at_release=%0d", not_presented_at_release);
            $display("FAIR_METRIC stall_req_high_at_release=%0d", stall_req_high_at_release);

            for (phase_id = 0; phase_id < NUM_PHASES; phase_id = phase_id + 1) begin
                $display("FAIR_PHASE phase=%0d events=%0d internal_toggles=%0d output_span_ns=%0d avg_demand_to_req_ns_x1000=%0d max_demand_to_req_ns=%0d avg_req_to_ack_ns_x1000=%0d max_req_to_ack_ns=%0d avg_ack_to_output_ns_x1000=%0d avg_req_to_output_ns_x1000=%0d max_req_to_output_ns=%0d avg_demand_to_output_ns_x1000=%0d max_demand_to_output_ns=%0d avg_req_to_rearm_ns_x1000=%0d",
                         phase_id,
                         event_count[phase_id],
                         phase_toggles[phase_id],
                         phase_last_output_ns[phase_id] - phase_first_output_ns[phase_id],
                         sum_demand_to_req[phase_id] * 1000 / event_count[phase_id],
                         max_demand_to_req[phase_id],
                         sum_req_to_ack[phase_id] * 1000 / event_count[phase_id],
                         max_req_to_ack[phase_id],
                         sum_ack_to_out[phase_id] * 1000 / event_count[phase_id],
                         sum_req_to_out[phase_id] * 1000 / event_count[phase_id],
                         max_req_to_out[phase_id],
                         sum_demand_to_out[phase_id] * 1000 / event_count[phase_id],
                         max_demand_to_out[phase_id],
                         sum_req_to_rearm[phase_id] * 1000 / event_count[phase_id]);
            end
            $display("FAIR_METRIC errors=%0d", errors);
            if (errors == 0)
                $display("AER_CONTRACT_FAIRNESS_PASS");
            else
                $display("AER_CONTRACT_FAIRNESS_FAIL");
        end
    endtask

    initial begin : fixed_demand_workload
        integer source;
        integer repetition;
        integer target;
        integer event_index;

        demand_total = 0;
        transfer_total = 0;
        scoreboard_errors = 0;
        stall_release_time_ns = -1;
        stall_req_high_at_release = -1;
        measurement_start_time_ns = -1;
        measurement_end_time_ns = -1;
        prev_out_valid = 1'b0;
        prev_out_ready = 1'b0;
        prev_out_addr = '0;

        for (source = 0; source < N; source = source + 1) begin
            demand_tail[source] = 0;
            issue_head[source] = 0;
            output_head[source] = 0;
            current_event[source] = -1;
            protocol_error[source] = 0;
            for (event_index = 0; event_index < MAX_EVENTS_PER_SOURCE;
                 event_index = event_index + 1) begin
                event_phase[source][event_index] = -1;
                demand_time_ns[source][event_index] = -1;
                req_time_ns[source][event_index] = -1;
                ack_time_ns[source][event_index] = -1;
                rearm_time_ns[source][event_index] = -1;
                output_time_ns[source][event_index] = -1;
            end
        end
        for (source = 0; source < NUM_PHASES; source = source + 1) begin
            phase_demands[source] = 0;
            phase_first_output_ns[source] = -1;
            phase_last_output_ns[source] = -1;
            phase_output_count[source] = 0;
        end

        repeat (5) @(posedge clk);
        @(negedge clk);
        rst_n = 1'b1;
        repeat (3) @(posedge clk);
        measurement_start_time_ns = $time;

        // Phase 0: isolated events.  There is no intentional queueing, so it
        // measures the minimum CDC + arbitration latency of each contract.
        $display("FAIR_TEST_START sparse");
        target = transfer_total + 16;
        for (source = 0; source < N; source = source + 1) begin
            @(posedge clk);
            #1 enqueue_demand(source, PH_SPARSE);
            repeat (5) @(posedge clk);
        end
        wait_for_transfers(target, 300, "sparse");
        wait_for_link_idle(100);

        // Phase 1: eight fixed arrivals while the receiver is stopped.  Two
        // events per active source expose where each design keeps elasticity.
        $display("FAIR_TEST_START receiver_stall");
        @(negedge clk);
        out_ready = 1'b0;
        @(posedge clk);
        #1;
        enqueue_demand(2, PH_STALL);  enqueue_demand(2, PH_STALL);
        enqueue_demand(7, PH_STALL);  enqueue_demand(7, PH_STALL);
        enqueue_demand(11, PH_STALL); enqueue_demand(11, PH_STALL);
        enqueue_demand(15, PH_STALL); enqueue_demand(15, PH_STALL);
        target = transfer_total + 8;
        repeat (20) @(posedge clk);
        @(negedge clk);
        stall_release_time_ns = $time;
        stall_req_high_at_release = popcount16(src_req_async);
        out_ready = 1'b1;
        wait_for_transfers(target, 400, "receiver_stall");
        wait_for_link_idle(100);

        // Phase 2: four simultaneous demands per source.  Arrival times are
        // fixed even though a four-phase source can present only one at once.
        $display("FAIR_TEST_START saturation");
        @(posedge clk);
        #1;
        for (source = 0; source < N; source = source + 1)
            for (repetition = 0; repetition < 4; repetition = repetition + 1)
                enqueue_demand(source, PH_SATURATION);
        target = transfer_total + 64;
        wait_for_transfers(target, 1600, "saturation");
        wait_for_link_idle(200);

        // Phase 3: one cold source competes with twelve queued hotspot events.
        $display("FAIR_TEST_START hotspot");
        @(posedge clk);
        #1;
        for (repetition = 0; repetition < 12; repetition = repetition + 1)
            enqueue_demand(0, PH_HOTSPOT);
        enqueue_demand(15, PH_HOTSPOT);
        target = transfer_total + 13;
        wait_for_transfers(target, 600, "hotspot");
        wait_for_link_idle(200);

        measurement_end_time_ns = $time;
        print_metrics();
        #20;
        $finish;
    end
endmodule
