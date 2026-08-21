# 뉴런의 발화 신호를 빠르고 공정하게 전달하는 AER 컨트롤러

여러 뉴런이 동시에 발화하면 다음 처리 블록은 어느 뉴런에서 이벤트가 발생했는지 알아야 한다. 뉴런마다 전용 데이터 버스를 만들면 배선과 핀이 빠르게 늘어난다. 이 프로젝트는 발화한 뉴런의 번호만 하나의 공용 주소 버스로 보내는 AER(Address-Event Representation) 방식으로 이 문제를 해결한다.

비교 기준으로 공통 clock 없이 요청과 응답만으로 움직이는 전통적 AER **T0-PPA**를 구현했다. 이후 비동기 발화를 안전하게 접수하고 모든 뉴런에 처리 기회를 주는 동기식 구조를 발전시켰다. **P7-GE**가 공정한 Gray 순서 중재를 완성했고, **P8-DG-SCR**은 같은 기능을 유지하면서 Gray 상태·선택 tree·reset 구조를 다시 설계했다. 현재 주 설계 **P9-GRR**은 ACK와 pending을 Gray 순번으로 저장하고 출력 rank register를 공정성 pointer로도 재사용해 상태를 75 FF에서 71 FF로 줄인다.

> 핵심 결과: 서버 제공 FPR 180 nm reference kit에서 같은 경계탐색 절차로 hold를 각각 재최적화한 P8-DG-SCR(0.021 ns) 대비 P9-GRR은 배치·배선 후 셀 면적 5.10%, 기본 활동률 전력 2.55%, 동일 workload mapped-SAIF 전력 2.98%를 줄였다. Core setup +4.810 ns, CDC setup +0.159 ns와 hold +0.012 ns로 timing을 만족했고 clock-tree·DRC·연결 위반은 0이었다. 이 180 nm 결과는 주최측 공식 공정이 확정되기 전의 잠정 비교값이다.

상세 수치와 검증 근거는 [P9 상태 압축·물리 탐색 문서](results/P9_STATE_COMPRESSION_EXPLORATION_2026-08-21.md), 설계 전 과정은 [대회 보고서](reports/AER_COMPETITION_REPORT_KR.md)에 정리한다.

회로 동작을 처음부터 이해하려면 [P9-GRR 세 핵심 기술 상세 설명](docs/P9_GRR_CORE_TECHNOLOGIES_KR.md)을 먼저 읽으면 된다. 이 문서는 T0를 기준으로 2FF의 아날로그 상태, pending·early ACK·output register의 clock별 동작, Gray-rank 중재와 pointer 재사용의 PPA 손익을 설명한다.

## 1. AER이 필요한 이유

이 설계의 입력은 16개 뉴런이 각각 발생시키는 발화 이벤트다. 막전위나 파형 전체를 전송하는 것이 아니라, 이벤트가 생겼을 때 **어느 뉴런이 발화했는지**만 보낸다.

```text
5번 뉴런 발화
    → 컨트롤러가 요청을 접수
    → 공용 주소 버스에 5를 출력
    → 수신기가 5번 뉴런의 발화로 해석
```

16개 뉴런은 0번부터 15번까지이므로 주소는 4 bit면 충분하다. 16개의 요청선을 하나의 4-bit 주소 버스로 모을 수 있지만, 여러 요청이 겹치면 어떤 이벤트를 먼저 보낼지 결정하는 **중재기(arbiter)**가 필요하다.

본 설계의 주소는 원래 뉴런 번호인 source ID다. 발화 크기, 막전위와 별도의 timestamp는 포함하지 않는다. 출력된 시각에는 동기화와 대기 시간이 포함되므로 원래 발화 시각과 같지 않다. 즉 이 회로는 뉴런의 막전위 계산기가 아니라 여러 뉴런의 이벤트를 모아 운반하는 통신 컨트롤러다.

## 2. 요청 하나가 전달되는 과정

### 2.1 뉴런 쪽 active-high 4-phase handshake

뉴런은 컨트롤러 clock과 관계없는 순간에 발화할 수 있다. 뉴런과 P8-DG-SCR/P9-GRR 사이의 `src_req`와 `src_ack`는 다음 네 단계를 거친다.

1. 뉴런이 `src_req`를 1로 올려 이벤트 발생을 알린다.
2. 컨트롤러가 이벤트를 안전하게 접수하고 `src_ack`를 1로 올린다.
3. 뉴런이 응답을 확인하고 `src_req`를 0으로 내린다.
4. 컨트롤러가 `src_ack`를 0으로 내려 다음 요청을 받을 준비를 한다.

