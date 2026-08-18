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
