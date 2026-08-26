# 최종 주장-검증 근거 대응표

이 문서는 발표나 보고서에 사용할 문장이 어떤 시험과 원본 파일에 근거하는지
연결한다. 비교 대상은 T0, P9-GRR, P9-OHT뿐이다.

## 1. 기능 주장

| 발표에 사용할 주장 | 시험 방법과 조건 | 결과 | 근거 | 정확한 해석 |
|---|---|---|---|---|
| T0가 입력 event를 유실·중복 없이 전달했다 | 단일, 16-source 동시 요청, burst, receiver stall, 64-event saturation, hotspot, reset, 독립 stream | Issued 139, received 139, assertion error 0 | [T0 RTL log](../sim/final/logs/t0_rtl.log) | Digital behavioral model과 정해진 지연 조건에서 protocol 무결성 확인. Analog metastability 증명은 아님 |
| GRR이 101-event 공통 workload를 처리했다 | Sparse 16, stall 8, saturation 64, hotspot 13 | Events 101, error 0 | [GRR contract log](../sim/final/logs/p9_grr_contract.log) | 해당 workload에서 phantom, duplicate, source queue order와 stall 안정성 확인 |
| OHT가 같은 service contract를 처리했다 | GRR과 같은 네 phase, 같은 demand schedule | Events 101, error 0 | [OHT contract log](../sim/final/logs/p9_oht_contract.log) | Interface·저장·throughput·fairness bound가 같음. Sparse contention의 source 간 출력 순서가 GRR과 bit-exact하다는 뜻은 아님 |
| P9가 full backlog에서 1 event/clock을 출력했다 | 64-event saturation, clock 10 ns | Output span 630 ns = 63 intervals × 10 ns | [GRR log](../sim/final/logs/p9_grr_contract.log), [OHT log](../sim/final/logs/p9_oht_contract.log) | Pipeline이 찬 뒤 ready=1일 때 back-to-back transfer. 각 event의 end-to-end latency가 1 clock이라는 뜻은 아님 |
| Receiver stall 중 P9 출력이 안정적이다 | out_ready=0 phase에서 valid/address hold assertion | Error 0 | [공통 testbench](../tb/final/aer_p9_contract_tb.sv) | Stall 중 현재 output register를 보존함 |
| P9가 Early ACK로 source와 receiver를 분리한다 | Stall phase에서 output 소비 전 source ACK 관찰 | Stall release 전 ACK 5개 | [GRR log](../sim/final/logs/p9_grr_contract.log), [OHT log](../sim/final/logs/p9_oht_contract.log) | ACK는 receiver 소비 완료가 아니라 controller 내부 소유권 기록을 의미 |

현재 101-event 시험은 모든 2^16 request mask와 모든 내부 state를 전수검사한 formal
proof가 아니다. 지속 Pending의 ≤16 successful-grant bound는 RTL 구조와 Gray
preference sweep으로 설명하며, 시험 이름만으로 전수 검증을 주장하지 않는다.

## 2. RTL 구조 주장

| 주장 | RTL 근거 | 의미 |
|---|---|---|
| T0는 TLATX1 5개와 DLY4X1 6개를 사용한다 | [T0 RTL](../rtl/final/aer_t0_traditional_async.sv) | Grant 4 bit + busy 1 latch, capture 5 delay + request launch 1 delay |
| GRR은 71 state points다 | [GRR RTL](../rtl/final/aer_p9_grr.sv), [GRR LEC](../reports/final_45nm/lec/p9_grr/lec.rpt) | Reset release 2 + REQ 2FF 32 + ACK 16 + Pending 16 + out_rank 4 + valid 1 |
| OHT는 75 state points다 | [OHT RTL](../rtl/final/aer_p9_oht.sv), [OHT LEC](../reports/final_45nm/lec/p9_oht/lec.rpt) | 공통 67 + Gray epoch 4 + output address 4 |
| GRR은 source 6을 rank 4에 고정 배선한다 | [GRR RTL](../rtl/final/aer_p9_grr.sv) | REQ·ACK·Pending이 같은 rank 위치에 있어 selected-rank feedback 변환을 줄임 |
| GRR은 output rank를 fairness pointer로 재사용한다 | [GRR RTL](../rtl/final/aer_p9_grr.sv) | Out_rank가 현재 출력과 다음 strict-cyclic 시작점 두 역할을 수행 |
| OHT는 16→8→4→2→1 top-down tree를 사용한다 | [OHT RTL](../rtl/final/aer_p9_oht.sv) | Pair, quarter, half valid를 병렬 생성하고 final one-hot을 pending clear mask로 사용 |
| OHT epoch는 선택 source가 아니라 successful grant마다 한 Gray step 전진한다 | [OHT RTL](../rtl/final/aer_p9_oht.sv) | GRR과 같은 exact source order가 아니라 Gray epoch preference sweep |

