# Schedule to 2026-08-28

The plan includes a one-day reproducibility/freeze buffer. A task is complete only when its raw evidence is stored.

| Date | Exit criterion |
|---|---|
| Aug 18 | PDF/local/server status recorded; baseline definition, RTL, and first self-checking simulation committed |
| Aug 19 | Baseline directed/random suite clean; baseline latency/throughput/fairness logs and VCD retained |
| Aug 20 | Proposed depth-2 round-robin elastic RTL compiles; common traffic driver connected |
| Aug 21 | Proposed directed/random suite clean; queue/full/backpressure/fairness assertions pass |
| Aug 22 | Cadence authentication available; exact library/PVT/LEF/QRC inventory recorded; Genus smoke synthesis for both tops |
| Aug 23 | Same-constraint baseline/proposed area and timing sweeps complete; raw reports archived |
| Aug 24 | Timing-critical logic identified; behavior-preserving RTL optimization and before/after table complete |
| Aug 25 | Xcelium activity run and SAIF/VCD-based power attempted; otherwise labeled vectorless fallback complete |
| Aug 26 | Scaling points and same-trace quantitative comparison complete; architecture/result narrative drafted |
| Aug 27 | Reproduction from clean checkout; report links, units, corner labels, and claim audit complete; design freeze |
| Aug 28 | Submission packaging, checksum, final opening test, and contingency buffer |

Critical dependency: secure Cadence login must be resolved by Aug 22. Local RTL/verification work does not wait for it.

