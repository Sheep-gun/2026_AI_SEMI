# P7-GE pending Gray-epoch AER 검증 결과

## 먼저 읽을 핵심

P7-GE는 이전 개선본 P4-C가 제공하던 비동기 요청 동기화, source별 이벤트 대기칸, 조기 ACK와 1 event/clock 출력을 그대로 유지한다. 바뀐 부분은 여러 대기 이벤트 중 다음 전송 대상을 고르는 중재기다.

P4-C는 다음 차례를 기억하기 위해 10 bit의 순번 상태를 사용했다. P7-GE는 이를 4-bit 내부 순번 하나로 줄이고, 모든 source를 Gray 순서로 우선하는 선택 tree를 사용한다. 모든 source가 대기하는 조건에서는 연속 주소가 한 bit씩만 달라지고, 지속적으로 기다리는 source는 receiver stall을 제외한 최대 16번의 실제 처리 결정 안에 선택된다.

동일 기능 조건으로 180 nm 배치·배선한 결과 P7-GE는 P4-C보다 cell area가 13.80%, 기본 활동률 기반 전력 추정치가 10.88% 감소했다. Setup과 hold, reset recovery/removal, 논리 등가성, DRC와 connectivity도 모두 통과했다. 아래 절은 이 결론을 뒷받침하는 시험 조건과 수치를 정리한다.

## 설계 목적

P7-GE는 P4-C의 source별 16-bit pending 저장과 조기 ACK를 그대로 유지하고,
`group pointer 2 bit + local pointer 8 bit` 중재 상태를 4-bit Gray epoch으로
교체한다. 따라서 receiver stall 중에도 source 요청을 controller 내부에 먼저
접수하는 P4-C의 elasticity를 잃지 않는다.

중재기는 대기 주소 중 `address XOR gray(epoch)`가 가장 작은 주소를 선택한다.
어떤 source가 계속 대기하면 자신의 주소와 Gray epoch이 같아지는 순간 XOR 값이
0이 되므로 최대 16 grants 안에 반드시 선택된다. 여기서 grant는 clock 수가 아니라
실제 service decision 수이며, `out_ready=0`인 receiver stall 시간은 제외한다.

기본 구현은 external reset을 비동기적으로 assert하고, 2FF reset synchronizer를
거쳐 내부 reset을 clock에 맞춰 deassert한다. `ROBUST_RESET=0`은 이 두 FF의 PPA
비용을 분리하기 위한 비교용이며 주 설계가 아니다.

## 기능 및 공정성 검증

| 시험 | 결과 |
|---|---:|
| 기존 broad regression | 139 offered / 139 received / 오류 0 |
| 평균 / 최대 지연 | 15.582 / 28 cycles |
| full-backlog 순서 | `0,1,3,2,6,7,5,4,12,13,15,14,10,11,9,8` |
| 최악 위치 공정성 | source 0이 정확히 16번째 grant에 처리 |
| frozen random mask | 64 / 64, 오류 0 |
| post-synthesis fair regression | PASS |
| CDC phase sweep, RTL / gate | 192 / 192, 오류 0 / 192 / 192, 오류 0 |
| receiver stall valid/address 안정성 | PASS |

동일한 101개 입력 이벤트와 도착 시각을 사용한 공정 비교에서도 P4-C와 P7-GE는
모든 이벤트를 손실과 중복 없이 처리했다. Stall 해제 전에 접수된 요청은 두 설계
모두 5개였고, 해제 시 controller에 아직 제시되지 않은 요청은 0개였다. 따라서
P7-GE의 면적 감소는 controller의 저장 기능을 source 쪽으로 옮긴 결과가 아니다.

| 공통 workload 항목 | P4-C | P7-GE |
|---|---:|---:|
| events | 101 | 101 |
| address bit toggles | 174 | **106** |
| saturation output-address toggles | 118 | **63** |
| stall pre-release ACK | 5 | 5 |
| stall not-presented at release | 0 | 0 |
| saturation output span | 630 ns | 630 ns |

