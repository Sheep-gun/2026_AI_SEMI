# P4-C Cut-through AER 결과

## 설계 목적

P3는 asynchronous request를 2FF synchronizer로 받은 뒤 source별 pending bit에 저장하고, 다음 clock의 arbitration에서만 그 event를 후보로 사용한다. 출력이 비어 있어도 신규 event는 pending register를 한 번 거친 뒤 선택되므로 한 cycle의 고정 service latency가 생긴다.

P4-C는 저장 용량, hierarchical round-robin, single-lane valid/ready output을 그대로 유지하면서 combinational next-state 순서만 바꿨다.

```text
P3: request 동기화 → pending register 기록 → 다음 cycle arbitration → output
P4-C: request 동기화 → pending next-state 기록과 같은 decision에서 arbitration → output
```

새 event도 기존 pending event와 동일한 round-robin 규칙으로 선택되며, 출력이 비어 있거나 현재 event가 소비되는 cycle이면 즉시 output register에 들어간다. 이를 cut-through scheduling이라고 한다.

## 기능 결과

| 항목 | P3 | P4-C | 변화 |
|---|---:|---:|---:|
| offered / received | 139 / 139 | 139 / 139 | loss·duplicate 0 유지 |
| average latency | 16.517 cycles | 15.741 cycles | **-4.70%** |
| maximum latency | 29 cycles | 28 cycles | **-3.45%** |
| source 15 hotspot | 4 cycles | 3 cycles | **-25.00%** |
| saturation throughput | 1 event/cycle | 1 event/cycle | 동일 |
| CDC phase | 192 / 192 | 192 / 192 | 동일 |
| 16-source order | 16 / 16 | 16 / 16 | 동일 |

Vivado RTL과 post-synthesis gate simulation, Cadence Xcelium main/CDC/order simulation이 모두 통과했다. Conformal LEC는 21 outputs와 79 state points, 총 100개 비교점을 모두 equivalent로 판정했다.

## PPA 결과

### Vivado

| 항목 | P3 | P4-C |
|---|---:|---:|
| LUT | 70 | 95 |
| FF | 79 | 79 |
| data path | 4.016 ns | 4.016 ns |
| 10 ns WNS | +2.546 ns | +2.546 ns |

FPGA LUT mapping에서는 same-cycle pending next-state feedback 때문에 LUT가 늘었지만 register 수와 critical path는 유지됐다.

### Genus 180 nm

| 항목 | P3 | P4-C | 변화 |
|---|---:|---:|---:|
| cells | 293 | 308 | +5.12% |
| cell area | 8,675.251 µm² | 8,568.807 µm² | **-1.23%** |
| data path | 3.132 ns | 2.990 ns | **-4.53%** |
| vectorless power | 1.13497 mW | 1.16579 mW | +2.72% |

### Innovus post-route

| 항목 | P3 | P4-C | 변화 |
|---|---:|---:|---:|
| cells | 311 | 362 | +16.40% |
| cell area | 8,981.280 µm² | 9,353.837 µm² | +4.15% |
| setup slack | +3.131 ns | +3.547 ns | **+13.29%** |
| hold slack | +0.027 ns | +0.004 ns | 둘 다 pass |
| default-activity power | 0.924919 mW | 0.960680 mW | +3.87% |
| DRC / connectivity | 0 / 0 | 0 / 0 | 동일 pass |

P4-C는 hold margin 확보용 buffer 때문에 post-route cell 수는 늘었지만, cell area 증가는 4.15%에 제한됐다. 이 비용으로 평균·최대·hotspot latency와 setup timing을 동시에 개선했다.

![P4-C TSMC 180 nm Innovus post-route](../docs/architecture/p4c_180nm_innovus_postroute.png)

## Homeostatic 확장 탐색

P4-H 후보는 receiver stall 동안 오래 기다린 4-source group으로 round-robin pointer를 미리 이동시키는 homeostatic backpressure steering을 추가했다. 별도 시험에서 `15(blocker) → 5(aged) → 0(fresh)` 순서를 확인했다. 세부 탐색은 [`results/P4_HOMEOSTATIC_EXPLORATION_2026-08-20.md`](P4_HOMEOSTATIC_EXPLORATION_2026-08-20.md)에 분리했다.

그러나 P4-H는 post-route 기준 391 cells, 10,039.075 µm², 1.022200 mW가 필요했다. 혼잡 복구 순서 개선은 확인했지만 대회 주 설계로는 P4-C의 latency/PPA 균형이 더 우수하다고 판단했다. P4-H RTL은 향후 QoS 연구용으로 보존한다.

## 결론

P4-C는 버스 폭, FIFO 깊이 또는 clock frequency를 늘리지 않고 기존 pending next-state를 arbitration에 직접 사용해 한 cycle의 고정 대기를 제거한다. 작은 물리 비용으로 latency와 setup margin을 함께 개선했으므로 P3를 대체하는 최종 개선안으로 채택한다.

## 근거

- RTL: [`rtl/improved/aer_improved_cutthrough.sv`](../rtl/improved/aer_improved_cutthrough.sv)
- 결과 요약: [`reports/improved_cutthrough/cadence/pnr_180nm/SUMMARY.txt`](../reports/improved_cutthrough/cadence/pnr_180nm/SUMMARY.txt)
- Vivado: [`reports/improved_cutthrough/vivado_sanity/`](../reports/improved_cutthrough/vivado_sanity/)
- Genus: [`reports/improved_cutthrough/cadence/pnr_180nm/p4c/`](../reports/improved_cutthrough/cadence/pnr_180nm/p4c/)
- Innovus: [`reports/improved_cutthrough/cadence/pnr_180nm/p4c_pnr/`](../reports/improved_cutthrough/cadence/pnr_180nm/p4c_pnr/)
- Xcelium: [`reports/improved_cutthrough/cadence/xcelium/`](../reports/improved_cutthrough/cadence/xcelium/)
