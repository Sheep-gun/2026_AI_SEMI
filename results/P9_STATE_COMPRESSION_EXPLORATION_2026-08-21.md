# P9 상태 압축형 AER 탐색

## 1. 목적과 유지한 계약

P9 탐색의 목적은 P8-DG-SCR의 기능을 줄이는 것이 아니라, 같은 기능을 표현하는
상태 수와 중재 비용을 줄이는 것이다. 다음 조건은 고정했다.

- 16개의 비동기 4-phase REQ/ACK source
- source별 pending event 16개와 controller 출력 register event 1개, 총 16+1 저장
- pending 칸이 비어 있으면 출력 정체 중에도 먼저 ACK하는 early acknowledgement
- single 4-bit address bus와 valid/ready 출력
- receiver가 받을 수 있을 때 clock마다 최대 event 1개
- 계속 기다리는 source는 최대 16번의 service decision 안에 선택
- 2FF request synchronizer, 두 clock reset release, clockless reset 출력 격리

## 2. 먼저 확인한 상태 비트의 하한

### 2.1 ACK와 pending은 source마다 모두 두 비트가 필요하다

한 source의 `(ACK, pending)`에는 다음 네 상태가 실제로 모두 발생한다.

| ACK | pending | 의미 |
|---:|---:|---|
| 0 | 0 | 요청도 저장 event도 없음 |
| 1 | 1 | REQ가 아직 높고 event도 pending에 있음 |
| 0 | 1 | source가 REQ를 내렸지만 event는 아직 pending에 있음 |
| 1 | 0 | event는 출력으로 이동했지만 source가 아직 REQ를 내리지 않음 |

따라서 이를 ternary state 세 개로 줄일 수 없다. 네 상태를 구분하는 정보의 하한이
`log2(4)=2 bit/source`이므로 16 source에는 32비트가 필요하다. 이 네 code를 모두
사용하므로 “사용하지 않는 ACK/pending code에 global epoch를 넣는” 방법도 성립하지
않는다.

### 2.2 출력은 5비트가 하한이다

외부 기능만 보면 출력은 `empty` 한 상태와 16개 source 주소 상태, 총 17개 상태를
구분해야 하므로 `ceil(log2(17))=5 bit`가 필요하다. 공정성 pointer까지 합치면
`valid=0`일 때 보존해야 할 마지막 grant 16상태와 `valid=1`일 때 현재 출력/마지막
grant 16상태, 총 32개 joint state가 된다. Address 4비트와 valid 1비트는 이 32개를
정확히 표현하므로 기능과 fairness를 함께 보아도 5비트가 하한이다. 주소의 한 code를
empty로 쓰면 16개 주소 중 하나를 잃는다.

### 2.3 별도 epoch는 출력 주소에 합칠 수 있다

독립적인 16-phase 공정성 위치를 저장하려면 4비트가 필요하다. 그러나 strict cyclic
round-robin은 **마지막으로 grant한 주소 다음부터 검색**하면 되므로, stalled output을
유지하는 4비트 register가 마지막 grant 정보도 동시에 저장할 수 있다. 출력이 empty가
되어도 주소 register를 지우지 않으면 별도 fairness pointer가 필요하지 않다.

이 설계 가정 안에서 상태 하한은 다음과 같다.

```text
request 2FF CDC        32
ACK + pending          32
output address/rank     4
output valid            1
reset release           2
--------------------------------
합계                    71 bit
```

P8-DG-SCR은 별도 Gray epoch 4비트를 포함해 75비트이고, P9 두 후보는 71비트로 이
하한에 도달한다. 이는 현재 2FF CDC·depth-1/source·deterministic bounded-fairness
계약 안의 하한이며, 모든 종류의 AER 회로에 대한 보편적인 최소 transistor 증명은
아니다.

## 3. 탈락시킨 압축 방향

| 방향 | 탈락 이유 |
|---|---|
| ACK/pending ternary encoding | source마다 네 semantic state가 모두 reachable이므로 2비트가 하한 |
| ACK/pending의 unused code에 epoch 삽입 | 네 code가 모두 사용되며 idle 상태에서도 과거 grant에 따라 fairness phase 16개가 가능 |
| valid를 address에 흡수 | empty+16주소=17 상태라 4비트로 표현 불가 |
| epoch와 output의 일반 joint code | valid일 때 `(epoch,address)` 256개와 empty일 때 epoch 16개, 총 272상태라 9비트가 필요; 현재 epoch4+address4+valid1도 9비트 |
| history가 없는 fixed priority | 특정 source가 계속 우선돼 16-decision bound를 보장하지 못함 |
| 마지막 주소의 단순 successor를 P8 XOR tree 선호값으로 사용 | sparse mask에서 strict cyclic order가 아니므로 일부 subset을 반복할 수 있음 |

