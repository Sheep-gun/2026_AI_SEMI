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

## DD-015: Treat the supplied TSMC 0.18um kit as the digital physical target, not a complete tapeout PDK

**Decision:** Use the contest server's Artisan TSMC 0.18um Liberty, six-metal LEF and `t018` QRC files for P2 core place-and-route. Report DEF/SDF/SPEF, MMMC timing, route DRC and connectivity, while explicitly withholding GDS/tapeout signoff claims.

**Why:** Official written notices do not state the 180 nm requirement, but the provided Liberty header explicitly names TSMC 0.18um and the kit contains a working Innovus training flow. The available subset is sufficient for digital core synthesis, CTS, routing and RC extraction. It lacks standard-cell GDS/CDL, stream-out mapping, foundry DRC/LVS decks and matching simulation models.

**Consequence:** P2 now has a verified 180 nm physical implementation point. It is not a pad-ring/package design and Innovus route DRC 0 is not represented as foundry signoff. Missing PDK collateral is a concrete organizer follow-up item.

## DD-016: Use B0-v1, not unstable T0, for apples-to-apples physical PPA

**Decision:** Preserve T0 as the true clockless protocol baseline and its physical-flow failure, while using the synchronous B0-v1 fixed-priority/no-FIFO/four-phase controller as the TSMC 0.18um physical reference for P2.

**Why:** T0 cannot produce meaningful STA or stable finite-delay simulation without a characterized MUTEX and asynchronous signoff flow. B0-v1 preserves the architectural bottlenecks under comparison and can traverse the exact same scan-free Genus and Innovus flow as P2.

**Consequence:** P2 is no longer described as a universal PPA improvement. At matched 100 MHz post-route conditions it delivers 4× throughput and much lower latency/starvation risk, but uses 7.51× cell area and 13.90× default-activity power. Future work must reduce queue and CDC overhead.

## DD-017: Replace P2 depth-2 counts with P3 single pending bits

**Decision:** Retain P2's 2FF CDC, hierarchical round-robin and elastic output, but reduce each source queue from a two-bit count with capacity two to one pending bit with capacity one.

**Why:** Four-phase sources hold requests until acknowledged, so a full pending slot can apply lossless backpressure instead of requiring a second internal slot. P3 passed the complete functional, CDC, burst, stall and order regressions while reducing P2 post-route cells by 34.7%, area by 24.0% and default-activity power by 19.7%.

**Consequence:** P3 replaces P2 as the balanced main design. Total queued capacity falls from 32 to 16 events, an explicit trade-off. A queue-free variant may be smaller but would remove receiver-stall decoupling and is not the same robustness point.

## DD-018: Keep P3 hierarchical arbitration after rejecting flat and queue-free reductions

**Decision:** Retain P3's parallel 4x4 hierarchical round-robin and one pending bit per source.

**Why:** A functionally equivalent flat-pointer candidate saved six FF but increased Vivado LUTs from 70 to 171 and data-path delay from 4.016 to 9.033 ns. Removing the pending bits would eliminate receiver-stall decoupling and change the robustness contract rather than optimize the same design.

**Consequence:** P3 is the current smallest verified balance under the fixed functionality. Further reductions require an explicit interface or buffering trade-off and must be reported as a different operating point, not a free PPA improvement.

## DD-019: Replace P3 with P4-C cut-through scheduling

**Decision:** Preserve P3's interface, 2FF CDC, sixteen depth-1 pending slots, parallel 4x4 round-robin and single valid/ready output, but make a newly accepted `pending_d` event eligible in the same next-state arbitration decision.

**Why:** P3 imposed one pending-register cycle even when the output could accept an event. P4-C removes that fixed service bubble without adding a bus, queue entry or pipeline stage. It passed RTL/post-synthesis/Xcelium main, CDC and order regressions plus 100/100 Conformal compare points. Versus P3 it reduces average latency 4.70%, maximum latency 3.45% and hotspot latency 25%; post-route area and default power rise 4.15% and 3.87%, while setup slack improves 13.29%.