뉴런은 ACK를 볼 때까지 REQ를 유지해야 한다. 짧은 pulse만 보냈다가 내리면 controller clock이 이벤트를 보지 못할 수 있다. REQ와 ACK가 모두 1로 올라갔다가 다시 0으로 돌아오는 이 규약을 active-high 4-phase handshake라고 한다.

![AER 4-phase handshake](docs/architecture/aer_4phase_handshake_flow.svg)

### 2.2 수신기 쪽 valid/ready

P8-DG-SCR과 P9-GRR은 뉴런 쪽에서 4-phase handshake를 사용하고, 수신기 쪽에서는 동기식 `out_valid/out_ready` 규약을 사용한다.

| 신호 | 역할 |
|---|---|
| `src_req_async[15:0]` | 각 뉴런이 이벤트 발생을 알리는 비동기 요청 |
| `src_ack_async[15:0]` | 해당 요청이 컨트롤러 내부에 접수됐다는 조기 응답 |
| `out_addr[3:0]` | 수신기로 보내는 원래 뉴런 번호 |
| `out_valid` | 현재 출력 주소가 유효하다는 표시 |
| `out_ready` | 수신기가 현재 주소를 받을 준비가 됐다는 표시 |

`src_ack`는 최종 수신기까지 전송이 끝났다는 뜻이 아니다. 이벤트가 source별 대기칸에 저장되거나 같은 처리 결정에서 output register에 실리면 ACK를 보낸다. 수신기가 잠시 멈춰도 이미 접수된 요청은 컨트롤러 안에서 기다릴 수 있다.

## 3. 비교 기준: 전통적 비동기 AER T0-PPA

T0-PPA에는 전체 회로를 움직이는 공통 clock이 없다. 요청이 들어오면 번호가 가장 작은 source를 고르고, 선택 주소를 투명 latch에 보관한다. 주소가 안정된 뒤에만 수신 요청이 올라가도록 delay cell을 사용해 bundled-data timing 조건을 맞췄다.

![T0-PPA 전통적 비동기 AER 구조](docs/architecture/aer_baseline_controller_structure.svg)

이 구조는 전통적 AER의 동작을 직접 보여주지만 다음 한계가 있다.

- 번호가 작은 요청이 계속 들어오면 큰 번호 요청은 오래 밀릴 수 있다.
- source별 내부 대기칸이 없어 선택되지 않은 뉴런이 요청을 계속 유지해야 한다.
- 이벤트마다 REQ와 ACK를 0으로 되돌리므로 다음 전송까지 빈 구간이 생긴다.
- 현재 서버의 180 nm reference library에는 characterized MUTEX cell이 없다. 따라서 T0-PPA의 동시 요청 판정에는 grant를 잡는 짧은 구간 동안 요청 집합이 안정적이라는 조건이 남는다.

T0-PPA는 이 한계를 숨기지 않은 최소 비교 기준이다. Xcelium에서 139개 이벤트를 유실·중복 없이 전달했고, RTL과 합성 netlist의 26개 비교점이 일치했다. 배치·배선 후 bundled-data 상대 시간 여유는 +0.676 ns였고 DRC와 연결 오류는 0이었다.

## 4. 개선 과정: P4-C에서 P9-GRR까지

P4-C에서 다음 기능이 먼저 갖춰졌다.

1. **2단 동기화기:** 비동기 REQ를 두 개의 플립플롭에 차례로 통과시켜 controller clock 영역으로 가져온다.
2. **source별 대기칸:** source마다 `pending` 1 bit를 두어 기다리는 이벤트를 기억한다.
3. **조기 ACK:** 이벤트가 내부에 접수되면 최종 출력 완료를 기다리지 않고 source에 응답한다.
4. **공정한 선택:** 특정 source가 계속 독점하지 않도록 우선순위를 순환한다.
5. **등록된 출력:** 수신기가 멈추면 주소와 valid를 유지하고, 준비된 동안에는 clock마다 이벤트 하나를 보낸다.

P7-GE는 P4-C의 10-bit 중재 상태를 4-bit epoch로 줄였다. Epoch가 모든 주소를 Gray 순서로 한 번씩 우선하도록 만들고, 16개 pending 중 현재 우선 주소와 가장 가까운 요청을 4단 tree로 선택했다.

```text
0, 1, 3, 2, 6, 7, 5, 4, 12, 13, 15, 14, 10, 11, 9, 8
```

주소를 Gray payload로 바꾸는 것이 아니라 **원래 source ID를 선택하는 순서**를 위와 같이 만든다. 수신기는 항상 원래 source ID를 받으므로 별도 Gray decoder가 필요 없다.

