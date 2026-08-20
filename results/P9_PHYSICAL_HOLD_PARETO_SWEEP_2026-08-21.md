# P9 180 nm 물리 hold/PPA Pareto 스윕

작성일: 2026-08-21

## 1. 목적과 고정 조건

이 실험은 RTL 기능을 바꾸는 탐색이 아니라, 이미 합성된 P8-DG-SCR,
P9-OHT, P9-GRR netlist에서 Innovus의 hold 보정 목표가 과도하게 큰지
확인하는 물리 최적화다. `holdTargetSlack`만 바꾸고 각 점을 floorplan부터
다시 시작하는 full clean place-and-route로 실행했다. 기존 최종 Innovus DB나
저장소의 baseline 산출물은 재사용하거나 수정하지 않았다.

세 설계에 공통으로 다음 조건을 고정했다.

- 서버에 구축된 FPR 180 nm digital reference kit
- 10 ns clock, Innovus clock uncertainty 0.2 ns
- 합성된 request synchronizer 32 FF와 reset-release 2 FF 보존
- Innovus `dont_touch`, request 16쌍과 reset 1쌍의 soft physical group
- request synchronizer pair max-delay 0.900 ns, reset pair 1.000 ns
- `source_max_capacitance=0.250 pF`
- legal clock driver와 Metal1-Metal6 routing
- post-CTS와 post-route에 동일한 `holdTargetSlack` 적용
- 모든 완료점에서 clock-tree violation 0, DRC violation 0, connectivity problem 0

원격 full-clean 실행에 사용한 고정 입력의 SHA-256은 다음과 같다. 이 mapped
netlist 자체와 비우승 sweep의 전체 raw report는 생성 산출물이라 공개 저장소에
중복 포함하지 않았고, 최종 세 winner의 raw report와 activity log만
`reports/p9_final/`에 보존한다.

| 설계 | 합성 netlist SHA-256 |
|---|---|
| P8-DG-SCR | `627a65aeec2effa370f58bd19fe664163e2b4e5df711a13285a64191fbb22139` |
| P9-OHT | `1a494494f35874dfe4a57de39e1ae79d608b52ad286f9bc3ff9c9d32e0d3bf67` |
| P9-GRR | `c280acede5bb5e41cb1ab82ba8e06c8808833f8ed8a1c393ecffe0ef42ae8a05` |

`holdTargetSlack`는 optimizer에 주는 목표값이지 최종 timing 통과를 보장하는
hard constraint가 아니다. 따라서 목표값이 커져도 실제 hold slack이나 셀 수가
항상 단조롭게 증가하지 않았다. 최종 판단은 각 clean run의 extracted post-route
timing report에 기록된 slack 부호로 했다. `-0.000 ns`도 음수 부호가 있으므로
통과로 간주하지 않았다.

## 2. P8-DG-SCR 스윕

아래 전체 sweep 표는 각 원격 독립 workspace의 report에서 추출한 관찰 기록이다.
공개 저장소에는 최종 `0.021 ns` winner의 raw report를 포함하고, 나머지 점의 raw
파일은 원격 workspace에만 보존한다. OHT와 GRR의 비우승점도 같은 원칙을 따른다.

| Hold 목표 (ns) | Inst. | 셀 면적 (µm²) | Vectorless power (mW) | Core setup (ns) | CDC setup (ns) | Hold (ns) | CDC hold (ns) | 판정 |
|---:|---:|---:|---:|---:|---:|---:|---:|---|
| 0.030 | 313 | 7,657.373 | 0.81695915 | +3.235 | +0.201 | +0.028 | +0.028 | 기존 최종점 |
| 0.028 | 312 | 7,587.518 | 0.81108984 | +3.233 | +0.135 | +0.023 | +0.023 | PASS |
| 0.025 | 307 | 7,494.379 | 0.80627502 | +3.231 | +0.170 | +0.008 | +0.008 | PASS |
| 0.022 | 301 | 7,401.240 | 0.79837055 | +3.234 | +0.193 | +0.010 | +0.010 | PASS |
| **0.021** | **297** | **7,364.650** | **0.79657531** | **+3.278** | **+0.200** | **+0.009** | **+0.009** | **최소 양수점** |
| 0.020 | 295 | 7,351.344 | 0.79518795 | +3.236 | +0.195 | -0.000 | -0.000 | FAIL |
| 0.019 | 293 | 7,311.427 | 0.79296349 | +3.236 | +0.225 | -0.000 | -0.000 | FAIL |