마지막 항목에는 더 강한 제약도 있다. 두 source `a,b`만 계속 pending인 경우, 마지막
grant가 `a`라면 다음에는 어떤 `b`에 대해서도 `a`가 아니라 `b`를 골라야 한다.
XOR distance가 작은 주소를 고르는 tree에서 이를 모든 `b!=a`에 대해 만족하려면
`a`가 가장 먼 주소여야 하므로 preference는 `~a`여야 한다. 그러면 full backlog에서
`a ↔ ~a` 두 주소만 반복해 16-source 공정성을 잃는다. 따라서 별도 epoch를 없애려면
단순 XOR preference가 아니라 실제 cyclic search가 필요하다.

## 4. 구현한 후보

### 4.1 P9-BR: binary ring reuse

P9-BR은 output address register를 마지막 grant pointer로 재사용하고, 다음 숫자
주소부터 `0→1→...→15→0` 순서로 검색한다. 16-bit barrel rotate 대신 4개 group과
4개 lane으로 나눈 strict cyclic selector를 사용했다. 마지막 group에서 현재 lane
뒤쪽을 먼저 보고, 비어 있으면 다음 group부터 순환한다.

장점은 별도 epoch 4비트와 Gray 변환이 모두 없다는 것이다. 단점은 full cycle의
주소 bit 전환이 Gray 순서 16회가 아니라 binary 순서 30회라는 점이다.

### 4.2 P9-GRR: Gray-rank register reuse

P9-GRR은 외부 Gray 주소를 그대로 register에 저장하지 않고, 그 주소가 Gray
순서에서 몇 번째인지를 나타내는 4-bit binary rank를 저장한다.

```text
내부 rank:  0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
외부 주소:  0,1,3,2,6,7,5,4,12,13,15,14,10,11,9,8
```

입력 request, ACK, pending도 내부에서는 같은 rank 순서로 고정 배선한다. 고정
permutation은 gate가 아니라 배선이므로, grant rank를 다시 source 주소로 바꿔
pending을 지우던 feedback XOR가 사라진다. 외부 address port에만
`rank XOR (rank >> 1)` encoder가 남는다. 이 출력은 register 하나의 조합 함수이므로
receiver stall 중에도 안정적이다.

P9-GRR은 P9-BR과 같은 71비트이면서 full cycle address 전환 16회를 유지한다.

## 5. 검증 결과

| 시험 | P9-BR | P9-GRR |
|---|---:|---:|
| RTL broad regression | 139/139, error 0 | 139/139, error 0 |
| post-synthesis broad | 139/139, error 0 | 139/139, error 0 |
| selector exhaustive | 16×65,536=1,048,576, error 0 | 16×65,536=1,048,576, error 0 |
| full backlog order | binary 0..15 | reflected Gray 16주소 |
| worst service bound | 16 decisions | 16 decisions |
| RTL/gate CDC phase | 192/192, error 0 | 192/192, error 0 |
| RTL/gate reset/restart | PASS | PASS |
| fixed-demand contract | 101 events, error 0 | 101 events, error 0 |

## 6. 현재 FPGA proxy와 activity 비교

| 항목 | P8-DG-SCR | P9-BR | P9-GRR |
|---|---:|---:|---:|
| 상태 FF | 75 | **71** | **71** |
| Vivado LUT | 108 | **90** | 91 |
| Vivado reg-to-reg path | **5.611 ns** | 5.881 ns | 5.881 ns |
| contract address toggles | **106** | 174 | 114 |

P9-GRR은 P8보다 FF 5.33%, LUT 15.74%가 적고, Vivado path는 4.81% 길다. 동일
101-event workload의 address 전환은 P8보다 7.55% 많지만 P9-BR보다 34.48% 적다.
따라서 P9-BR은 최소 논리 후보, P9-GRR은 면적과 출력 activity를 함께 고려한 우선
후보다. FPGA LUT와 unplaced timing은 ASIC PPA 결론이 아니므로 최종 채택은 동일
FPR 180 nm Genus 및 Innovus 결과로 결정해야 한다.