P8-DG-SCR은 P7의 입출력 계약과 공정성은 그대로 두고 다음 세 비용을 다시 줄였다.

- Binary epoch를 저장한 뒤 Gray로 변환하지 않고, Gray epoch를 상태로 직접 저장한다.
- `pair → quarter → half → grant`로 이어지는 하나의 균형 OR tree를 여러 선택 단계가 공유한다.
- 모든 플립플롭에 같은 비동기 reset을 배포하지 않고, 상태의 역할에 따라 reset 방식을 나눈다.

![P8-DG-SCR 구조](docs/architecture/aer_p8_dgscr_structure.svg)

## 5. P8-DG-SCR의 핵심 구조

### 5.1 이벤트를 잃지 않는 저장 구조

Source마다 pending 1 bit가 있으므로 대기칸은 16개다. 수신기로 보낼 주소를 저장하는 output register 한 칸도 별도로 있다. 컨트롤러가 접수했지만 아직 수신기로 넘기지 않은 이벤트는 최대 17개까지 존재할 수 있다.

이 저장 능력은 P7-GE와 같다. P8의 면적 감소는 필요한 저장소를 외부 뉴런으로 떠넘긴 결과가 아니다.

### 5.2 Direct Gray epoch와 공유 선택 tree

4-bit Gray epoch는 다음에 어느 source를 가장 우선해서 볼지 나타내는 내부 순번표다. 실제 service decision이 일어날 때마다 다음 Gray 상태로 이동하며, 한 번에 epoch bit 하나만 바뀐다.

선택 회로는 16개 candidate를 두 개씩 묶어 8개 pair-valid를 만든다. 다시 4개 quarter-valid, 2개 half-valid와 최종 grant-valid를 만든다. 이 유효성 tree를 한 번만 계산한 뒤 Gray epoch가 선호하는 branch를 따라 내려가 실제 pending source 하나를 고른다.

지속적으로 pending인 source는 epoch가 16개 주소를 도는 동안 자신의 차례를 반드시 만난다. 따라서 최대 16번의 service decision 안에 선택된다. 이 값은 16 clock 보장이 아니다. Receiver가 `out_ready=0`으로 멈춘 시간에는 새로운 service decision이 진행되지 않으므로 stall 시간은 상한에서 제외한다.

### 5.3 Reset을 상태의 역할에 따라 나누기

P7-GE의 75개 상태 플립플롭은 모두 비동기 reset pin을 사용했다. P8-DG-SCR도 상태 수는 75개지만 reset 방식은 다음처럼 나눈다.

| 분류 | 상태 | 수량 | 이유 |
|---|---|---:|---|
| 비동기 reset | `reset_release_q[1:0]` | 2 | reset assertion을 즉시 받고 해제를 clock 두 번에 맞춤 |
| resetless | 2FF request synchronizer 32 + `out_addr` 4 | 36 | reset 중에도 실제 입력을 샘플하고, 주소는 valid=0일 때 무효 |
| 동기 clear | ACK 16 + pending 16 + Gray epoch 4 + valid 1 | 37 | 보호된 release clock 두 번 동안 0으로 정리 |

외부 reset이 0이 되면 `core_rst_n`도 즉시 0이 되고 ACK와 valid 출력은 isolation 논리로 clock 없이 즉시 0이 된다. Reset이 해제돼도 바로 동작하지 않는다. 첫 번째와 두 번째 clock edge에서 내부 37개 상태를 0으로 지운 뒤에만 출력 isolation을 푼다.

따라서 reset 해제 뒤 정상 동작 전까지 clock 두 번이 공급돼야 한다. `out_valid=0`인 동안 `out_addr`는 임의 값일 수 있으며 수신기는 이 주소를 해석하면 안 된다.

## 6. 기능과 안정성 검증

### 6.1 이벤트, 공정성, CDC

단일 요청, 16개 동시 요청, burst, receiver stall, 포화 입력, hotspot과 reset을 포함한 broad regression에서 RTL과 합성 gate netlist가 각각 139개 이벤트를 모두 한 번씩 출력했다.

- Broad regression: RTL 139/139, gate 139/139, 오류 0
- 비동기 요청 phase sweep: RTL 192/192, gate 192/192, 오류 0
- 16-source 포화 순서: 예상 Gray 순서와 정확히 일치
- Random pending mask: 64/64, 오류 0
- 가장 불리한 지속 요청: 16번째 service decision에서 처리
- Stall 중 `out_valid/out_addr`: 안정적으로 유지

