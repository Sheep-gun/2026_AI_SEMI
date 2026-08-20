# P8 선호 상태 Pareto 탐색 — 2026-08-21

## 탐색 질문

P7-GE는 4비트 이진 epoch(중재 우선순위가 한 바퀴 도는 동안의 순번 상태)를 저장하고, 이를 reflected Gray code(인접 상태 사이에서 한 비트만 바뀌도록 배열한 Gray code)로 변환한 뒤 XOR tournament(XOR로 계산한 점수를 비교해 요청 하나를 고르는 중재 방식)의 선호값으로 사용한다. 이번 탐색의 질문은 동일한 **사이클당 이벤트 1개 전송 계약**과 **최대 16회 grant 이내의 공정성 한계**를 유지하면서 상태 비트, 논리량 또는 주소 전환을 줄일 수 있는가이다. 여기서 grant는 대기 중인 요청 하나를 실제 서비스 대상으로 선택하는 **서비스 결정**을 뜻한다. 따라서 최대 16회 서비스 결정은 16 clock을 뜻하지 않으며, 수신기 stall(수신기가 준비되지 않아 전송이 멈춘 구간)은 grant 자체가 발생하지 않으므로 이 횟수에서 제외한다.

기존 P7 및 P8 파일은 수정하지 않았다. 모든 대안은 새 experiment 또는 candidate RTL 파일에 분리했다.

## 순서열 탐색

아래의 모든 epoch 부호화 정책에서 16개 상태로 이루어진 선호 순서열은 bijection(각 source가 중복 없이 정확히 한 번씩 대응되는 일대일 순열)이다. source `s`가 계속 pending(서비스를 기다리는 요청 상태)이라면, 이후 최대 16회의 grant 안에 선호값이 `s`와 같아진다. 이때 해당 source의 XOR 점수는 0이므로 반드시 선택된다. 수신기 stall 중에는 grant가 발생하지 않으므로 stall clock은 이 한계에서 제외한다.

| 정책 | 상태 갱신 / 선호값 논리 | 전체 source가 계속 대기할 때 한 주기의 주소 전환 수 | 공정성 |
|---|---|---:|---:|
| binary | 4비트 증가기, encoder 없음 | 30 | <=16 grants |
| one-XOR G2 | 증가기 + XOR 1개 | 22 | <=16 grants |
| two-XOR G3 | 증가기 + XOR 2개 | 18 | <=16 grants |
| full reflected Gray | 증가기 + XOR 3개 | **16** | <=16 grants |
| directly registered Gray | Gray-successor network, 선택 encoder 없음 | **16** | <=16 grants |
| 4비트 LFSR plus zero | 선형 XOR 1개 + zero 삽입 | 32 | <=16 grants |
| strict Gray ring | 출력 주소를 마지막 grant pointer로 재사용 | **16** | <=16 grants |

two-XOR 순서열은 다음과 같다.

```text
0, 1, 3, 2, 6, 7, 5, 4, 8, 9, 11, 10, 14, 15, 13, 12
```

이 순서열은 binary 대비 Gray code가 줄이는 주소 전환 14회 가운데 12회를 유지하면서 encoder의 XOR 하나를 제거한다. LFSR(linear-feedback shift register, 선형 되먹임으로 다음 상태를 만드는 작은 상태 발생기)은 일반적인 다음 상태 점화식이 단순하지만, zero 상태를 별도로 삽입해야 하고 주소 전환이 32회이므로 동적 전력 측면에서 매력적이지 않다.

## Pointer 재사용 시 정확성 주의사항

`out_addr`를 상태로 재사용하는 방식은 strict cyclic search(실제로 마지막으로 서비스한 source의 바로 다음 순위부터 원형으로 탐색하는 방식)를 적용할 때만 안전하다. `Gray-successor(out_addr)`를 계산한 뒤 기존 XOR tournament에 넣는 단순한 방식은 공정하지 않다. pending mask가 `{source 0, source 1}`이고 마지막 grant가 0이면 source 1만 계속 선택하여 source 0을 starvation(요청이 계속 대기하지만 영원히 선택되지 않는 현상)에 빠뜨린다.

따라서 `aer_pending_gray_ring_sparse_reset`은 정적으로 Gray 순위가 부여된 candidate vector에서 실제 마지막 grant 다음 위치부터 엄격하게 탐색한다. 이 설계의 4-group/4-lane selector에는 16비트 mask/carry chain이 없다.

## 전수 검증 및 통합 검증

공유 XOR tournament와 strict Gray-ring selector 각각에 대해 `16 * 65,536 = 1,048,576`개의 모든 pointer/선호값 및 candidate-mask 조합을 평가했다. 두 방식 모두 validity 또는 address error가 0이었다.

전용 P8-X2 및 P8-GR candidate는 다음 항목도 통과했다.

