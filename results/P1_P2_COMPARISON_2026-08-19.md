# P1 대비 P2 최적화 비교

## 고정한 것과 바꾼 것

- 고정: 16 sources, 비동기 4-phase 입력, 2FF CDC, source별 depth-2 queue, single elastic output, traffic와 constraints
- 변경: flat 16-way round-robin scheduler → parallel 4×4 hierarchical round-robin scheduler

따라서 아래 차이는 scheduler 계층화 효과로 해석할 수 있다.

| 평가축 | P1 | P2 | 판정 |
|---|---:|---:|---|
| functional/CDC/order errors | 0 | 0 | 동등 |
| steady throughput | 1 event/cycle | 1 event/cycle | 동등 |
| average / max latency | 18.438 / 44 cycles | 18.438 / 44 cycles | 동등 |
| FPGA LUT | 207 | 148 | P2 -28.5% |
| FPGA 10 ns WNS | -0.813 ns | +1.735 ns | P2만 constraint 만족 |
| ASIC 10 ns area | 11,605.810 | 11,386.267 | P2 -1.9% |
| ASIC 10 ns vectorless power | 1.66431 mW | 1.64037 mW | P2 -1.4% |
| ASIC 2 ns area | 15,511.003 | 13,229.093 | P2 -14.7% |
| fastest tested passing synthesis point | 2.0 ns | 1.8 ns | P2 약 555.6 MHz |

## 채택 판단

P2를 P1의 후속 주 설계로 채택한다. 추가 pointer FF 6개보다 arbitration logic 감소 효과가 더 컸고, 특히 FPGA constraint와 high-speed ASIC area에서 명확한 이득을 냈다.

단, activity-based power는 낮은 mapping coverage 조건에서 P2가 더 높았다. 따라서 “모든 power 조건에서 개선”이라고 주장하지 않고 post-layout activity coverage를 다음 검증 과제로 남긴다.