CDC phase sweep은 요청 유지 규약과 2FF 구조의 디지털 동작을 확인한 시험이다. 실제 실리콘의 metastability 발생 확률이나 MTBF를 직접 측정한 것은 아니다.

### 6.2 Reset 전용 시험

Clock을 멈춘 상태와 ACK·valid가 활성인 transaction 중간에서 reset을 assertion/deassertion했다. Assertion 직후 ACK와 valid가 즉시 0이 되는지, 두 release clock 이전에 stale state가 보이지 않는지, reset 중 high인 요청이 재시작 후 정확히 한 번 접수되는지 확인했다. RTL과 gate simulation 모두 오류 0으로 통과했다.

Cadence Xcelium에서도 broad 139/139, CDC 192/192, 공정성 64 random cases와 reset 전용 시험이 모두 통과했다.

### 6.3 P7-GE와 동일 입력 비교

P7과 P8에 같은 101-event demand 도착 시각을 주고 source 바깥 대기부터 최종 출력까지 비교했다.

| 항목 | P7-GE | P8-DG-SCR | 해석 |
|---|---:|---:|---|
| 전달 이벤트 / 오류 | 101 / 0 | 101 / 0 | 유실·중복 없음 |
| 포화 구간 출력 시간 | 630 ns | 630 ns | 최대 1 event/clock 유지 |
| Stall 해제 전 미리 ACK한 이벤트 | 5 | 5 | 내부 elasticity 동일 |
| 포화 구간 평균 demand→output | 354 ns | 354 ns | end-to-end 동작 동일 |
| 전체 output address bit 전환 | 106 | 106 | 선택 순서도 동일 |

P8의 전력 감소는 P7보다 이벤트를 덜 처리하거나 주소 의미를 바꿔 얻은 것이 아니다. 같은 이벤트 수, 출력 순서, 저장 능력과 처리율에서 내부 상태 표현과 reset 배포 비용을 줄인 결과다.

## 7. 서버 제공 FPR 180 nm 구현 결과

현재 주최측 공식 공정은 확인되지 않았다. 아래 수치는 서버에서 먼저 사용 가능했던 FPR 180 nm digital reference kit에서 P7과 P8을 비교한 잠정 결과다. Genus 합성은 10 ns clock과 1 ns I/O delay를 사용했으며 명시적인 clock uncertainty는 두지 않았다. Innovus 배치·배선에는 10 ns clock, 0.2 ns uncertainty와 Metal1-Metal6를 적용했다. 주최측 공식 공정 환경이 확정되면 비교 설계를 같은 조건으로 다시 실행해야 한다.

### 7.1 Genus 논리 합성

| 항목 | P7-GE | P8-DG-SCR | 변화 |
|---|---:|---:|---:|
| 표준셀 수 | 236 | **232** | -1.70% |
| 셀 면적 | 7,248.226 µm² | **6,383.362 µm²** | **-11.93%** |
| 가장 긴 data path | **2.508 ns** | 3.130 ns | +0.622 ns |
| 10 ns 목표 setup 여유 | **+7.268 ns** | +6.657 ns | -0.611 ns |
| 기본 활동률 전력 추정 | 0.887720 mW | **0.848839 mW** | -4.38% |
| 동일 101-event VCD 전력(보조 관찰) | 0.686263 mW | **0.620896 mW** | **-9.525%** |

합성 면적 감소는 reset partition이 지배했다. Sequential cell area는 P7의 5,255.712에서 P8의 4,144.694 µm²로 줄었지만, 조합·inverter·buffer 면적은 1,992.514에서 2,238.667 µm²로 증가했다. 따라서 shared tree가 mapped 조합 면적까지 독립적으로 줄였다고 주장하지 않는다.

P8의 선택 경로는 P7보다 길어졌지만, 명시적 uncertainty가 없는 10 ns Genus 조건에서 +6.657 ns의 합성 여유가 남았다. 이 값을 0.2 ns uncertainty까지 포함한 slack으로 해석하면 안 된다.

VCD 재실행은 두 설계 모두 RTLStim2Gate mapping을 켜 STIM-0551 경고를 제거했고 sequential/RTL-driver 주석률은 100%였다. 그러나 전체 driver-net 주석률은 P7 37.10%, P8 51.21%로 달랐다. 따라서 -9.525%는 같은 workload에서 관찰한 방향성 보조값이며 clean matched-coverage 전력 근거로 사용하지 않는다.

### 7.2 Conformal LEC와 Innovus 배치·배선

Conformal LEC에서 상태점 75개가 모두 equivalent였고 nonequivalent, abort와 unknown point는 0이었다.

