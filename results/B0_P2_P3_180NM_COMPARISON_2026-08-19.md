# B0-v1 / P2 / P3 180 nm 비교

| 항목 | B0-v1 | P2 depth-2 | P3 depth-1 |
|---|---:|---:|---:|
| queue capacity | 0 | 32 | 16 |
| arbitration | fixed priority | hierarchical RR | hierarchical RR |
| throughput | 0.25 event/cycle | 1 | 1 |
| average latency | 29.658 | 18.438 | 16.517 cycles |
| maximum latency | 901 | 44 | 29 cycles |
| post-route cells | 94 | 476 | 311 |
| post-route area | 1,573.387 | 11,812.046 | 8,981.280 µm² |
| post-route power | 0.082858 | 1.151400 | 0.924919 mW |
| setup slack | +6.704 | +2.721 | +3.131 ns |
| hold slack | +0.103 | +0.033 | +0.027 ns |
| route DRC/connectivity | 0/0 | 0/0 | 0/0 |

## 판단

- B0: 최소 area/power지만 4-phase bubble, fixed-priority starvation, FIFO 부재와 긴 latency tail을 가진다.
- P2: 기능적 개선은 크지만 depth-2 queue 비용이 과도하다.
- P3: P2의 기능 장점을 유지하면서 area 24.0%, power 19.7%, maximum latency 34.1%를 추가 개선한다.

현재 대회 주 설계 후보는 P3다. “모든 항목이 B0보다 작다”는 주장은 하지 않는다. P3의 설계 철학은 B0보다 자원을 더 사용하되, P2에서 불필요했던 두 번째 queue slot을 제거해 성능·공정성·강건성 대비 비용을 낮추는 것이다.