## 3. Genus 합성 주장

| 설계 | Cells | Cell area | Vectorless | Workload power | Data path | 근거 |
|---|---:|---:|---:|---:|---:|---|
| T0 | 91 | 210.672 µm² | 0.001541 mW | 해당 없음 | Selected max-delay | [Area](../reports/final_45nm/synthesis/t0/genus_area.rpt), [Power](../reports/final_45nm/synthesis/t0/genus_power.rpt), [Timing](../reports/final_45nm/synthesis/t0/genus_timing.rpt) |
| P9-GRR | 260 | 655.272 µm² | 0.023833 mW | 0.014789 mW | 2.210 ns | [Area](../reports/final_45nm/synthesis/p9_grr/genus_area.rpt), [Power](../reports/final_45nm/synthesis/p9_grr/genus_power.rpt), [Activity power](../reports/final_45nm/synthesis/p9_grr_activity/genus_power_vcd.rpt), [Timing](../reports/final_45nm/synthesis/p9_grr/genus_timing.rpt) |
| P9-OHT | 275 | 696.654 µm² | 0.019387 mW | 0.014515 mW | 1.588 ns | [Area](../reports/final_45nm/synthesis/p9_oht/genus_area.rpt), [Power](../reports/final_45nm/synthesis/p9_oht/genus_power.rpt), [Activity power](../reports/final_45nm/synthesis/p9_oht_activity/genus_power_vcd.rpt), [Timing](../reports/final_45nm/synthesis/p9_oht/genus_timing.rpt) |

Cell area는 die 면적이 아니라 표준셀 footprint의 합이다.

## 4. Innovus post-route PPA 주장

| 항목 | T0 | P9-GRR | P9-OHT | 원본 근거 |
|---|---:|---:|---:|---|
| Instances | 92 | 263 | 278 | 각 postroute area report |
| Cell area | 214.092 µm² | 669.294 µm² | 709.308 µm² | [T0](../reports/final_45nm/pnr/t0/reports/postroute_area.rpt), [GRR](../reports/final_45nm/pnr/p9_grr/reports/postroute_area.rpt), [OHT](../reports/final_45nm/pnr/p9_oht/reports/postroute_area.rpt) |
| Vectorless power | 0.00212669 mW | 0.02064081 mW | 0.01921823 mW | [T0](../reports/final_45nm/pnr/t0/reports/postroute_power.rpt), [GRR](../reports/final_45nm/pnr/p9_grr/reports/postroute_power.rpt), [OHT](../reports/final_45nm/pnr/p9_oht/reports/postroute_power.rpt) |
| Mapped-SAIF total | 해당 없음 | 0.01438235 mW | 0.01377985 mW | [GRR](../reports/final_45nm/pnr/p9_grr/reports/postroute_power_saif.rpt), [OHT](../reports/final_45nm/pnr/p9_oht/reports/postroute_power_saif.rpt) |
| Core arrival / slack | 해당 없음 | 2.807 / +6.824 ns | 2.159 / +7.555 ns | [GRR](../reports/final_45nm/pnr/p9_grr/reports/postroute_core_setup_timing.rpt), [OHT](../reports/final_45nm/pnr/p9_oht/reports/postroute_core_setup_timing.rpt) |
| Overall setup | 해당 없음 | +0.472 ns | +0.458 ns | [GRR](../reports/final_45nm/pnr/p9_grr/reports/postroute_setup_timing.rpt), [OHT](../reports/final_45nm/pnr/p9_oht/reports/postroute_setup_timing.rpt) |
| Hold | 해당 없음 | +0.024 ns | +0.024 ns | [GRR](../reports/final_45nm/pnr/p9_grr/reports/postroute_hold_timing.rpt), [OHT](../reports/final_45nm/pnr/p9_oht/reports/postroute_hold_timing.rpt) |
| Recovery / removal | 해당 없음 | +9.386 / +0.061 ns | +9.380 / +0.061 ns | 각 recovery/removal report |

Overall setup은 0.8 ns로 제한한 FF1→FF2 CDC placement path가 지배하므로 arbiter
속도 비교에 사용하지 않는다. GRR/OHT 중재 core 비교에는 core arrival와 slack을
사용한다. 10 ns 조건에서는 둘 다 1 event/clock이므로 OHT의 timing 이점은 더 큰
주파수 여유다. 별도 Fmax sweep을 수행한 것은 아니다.