P8 내부에서는 0.021 ns 점이 최소 양수 hold를 만족한다. 기존 0.030 ns 점보다
셀 면적은 3.8228%, vectorless power는 2.4951% 감소했다. 다만 아래의 OHT와
GRR 후보가 이 P8 물리점을 다시 앞서므로 P8 자체를 최종 P9 후보로 선택할
근거는 남지 않는다.

## 3. P9-OHT 스윕

| Hold 목표 (ns) | Inst. | 셀 면적 (µm²) | Vectorless power (mW) | Core setup (ns) | CDC setup (ns) | Hold (ns) | CDC hold (ns) | 판정 |
|---:|---:|---:|---:|---:|---:|---:|---:|---|
| 0.030 | 304 | 7,511.011 | 0.78894292 | +6.196 | +0.163 | +0.032 | +0.039 | 원래 물리점 |
| 0.020 | 299 | 7,397.914 | 0.77976867 | +6.188 | +0.206 | +0.010 | +0.010 | PASS |
| 0.015 | 292 | 7,304.774 | 0.77302382 | +6.204 | +0.224 | +0.008 | +0.008 | PASS |
| **0.012** | **290** | **7,291.469** | **0.77267187** | **+6.201** | **+0.300** | **+0.010** | **+0.010** | **최소 양수점** |
| 0.011 | 290 | 7,281.490 | 0.77204797 | +6.201 | +0.301 | -0.001 | -0.001 | FAIL |
| 0.010 | 290 | 7,278.163 | 0.77221174 | +6.200 | +0.204 | -0.001 | -0.001 | FAIL |
| 0.005 | 289 | 7,261.531 | 0.77098204 | +6.200 | +0.307 | -0.002 | -0.002 | FAIL |

OHT의 경계는 0.011~0.012 ns 사이에서 확인됐다. 0.012 ns 점은 원래 0.030 ns
점보다 셀 면적 2.9229%, vectorless power 2.0624%를 줄이면서 양수 hold를
유지한다.

## 4. P9-GRR 스윕

| Hold 목표 (ns) | Inst. | 셀 면적 (µm²) | Vectorless power (mW) | Core setup (ns) | CDC setup (ns) | Hold (ns) | CDC hold (ns) | 판정 |
|---:|---:|---:|---:|---:|---:|---:|---:|---|
| 0.030 | 287 | 7,138.454 | 0.78845680 | +4.843 | +0.183 | +0.010 | +0.010 | 원래 물리점 |
| 0.028 | 289 | 7,151.760 | 0.78903985 | +4.842 | +0.159 | +0.024 | +0.040 | PASS, 지배됨 |
| 0.025 | 285 | 7,055.294 | 0.78157709 | +4.865 | +0.156 | +0.024 | +0.025 | PASS |
| **0.020** | **281** | **6,988.766** | **0.77624020** | **+4.810** | **+0.159** | **+0.012** | **+0.012** | **최종 스윕점** |

GRR 0.020 ns 점은 원래 0.030 ns 점보다 셀 면적 2.0969%, vectorless power
1.5494%를 줄였다. 양수 hold와 충분한 core/CDC setup을 유지했고 0.025 및
0.028 ns 점을 면적과 vectorless power에서 모두 앞선다. 이번 실행 범위에서는
0.020 ns 아래의 경계를 추가 탐색하지 않았으므로, 이 점을 "수학적으로 가장
낮은 통과 목표"라고 부르지는 않는다. 다만 현재 검증된 GRR 중 최저 PPA점이다.