**Consequence:** P4-C replaces P3 as the main improved controller. P4-H homeostatic stall-time pointer steering is retained as a QoS research extension because it improves aged-group recovery order but costs 391 cells, 10,039.075 µm² and 1.02219972 mW post-route.

## DD-020: Replace P4-C with robust P7-GE Gray-epoch arbitration

**Decision:** Preserve P4-C's asynchronous source protocol, 2FF request CDC, sixteen source-indexed pending slots, early ACK, registered valid/ready output and one-event-per-clock peak throughput. Replace the 10-bit hierarchical round-robin state with a 4-bit Gray epoch and XOR tournament. Add a two-FF asynchronous-assert/synchronous-deassert reset release path in the final robust implementation.

**Why:** Under the same event-storage and output contract, P7-GE passed the broad, CDC, fairness, gate, Xcelium, Conformal and Innovus checks. Versus P4-C it reduced post-route cells 362 to 292, cell area 13.80% and vectorless power estimate 10.88%, while setup slack increased from +3.547 ns to +4.350 ns. The common 101-event fixed-demand workload preserved aggregate service timing and reduced output-address bit transitions from 174 to 106.

**Consequence:** P7-GE robust replaces P4-C as the main improved controller. Its fairness bound is at most 16 service decisions for a continuously pending source, excluding receiver stall wall time; it is not FCFS and carries no original-event timestamp. The fall-through variant is retained only as a rejected latency experiment because its register-to-output slack was -2.380 ns.

## DD-021: Replace P7-GE with P8-DG-SCR reset-partitioned direct Gray

**Decision:** Preserve P7-GE's 2FF CDC, sixteen pending slots, early ACK, registered output, full-Gray service order, 16-service-decision fairness bound and one-event-per-clock peak throughput. Store the Gray epoch directly, share one balanced candidate-valid OR tree, factor request acceptance as bit-vector logic, and partition the 75 state FFs into two asynchronous-reset release FFs, 36 resetless FFs and 37 synchronous-clear core FFs. Isolate ACK and valid low while the core reset is active.

**Why:** P8-DG-SCR passed RTL/gate broad, fairness, CDC and clockless/mid-transaction reset tests, repeated the checks in Cadence Xcelium, and passed 75/75 state-point Conformal equivalence. On the fixed 101-event workload it kept P7's event count, service timing, elasticity, output order and 106 address toggles. In the same FPR 180 nm reference flow it reduced Genus area 11.93%. RTLStim2Gate VCD showed a 9.525% directional reduction, but gate driver coverage differed and this value is not treated as clean matched power evidence. The final physical rerun preserves/groups all synchronizer pairs, bounds request-pair delay to 0.9 ns, uses the same CLKBUFX20 root driver as P7, has zero clock-tree violations, and reduces post-route cell area 5.03% and vectorless power 4.58%.

**Consequence:** P8-DG-SCR replaces P7-GE as the current main controller. Normal operation requires two rising clock edges after reset deassertion; `out_addr` is invalid while `out_valid=0`. The smaller timing margins must be reclosed when the official process is known.

## DD-022: Treat all current 180 nm results as provisional reference comparisons

**Decision:** Do not describe the available 180 nm FPR kit as the organizer's confirmed process or as a complete foundry tapeout PDK. Use it only for matched architecture comparison until the organizer specifies the official PDK, library set, corners and submission artifacts.

**Why:** Earlier inspection found process-identifying metadata in the reference library, but no organizer document confirmed that metadata as the contest target. A separate generic 45 nm library is also present on the server. Selecting a server-visible kit is not the same as receiving an official process requirement.

**Consequence:** P7 and P8 180 nm PPA remain valid relative evidence under one controlled library and flow. Once the organizer responds, both designs must be rerun under the same official 45 nm or other target conditions before using the numbers as submission-final PPA.

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
| Cut-through pending next-state | Removes one fixed service cycle without more buffering | Longer same-cycle next-state dependency | Selected as P4-C |
| Homeostatic stall steering | Aged backlog resumes before fresh groups | Extra age state and physical area | Research extension |
| Gray-epoch XOR tournament | Reduces arbitration state and full-backlog address switching | Reorders events; not FCFS | Selected as P7-GE |
