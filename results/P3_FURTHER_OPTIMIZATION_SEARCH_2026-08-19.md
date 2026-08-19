# P3 추가 최적화 탐색

## P3-flat 후보

P3 hierarchical scheduler의 group pointer 2비트와 local pointer 8비트를 하나의 flat pointer 4비트로 바꾸어 6 FF를 줄이는 후보를 구현했다. CDC, pending buffer와 output은 동일하게 유지했다.

기능 workload는 139/139 events, error 0, average latency 16.517 cycles, maximum latency 29 cycles로 통과했고 CDC phase도 192/192, error 0이었다.

| Vivado 10 ns | P3 hierarchical | P3-flat | 변화 |
|---|---:|---:|---:|
| FF | 79 | 73 | -6 |
| LUT | 70 | 171 | +144% |
| WNS | +2.546 ns | +0.816 ns | -1.730 ns |
| data path | 4.016 ns | 9.033 ns | +125% |

16-way rotating scan logic의 비용이 pointer 6 FF 절감보다 훨씬 컸으므로 P3-flat은 Vivado 단계에서 탈락시켰다. 명확히 열등한 후보에 Cadence license와 P&R 시간을 사용하지 않았다.

## Queue-free 후보를 채택하지 않은 이유

P3의 pending bit까지 제거하면 source request 자체가 event를 보존할 수는 있지만, receiver가 stall된 동안 controller가 source를 먼저 acknowledge할 수 없다. 즉 P3가 제공하는 receiver-stall decoupling과 16-event buffering을 잃으며 동일 기능 비교가 아니다.

## 현재 결론

현재 고정 조건은 다음과 같다.

- source별 2FF CDC
- lossless four-phase held-request interface
- receiver stall 중 source 조기 acknowledge
- 16-source fairness
- ready 상태에서 1 event/cycle

이 조건 안에서 P3의 1-bit pending + parallel 4×4 hierarchical round-robin은 지금까지 검증한 후보 중 가장 작은 균형점이다. 절대적인 수학적 최적성을 증명한 것은 아니지만, 추가 상태 제거는 기능을 바꾸고 pointer 축소는 실제 합성 결과가 악화됐다.
