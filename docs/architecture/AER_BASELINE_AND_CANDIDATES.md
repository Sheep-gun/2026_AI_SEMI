# Traditional AER and Improvement Candidates

## AER in plain language

A biological neuron communicates mainly by *when* it spikes. AER reuses a fast digital channel among many artificial neurons: when neuron 5 spikes, the channel sends the number 5 instead of dedicating a separate long wire to neuron 5. The receiver looks up address 5 and recreates or routes the event.

In the traditional transaction used here, the sender first puts the address on a shared bus and raises `request`. The receiver raises `acknowledge` after capturing it. The sender then lowers `request`, and the receiver lowers `acknowledge`. Those four signal transitions return the interface to its original state. If several neurons request together, an arbiter chooses one. A stalled receiver simply delays acknowledgement, so backpressure holds the entire shared channel.

### AER is not UART

UART serializes ordinary bytes one bit at a fixed baud rate and frames them with start/stop bits. It does not inherently know that a byte is a neuron event, nor does a normal UART transaction use a per-event acknowledge. AER is event-driven: silence consumes no event transfers, an event commonly carries a neuron/pixel address on a parallel or otherwise encoded link, and request/acknowledge plus arbitration preserve channel exclusivity. Both can carry an address, but their timing model, framing, arbitration, and flow control are different.

## Explicit traditional baseline for this project

There is no single universal AER packet or circuit. This project therefore calls only the following structure the **traditional baseline**:

- N level-held event requests from neurons.
- Centralized fixed-priority arbitration.
- One shared binary address bus.
- One receiver-facing four-phase request/acknowledge link.
- No elastic input buffer.
- Direct receiver backpressure.

The controller is clocked for synthesizability in the available standard-cell flow, even though the protocol semantics come from asynchronous AER. This modeling choice is part of the result boundary.

## Expected baseline bottlenecks

| Bottleneck | Mechanism | Measurement in this project |
|---|---|---|
| Round-trip handshake | New request waits for request-up, acknowledge-up, request-down, acknowledge-down | Completed-event interval and latency under zero/variable receiver delay |
| Throughput ceiling | One shared link and return-to-zero bubbles serialize all sources | events/cycle and sustainable offered load |
| Simultaneous collisions | Only one source wins; others hold requests | pending time and arbitration wait |
| Starvation | Fixed priority can repeatedly prefer a hotspot source | low-priority maximum wait under source-0 hotspot |
| Scaling | Priority encode/mux fan-in and shared-bus load grow with N | N=8/16/32/64 timing/area sweep |
| Switching | Shared control and address nets toggle for every isolated event | VCD/SAIF dynamic power and toggles/event |
| Metastability/CDC | Raw asynchronous request/acknowledge sampled by a clock can violate setup/hold | CDC wrapper audit; no raw async input allowed in frozen core |
| Loss/duplicate/reorder | Contract violation, missing storage, reset, or incorrect state sequencing | accepted-vs-output scoreboard and protocol assertions |
| Backpressure propagation | One stuck receiver keeps the shared transaction open | stall-to-source delay and blocked-source cycles |

Some problems are workload or implementation dependent. For example, correct handshaking need not lose events, and a well-designed asynchronous arbiter need not be clocked. The project measures the stated RTL baseline rather than claiming every historical AER circuit has every failure.

## Candidate evaluation

### Two-phase toggle handshake

Only one control transition is needed for each direction per event instead of returning each wire to zero within the transaction. It is attractive at a CDC boundary, but correct bundled-data timing, synchronizer latency, reset phase alignment, and formal CDC checks are substantial. It is therefore an explicit adapter experiment.

### Elastic buffering plus round-robin

Two accepted events per source can wait locally while a registered output is stalled. Round-robin rotates the first choice after each completed transfer. This is the selected core because the same one-lane bus can target one transfer per ready cycle and fairness has a simple grant-count bound.

### Hierarchical/pipelined arbitration

A tree reduces a large flat priority cone and localizes wiring. It becomes more valuable at N=64 or N=256, but pipeline stages add latency and verification states. The N-sweep will determine when it is justified.

### Multi-lane banking

Even/odd or region banks can produce two events per cycle if traffic is balanced. A hotspot in one bank still serializes, and output wires roughly double. It will not be used for the headline single-lane comparison.

### Burst or delta encoding

Nearby addresses often share upper bits; a burst header plus delta can reduce switched bits and handshakes. The benefit vanishes for random addresses and escape coding adds state. This requires trace-driven evidence and follows the base design.

## Recommended architecture

```text
src_valid[N] -> depth-2 per-source queues -> round-robin select
                                               |
                                               v
                                      registered address
                                               |
                                      out_valid/out_ready
```

Why this is the best first-round choice:

1. It attacks handshake bubbles, burst collision loss risk, unfair arbitration, and global backpressure without adding a second address lane.
2. Every claimed improvement has a direct metric: throughput, latency distribution, maximum grant wait, queue occupancy, stall ratio, area, timing, and power/event.
3. It uses ordinary flops and combinational logic that Genus and Xcelium can synthesize and simulate reproducibly.
4. It leaves clear, measurable follow-ups: CDC adapter cost, tree arbitration scaling, and two-lane upper bound.