## 5. 실제 workload activity를 반영한 post-route power

각 winner의 post-route DB를 복원한 뒤, 해당 설계의 fixed-demand mapped SAIF를
`read_activity_file`로 읽고 같은 setup view에서 static power를 다시 계산했다.
세 실행 모두 SAIF read 완료 marker가 있었고 Innovus error는 0이었다.

| 설계 / 물리점 | SAIF SHA-256 | PI coverage | Flop-output coverage | Total-net coverage | SAIF power (mW) |
|---|---|---:|---:|---:|---:|
| P8-DG-SCR / 0.021 | `b148499d5801b51369840555db1fe8eacab92c4a68c426a04f591ea3edd488ea` | 19/19 = 100% | 111/111 = 100% | 284/352 = 80.6818% | 0.59663396 |
| OHT / 0.012 | `a6ace24abc637605590c41e1fefddf8fb5e60667b55794e91681963f289a4ec3` | 19/19 = 100% | 129/129 = 100% | 306/363 = 84.2975% | 0.58959029 |
| GRR / 0.020 | `dc0f274d6ed6acb5bbbe4d1831e72993d2a394e2463d24f51c86174aa34ac55a` | 19/19 = 100% | 108/108 = 100% | 272/337 = 80.7122% | **0.57886987** |

OHT는 P8보다 SAIF power가 1.1806% 낮고, GRR은 P8보다 2.9774%, OHT보다
1.8183% 낮다. P8과 GRR의 total-net coverage는 각각 80.6818%와 80.7122%로
거의 같으며, OHT는 84.2975%다. 세 설계 모두 primary input과 flop output
coverage가 100%다. 이 값은 동일 workload 방향을 보여 주는 근거지만
transistor-level sign-off power 측정은 아니다.

## 6. 최종 물리 Pareto

| 설계 / 목표 | Inst. | 셀 면적 (µm²) | Vectorless power (mW) | SAIF power (mW) | Core setup (ns) | CDC setup (ns) | Hold (ns) |
|---|---:|---:|---:|---:|---:|---:|---:|
| P8-DG-SCR / 원래 0.030 | 313 | 7,657.373 | 0.81695915 | - | +3.235 | +0.201 | +0.028 |
| P8-DG-SCR / 0.021 | 297 | 7,364.650 | 0.79657531 | 0.59663396 | +3.278 | +0.200 | +0.009 |
| P9-OHT / 0.012 | 290 | 7,291.469 | **0.77267187** | 0.58959029 | **+6.201** | **+0.300** | +0.010 |
| **P9-GRR / 0.020** | **281** | **6,988.766** | 0.77624020 | **0.57886987** | +4.810 | +0.159 | **+0.012** |

결론은 다음과 같다.

1. P8 0.021 ns는 P8 내부 최적점이지만 OHT 0.012 ns가 면적, vectorless power,
   core setup, CDC setup, hold에서 모두 앞서므로 P9 최종 후보에서는 제외한다.
2. GRR 0.020 ns는 OHT 0.012 ns보다 면적이 4.1515%, 실제 workload SAIF power가
   1.8183% 낮다. 따라서 **면적과 workload 기반 전력을 중시하는 주 후보**다.
3. OHT 0.012 ns는 GRR보다 vectorless power가 0.4618% 낮고 core/CDC setup
   여유가 더 크다. 따라서 **보수적인 timing margin과 vectorless power를
   중시하는 Pareto 대안**으로 남긴다.
4. 원래 P8 0.030 ns 최종점과 비교하면 GRR 0.020 ns는 post-route 셀 면적을
   8.7315%, vectorless power를 4.9842% 줄였다. OHT 0.012 ns는 각각 4.7785%,
   5.4210% 줄였다.

## 7. Clean-check 근거와 원격 산출물