| 항목 | P7-GE | P8-DG-SCR | 변화 |
|---|---:|---:|---:|
| 배치 후 셀 수 | **292** | 313 | +7.19% |
| 배치 후 셀 면적 | 8,063.194 µm² | **7,657.373 µm²** | **-5.03%** |
| Core setup slack | **+4.350 ns** | +3.235 ns | -1.115 ns |
| CDC max-delay slack | 별도 제약 없음 | **+0.201 ns** | 0.9 ns pair constraint 통과 |
| Hold slack | +0.006 ns | **+0.028 ns** | +0.022 ns |
| Recovery slack | +8.366 ns | **+9.104 ns** | +0.738 ns |
| Removal slack | **+0.340 ns** | +0.043 ns | -0.297 ns |
| 기본 활동률 post-route 전력 | 0.85619239 mW | **0.81695915 mW** | **-4.58%** |
| DRC / 연결 오류 | 0 / 0 | **0 / 0** | 통과 |

P8의 instance 수는 CDC max-delay와 hold를 함께 닫기 위한 buffer 때문에 증가했지만, reset 방식에 맞춘 더 작은 FF mapping 덕분에 총 cell area는 5.03% 감소했다.

첫 P8 run은 전용 clock buffer가 없어 root capacitance를 0.002 pF 초과했으므로 폐기했다. 최종 run은 P7과 같은 `CLKBUFX20` clock driver를 사용하며 clock-tree max-capacitance·slew·fanout·length 위반이 모두 0이다. 또한 Genus가 무시한 `ASYNC_REG` 표기 대신 34개 synchronizer FF를 명시적으로 보존하고, 17개 pair group과 0.9 ns request-pair max-delay를 적용했다. 이 물리 안전 제약을 포함한 뒤에도 면적과 전력이 각각 5.03%, 4.58% 감소했다.

모든 timing slack이 양수이므로 10 ns 목표에서 setup, hold와 reset recovery/removal 조건을 만족했다. P8의 setup과 removal 여유는 P7보다 작아졌으므로 공정 이관 시 다시 확인해야 한다.

### 7.3 실제 Innovus post-route 화면

아래 이미지는 발표용 예상도가 아니라 최종 Innovus database를 다시 열어 직접 출력한 화면이다. 가운데의 작은 사각형은 표준 논리 셀이고 여러 색의 선은 전원망과 신호 배선이다.

![P8-DG-SCR 180 nm Innovus post-route](docs/architecture/p8dgscr_180nm_innovus_postroute.png)

## 8. 시도했지만 최종안에서 제외한 방향

최적점을 찾기 위해 다음 후보도 같은 기능 계약에서 구현하고 검증했다.

- **P8-DG-T:** 공유 OR tree를 먼저 적용했다. 논리는 정리됐지만 P8-DG와 동일 VCD에서 전력 차이가 거의 없었다.
- **P8-DG-PR:** 내부 상태만 동기 clear하고 ACK/valid는 비동기 reset으로 유지했다. 면적 6,579.619 µm², VCD 전력 0.632877 mW로 최종 P8-DG-SCR보다 모두 컸다.
- **P8-X2:** Gray 변환 XOR 수를 줄였지만 해당 101-event workload에서 주소 전환과 전력이 증가했다.
- **P8-GR:** output address를 중재 pointer로 재사용해 71 FF로 줄였다. 그러나 순환 검색 조합 논리 비용 때문에 면적 6,606.230 µm², VCD 전력 0.642428 mW로 최종안보다 불리했다.
- **Fall-through 출력:** latency를 1 clock 줄였지만 10 ns 출력 timing을 만족하지 못해 제외했다.

기능 simulation만 빠른 후보가 아니라, 같은 기능을 유지하면서 면적과 실제 활동 기반 전력을 함께 낮추고 timing을 통과한 P8-DG-SCR을 이 단계의 기준점으로 선택했다. 이후 P9 탐색은 이 기준점을 다시 같은 물리 조건에서 개선했다.

P8-GR과 P9-GRR은 모두 출력 상태 재사용을 시도하지만 내부 표현이 다르다. P8-GR은 source 주소 순서의 저장부 뒤에 순환 검색·변환 비용이 남았고, P9-GRR은 ACK와 pending 자체를 Gray rank 순서로 배열해 그 feedback 비용을 없앴다. 같은 71 FF라도 조합 경로가 달라 PPA 결과가 달라졌다.

## 9. P9-GRR의 세 핵심 기술

P9-GRR은 네 개의 독립 기술이 아니라 다음 세 축으로 이해하는 것이 정확하다.

