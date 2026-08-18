# References and Claim Map

This file distinguishes literature facts from project decisions. Direct links point to author, publisher, or open-access copies where available.

## Core AER sources

1. K. A. Boahen, “Point-to-Point Connectivity Between Neuromorphic Chips Using Address Events,” *IEEE Transactions on Circuits and Systems II*, vol. 47, no. 5, pp. 416-434, 2000. [Author-hosted PDF](https://web.stanford.edu/group/brainsinsilicon/documents/00_journ_IEEEtsc_Point.pdf)
   - Supports: address-events as time-multiplexed connectivity, shared address encoding, arbitration, four-phase handshaking, collision/queueing analysis, and arbiter/tree scaling discussion.

2. K. A. Boahen, “A Burst-Mode Word-Serial Address-Event Link - I: Transmitter Design,” *IEEE Transactions on Circuits and Systems I*, vol. 51, no. 7, pp. 1269-1280, 2004. [Author-hosted PDF](https://web.stanford.edu/group/brainsinsilicon/documents/04_journ_IEEEtcs_AERChanI.pdf)
   - Supports: burst readout, row/column hierarchy, locality exploitation, address multiplexing, and the throughput/scalability motivation for pipelined or burst AER.
   - The paper reports historical implementation examples; those numbers are not reused as this project's PPA.

3. J. Lin and K. Boahen, “A Delay-Insensitive Address-Event Link,” *15th IEEE Symposium on Asynchronous Circuits and Systems*, pp. 55-62, 2009. [Author-hosted PDF](https://web.stanford.edu/group/brainsinsilicon/documents/09_conf_IEEE_DI_AER.pdf)
   - Supports: delay-insensitive encoded links as an alternative to bundled parallel AER and the cost/robustness trade-off of asynchronous encoding.

4. S. Joshi, S. Deiss, M. Arnold, J. Park, T. Yu, and G. Cauwenberghs, “Scalable Event Routing in Hierarchical Neural Array Architecture with Global Synaptic Connectivity,” *CNNA*, 2010. [Open PDF](https://citeseerx.ist.psu.edu/document?doi=ed727c5d456f91470aa158e5723f18583ac956e9&repid=rep1&type=pdf)
   - Supports: flat shared AER as a scaling limitation and hierarchical routing as a throughput/latency scaling approach.

5. S. Purohit and R. Manohar, “Field-programmable encoding for address-event representation,” *Frontiers in Neuroscience*, vol. 16, 2022, doi: 10.3389/fnins.2022.1018166. [Publisher PDF](https://www.frontiersin.org/journals/neuroscience/articles/10.3389/fnins.2022.1018166/pdf)
   - Supports: encoder/arbitration roles, source/shared queue choices, binary-tree and ring arbitration, `log2(N)` tree traversal, scaling load/delay, burst locality, and fairness-oriented hybrid hierarchy.

## Project-specific inferences, not literature facts

- Selecting a synchronous depth-2 per-source queue, round-robin arbiter, and one-lane `valid/ready` output is this team's design decision.
- One-event-per-cycle and the round-robin grant bound are protocol targets under the assumptions in `SPECIFICATION.md`; simulation and synthesis must confirm the implementation.
- Any final energy/event, Fmax, area, or percentage improvement must come from this repository's same-condition runs, never from a literature number copied across technologies.

## Sources still to add after implementation

- Exact Cadence Genus/Xcelium documentation version available on the team server.
- Foundry library databook for the selected standard-cell/PVT corner, if license permits citation in the private submission.
- CDC methodology source used for the optional two-phase adapter and MTBF calculation.