각 원격 point는 독립 project root를 사용한다. 공개 문서에서는 계정과 host를
제거한 다음 표기만 남기며, winner의 동일 내용 raw report는
`reports/p9_final/`에서 직접 확인할 수 있다.

| 설계 / point | 보존된 작업공간 표기 |
|---|---|
| P8-DG-SCR / 0.021 | `<REMOTE_WORKSPACE>/p8_hold_0p021` |
| P9-OHT / 0.012 | `<REMOTE_WORKSPACE>/p9oht_hold_0p012` |
| P9-GRR / 0.020 | `<REMOTE_WORKSPACE>/p9grr_hold_0p020` |

각 root에서 다음 파일을 직접 확인했다.

- `logs/innovus_console.log`: 완료 marker 1회, run exit 0
- `reports/*_pnr/postroute_setup_timing.rpt`
- `reports/*_pnr/postroute_core_setup_timing.rpt`
- `reports/*_pnr/postroute_cdc_setup_timing.rpt`
- `reports/*_pnr/postroute_hold_timing.rpt`
- `reports/*_pnr/postroute_cdc_hold_timing.rpt`
- `reports/*_pnr/postroute_area.rpt`
- `reports/*_pnr/postroute_power.rpt`
- `reports/*_pnr/postroute_clock_tree.rpt`: `Clock DAG net violations: None`
- `reports/*_pnr/postroute_drc.rpt`: `No DRC violations were found`
- `reports/*_pnr/postroute_connectivity.rpt`: `Found no problems or warnings`
- P8/OHT/GRR `reports/*_pnr/postroute_power_saif.rpt`와
  `logs/postroute_saif_power.log`: SAIF read 완료 marker, error 0

원격 DB와 route 산출물은 각 winner workspace의 `db/`와 `outputs/` 아래에 그대로
보존했다. 공개 저장소에는 계정·호스트 경로를 제거한 핵심 report를
`reports/p9_final/`에 복사했다. 이 문서를 작성하기 위해 기존 P8 final report,
post-route DB, DEF/SDF/SPEF 또는 이미지를 덮어쓰지 않았다.

## 8. 탐색 소진 판단

- P8은 0.020 ns 실패와 0.021 ns 통과, OHT는 0.011 ns 실패와 0.012 ns
  통과를 각각 full clean P&R로 확인했다. 현재 flow와 0.001 ns 목표 해상도에서
  두 후보의 hold-target 경계 탐색은 소진됐다.
- GRR은 0.030, 0.028, 0.025, 0.020 ns를 실행했고 0.020 ns가 모든 상위점을
  PPA에서 앞섰다. 0.020 ns 아래의 실패 경계까지는 실행하지 않았으므로 GRR의
  절대 최저 통과 목표가 증명된 것은 아니다.
- 다만 GRR 0.020 ns의 최종 hold는 +0.012 ns에 불과하다. 이보다 목표를 더
  낮추는 작업은 수 ps 수준의 여유를 비용과 교환하는 미세 조정이며, 공정/전압/
  온도 sign-off가 아닌 현재 단일 reference flow에서는 결과 재현성과 물리
  안전 여유를 함께 약화시킨다. 따라서 이번 회차에서는 추가 hold-target sweep의
  효용이 충분히 소진된 것으로 보고 중단한다.
- 다음의 유의미한 개선은 같은 knob를 더 미세하게 누르는 작업보다, 공식 PDK가
  확정된 뒤 OHT와 GRR을 동일 공정에서 재합성·재배치하거나 새로운 RTL 후보를
  검증하는 것이다.

## 9. 결과 범위

이 결과는 서버의 FPR 180 nm reference 환경에서 아키텍처와 물리 옵션을 같은
조건으로 비교한 값이다. 주최 측 공식 PDK sign-off, silicon MTBF, pad ring,
package, foundry DRC/LVS 또는 실측 전력을 뜻하지 않는다.
