# P2 계층형 round-robin AER 결과

## 결론

`P2`는 P1의 비동기 4-phase 입력, 2FF CDC, source별 depth-2 queue와 elastic output을 그대로 유지하면서 flat 16-way scheduler만 **병렬 local 4-way arbiter 4개 + global 4-way arbiter 1개**로 교체한 PPA 최적화본이다.

기능, CDC 안정성, 공정성 지표와 1 event/cycle 처리율을 유지하면서 FPGA LUT/timing과 ASIC 고성능 area를 크게 개선했다. 따라서 P2를 현재 대회 주 설계 후보로 채택한다.

RTL: [`rtl/improved/aer_improved_hierarchical.sv`](../rtl/improved/aer_improved_hierarchical.sv)

## 구조

1. 16개 asynchronous request를 source별 2FF synchronizer로 받는다.
2. source별 2-bit counter가 최대 2개의 동일-address event를 저장한다.
3. 각 4-source group이 local round-robin winner를 병렬로 계산한다.
4. global round-robin이 valid local winner 4개 중 한 group을 선택한다.
5. registered elastic output이 현재 event를 전송한 cycle에 다음 event로 refill된다.

group pointer 2비트와 local pointer 8비트 때문에 P1보다 FF가 6개 늘지만, 긴 16-way rotating scan을 작은 병렬 블록으로 분리한다.

## 기능 검증

| 환경 | main workload | CDC phase | 16-source order |
|---|---:|---:|---:|
| Vivado RTL | 139/139, error 0 | 192/192, error 0 | 16/16, error 0 |
| Vivado post-synthesis | 139/139, error 0 | 192/192, error 0 | 16/16, error 0 |
| Cadence Xcelium | 139/139, error 0 | 192/192, error 0 | 16/16, error 0 |

추가 order test는 reset 직후 모든 source가 동시에 pending일 때 다음 순서를 확인한다.

```text
0, 4, 8, 12, 1, 5, 9, 13, 2, 6, 10, 14, 3, 7, 11, 15
```

이는 global pointer가 group을 순환하고 각 local pointer가 group 내부 source를 순환한다는 것을 직접 검증한다. 전체 발화 시각순 FCFS를 의미하지는 않는다.

기존 P1과 동일하게 saturation gap은 1 cycle, source-15 hotspot latency는 4 cycles, 평균 latency는 18.438 cycles, 최대 latency는 44 cycles다.

## Vivado FPGA sanity

| 항목 | P1 | P2 | 변화 |
|---|---:|---:|---:|
| LUT | 207 | 148 | -28.5% |
| FF | 89 | 95 | +6.7% |
| 10 ns WNS | -0.813 ns | +1.735 ns | +2.548 ns |
| data path | 10.662 ns | 8.114 ns | -23.9% |

P1이 놓쳤던 FPGA 100 MHz sanity constraint를 P2는 만족했다. combinational loop와 unconstrained internal endpoint는 모두 0이다.

## Cadence Genus PPA

### 10 ns 기준점

| 항목 | P1 | P2 | 변화 |
|---|---:|---:|---:|
| cells | 478 | 450 | -5.9% |
| cell area | 11,605.810 | 11,386.267 | -1.9% |
| sequential cells | 89 | 95 | +6.7% |
| worst data path | 3.344 ns | 3.396 ns | +1.6% |
| slack | +6.202 ns | +6.132 ns | -0.070 ns |
| vectorless power | 1.66431 mW | 1.64037 mW | -1.4% |

10 ns에서는 timing이 사실상 유지되고 area와 vectorless power가 소폭 감소한다.

### 고성능 합성점

| constraint | cells | area | data path | slack |
|---|---:|---:|---:|---:|
| P1 2.0 ns | 676 | 15,511.003 | 1.799 ns | 0 ps |
| P2 2.0 ns | 510 | 13,229.093 | 1.542 ns | 0 ps |
| P2 1.8 ns | 553 | 14,177.117 | 1.638 ns | 0 ps |

동일 2 ns에서 P2 area는 P1보다 14.7% 작고 data path는 14.3% 짧다. P2는 1.8 ns, 즉 synthesis 기준 약 555.6 MHz 지점에도 도달했다. 이는 post-layout signoff Fmax가 아니다.

### Power 해석

139-event VCD 보조 power는 P1 1.33562 mW, P2 1.70590 mW였다. 그러나 두 결과 모두 driver-net coverage가 약 15%이고 queue MDA coverage가 0%라 absolute power로 사용할 수 없다. P2의 병렬 local arbitration이 workload switching을 늘릴 가능성은 남아 있으므로, 공식 표에는 동일 vectorless 조건을 쓰고 activity-based power는 위험 신호로 별도 보존한다.

Sanitized evidence: [`reports/improved_hierarchical/cadence/final/SUMMARY.txt`](../reports/improved_hierarchical/cadence/final/SUMMARY.txt)

## Shared FIFO를 채택하지 않은 이유

P1/P2의 source별 counter는 source address가 위치에 암묵적으로 포함되므로 32비트로 32 events를 나타낸다. 동일 32-event capacity의 central FIFO는 address payload만 `32 × 4 = 128 bits`가 필요하고 pointer/count와 admission arbiter도 추가된다.

depth-8 shared FIFO는 payload가 32비트라 비슷해 보이지만 total capacity가 32에서 8로 75% 감소해 동일 조건 비교가 아니다. 따라서 현재 standard-cell 1차 설계에서는 shared FIFO를 area 개선안으로 구현하지 않는다. SRAM macro를 사용할 수 있거나 workload가 낮은 total occupancy를 보장할 때 별도 후보로 다시 평가한다.