동일한 101-event 입력 demand-arrival workload에서 중재에 따른 출력 순서는
서로 다르며, output address toggle은 39.08%, saturation 구간에서는 46.61%
감소했다. P7-GE는 주소를 별도의 code로 바꾸지 않는다. 대기 요청을
고르는 순서 자체가 reflected Gray 순서를 따르므로, full backlog에서 연속 source
주소가 한 번에 한 bit만 달라진다.

## Vivado 합성

| 항목 | P4-C | P7-GE robust | P7-GE raw-reset 참고 |
|---|---:|---:|---:|
| LUT | 95 | **92** | **91** |
| FF | 79 | **75** | **73** |
| reg-to-reg data path | 기존 전용 보고 없음 | 5.611 ns | 5.611 ns |
| reg-to-reg slack, 10 ns | 기존 전용 보고 없음 | +4.238 ns | +4.238 ns |

Robust형은 reset synchronizer 2 FF를 포함하고도 P4-C보다 LUT 3개와 FF 4개가
적다. Raw-reset형과의 차이는 LUT 1개와 FF 2개이며, 이는 reset 안정성 비용을
숨기지 않고 분리한 값이다.

## Cadence TSMC 180 nm 결과

P7-GE robust를 P4-C와 같은 Artisan TSMC 0.18 µm 표준셀, 10 ns clock,
0.2 ns uncertainty, 60% target utilization, Metal1~Metal6 조건으로 다시
합성하고 배치·배선했다.

### Genus 합성 비교

| 항목 | P4-C | P7-GE | 변화 |
|---|---:|---:|---:|
| standard cells | 308 | **236** | -23.38% |
| cell area | 8,568.807 µm² | **7,248.226 µm²** | -15.41% |
| worst data path | 2.990 ns | **2.508 ns** | -16.12% |
| setup slack | +6.853 ns | **+7.268 ns** | +0.415 ns |
| vectorless power | 1.165790 mW | **0.887720 mW** | -23.85% |

P4-C의 `group pointer 2 bit + local pointer 8 bit`를 4-bit epoch으로 줄인 효과가
단순 FF 수에만 머물지 않았다. 4-level subtree-valid tournament가 계층형 RR보다
작게 매핑되어 combinational cell과 worst path도 함께 감소했다.

### 동일 traffic VCD 전력 보조 비교

동일 fixed-demand 101-event workload를 각 DUT boundary에서 따로 기록한 VCD를
Genus에 넣었을 때 P4-C는 1.048950 mW, P7-GE는 0.686120 mW로 추정됐다. 두 VCD는
내부 signal·출력 순서·종료 시각이 같지 않다. 또한 sequential annotation coverage가
P4-C 82.75%, P7-GE 100%로 완전히 같지 않으므로 **34.59% 감소를 sign-off 수치로
단정하지 않는다**. 동일 activity를 직접 반영한 보조 근거이며, 최종 비교의 주
근거는 동일 조건 vectorless와 post-route 결과다.

### Innovus post-route 비교

| 항목 | P4-C | P7-GE | 변화 |
|---|---:|---:|---:|
| placed cells | 362 | **292** | -19.34% |
| cell area | 9,353.837 µm² | **8,063.194 µm²** | -13.80% |
| setup slack | +3.547 ns | **+4.350 ns** | +0.803 ns |
| hold slack | +0.004 ns | **+0.006 ns** | +0.002 ns |
| vectorless power | 0.960680 mW | **0.856192 mW** | -10.88% |
| DRC violations | 0 | **0** | pass |
| connectivity problems | 0 | **0** | pass |

Robust reset의 실제 release path도 별도로 STA했다. Recovery slack은 +8.366 ns,
removal slack은 +0.340 ns로 모두 통과했다. RTL과 Genus netlist는 Conformal에서
primary output 21개와 state point 75개, 총 96/96이 등가였고 nonequivalent,
abort, unknown은 모두 0이었다.

![P7-GE 구조](../docs/architecture/aer_p7_gray_epoch_structure.svg)

