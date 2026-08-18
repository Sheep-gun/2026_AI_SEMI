# B0 Traditional AER Baseline Freeze

Freeze identifier: `B0-v1`  
Freeze date: 2026-08-18  
Purpose: immutable functional and architectural reference for all later AER improvements

## 1. What this baseline represents

`B0-v1` is a synthesizable, clocked realization of traditional shared-bus AER semantics:

- 16 event sources and one receiver.
- Source address is the 4-bit source index.
- Level-held source request/acknowledge.
- Centralized fixed priority; source 0 is highest.
- One shared parallel address bus.
- Receiver-facing four-phase request/acknowledge.
- No FIFO and one outstanding event per source.
- Direct end-to-end receiver backpressure.

It is not presented as the only historical AER implementation and is not an asynchronous full-custom circuit. It is the explicit, reproducible comparison reference for this project.

## 2. Transaction sequence

```text
source raises src_req[i]
        |
        v
fixed-priority grant latches address i
        |
        v
aer_addr valid, aer_req rises
        |
        v
receiver captures address, aer_ack rises
        |
        v
src_ack[i] rises, source lowers src_req[i]
        |
        v
aer_req falls, receiver lowers aer_ack
        |
        v
interface returns to idle
```

The address remains stable while `aer_req` is high. A new receiver transaction cannot begin until `aer_ack` returns low.

## 3. State machine

| State | Receiver request | Source acknowledge | Exit condition |
|---|---:|---:|---|
| `ST_IDLE` | 0 | all 0 | sink ack low and at least one source request |
| `ST_WAIT_SINK_ACK` | 1 | all 0 | sink ack high |
| `ST_WAIT_SOURCE_RELEASE` | 1 | selected source 1 | selected source request low |
| `ST_WAIT_SINK_RELEASE` | 0 | all 0 | sink ack low |

## 4. Functional guarantee and boundary

- A source obeying the four-phase source contract is not silently dropped.
- No accepted event may be duplicated or converted to a different source address.
- Per-source order is preserved because one source has at most one outstanding event.
- Global ordering among simultaneous sources follows fixed priority.
- Reset discards internal state. A source that holds its request across reset is treated as a new post-reset request.
- A source that violates request/acknowledge sequencing is outside the guarantee.

## 5. Known weaknesses intentionally retained

- Fixed-priority starvation is possible under sustained higher-priority traffic.
- Four receiver-link phases create a measured four-cycle event interval in the zero-delay synchronous receiver model.
- No input buffering exists beyond each source holding one request.
- Receiver backpressure blocks the entire shared bus.
- Flat priority selection and shared address/control nets become harder to scale with source count.

These are comparison variables, not implementation bugs. Later variants must change one variable at a time.

## 6. Frozen verification evidence

- Vivado Simulator 2020.2 compilation and elaboration pass.
- Procedural scoreboard/assertions and concurrent SVA enabled.
- 431 issued events and 431 received events.
- Directed coverage: single, simultaneous-16, burst, receiver stall, saturation, hotspot, reset, and random traffic.
- No-stall saturation interval: four cycles/event, or 0.25 event/cycle.
- Suite average latency: 29.658 cycles; worst observed latency: 901 cycles.
- Pass marker: `TEST_PASS baseline issued=431 received=431`.

## 7. Frozen synthesis-sanity evidence

Vivado FPGA synthesis is used only to prove structural synthesizability before Cadence:

- Tool/part: Vivado 2020.2, `xc7a35tcpg236-1`.
- `synth_design`: 0 errors, 0 critical warnings, 0 warnings.
- Optimized hierarchy: 41 LUTs and 10 FFs.
- No combinational loops and no unconstrained internal endpoints.
- At a 10 ns FPGA sanity clock, estimated post-synthesis WNS is +1.401 ns and estimated data-path delay is 5.161 ns.

These LUT/FF/timing numbers are **not ASIC PPA** and must not appear as the competition's final area, power, or Fmax.

## 8. Comparison rules after freeze

- Do not edit `rtl/baseline/aer_traditional.sv` merely to make a proposed design look better.
- If a genuine baseline bug is found, create `B0-v2`, record the reason, rerun all evidence, and compare every proposed design against the new version.
- Reuse identical event traces, receiver stalls, source count, address width, and acceptance accounting.
- First incremental variant: replace fixed priority with round-robin only. Do not add FIFO or change the receiver protocol in that step.