- 전체 source가 계속 대기할 때의 서비스 순서와 수신기 stall 중 출력 안정성
- 139 offered / 139 received 전송 회귀시험, error 0
- 64-event 포화 입력에서 매 cycle마다 출력 1개 수락
- 192 / 192 digital CDC(clock-domain crossing, 서로 다른 타이밍 영역 사이의 신호 전달) phase case, error 0
- P8에서 물려받은 early ACK, source별 pending bit 1개, registered output 및 견고한 core reset 동작

139-event 회귀시험과 192-point CDC sweep은 RTL과 Vivado 합성 후 기능 netlist에서 모두 통과했다. Gate simulation에서도 동일한 event/toggle 수와 error 0을 확인했다.

## 동일 조건의 Vivado 탐색

폭넓은 순서열 sweep에는 구조를 동일하게 맞춘 experimental controller를 사용했다. 아래 수치는 순서열 및 상태 선택의 영향만 분리해 보여 주므로, 코딩 구조가 다른 P7의 92-LUT 보고값과 직접 비교하면 안 된다. LUT(look-up table)는 FPGA에서 조합논리를 구현하는 기본 자원이고, FF(flip-flop)는 상태를 저장하는 순차논리 자원이다.

| 순서열 | LUT | FF | 100 MHz에서의 reg-to-reg slack |
|---|---:|---:|---:|
| binary | 82 | 75 | +3.601 ns |
| one-XOR | 82 | 75 | +3.603 ns |
| **two-XOR** | **82** | 75 | **+3.656 ns** |
| P7-equivalent full Gray control | 83 | 75 | +3.204 ns |
| direct Gray state | 83 | 75 | +3.204 ns |
| LFSR plus zero | **81** | 75 | +3.601 ns |
| strict Gray ring / output pointer reuse | 87 | **71** | +3.236 ns |

이 sweep에서는 two-XOR가 binary와 one-XOR보다 우세하다. 전체 LUT 수가 같고 내부 slack이 가장 크며, 한 주기 동안의 주소 전환 수도 더 적다. Ring은 FF 4개를 제거하므로 별도의 area/state tradeoff(면적과 상태 수 사이의 절충안)로 보아야 한다.

## 전용 sparse-reset candidate

최종 candidate는 P8 sparse-reset transport(synchronizer 등 안전하게 초기값을 요구하지 않는 일부 레지스터에서 reset을 제거한 전송 구조)에 직접 다시 코딩한 뒤, P8과 동일한 Artix-7, 10 ns clock, 1 ns I/O-delay 설정으로 합성했다.

| 설계 | LUT | FF | reg-to-reg slack | 139-event address toggles |
|---|---:|---:|---:|---:|
| P8-SR full-Gray reference | 92 | 75 | +4.238 ns | 136 |
| P8-DG direct-Gray reference | 91 | 75 | +4.240 ns | 136 |
| P8-X2 two-XOR | 91 | 75 | **+4.246 ns** | 152 |
| **P8-GR strict Gray ring** | **80** | **71** | +3.315 ns | **133** |

P8-GR은 FPGA 로컬 결과만 보면 가장 강한 Pareto candidate다. P8-SR 대비 LUT 12개와 FF 4개를 제거하고, 최대 16회 grant 한계를 유지하며, 측정한 회귀시험 trace에서 출력 switching도 소폭 줄였다. 내부 timing margin은 0.923 ns 작지만, 동일한 100 MHz constraint는 여전히 통과한다.

P8-X2는 위험이 낮은 ASIC 비교군으로 여전히 유용하다. 선호값을 만드는 XOR 식 2개만 바꾸고 P8의 별도 binary epoch는 유지하므로 timing이 P8-SR과 거의 같다. 그러나 전체 source가 계속 대기할 때 주소 전환이 18회라는 사실이 모든 sparse workload(일부 source만 간헐적으로 요청하는 부하)에서 전환 수 감소를 보장하지는 않는다. 139-event trace에서는 P8-SR의 136회보다 많은 152회가 발생해 이 점을 보여 준다.

두 번째 fixed-demand contract-fair suite 역시 switching이 workload에 따라 달라짐을 확인한다. 모든 설계가 error 0으로 101 events를 전달했지만, P8-SR의 address toggles는 106, P8-X2는 112, P8-GR은 114였다. Ring이 상태 비트 4개를 제거한다는 사실은 workload와 무관하지만, mapping 후 면적은 공정 기술에 따라 달라진다. 따라서 최종 workload VCD(value change dump, 실제 simulation의 신호 전환 기록)와 현실적인 address-bus load 없이 ring 또는 two-XOR가 출력 전력을 개선한다고 주장할 수 없다.

## Reset 경계