1. Source별 2FF 입력 동기화
2. Pending 16개와 출력 register 1개를 묶은 2단 elastic buffer
3. Gray-rank strict-cyclic 중재와 출력 rank pointer 재사용

출력 register는 별도의 네 번째 기술이 아니다. 이벤트를 보관하는 기능은 두 번째
buffer 축에 포함되고, 저장된 rank를 다음 중재 위치로 재사용하는 기능은 세 번째
중재 축에 포함된다.

![P9-GRR 구조](docs/architecture/aer_p9_grr_structure.svg)

### 9.1 세 축이 각각 담당하는 역할

| 축 | 회로가 실제로 하는 일 | T0 대비 얻는 것 | PPA 비용·절감 |
|---|---|---|---|
| 2FF 입력 동기화 | 비동기 REQ를 FF 두 개에 통과시켜 controller는 두 번째 FF만 사용 | Metastability가 내부로 퍼질 확률 감소, synchronous ASIC flow 사용 | Source 16개 × 2 FF = 32 FF와 입력 지연 추가 |
| 2단 elastic buffer | Source별 pending은 대기 이벤트를, output register는 receiver 앞의 현재 이벤트를 보관 | Early ACK, 최대 17개 보관, stall 중 주소 고정, 최대 1 event/clock | Pending·ACK·output FF와 clock/control 비용 추가 |
| Gray-rank 공정 중재 | Pending을 Gray 순번으로 배열하고 마지막 rank 다음부터 원형 검색 | Fixed-priority starvation 제거, 포화 traffic의 주소 전환 감소 | Gray XOR와 cyclic selector 비용은 추가되지만 output rank를 pointer로 재사용해 별도 4 FF 제거 |

회로 전체 흐름은 다음과 같다.

```text
T0-PPA
비동기 REQ → fixed priority → grant/address latch → receiver ACK

P9-GRR
비동기 REQ → 2FF → pending 16 → Gray-rank 중재 → output register → valid/ready receiver
```

Pending이 source별 보조 주머니라면 output register는 receiver 앞의 전송 쟁반이다.
두 저장소를 합쳐야 `pending 16 + output 1 = 최대 17개`라는 수용량과 early ACK,
stall 격리가 만들어진다.

Gray-rank는 이 주머니들을 확인하는 원형 순서표다.

```text
내부 rank:  0, 1, 2, 3, 4, 5, 6, 7, ...
source ID:  0, 1, 3, 2, 6, 7, 5, 4, ...
```

Source 6은 rank 4 위치에 고정 연결된다. 중재기가 rank 4를 선택하면 같은 위치의
pending을 바로 지우고, 외부에는 `Gray(4)=source ID 6`을 출력한다. Output register에
저장된 rank 4는 현재 주소를 만드는 동시에 다음 탐색을 rank 5부터 시작하게 하는
책갈피가 된다.

```text
reset release 2 + request CDC 32 + ACK 16 + pending 16 + output rank 4 + valid 1
    = 71 FF
```

각 기술의 transistor-level 동작, clock별 상태 변화, T0 대비 기능·PPA 손익은
[P9-GRR 핵심 기술 상세 설명](docs/P9_GRR_CORE_TECHNOLOGIES_KR.md)에 단계별로
정리한다.

### 9.2 T0와 비교할 때의 정확한 의미

T0-PPA는 source별 2FF, pending, registered valid/ready output과 공정성 pointer가
없기 때문에 P9보다 훨씬 작다. P9-GRR은 T0의 raw PPA를 이긴 구조가 아니라,
T0에 없던 입력 안전성·이벤트 보관·starvation 상한·동기식 후단 처리율을 추가하고
Gray-rank 배열과 상태 재사용으로 그 추가 비용을 줄인 구조다.

| 기능 | T0-PPA | P9-GRR |
|---|---|---|
| 비동기 요청 | 비동기 중재·relative timing | Source별 2FF 뒤 synchronous core |
| 대기 공간 | Source별 pending 없음 | Pending 16 + output 1 |
| ACK | Receiver transaction과 직접 연결 | 내부 접수 뒤 early ACK |
| 중재 | Fixed priority | Stall 제외 최대 16 service decisions의 strict cyclic |
| Receiver stall | 현재 link와 source에 직접 전파 | Output 유지, 빈 pending까지 추가 접수 |
| 후단 처리율 | 4-phase transaction 간격 | Full backlog에서 최대 1 event/clock |

### 9.3 P9-GRR과 P9-OHT의 post-route Pareto