아래 이미지는 예상도가 아니라 최종 배치·배선 database를 Innovus에서 복원해
`gui_dump_picture`로 직접 출력한 화면이다.

![P7-GE TSMC 180 nm Innovus post-route](../docs/architecture/p7ge_180nm_innovus_postroute.png)

## Fall-through 연구 변형

P7-GE-FT는 ready가 높을 때 tournament 결과를 output으로 직접 내보내고,
receiver가 막힐 때만 5-bit hold register를 사용한다.

| 항목 | 결과 |
|---|---:|
| no-stall transfer latency | registered P7보다 1 cycle 감소 |
| stall 12-cycle 안정성 | PASS |
| 4-event stall drain | loss / duplicate 0 |
| saturation | 16 events, min/max gap 1 cycle |
| Vivado LUT / FF | 93 / 75 |
| reg-to-reg | 5.611 ns, slack +4.238 ns |
| register-to-output | 8.942 ns, slack **-2.380 ns** |

기능과 처리량 개선은 확인됐지만 10 ns interface constraint에서 combinational
register-to-output 경로가 timing을 위반했다. 따라서 P7-GE-FT는 latency/timing
tradeoff 연구 결과로 보존하고 주 설계로 채택하지 않는다.

## 결론

최종 개선본은 registered-output P7-GE robust이다. P4-C와 동일한 buffering과
single-lane throughput을 유지하고, 공통 fixed-demand workload에서는 end-to-end
latency도 같으면서 output address toggle을 39.08% 줄였다. 동시에 180 nm post-route area 13.80%, vectorless power
10.88%를 줄이고 setup slack을 0.803 ns 늘렸다. 16-grant starvation bound,
reset recovery/removal, LEC, DRC와 connectivity까지 확인했으므로 P7-GE를 본
과제의 새 주 설계로 채택한다.

## 근거 파일

- RTL: [`rtl/improved/aer_pending_gray_epoch.sv`](../rtl/improved/aer_pending_gray_epoch.sv)
- 공정성 TB: [`tb/aer_pending_gray_epoch_fair_tb.sv`](../tb/aer_pending_gray_epoch_fair_tb.sv)
- Vivado robust: [`reports/pending_gray_epoch/vivado_robust/`](../reports/pending_gray_epoch/vivado_robust/)
- 180 nm 요약: [`reports/pending_gray_epoch/cadence/pnr_180nm/SUMMARY.txt`](../reports/pending_gray_epoch/cadence/pnr_180nm/SUMMARY.txt)
- 증거 manifest: [`results/P7_PENDING_GRAY_EPOCH_MANIFEST_2026-08-20.md`](P7_PENDING_GRAY_EPOCH_MANIFEST_2026-08-20.md)
- post-route report: [`reports/pending_gray_epoch/cadence/pnr_180nm/p7ge_pnr/`](../reports/pending_gray_epoch/cadence/pnr_180nm/p7ge_pnr/)
- Genus report: [`reports/pending_gray_epoch/cadence/pnr_180nm/p7ge/`](../reports/pending_gray_epoch/cadence/pnr_180nm/p7ge/)
- VCD power·annotation evidence: [`reports/pending_gray_epoch/cadence/pnr_180nm/contract_vcd_power/`](../reports/pending_gray_epoch/cadence/pnr_180nm/contract_vcd_power/)
- Cadence bundle/재현 절차: [`scripts/cadence/P7GE_FLOW.md`](../scripts/cadence/P7GE_FLOW.md)
- Gate fair log: [`sim/logs/p7ge_gate_fair.log`](../sim/logs/p7ge_gate_fair.log)
- Contract log: [`sim/logs/contract_fairness_p7ge.log`](../sim/logs/contract_fairness_p7ge.log)
- FT RTL: [`rtl/improved/aer_pending_gray_epoch_fallthrough.sv`](../rtl/improved/aer_pending_gray_epoch_fallthrough.sv)
- FT 결과: [`reports/pending_gray_epoch_fallthrough/vivado_robust/`](../reports/pending_gray_epoch_fallthrough/vivado_robust/)
