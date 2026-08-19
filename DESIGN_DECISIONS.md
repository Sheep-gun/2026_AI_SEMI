# DESIGN_DECISIONS

## DD-001: Define one explicit traditional AER baseline

**Decision:** Traditional AER in this project means a single receiver-facing parallel address bus with request/acknowledge four-phase handshaking, multiple level-held source requests, one centralized fixed-priority arbiter, and direct backpressure without an input FIFO.

**Why:** AER is a family of protocols, not one universal packet. This definition matches the classic shared-address/event, arbitration, and handshake concepts while remaining synthesizable in an ordinary standard-cell flow.

**Consequence:** The baseline intentionally exposes fixed-priority starvation and handshake turnaround. It is a benchmark, not a recommended production interface.

## DD-002: Use a clocked controller for the first ASIC comparison

**Decision:** Both baseline and improved cores are clocked by the same clock for the first PPA comparison. The baseline preserves four-phase protocol semantics; the improved core uses decoupled `valid/ready` semantics.

**Why:** Fully delay-insensitive arbiters and C-elements often require custom cells or specialized asynchronous constraints. A clocked reference is reproducible in Genus and allows identical library/PVT/timing assumptions.

**Consequence:** Results describe the synthesized control architecture, not the absolute performance of a hand-crafted asynchronous AER link. The distinction must be explicit in every report.

## DD-003: Recommend buffered round-robin elastic AER

**Decision:** The first proposed structure is one output lane with source-local depth-2 queues, round-robin arbitration, a registered output stage, and `valid/ready` backpressure.

**Why:** It addresses three baseline bottlenecks at once while keeping the same address-bus width: queueing absorbs short collisions, round-robin prevents permanent fixed-priority starvation, and an elastic output removes the return-to-zero bubbles of a four-phase exchange inside one clock domain.

**Expected bounds under stated assumptions:**

- When `out_ready=1` continuously and at least one queue is non-empty, the output target is one event per cycle after pipeline fill.
- With no downstream stall and one event selected per grant, a continuously eligible source should wait no more than `NUM_SOURCES-1` other grants under round-robin.
- No finite FIFO can guarantee losslessness against unbounded overload. Losslessness is guaranteed only for events accepted with `src_valid && src_ready`; unaccepted events remain the source's responsibility.

These are design targets until simulation and synthesis produce measured evidence.

## DD-004: Keep the first comparison single-lane

**Decision:** Multi-lane banking is not included in the initial proposed-vs-baseline headline result.

**Why:** A second lane changes wire count and raw receiver bandwidth. Keeping one lane makes throughput improvement attributable to buffering, fair arbitration, and link protocol rather than twice the physical datapath.

## DD-005: Keep the event format address-only at first

**Decision:** The base event contains only the source/neuron address. Polarity, timestamp, and payload are parameterized follow-up extensions.

**Why:** Added fields increase bus width, register count, switching, and test complexity without directly solving the baseline arbitration bottleneck. Address-only events allow a clean PPA comparison.

## DD-006: Separate core PPA from CDC wrapper PPA

**Decision:** If the neuron source is asynchronous, a bundled-data two-phase toggle adapter plus synchronizers will be an explicit wrapper. Core and wrapper results will be reported separately.

**Why:** A synchronizer lowers but never mathematically eliminates metastability probability. Hiding CDC logic in only one design would make the core comparison unfair.

## DD-007: Reproduce frozen evidence in an isolated workspace

**Decision:** Routine `B0-v1` rechecks copy the manifest-bound RTL, testbench, and scripts into a Git-ignored temporary workspace and run Vivado there. They do not overwrite the frozen log, VCD, report, or checkpoint files in the repository.

**Why:** Vivado logs, reports, waveforms, and checkpoints can change hashes because of timestamps or generated metadata even when RTL behavior is identical. An in-place rerun would destroy the byte-for-byte evidence named by `results/BASELINE_MANIFEST_2026-08-18.md`.

**Consequence:** A recheck compares pass markers and named metrics against the frozen result, then revalidates the original manifest. Any intentional replacement of frozen evidence requires a new dated manifest; an RTL bug fix also requires a new baseline identifier such as `B0-v2`.

## DD-008: Add a clockless functional baseline without overstating signoff

**Decision:** Preserve `B0-v1` unchanged and add `A0-functional` as a separate clockless four-phase baseline. `A0-functional` has no `clk` port; latch state advances from request, acknowledge and state changes. Its fixed-priority encoder remains a functional selection model rather than a physical MUTEX.

**Why:** A clocked FSM alone does not demonstrate self-timed protocol progress. A separate clockless RTL and asynchronous testbench expose the real control behavior while retaining the reproducible synchronous reference. The Cadence audit found no characterized MUTEX or Muller C-element, so claiming a metastability-safe fully asynchronous ASIC would exceed available evidence.

**Consequence:** XSIM event accounting and Vivado latch-structure synthesis are valid evidence for `A0-functional`. Its testbench ns values, unconstrained Vivado timing and LUT/latch count are not asynchronous ASIC PPA. Any headline asynchronous arbiter requires a characterized MUTEX/C-element flow or custom-cell evidence first.

## DD-009: Reject A0-functional as a physical implementation baseline

**Decision:** Retain `A0-functional` for protocol education and RTL waveform evidence, but do not use it as the baseline for FPGA/ASIC implementation or PPA.

