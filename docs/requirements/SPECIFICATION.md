# AER Comparison Specification v0.1

Status: initial comparison point frozen on 2026-08-18. Items marked **TBD after server inventory** are not facts yet.

## 1. Use scenario and block view

Sixteen bio-mimetic event sources share one digital transport to one downstream event receiver or synaptic-memory front end.

```text
event sources[0..15]
        |
        | source request/event
        v
  capture / arbitration  ---> shared address link ---> receiver
        ^                                      |
        +------------- backpressure -----------+
```

The baseline sends a source address through an end-to-end four-phase exchange. The proposed core queues accepted events, selects queues fairly, and transfers a registered address whenever `valid && ready` is true.

## 2. Frozen logical parameters

| Item | Initial value | Scaling sweep |
|---|---:|---:|
| Event sources | 16 | 8, 16, 32, 64 |
| Receivers/output lanes | 1 | Optional 2-lane stretch case |
| Address width | `ceil(log2(NUM_SOURCES))` = 4 | Derived from source count |
| Payload | None | Optional polarity/timestamp after base comparison |
| Proposed queue depth | 2/source | 1, 2, 4 |
| Event ordering | Per-source order only | Same |

## 3. Clock, reset, and CDC

- Core comparison uses one clock for both designs.
- Active-low reset is asynchronously asserted in RTL. Integration must synchronously release it to the core clock.
- Inputs in the frozen core comparison obey the core clock interface contract.
- A truly asynchronous neuron source requires a separate two-phase toggle/bundled-data CDC adapter. The source must hold bundled data stable until acknowledgement returns. The adapter needs at least a two-flop control synchronizer, CDC constraints, and dedicated verification.
- Receiver-side CDC uses another explicit adapter; it is not inferred from a `ready` or `ack` signal.

## 4. Event and protocol definitions

### 4.1 Baseline source side

- A source raises `src_req[i]` and holds it high.
- The source address is implicit: `i`.
- It may lower `src_req[i]` only after `src_ack[i]` is high.
- It may issue another event only after `src_ack[i]` returns low.
- One source therefore holds at most one outstanding event.

### 4.2 Baseline receiver side

1. Sender places `aer_addr` and raises `aer_req`.
2. Receiver captures the address and raises `aer_ack`.
3. Sender lowers `aer_req` after its source releases the request.
4. Receiver lowers `aer_ack`.

`aer_addr` must remain stable while `aer_req` is high. A new event cannot begin until acknowledgement has returned low.

### 4.3 Proposed core side

- Source event acceptance: `src_valid[i] && src_ready[i]` on a rising edge.
- Output event acceptance: `out_valid && out_ready` on a rising edge.
- Once accepted at a source queue, an event remains internally until transferred or reset.
- When full, a queue lowers `src_ready`; the source retains responsibility for an unaccepted event.

## 5. Arbitration

- Baseline: centralized fixed priority, source 0 highest.
- Proposed: round-robin starting after the most recently served source.
- Round-robin bound: with `out_ready=1`, no resets, and one grant per event, a continuously non-empty source is served within at most `NUM_SOURCES-1` intervening grants. Cycle latency may be larger under backpressure.

## 6. Backpressure

- Baseline backpressure propagates directly from receiver `aer_ack` to the selected source's `src_ack` and blocks all other sources from the bus.
- Proposed backpressure first fills the registered output and per-source queues. It reaches only a full source queue; unrelated non-full sources may still be accepted until their queues fill.
- Neither design claims losslessness when a producer violates its handshake contract or when reset discards an in-flight event.

## 7. Reset policy

- Reset clears grants, requests, acknowledgements, pointers, valid bits, queue occupancy, and metric state.
- Events asserted during reset are not accepted.
- A baseline source that holds `src_req` until after reset is treated as a new post-reset request.
- Proposed sources must retry using `valid/ready` after reset.

## 8. Ordering, loss, and duplication

- Per-source FIFO order is mandatory.
- Global order among simultaneous sources is intentionally arbitration-dependent.
- Scoreboards compare accepted input events with accepted output events.
- An output with no corresponding accepted input is a duplicate/phantom error.
- An accepted input remaining after the drain timeout is a loss/deadlock error.

## 9. Metric definitions

- **Latency (cycles):** output acceptance edge minus source issue/acceptance edge. Baseline also records request-to-output-acceptance latency because the source event becomes pending before acknowledgement.
- **Average latency:** arithmetic mean over all completed events in a named measurement window.
- **Worst latency:** maximum completed-event latency in that window.
- **Throughput:** completed output events divided by non-reset measurement cycles.
- **Peak sustainable throughput:** highest offered rate that reaches steady state without unbounded pending growth for the finite test duration.
- **Stall ratio:** cycles with a pending output event that cannot complete divided by active measurement cycles.
- **Queue occupancy:** per-source and aggregate cycle-weighted occupancy, plus maximum.
- **Arbitration wait:** number of other grants between a source becoming eligible and its service.
- **Fairness:** maximum intervening-grant count and Jain's fairness index over equal-offer windows. Throughput fairness is not claimed under unequal offered loads.
- **Fmax:** reciprocal of the minimum clock period that satisfies the selected signoff-style synthesis timing check, reported with library/PVT and uncertainty.
- **Area:** Genus mapped cell area, with sequential/combinational breakdown when available.
- **Power:** dynamic, leakage, total, activity source, activity window, clock frequency, voltage, and temperature.

## 10. Fair PPA conditions

The following must be identical unless a row explicitly states otherwise:

- Standard-cell library and PVT corner: **TBD after server inventory**.
- Supply voltage and temperature: **TBD after server inventory**.
- Clock period sweep, uncertainty, transition, and latency.
- Input/output delay and drive/load assumptions.
- `NUM_SOURCES` and address width.
- Receiver readiness/backpressure waveform for activity simulation.
- Event arrival trace and accepted-event accounting.
- Synthesis effort, boundary optimization policy, and physical-awareness option.
- Area hierarchy and excluded-cell policy.
- Power activity window and VCD/SAIF mapping coverage.

Pin/control count and storage bits are architectural outcomes and will be reported rather than silently normalized away.

## 11. Required verification matrix

| Test | Baseline | Proposed | Pass evidence |
|---|---|---|---|
| Single event | Required | Required | Exact one output |
| Simultaneous sources | Required | Required | Counts/order contract |
| Continuous burst | Required | Required | No accepted-event loss |
| Maximum load | Required | Required | Drain and throughput |
| Hotspot | Required | Required | Wait/fairness metrics |
| Receiver stall | Required | Required | Stable output and drain |
| Reset during/after request | Required | Required | Reset policy observed |
| FIFO full/empty | N/A: no FIFO | Required | Boundary assertions |
| Long random traffic | Required | Required | Scoreboard clean |
| Protocol assertions | Required | Required | Zero assertion failures |