## 7. FPR 180 nm Genus 결과

최신 rank-indexed P9-GRR을 P8-DG-SCR과 같은 10 ns clock, 1 ns I/O delay,
FPR 180 nm library 조건으로 합성했다.

| 항목 | P8-DG-SCR | P9-GRR | 변화 |
|---|---:|---:|---:|
| mapped cells | 232 | **220** | -5.17% |
| cell area | 6,383.362 µm² | **6,087.312 µm²** | **-4.64%** |
| vectorless power | **0.848839 mW** | 0.905723 mW | +6.70% |
| 101-event VCD power | 0.620896 mW | **0.601712 mW** | **-3.09%** |
| setup slack | +6.657 ns | **+7.426 ns** | +0.769 ns |

P9-GRR은 P8보다 작고 빠르다. 입력 활동을 일률적으로 가정한 vectorless power는
높지만, 같은 101-event fixed-demand VCD를 RTLStim2Gate로 연결한 power는 오히려
3.09% 낮다. 따라서 “항상 저전력” 또는 “항상 고전력”으로 한 숫자만 고르는 대신,
기본 activity 가정과 측정 workload의 차이를 함께 남긴다. Strict cyclic selector가
P8의 XOR tree보다 일반적인 원형 검색 조합논리를 사용하므로 vectorless 추정은
증가했지만, 실제 workload에서는 제거한 epoch FF와 activity 분포의 이득이 더 컸다.

P9-GRR VCD power의 breakdown은 register 0.483277 mW, logic 0.0507514 mW,
clock 0.0676836 mW였다. Sequential signal과 RTL driver annotation은 모두 100%였고,
gate driver coverage는 53.26%였다. P8의 같은 방식 결과는 gate driver 51.21%이므로
완전히 동일한 coverage는 아니지만 차이가 작고, 두 run 모두 sequential/RTL driver
100%이며 STIM mapping 경고가 없다. 이 수치는 P9-GRR을 post-route까지 올릴 충분한
근거지만 실제 silicon 전력을 확정하는 측정값은 아니다.

P9-GRR 자체에서 vectorless와 VCD breakdown을 비교하면 숫자가 반대로 보이는
이유가 더 분명하다.

| P9-GRR power | vectorless | 101-event VCD |
|---|---:|---:|
| register | 0.625346 mW | 0.483277 mW |
| logic | 0.212694 mW | 0.050751 mW |
| clock | 0.067684 mW | 0.067684 mW |
| **total** | **0.905723 mW** | **0.601712 mW** |

Vectorless에서는 register가 전체의 69.04%, logic이 23.48%, clock이 7.47%였다.
고정 workload를 넣으면 clock은 같지만 register와 logic activity가 각각 낮아진다.
특히 strict cyclic selector를 포함한 logic power가 0.212694에서 0.050751 mW로
줄었다. 즉 OI처럼 gate를 더 붙여 selector를 강제로 막기보다, 실제 event/stall
activity를 정확히 주는 편이 이 설계의 동작 특성을 더 잘 반영했다.

### 7.1 전력 저감 micro-variant 결과

출력이 stall됐거나 core reset 중일 때 selector의 16-bit operand를 0으로 격리하는
P9-GRR-OI를 별도 구현했다. 기능은 통과했지만 실제 Genus 결과는 다음과 같았다.
이 표는 원격 screening run의 관찰값이며 OI Genus raw report는 최종 공개 근거에
중복 포함하지 않았다. 최종 winner의 원시 Genus/Innovus 보고서는
`reports/p9_final/`에 보존한다.

| 항목 | P9-GRR | P9-GRR-OI |
|---|---:|---:|
| mapped cells | **220** | 266 |
| cell area | **6,087.312 µm²** | 6,409.973 µm² |
| vectorless power | **0.905723 mW** | 1.006910 mW |
| setup slack | **+7.426 ns** | +6.194 ns |

16개 isolation gate와 늘어난 fanout/논리가 vectorless activity 감소보다 비쌌다.
면적, 전력, timing이 모두 나빠 P9-GRR-OI는 즉시 탈락시켰다.

