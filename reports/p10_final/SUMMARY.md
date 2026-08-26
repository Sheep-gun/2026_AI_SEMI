# P10 논문 기반 탐색과 P9-GRR 재최적화 근거

공정은 주최측 공식 공정으로 확인되지 않은 서버 제공 FPR 180 nm reference kit다.
모든 수치는 같은 10 ns clock, 1 ns I/O delay, 0.2 ns clock uncertainty와 동일한
CDC 물리 제약을 사용했다.

## 최종 결론

| 설계 / hold target | instances | area (um2) | vectorless (mW) | mapped-SAIF (mW) | core setup | overall setup | hold |
|---|---:|---:|---:|---:|---:|---:|---:|
| 기존 P9-GRR / 0.020 ns | 281 | 6,988.766 | 0.77624020 | 0.57886987 | +4.810 ns | +0.159 ns | +0.012 ns |
| P10-X1 / 0.013 ns | 279 | 6,942.197 | 0.77227874 | 0.58111653 | **+4.971 ns** | +0.198 ns | +0.002 ns |
| **P9-GRR / 0.008 ns** | **263** | **6,742.613** | **0.76127733** | **0.57559566** | +4.844 ns | **+0.317 ns** | +0.001 ns |

P9-GRR 0.008 ns가 새 주력 물리점이다. 0.007 ns run은 hold -0.001 ns로
실패했으므로 0.008~0.007 ns 사이에 경계가 확인됐다.

## 직접 근거

- P9-GRR 0.008 ns: [area](p9grr_h008/postroute_area.rpt),
  [setup](p9grr_h008/postroute_setup_timing.rpt),
  [core setup](p9grr_h008/postroute_core_setup_timing.rpt),
  [hold](p9grr_h008/postroute_hold_timing.rpt),
  [vectorless power](p9grr_h008/postroute_power.rpt),
  [mapped-SAIF power](p9grr_h008/postroute_power_saif.rpt),
  [DRC](p9grr_h008/postroute_drc.rpt),
  [connectivity](p9grr_h008/postroute_connectivity.rpt),
  [clock tree](p9grr_h008/postroute_clock_tree.rpt),
  [LEC](p9grr_h008/p9grr_h008_lec.rpt)
- P9-GRR 0.007 ns 실패점: [hold](p9grr_h007_fail/postroute_hold_timing.rpt),
  [CDC hold](p9grr_h007_fail/postroute_cdc_hold_timing.rpt)
- P10-X1 0.013 ns: [area](p10xor1_h013/postroute_area.rpt),
  [core setup](p10xor1_h013/postroute_core_setup_timing.rpt),
  [hold](p10xor1_h013/postroute_hold_timing.rpt),
  [vectorless power](p10xor1_h013/postroute_power.rpt),
  [mapped-SAIF power](p10xor1_h013/postroute_power_saif.rpt),
  [LEC](p10xor1_h013/p10xor1_lec.rpt)
- Genus screening: [IPRRA](genus/iprra/genus_area.rpt),
  [X1](genus/xor1/genus_area.rpt), [X2](genus/xor2/genus_area.rpt)
- Vivado screening: [IPRRA](vivado/iprra/utilization.rpt),
  [X1](vivado/xor1/utilization.rpt), [X2](vivado/xor2/utilization.rpt)

상세한 논문 적용 범위, 전수검증, hold sweep과 탈락 이유는
[`results/P10_PAPER_DERIVED_PPA_EXPLORATION_2026-08-21.md`](../../results/P10_PAPER_DERIVED_PPA_EXPLORATION_2026-08-21.md)에 정리했다.