두 candidate 모두 CDC synchronizer 2단은 resetless로 두고, ACK, pending storage, output validity 및 two-clock reset-release circuit에는 견고한 reset을 유지한다. P8-X2의 `out_addr`도 `out_valid=0`일 때 값이 무효이므로 resetless로 둔다. 반면 P8-GR의 동일한 4비트는 payload가 무효인 동안에도 실제 scheduling state로 쓰이므로 `out_addr`를 source 8 (Gray rank 15)로 reset해야 한다.

## 180 nm Genus 측정 및 탈락 결정

두 전용 candidate는 동일한 FPR 180 nm library, 10 ns clock 및 I/O constraint로 mapping했다. 여기서 180 nm 조건은 **현재 서버에 구축된 FPR reference 환경에서의 동일 조건 비교**를 뜻하며, 주최 측이 확정한 공식 PDK 또는 최종 제출 공정이라는 뜻은 아니다. Activity-aware 열은 기본 switching activity 가정 대신 동일 조건의 검증 VCD를 사용한 결과다.

| 설계 | FF | mapped cell area (um^2) | vectorless power (mW) | 초기 VCD power (mW) |
|---|---:|---:|---:|---:|
| P8-X2 | 75 | 6626.189 | 0.833848 | 0.663896 |
| P8-GR | **71** | 6606.230 | 0.979172 | 0.642428 |
| current leader P8-DG-SCR | 75 | **6383.362** | 0.848839 | **0.619188** |

이 표의 VCD 열은 후보 screening 당시 동일한 첫 번째 annotation 방식으로 얻은
값이다. 최종 P7/P8 비교는 RTLStim2Gate mapping을 켜 다시 실행해 P7
0.686263 mW, P8 0.620896 mW를 얻었지만 전체 gate-driver coverage가 각각
37.10%, 51.21%로 달랐다. 따라서 어느 VCD 열도 clean matched-coverage power
순위로 사용하지 않으며 후보 선택의 방향성 보조값으로만 남긴다.

Ring은 의도대로 FF 4개를 제거했지만, cyclic search가 추가한 조합논리 때문에 180 nm 면적은 P8-X2보다 0.30% 작은 데 그쳤다. Vectorless 추정치는 P8-X2보다 17.43% 높으며, 이는 일반적인 activity 가정에서 search network가 치르는 비용을 보여 준다. 측정 VCD activity를 적용하면 P8-GR은 P8-X2보다 3.23% 낮으므로, ring 자체가 본질적으로 전력에 불리한 구조라는 뜻은 아니다. 결론은 실제 switching workload에 따라 달라진다.

그러나 둘 다 최종 비교에서 승리하지 못했다. P8-DG-SCR은 P8-GR보다 면적이 3.49% 작고 VCD power가 3.75% 낮다. P8-X2보다도 면적이 3.80% 작고 VCD power가 7.22% 낮다. P8-DG-SCR은 shared arbitration-valid tree(여러 중재 후보의 유효 여부를 공통 논리로 계산하는 트리), direct Gray state, vector-factored request acceptance(중복되는 요청 수락 조건을 벡터 단위로 묶은 논리), synchronous core clear 및 asynchronous output isolation을 결합한다. 이 library에서는 epoch FF 4개를 제거하는 것보다 reset network와 acceptance logic의 비용을 줄이는 편이 더 큰 효과를 냈다.

Split-reset ring도 검토했지만, RTL을 더 추가하기 전에 의도적으로 중단했다. 비교 가능한 direct-Gray controller에서 측정한 split-reset 변경은 mapped area를 약 76.5 um^2 줄였다. P8-GR에서도 동일한 절감량이 온전히 나온다고 가정해도 P8-DG-SCR보다 약 146 um^2 크며, 측정 VCD power도 이미 0.023240 mW 높다. 이는 구현하지 않은 split-reset ring의 측정 결과를 주장하는 것이 아니라, 기존 측정값에서 추론해 후보를 걸러 낸 결정이다.

## 최종 결정 경계

P8-GR은 공정성을 충족하면서 상태 수를 줄인 유효한 ablation(특정 설계 요소의 효과를 분리해 확인하는 비교 실험)이고, P8-X2도 순서 부호화 방식의 효과를 확인하는 유용한 control이다. 그러나 180 nm Genus 면적, 기능과 전력 보조 관찰을 함께 본 결과 두 설계 모두 주 P8 candidate에서는 탈락했다. **현재 최종 선두는 P8-DG-SCR**이다. 이후 Cadence가 무시한 `ASYNC_REG`를 명시적 preserve/physical grouping/0.9 ns pair constraint로 대체하고 P7과 같은 `CLKBUFX20` clock driver를 사용한 Innovus rerun에서 post-route 면적 7,657.373 µm², core setup/hold +3.235/+0.028 ns, CDC max-delay slack +0.201 ns, vectorless power 0.81695915 mW와 clock-tree/DRC/connectivity 위반 0을 달성했다. 상세 최종 결과는 [`P8_DG_SCR_2026-08-21.md`](P8_DG_SCR_2026-08-21.md)에 분리해 기록한다.