같은 FPR 180 nm 잠정 조건에서 hold-target sweep까지 수행한 최종 물리 결과다. P9-GRR은 `holdTargetSlack=0.020 ns`, P9-OHT는 `0.012 ns` 설정의 clean run을 사용했다.

| 항목 | P8-DG-SCR / 0.021 | P9-GRR / 0.020 | P9-OHT / 0.012 |
|---|---:|---:|---:|
| 상태 FF | 75 | **71** | 75 |
| Post-route instance | 297 | **281** | 290 |
| 셀 면적 | 7,364.650 µm² | **6,988.766 µm²** | 7,291.469 µm² |
| Vectorless power | 0.79657531 mW | 0.77624020 mW | **0.77267187 mW** |
| 동일 workload mapped-SAIF power | 0.59663396 mW | **0.57886987 mW** | 0.58959029 mW |
| Core setup slack | +3.278 ns | +4.810 ns | **+6.201 ns** |
| Overall/CDC setup slack | +0.200 ns | +0.159 ns | **+0.300 ns** |
| Hold/CDC hold slack | +0.009 ns | +0.012 ns | +0.010 ns |
| DRC / connectivity | 0 / 0 | **0 / 0** | **0 / 0** |

P9-OHT는 P8의 75 FF 상태를 유지하되 중재 선택 경로를 top-down one-hot tree로 표현한 대안이다. P9-GRR보다 vectorless power가 0.46% 낮고 core timing 여유가 크다. 반대로 P9-GRR은 OHT보다 셀 면적이 4.15% 작고, 동일 workload mapped-SAIF power도 1.82% 낮다. 따라서 OHT는 저전력 기본 가정과 timing을 우선하는 유효한 Pareto 대안이고, P9-GRR은 면적과 관찰 workload 전력을 함께 본 현재 주 설계다.

아래 화면은 구조를 그린 예상도가 아니라, 최종 P9-GRR `0.020 ns` post-route database를 Innovus에서 복원해 직접 출력한 Metal1-Metal6 배치·배선 화면이다.

![P9-GRR 최종 Innovus post-route 화면](docs/architecture/p9grr_180nm_innovus_postroute.png)

P9-OHT의 독립 clean run 화면도 [별도 PNG](docs/architecture/p9oht_180nm_innovus_postroute.png)로 보존한다.

Vectorless power는 실제 event trace 없이 도구가 각 신호의 활동률을 기본값으로 가정한 추정치다. Mapped-SAIF power는 동일한 101-event workload에서 기록한 switching activity를 배치·배선 회로에 연결한 추정치다. 후자가 이번 workload에는 더 구체적이지만 실제 ECG spike 분포, pad 부하와 실리콘 측정을 대신하지 않는다. 두 수치를 섞어 하나의 보장된 절감률로 주장하지 않는다.

## 10. 2차 설계과제에서의 재사용

P9-GRR은 특정 응용 계산을 포함하지 않은 독립 이벤트 전송 IP다. 2차 설계에서는 다음과 같이 전단 블록으로 재사용할 수 있다.

```text
뉴런 또는 센서 이벤트 16개
    → P9-GRR이 동기화·저장·중재
    → source ID[3:0] + valid/ready
    → 좌표 변환, N×M 메모리, SNN 연산 또는 분류기
```

후단은 원래 source ID를 받으므로 Gray decoder가 필요 없다. 재사용되는 범위는 비동기 이벤트의 동기화·보관·중재와 단일 주소 스트림 생성까지다. 좌표 변환, 메모리 접근, 막전위 갱신, SNN 연산과 분류 기능까지 P9-GRR이 대신하는 것은 아니다. 현재 RTL은 16 sources와 4-bit 주소로 고정돼 있으므로 2차 과제의 뉴런 수가 달라지면 source 수와 중재 구조를 parameter화하고 공정성·CDC·PPA를 다시 검증해야 한다.

원래 도착 순서를 항상 보존해야 하는 응용에는 timestamp 또는 FCFS queue가 별도로 필요하다. 같은 source에서 ACK 전에 여러 이벤트가 연속 발생할 수 있다면 source-side accumulator나 추가 FIFO가 필요하다.

## 11. 적용 범위와 한계