추가로 dynamic-index pending clear를 explicit one-hot vector mask로 바꾼
P9-GRR-OHD는 Vivado에서 94 LUT/71 FF/5.896 ns로, 기본 P9-GRR의
91 LUT/71 FF/5.881 ns보다 좋아지지 않았다. Encoded-pointer mask-method selector는
전수 기능은 통과했지만 selector 단독 합성이 46 LUT로 grouped selector의 18 LUT보다
2.56배 컸다. 두 방식은 180 nm 전체 합성 우선순위에서 제외했다.

### 7.2 상태 압축 탐색의 종료 근거

- ACK/pending 32비트와 output 5비트는 실제 reachable state 수로 이미 하한이다.
- 별도 fairness 상태를 없애면서 16-decision bound를 지키는 방법은 마지막 grant를
  출력 상태로 재사용하는 strict cyclic search이며 P9-GRR이 이를 71비트로 달성했다.
- 이를 더 줄이면 17개 output state 또는 source별 네 protocol state 중 하나를
  구분하지 못한다.
- 같은 71비트에서 selector를 operand-isolate하거나 one-hot/mask 형태로 바꾼 후보는
  실제 또는 proxy PPA가 악화됐다.
- 전력을 P8 수준으로 낮추는 가장 직접적인 방법은 저전력 XOR tournament와 독립
  epoch 4비트를 다시 쓰는 것이며, 그것이 현재 P8-DG-SCR이다.

따라서 현재 계약을 그대로 둔 **상태 압축 방향에서는 P9-GRR이 유의미한 마지막
후보이자 Genus workload-PPA 선두**다. 추가 연구는 상태 비트 제거가 아니라
library-specific cell sizing, physical placement, activity-aware power 또는 계약 변경을
포함하는 별도 축으로 넘어가야 한다.

### 7.3 Innovus post-route 및 Conformal 최종 확인

Genus에서 선별한 P9-GRR과 P9-OHT를 P8과 같은 FPR 180 nm physical flow에 넣고,
각 설계에서 양수 hold를 유지하는 지점까지 full clean P&R을 반복했다. P8도 같은
방식으로 다시 조정해, 이전 `0.030 ns` 결과가 아니라 최적화된 `0.021 ns` 지점을
공정한 비교 기준으로 사용했다.

| post-route 항목 | P8 / 0.021 | P9-GRR / 0.020 | P9-OHT / 0.012 |
|---|---:|---:|---:|
| instances | 297 | **281** | 290 |
| cell area | 7,364.650 µm² | **6,988.766 µm²** | 7,291.469 µm² |
| vectorless power | 0.79657531 mW | 0.77624020 mW | **0.77267187 mW** |
| mapped-SAIF power | 0.59663396 mW | **0.57886987 mW** | 0.58959029 mW |
| overall / CDC setup | +0.200 ns | +0.159 ns | **+0.300 ns** |
| core setup | +3.278 ns | +4.810 ns | **+6.201 ns** |
| overall / CDC hold | +0.009 ns | **+0.012 ns** | +0.010 ns |
| reset recovery / removal | +9.106 / +0.044 ns | +9.113 / +0.040 ns | +9.128 / +0.025 ns |
| DRC / connectivity / clock violation | 0 / 0 / 0 | **0 / 0 / 0** | **0 / 0 / 0** |

P9-GRR은 최적화한 P8보다 면적 5.10%, vectorless power 2.55%, 동일 workload
mapped-SAIF power 2.98%를 줄였다. P9-OHT와 비교하면 면적 4.15%와 SAIF power
1.82%가 낮다. 반대로 OHT는 GRR보다 vectorless power가 0.46% 낮고 core setup
여유가 1.391 ns 크므로 timing·기본 활동률 기준의 Pareto 대안으로 남는다.

Mapped-SAIF는 primary input과 flop output에서 세 설계 모두 100% annotation을
달성했다. Total-net coverage는 P8 80.68%, GRR 80.71%, OHT 84.30%로 완전히 같지
않으므로, 실제 workload 방향을 보여 주는 강한 보조 근거이지 transistor-level
sign-off나 실리콘 측정값은 아니다. Hold와 reset removal은 모두 양수지만 수십 ps
수준이므로 공식 PDK·다른 corner로 옮길 때 다시 닫아야 한다.

