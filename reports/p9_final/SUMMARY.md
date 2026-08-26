# P9 최종 180 nm 물리 비교 근거

> 이 디렉터리는 `0.020 ns` hold-target 당시의 동결 근거다. 이후 P10 논문 기반
> 재탐색에서 같은 P9-GRR RTL의 경계를 `0.008 ns` 통과 / `0.007 ns` 실패까지
> 닫았다. 최신 주력 수치는 [P10 최종 근거](../p10_final/SUMMARY.md)를 따른다.
> 아래 표는 비교 이력을 보존하기 위해 수정하지 않았다.

이 디렉터리는 서버 제공 FPR 180 nm digital reference 환경에서 수행한 최종
full clean place-and-route의 핵심 보고서를 보존한다. 이 공정은 주최 측 공식 PDK로
확정된 것이 아니며, 수치는 세 설계를 같은 조건에서 비교하기 위한 잠정 기준이다.

| 설계 / hold target | Inst. | 셀 면적 (µm²) | Vectorless (mW) | Mapped-SAIF (mW) | Core setup | CDC setup | Hold |
|---|---:|---:|---:|---:|---:|---:|---:|
| P8-DG-SCR / 0.021 ns | 297 | 7,364.650 | 0.79657531 | 0.59663396 | +3.278 ns | +0.200 ns | +0.009 ns |
| P9-OHT / 0.012 ns | 290 | 7,291.469 | **0.77267187** | 0.58959029 | **+6.201 ns** | **+0.300 ns** | +0.010 ns |
| **P9-GRR / 0.020 ns** | **281** | **6,988.766** | 0.77624020 | **0.57886987** | +4.810 ns | +0.159 ns | **+0.012 ns** |

세 최종점 모두 clock-tree violation, route DRC, connectivity problem이 0이다.
Mapped-SAIF의 primary-input/flop-output annotation은 세 설계 모두 100%이며,
total-net coverage는 P8 80.68%, OHT 84.30%, GRR 80.71%다. 따라서 SAIF 수치는
동일 101-event workload의 방향성 비교이고, 실리콘 전력 sign-off나 실제 ECG
traffic의 energy/event 측정값은 아니다.

- `p8_optimized_180nm/`: 공정한 직전 기준점 P8
- `oht_180nm/`: timing·vectorless-power Pareto 대안 P9-OHT
- `grr_180nm/`: 면적·workload-power 주 후보 P9-GRR
- `grr_cadence/`, `oht_cadence/`: Genus와 Conformal 보고서
- `grr_activity/`, `oht_activity/`, `activity_logs/`: VCD→mapped-SAIF 전력 근거

전체 hold sweep과 실패 경계는
[`results/P9_PHYSICAL_HOLD_PARETO_SWEEP_2026-08-21.md`](../../results/P9_PHYSICAL_HOLD_PARETO_SWEEP_2026-08-21.md)에 기록한다.