**Why:** A dedicated ±20 ps request-skew and X-window test passed 84/84 trials at RTL. The same test on the Vivado post-synthesis functional netlist completed no receiver events in 84 trials and produced 170 assertion failures. Partial SDF annotation also deadlocked in the first trial after unsupported latch timing arcs were removed.

**Consequence:** A future asynchronous baseline must use characterized asynchronous primitives and a validated flow. Otherwise the implementation baseline moves to an H-series structure with explicit asynchronous request capture/synchronization and a synchronous arbiter.

## DD-010: Keep T0 as the unstable traditional structural baseline

**Decision:** Use `T0` as the explicit clockless traditional baseline: structural cross-coupled NOR storage, fixed-priority selection, no FIFO, one address lane and source/receiver 4-phase handshakes. Do not add a synchronous arbiter or hidden synchronizer to T0.

**Why:** The goal of T0 is to expose what the MUTEX-free traditional clockless structure does in the available flow. Vivado functional simulation can pass while Cadence finite-delay simulation oscillates and Genus cannot produce useful constrained timing. Repairing those behaviors inside T0 would erase the baseline problem that P1 is meant to solve.

**Consequence:** T0 area and vectorless power are recorded as tool outputs, but they are not treated as a valid normal-operation PPA point. The lack of usable Fmax and the Xcelium instability remain headline baseline results.

## DD-011: Select P1 for the first-round contest architecture

**Decision:** P1 keeps asynchronous 4-phase source request/acknowledge but crosses requests through two-flop synchronizers into a synchronous buffered core. The core uses a depth-2 queue per source, round-robin scheduling and a one-entry registered valid/ready output.

**Why:** This simultaneously addresses the contest-relevant dimensions of implementation stability, fairness, burst handling, backpressure, throughput and measurable PPA without requiring an unavailable MUTEX cell. Main and CDC-phase tests passed in both Vivado and Xcelium, and Genus produced constrained timing through a 2 ns synthesis point.

**Consequence:** P1 is the main design candidate. Its cost is explicit: 89 sequential cells and 11,605.810 cell area at the 10 ns point. Further work optimizes the 16-way rotating scan and queue allocation without changing the verified interface contract.

## DD-012: Prefer implementation quality over VCD annotation convenience

**Decision:** Retain the multi-dimensional packed source queue representation used by the 207-LUT P1 mapping. Do not flatten it solely to improve VCD queue annotation.

**Why:** A flat 32-bit experiment raised Vivado use from 207 to 347 LUT and worsened 10 ns WNS from -0.813 ns to -1.538 ns. The activity-based result still has incomplete internal mapping, so measurement convenience did not justify the PPA regression.

**Consequence:** Genus vectorless power is the official comparison value. The 1.33562 mW VCD result is auxiliary and is always accompanied by its 15.43% driver-net, 63.63% RTL-driver and 0% MDA-queue coverage.

## DD-013: Replace the flat P1 scheduler with parallel 4x4 hierarchical round-robin

**Decision:** Keep P1's asynchronous source boundary, synchronizers, per-source depth-2 queues and elastic output, but compute four local 4-way winners in parallel and select one with a global 4-way round-robin pointer.

**Why:** A first serial group-then-local implementation improved FPGA results but regressed the 2 ns ASIC point. Parallel local winner computation removed that serial dependency. The final P2 kept all functional metrics while reducing FPGA LUTs by 28.5%, meeting the 10 ns FPGA constraint, reducing 10 ns ASIC area/power slightly, and reducing 2 ns ASIC area by 14.7%.

**Consequence:** P2 replaces P1 as the current main contest design. P1 remains the ablation reference that attributes the measured gain to scheduler structure alone. Activity-based power remains a caution because low-coverage VCD analysis was higher for P2 despite lower vectorless power.

## DD-014: Reject an equal-capacity shared FIFO in the standard-cell first-round design

**Decision:** Retain source-local event counts rather than implementing a central address FIFO for the same 32-event capacity.

**Why:** Source identity is implicit in each local counter, so P1/P2 represent 32 queued events with 32 count bits. A 32-entry central FIFO requires 128 address payload bits plus pointers/count and still needs an admission arbiter for simultaneous requests. A depth-8 FIFO would use fewer bits only by cutting total capacity by 75%, which is not an equal comparison.

**Consequence:** Shared FIFO is reconsidered only with an SRAM macro or a workload contract that justifies lower total occupancy. It is not presented as an area improvement under the current standard-cell constraints.

## Candidate comparison

| Candidate | Main benefit | Main cost/risk | First-round decision |
|---|---|---|---|
| Two-phase asynchronous handshake | Fewer control transitions than four-phase | CDC proof, bundled-data timing, and asynchronous synthesis constraints | CDC wrapper experiment |
| Input FIFO + elastic output | Absorbs bursts and decouples receiver stalls | Storage area and FIFO control power | Selected |
| Round-robin arbitration | Bounded service in grant count under no stall | Pointer and rotating-priority logic | Selected |
| Pipelined/hierarchical arbiter | Shorter combinational fan-in for large N | Extra stages, control complexity, global-order changes | Scaling experiment |
| Two banked lanes | Up to two events/cycle for balanced traffic | Wider I/O and bank-hotspot imbalance | Stretch goal |
| Burst/delta address encoding | Fewer transferred address bits for local bursts | Workload dependence, packet state, escape cases | Trace-driven stretch goal |
| Timestamp/polarity/payload | More expressive events | Wider datapath and higher switching | Functional extension only |
| Congestion indication | Earlier throttling and observability | Threshold tuning and extra status paths | Add counters first |