Conformal은 P9-GRR RTL과 Genus mapped netlist 사이의 primary output 21개와 state
point 71개를 모두 equivalent로 판정했다. Nonequivalent, abort, unknown point 없이
통과했으므로 4비트 epoch를 제거하고 rank-indexed ACK/pending으로 바꾼 상태 전이가
synthesis 과정에서 보존됐음을 확인했다.

이 결과로 P9-GRR은 최적화된 P8 대비 post-route 면적과 두 전력 추정치를 모두
줄이고 core timing을 개선했다. P9-GRR을 현재 FPR 180 nm 비교의 주 설계로,
P9-OHT를 timing·vectorless-power 지향 Pareto 대안으로 유지한다.

## 8. 관련 연구와 이번 구조의 관계

- Zheng과 Yang의 parallel round-robin 연구는 binary-search형 병렬 arbiter가 모든
  input pattern에서 round-robin fairness를 만족하며 0.18 µm 표준셀에서도 구현될 수
  있음을 분석했다. P9의 4×4 grouped cyclic search는 그 논문의 회로를 그대로 복사한
  것이 아니라, 같은 목표인 긴 linear scan 회피를 16-input 고정 구조에 적용한 것이다.
  [Algorithm-Hardware Codesign of Fast Parallel Round-Robin Arbiters](https://citeseerx.ist.psu.edu/document?doi=f18ea8b1e48e07c4d9736ac2597f8100f4176e8d&repid=rep1&type=pdf)
- Purohit와 Manohar의 AER encoder 연구는 tree, token ring, hybrid arbitration의
  throughput·sparse-traffic tradeoff를 비교한다. P9는 MUTEX token ring을 새로 만든
  비동기 회로가 아니라, 검증 가능한 synchronous core에서 output state를 strict ring
  pointer로 재사용한 구조다.
  [Field-programmable encoding for address-event representation](https://www.frontiersin.org/journals/neuroscience/articles/10.3389/fnins.2022.1018166/pdf)

## 9. 근거 파일

| 구분 | 파일 |
|---|---|
| P9-BR RTL | `rtl/experiments/aer_pending_binary_ring_sync_core_reset.sv` |
| P9-GRR RTL | `rtl/experiments/aer_pending_gray_rank_reuse_sync_core_reset.sv` |
| P9-GRR-OI RTL | `rtl/experiments/aer_pending_gray_rank_reuse_operand_isolated.sv` |
| P9-GRR-OHD RTL | `rtl/experiments/aer_pending_gray_rank_reuse_onehot_decode.sv` |
| P9-BR exhaustive/fair TB | `tb/aer_p9_binary_ring_fair_tb.sv` |
| P9-GRR exhaustive/fair TB | `tb/aer_p9_gray_rank_fair_tb.sv` |
| P9-BR verification | `scripts/run_p9_binary_ring_verification.ps1` |
| P9-GRR verification | `scripts/run_p9_gray_rank_verification.ps1` |
| P9-BR Vivado | `reports/p9_state_compression/vivado_binary_ring/` |
| P9-GRR Vivado | `reports/p9_state_compression/vivado_gray_rank/` |
| P9-GRR Cadence flow | `scripts/cadence/p9grr_genus_explore.tcl`부터 시작 |
| P9-GRR bundle | `scripts/prepare_p9grr_cadence_bundle.ps1` |
| P9-GRR 재현 순서 | `scripts/cadence/P9GRR_FLOW_NOTES.md` |
| 물리 hold/PPA sweep | `results/P9_PHYSICAL_HOLD_PARETO_SWEEP_2026-08-21.md` |
| P9-GRR 실제 Innovus 화면 | `docs/architecture/p9grr_180nm_innovus_postroute.png` |
| P9-OHT 실제 Innovus 화면 | `docs/architecture/p9oht_180nm_innovus_postroute.png` |

현재 결론은 **P9-GRR을 새 post-route 주 설계로 승격하고 P8-DG-SCR을 직전 기준점,
P9-OHT를 Pareto 대안으로 유지**하는 것이다. P9-BR, OI, OHD와 mask selector는
원인을 설명하는 ablation으로만 보존한다. 최적화된 P8과 비교해 P9-GRR은 면적
5.10%, vectorless power 2.55%, mapped-SAIF power 2.98%를 줄였고 core setup
여유를 1.532 ns 늘렸다. LEC 21 output/71 state, timing, DRC, connectivity와
clock-tree 검사를 모두 통과했다.