## 5. OHT 전력 이점의 원인

| Post-route SAIF 항목 | P9-GRR | P9-OHT | 해석 |
|---|---:|---:|---|
| Sequential total | 약 0.01206 mW | 약 0.01251 mW | OHT의 별도 epoch 4 FF 비용으로 증가 |
| Combinational total | 약 0.002321 mW | 약 0.001269 mW | One-hot tree의 조합 activity 감소 |
| Total switching | 0.00135875 mW | 0.00085341 mW | OHT가 약 37.2% 낮음 |
| Total capacitance | 3.452e-13 F | 3.36335e-13 F | OHT가 약 2.57% 낮음 |
| Total power | 0.01438235 mW | 0.01377985 mW | OHT가 4.189% 낮음 |
| Annotation coverage | 97.517731% | 97.315437% | 매우 가깝지만 100% silicon measurement는 아님 |

OHT는 순차소자 전력이 증가했지만 조합논리 전력 감소가 더 커 전체 전력이 낮아졌다.
주소 toggle 114→106도 같은 방향의 보조 근거지만 전체 전력의 단독 원인은 아니다.

## 6. LEC와 물리 검증

| 설계 | LEC | DRC | Connectivity | 근거 |
|---|---|---:|---:|---|
| T0 | 21 output + 5 state equivalent | 0 | 0 | [LEC](../reports/final_45nm/lec/t0/lec.rpt), [DRC](../reports/final_45nm/pnr/t0/reports/postroute_drc.rpt), [Connectivity](../reports/final_45nm/pnr/t0/reports/postroute_connectivity.rpt) |
| P9-GRR | 21 output + 71 state equivalent | 0 | 0 | [LEC](../reports/final_45nm/lec/p9_grr/lec.rpt), [DRC](../reports/final_45nm/pnr/p9_grr/reports/postroute_drc.rpt), [Connectivity](../reports/final_45nm/pnr/p9_grr/reports/postroute_connectivity.rpt) |
| P9-OHT | 21 output + 75 state equivalent | 0 | 0 | [LEC](../reports/final_45nm/lec/p9_oht/lec.rpt), [DRC](../reports/final_45nm/pnr/p9_oht/reports/postroute_drc.rpt), [Connectivity](../reports/final_45nm/pnr/p9_oht/reports/postroute_connectivity.rpt) |

LEC는 RTL과 Genus mapped netlist의 등가성이다. Post-route netlist LEC, LVS와
GDS sign-off를 의미하지 않는다. DRC 0과 connectivity 0도 현재 routing database의
규칙·연결 검사이며 완성 chip의 pad ring, IR drop, electromigration 또는 antenna
sign-off를 뜻하지 않는다.

## 7. T0 timing 주장 범위

T0의 [Genus timing](../reports/final_45nm/synthesis/t0/genus_timing.rpt)은 선택한
5 ns I/O max-delay 검사를 만족한다. Post-route 최악 보고 slack은 +4.126 ns다.
그러나 [unconstrained report](../reports/final_45nm/synthesis/t0/genus_unconstrained.rpt)에는
busy_latch G/D 등 내부 self-timed path가 남아 있다.

따라서 사용할 수 있는 문장:

> T0는 GPDK45 표준 latch·delay cell로 합성·배치·배선됐고 선택한 I/O max-delay,
> DRC, connectivity와 RTL-to-mapped LEC를 통과했다.

사용하면 안 되는 문장:

> T0의 모든 비동기 bundled-data 경로와 metastability 안전성이 sign-off됐다.

## 8. 물리 이미지 출처

| 그림 | 원본 DEF | 생성 도구 |
|---|---|---|
| [T0](figures/t0_45nm_postroute.png) | [T0 DEF](../reports/final_45nm/pnr/t0/outputs/aer_traditional_latch_paa_45nm_postroute.def) | [DEF renderer](../scripts/render_final_def_layout.py) |
| [P9-GRR](figures/p9_grr_45nm_postroute.png) | [GRR DEF](../reports/final_45nm/pnr/p9_grr/outputs/aer_pending_gray_rank_reuse_sync_core_reset_postroute.def) | 같은 renderer |
| [P9-OHT](figures/p9_oht_45nm_postroute.png) | [OHT DEF](../reports/final_45nm/pnr/p9_oht/outputs/aer_pending_direct_gray_scr_onehot_tree_postroute.def) | 같은 renderer |

이 이미지는 Innovus GUI 직접 screenshot이 아니라 Innovus post-route DEF의 실제
placement 중심과 routing 좌표를 재렌더링한 시각화다.