- Event 보존은 source가 ACK까지 REQ를 유지하고 source당 한 번에 요청 하나만 제시한다는 계약 안에서 성립한다.
- P9-GRR은 FCFS가 아니며 원래 발화 시각을 payload로 보내지 않는다.
- CDC 검증은 디지털 phase sweep이며 실리콘 metastability MTBF sign-off가 아니다.
- Reset 해제 뒤 정상 동작 전까지 clock 두 번이 필요하다.
- Recovery/removal slack은 STA가 둔 reset 입력 도착 가정에서의 값이다. 임의 위상에서 들어오는 모든 비동기 deassertion의 안전성을 그 숫자만으로 증명하지 않으며, 2단 release 구조와 별도로 RDC/실리콘 검증이 필요하다.
- Post-route vectorless와 mapped-SAIF 전력은 모두 도구 추정값이다. 실제 ECG/SNN spike 분포, pad/receiver load와 실리콘 측정 결과가 아니다.
- 완료 범위는 디지털 코어 RTL, 합성, LEC, 배치·배선과 STA다. Pad ring, package, 제조용 GDS, foundry sign-off DRC/LVS와 실리콘 제작은 포함하지 않는다.
- 180 nm 결과는 잠정 reference 비교다. 주최측 공식 PDK가 확정되면 P8, P9-GRR과 P9-OHT를 같은 조건에서 함께 재합성·재배치해야 한다.

## 12. 주요 파일과 재현 근거

| 내용 | 경로 |
|---|---|
| 현재 P9-GRR RTL | [rtl/experiments/aer_pending_gray_rank_reuse_sync_core_reset.sv](rtl/experiments/aer_pending_gray_rank_reuse_sync_core_reset.sv) |
| P9-GRR 구조 SVG | [docs/architecture/aer_p9_grr_structure.svg](docs/architecture/aer_p9_grr_structure.svg) |
| P9-GRR 세 핵심 기술 상세 설명 | [docs/P9_GRR_CORE_TECHNOLOGIES_KR.md](docs/P9_GRR_CORE_TECHNOLOGIES_KR.md) |
| P9 상태 압축·물리 탐색 | [results/P9_STATE_COMPRESSION_EXPLORATION_2026-08-21.md](results/P9_STATE_COMPRESSION_EXPLORATION_2026-08-21.md) |
| P9 hold/PPA 전체 sweep | [results/P9_PHYSICAL_HOLD_PARETO_SWEEP_2026-08-21.md](results/P9_PHYSICAL_HOLD_PARETO_SWEEP_2026-08-21.md) |
| P9 최종 Cadence 원시 보고서 | [reports/p9_final/](reports/p9_final/) |
| P9-GRR Cadence 재현 절차 | [scripts/cadence/P9GRR_FLOW_NOTES.md](scripts/cadence/P9GRR_FLOW_NOTES.md) |
| 직전 기준 P8-DG-SCR RTL | [rtl/improved/aer_pending_direct_gray_sync_core_reset.sv](rtl/improved/aer_pending_direct_gray_sync_core_reset.sv) |
| P8 구조 SVG | [docs/architecture/aer_p8_dgscr_structure.svg](docs/architecture/aer_p8_dgscr_structure.svg) |
| P8 상세 결과 | [results/P8_DG_SCR_2026-08-21.md](results/P8_DG_SCR_2026-08-21.md) |
| P8 증거 manifest | [results/P8_DG_SCR_MANIFEST_2026-08-21.md](results/P8_DG_SCR_MANIFEST_2026-08-21.md) |
| P8 180 nm 요약 | [reports/p8_dg_scr/cadence/pnr_180nm/SUMMARY.txt](reports/p8_dg_scr/cadence/pnr_180nm/SUMMARY.txt) |
| Genus/LEC/Innovus 재현 절차 | [scripts/cadence/P8DGSCR_FLOW_NOTES.md](scripts/cadence/P8DGSCR_FLOW_NOTES.md) |
| RTL·gate 검증 실행 | [scripts/run_p8_dgscr_verification.ps1](scripts/run_p8_dgscr_verification.ps1) |
| 동일 입력 workload TB | [tb/aer_contract_fairness_tb.sv](tb/aer_contract_fairness_tb.sv) |
| 전통적 T0-PPA 결과 | [results/T0_PAA_TRADITIONAL_AER_2026-08-19.md](results/T0_PAA_TRADITIONAL_AER_2026-08-19.md) |
| 이전 P7-GE 결과 | [results/P7_PENDING_GRAY_EPOCH_2026-08-20.md](results/P7_PENDING_GRAY_EPOCH_2026-08-20.md) |
| 후보 탐색 기록 | [results/P8_EPOCH_PARETO_EXPLORATION_2026-08-21.md](results/P8_EPOCH_PARETO_EXPLORATION_2026-08-21.md) |

README는 전체 설계 흐름을 설명하고, `results/`와 `reports/`는 수치와 도구 출력의 근거를 보존한다. 결과를 인용할 때는 측정 조건과 한계를 함께 확인해야 한다.
