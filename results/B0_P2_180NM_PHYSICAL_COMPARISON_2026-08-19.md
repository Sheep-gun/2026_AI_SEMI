# B0-v1 대비 P2 180 nm physical 비교

## 비교 기준

사용자 지적대로 P2만 Innovus까지 진행한 상태에서는 공정한 physical PPA 비교가 아니었다. 이를 보완하기 위해 `B0-v1`을 P2와 동일한 조건으로 구현했다.

- TSMC 0.18 µm Artisan standard cells
- scan cell 사용 금지
- 동일 slow setup / fast hold Liberty와 `t018` QRC
- clock 10 ns, uncertainty 0.2 ns
- target utilization 60%
- VDD/VSS core ring, CTS, hold optimization, Metal1~Metal6 routing
- post-route coupled extraction, DRC와 connectivity 검사

`T0`는 진짜 clockless 전통 구조지만 feedback loop와 finite-delay 발진 때문에 정상적인 STA/Innovus 비교 대상으로 만들 수 없다. 따라서 T0의 physical-flow 실패는 baseline 문제점으로 보존하고, 합성 가능한 동일 프로토콜 의미의 `B0-v1`을 physical PPA reference로 사용한다.

## 동일 180 nm post-route 결과

| 항목 | B0-v1 | P2 | P2/B0 또는 변화 |
|---|---:|---:|---:|
| post-route cells | 94 | 476 | 5.06× |
| cell area | 1,573.387 µm² | 11,812.046 µm² | 7.51× |
| placement density | 59.87% | 61.45% | 유사 |
| setup slack, slow | +6.704 ns | +2.721 ns | 둘 다 100 MHz 통과 |
| hold slack, fast | +0.103 ns | +0.033 ns | 둘 다 통과 |
| default-activity power | 0.082858 mW | 1.151400 mW | 13.90× |
| route DRC | 0 | 0 | 동등 |
| connectivity problem | 0 | 0 | 동등 |
| coupled SPEF nets | 113 | 504 | P2 구조 증가 반영 |

Power는 두 설계 모두 slow 1.62 V view와 동일 default activity 0.2로 산출했으므로 조건은 일치한다. 하지만 실제 AER traffic VCD가 아니므로 energy/event 또는 실사용 전력을 의미하지는 않는다.

## 기능 성능 비교

| 항목 | B0-v1 | P2 | 변화 |
|---|---:|---:|---:|
| no-stall throughput | 0.25 event/cycle | 1 event/cycle | 4× |
| 100 MHz 기준 peak | 25 Mevents/s | 100 Mevents/s | 4× |
| average latency | 29.658 cycles | 18.438 cycles | -37.8% |
| maximum latency | 901 cycles | 44 cycles | -95.1% |
| source-15 hotspot latency | 49 cycles | 4 cycles | -91.8% |
| arbitration | fixed priority | hierarchical round-robin | starvation 위험 완화 |
| queued capacity | 없음 | 32 events | burst/backpressure 흡수 |

## 정확한 결론

P2는 모든 PPA 지표를 동시에 줄인 설계가 아니다.

- 얻은 것: throughput 4배, starvation 완화, burst buffer, receiver stall 격리, latency tail 대폭 감소, clockless baseline 불안정성 제거
- 지불한 것: cell area 7.51배, default-activity power 13.90배, 더 작은 setup/hold margin

따라서 P2는 **성능·공정성·강건성을 위해 면적과 전력을 지불한 architecture**다. 향후 최적화의 핵심은 기능을 유지하면서 source별 depth-2 queue와 2FF CDC의 storage/clock power를 줄이는 것이다.

## 증거

- B0 sanitized summary: [`reports/baseline/cadence/pnr_180nm/SUMMARY.txt`](../reports/baseline/cadence/pnr_180nm/SUMMARY.txt)
- P2 sanitized summary: [`reports/improved_hierarchical/cadence/pnr_180nm/SUMMARY.txt`](../reports/improved_hierarchical/cadence/pnr_180nm/SUMMARY.txt)

