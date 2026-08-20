# 뉴런의 발화 신호를 빠르고 공정하게 전달하는 AER 컨트롤러

여러 뉴런이 동시에 동작하는 회로에서는 각 뉴런의 발화 신호를 다음 처리 블록까지 전달해야 한다. 뉴런마다 전용 데이터선을 만들면 연결선과 출력 핀이 빠르게 늘어난다. 이 프로젝트는 발화한 뉴런의 번호만 하나의 공용 주소 버스로 보내는 AER(Address-Event Representation) 방식을 사용해 이 문제를 해결한다.

먼저 공통 clock 없이 요청과 응답만으로 동작하는 전통적 AER 구조인 **T0-PPA**를 구현했다. 그다음 비동기 발화를 안전하게 저장하고 모든 뉴런에 처리 기회를 주는 동기식 개선 과정을 거쳤다. 최종 개선본 **P7-GE**는 기존 개선본과 같은 이벤트 저장 능력과 처리율을 유지하면서, 다음 이벤트를 고르는 회로를 단순화해 면적과 전력, 주소선의 전환 횟수를 함께 줄인다.

> 핵심 결과: P7-GE는 이전 개선본 P4-C와 같은 입력·출력 규격과 최대 처리율을 유지한다. TSMC 180 nm 배치·배선 결과, 셀 면적은 13.80%, 전력 추정치는 10.88% 감소했고 setup 시간 여유는 0.803 ns 증가했다.

상세한 설계 과정은 [대회 보고서](reports/AER_COMPETITION_REPORT_KR.md), 수치와 검증 근거는 [P7-GE 결과 문서](results/P7_PENDING_GRAY_EPOCH_2026-08-20.md)에 정리했다.

## 1. AER이 필요한 이유

이 프로젝트의 입력은 16개 뉴런이 각각 발생시키는 발화 이벤트다. 뉴런의 막전위나 파형 전체를 보내는 것이 아니라, 이벤트가 생겼을 때 **어느 뉴런이 발화했는지**만 전달한다.

예를 들어 5번 뉴런이 발화하면 컨트롤러는 다음과 같이 동작한다.

```text
5번 뉴런 발화
    → 컨트롤러가 요청을 접수
    → 공용 버스에 주소 5를 출력
    → 수신기가 5번 뉴런의 발화로 해석
```

16개 뉴런은 0번부터 15번까지의 번호로 구분할 수 있으므로 주소 폭은 4 bit면 충분하다. 뉴런마다 별도의 데이터 버스를 만드는 대신, 16개의 요청을 하나의 4-bit 주소 버스로 차례대로 내보낸다. 연결선은 줄어들지만 여러 요청이 겹치면 어떤 이벤트를 먼저 보낼지 결정하는 **중재기(arbiter)**가 필요하다.

본 설계에서 주소는 발화한 위치를 나타내는 source ID다. 발화 크기, 막전위, 별도의 timestamp는 포함하지 않는다. 출력 transaction의 시각에는 내부 동기화와 대기·중재 시간이 포함되므로 원래 발화 시각과 같지 않다. 따라서 설계 대상은 뉴런의 계산식이 아니라 여러 뉴런의 이벤트를 모아 운반하는 통신 컨트롤러다.

## 2. 요청 하나가 전달되는 과정

### 2.1 뉴런과 컨트롤러 사이의 4단계 요청·응답

뉴런은 내부 controller clock과 관계없는 순간에 발화할 수 있다. 뉴런과 P7-GE 사이에서는 `src_req`와 `src_ack`가 다음 네 단계를 거친다.

1. 뉴런이 `src_req`를 1로 올려 이벤트 발생을 알린다.
2. 컨트롤러가 이벤트를 안전하게 저장한 뒤 `src_ack`를 1로 올린다.
3. 뉴런이 응답을 확인하고 `src_req`를 0으로 내린다.
4. 컨트롤러가 `src_ack`를 0으로 내려 다음 요청을 받을 준비를 한다.

뉴런은 `src_ack=1`을 확인할 때까지 `src_req=1`을 유지해야 한다. 짧은 pulse만 보냈다가 바로 내리면 controller clock이 이벤트를 보지 못할 수 있다. 이처럼 두 신호가 0에서 1로 올라갔다가 다시 0으로 돌아오는 규약을 active-high 4-phase handshake라고 한다.

### 2.2 전통적 AER과 P7-GE의 수신기 인터페이스

전통적 baseline T0-PPA는 수신기와도 `aer_req/aer_ack` 4-phase handshake를 사용한다. 주소를 먼저 고정한 뒤 요청을 올리고, 수신 완료 응답을 받은 뒤 두 신호를 차례대로 0으로 되돌린다.

![전통적 AER의 4단계 요청·응답](docs/architecture/aer_4phase_handshake_flow.svg)

P7-GE는 뉴런 쪽에서는 위 4-phase 규약을 유지하지만, 수신기 쪽에서는 동기식 회로에서 널리 사용하는 `out_valid/out_ready` 규약을 사용한다.

T0-PPA도 source 쪽 신호 순서는 같지만 ACK의 의미가 다르다. T0-PPA의 `src_ack`는 receiver가 주소를 받은 뒤 source로 돌아오는 완료 응답이고, P7-GE의 `src_ack`는 이벤트가 controller 내부에 접수됐음을 알리는 조기 응답이다.

| 신호 | 역할 |
|---|---|
| `src_req[15:0]` | 각 뉴런이 이벤트 발생을 알리는 비동기 요청 |
| `src_ack[15:0]` | 해당 이벤트가 controller 내부에 안전하게 저장됐다는 응답 |
| `out_addr[3:0]` | 현재 수신기로 보내는 원래 뉴런 번호 |
| `out_valid` | 현재 주소가 유효하다는 표시 |
| `out_ready` | 수신기가 현재 주소를 받을 준비가 됐다는 표시 |

`src_ack`는 최종 수신기까지 전송이 끝났다는 뜻이 아니다. P7-GE에서는 이벤트가 source별 대기칸에 저장되거나 같은 처리 결정에서 곧바로 output register에 실리면 `src_ack`를 보낸다. 이 덕분에 수신기가 잠시 멈춰도 뉴런은 다음 동작을 준비할 수 있다.

## 3. 비교 기준: 전통적 비동기 AER T0-PPA

T0-PPA에는 전체 회로를 움직이는 공통 clock이 없다. 요청이 들어오면 번호가 가장 작은 뉴런을 선택하고, 선택 주소를 표준셀 library의 투명 latch에 보관한다. 주소가 안정된 뒤에만 수신 요청이 올라가도록 delay cell을 넣어 bundled-data timing 조건을 맞췄다.

![T0-PPA 전통적 비동기 AER 구조](docs/architecture/aer_baseline_controller_structure.svg)

이 구조는 전통적 AER의 동작을 직접 보여주는 baseline이지만 다음 한계가 있다.

- 항상 번호가 작은 요청을 먼저 처리한다. 0번 요청이 계속 들어오면 15번 요청은 오랫동안 선택되지 못할 수 있다.
- 컨트롤러 내부에 이벤트 대기칸이 없다. 선택되지 않은 뉴런은 자신의 요청을 계속 유지해야 한다.
- 이벤트 하나를 보낼 때마다 요청과 응답을 모두 0으로 되돌려야 하므로 다음 전송까지 빈 시간이 생긴다.
- 현재 180 nm library에는 비동기 동시 요청을 물리적으로 판정하는 characterized MUTEX cell이 없다. 따라서 grant를 정하는 짧은 구간 동안 요청 집합이 안정적이라는 동작 조건이 필요하다.

T0-PPA는 이러한 한계를 숨기지 않은 비교 기준이다. Xcelium에서 139개 이벤트를 유실이나 중복 없이 전달했고, RTL과 합성 netlist의 26개 비교점이 모두 일치했다. 180 nm 배치·배선 후에는 주소가 제어 신호보다 먼저 안정되는 상대 시간 여유를 +0.676 ns 확보했으며 DRC와 연결 오류는 0이었다.

## 4. T0-PPA에서 P7-GE까지의 개선 과정

전통적 구조의 문제를 한 번에 바꾸면 어느 아이디어가 효과를 냈는지 알기 어렵다. 이 프로젝트는 선택 방식, 이벤트 저장, 출력 구조와 고정 대기를 단계적으로 개선했다.

이전 개선본 P4-C에서 다음 기능이 갖춰졌다.

1. **2단 동기화기:** 비동기 뉴런 요청을 플립플롭 두 개에 차례로 통과시켜 controller clock 영역으로 가져온다.
2. **source별 대기칸:** 뉴런마다 1-bit `pending`을 두어 해당 뉴런의 이벤트가 기다리고 있음을 기억한다.
3. **조기 응답:** 이벤트가 `pending` 또는 output register에 안전하게 접수되면 수신기 전송 완료를 기다리지 않고 뉴런에 ACK를 돌려준다.
4. **순환 선택:** 마지막 처리 위치를 기준으로 다음 차례를 옮겨 특정 뉴런의 독점을 막는다.
5. **등록된 출력:** 수신기가 멈추면 `out_valid`와 `out_addr`를 그대로 유지하고, 준비된 동안에는 매 clock마다 이벤트 하나를 보낸다.

P4-C는 기능과 처리율을 확보했지만 다음 차례를 기억하기 위해 그룹 순번 2 bit와 그룹 내부 순번 8 bit, 총 10 bit의 중재 상태를 사용했다. P7-GE는 이 중재 상태와 선택 회로를 더 단순하게 만드는 데 초점을 맞췄다.

## 5. P7-GE의 핵심 아이디어

### 5.1 다음 차례를 4-bit 숫자 하나로 표현

P7-GE는 여러 순번 정보를 따로 저장하지 않고 `epoch`이라는 4-bit 상태 하나만 유지한다. 여기서 epoch는 이벤트가 발생한 시간이 아니라, **현재 중재기가 어느 주소를 우선해서 볼 차례인지 나타내는 내부 순번표**다.

Epoch는 0부터 15까지 순환한다. 이 값을 Gray code 순서로 해석하면 다음 우선 주소가 된다.

```text
0, 1, 3, 2, 6, 7, 5, 4, 12, 13, 15, 14, 10, 11, 9, 8
```

Gray 순서의 특징은 인접한 두 값 사이에서 주소 bit가 하나만 바뀐다는 것이다. 예를 들어 `0001` 다음은 `0011`이므로 한 bit만 변한다. 모든 뉴런이 계속 기다리는 포화 상태에서는 P7-GE의 출력 주소도 이 순서를 따른다. 주소를 다른 code로 변환하는 것이 아니라, **원래 source ID를 고르는 순서 자체를 Gray 순서로 만든 것**이므로 수신기에 별도 decoder가 필요하지 않다.

### 5.2 현재 기다리는 뉴런 중 하나를 고르는 방법

항상 Gray 순서의 다음 뉴런이 요청 중인 것은 아니다. P7-GE는 16개 `pending`을 두 개씩 묶고, 다시 네 개와 여덟 개 단위로 묶어 어느 구역에 대기 이벤트가 있는지 확인한다.

선택 회로는 가장 선호하는 절반에 이벤트가 있으면 그쪽으로 내려가고, 비어 있으면 반대쪽으로 이동한다. 이 판단을 주소 bit 네 단계에 걸쳐 반복하면 실제로 대기 중인 source 하나가 선택된다. 토너먼트 대진표처럼 후보 범위를 절반씩 좁히므로 이 회로를 **Gray-epoch XOR tournament**라고 부른다.

수식으로는 pending인 주소 `i` 가운데 `unsigned(i XOR Gray(epoch))`가 가장 작은 주소를 선택한다. XOR 결과에서 1의 개수만 세는 것이 아니라 4-bit 숫자의 크기를 비교하며, 위 선택 tree가 상위 bit부터 이 판단을 구현한다.

### 5.3 특정 뉴런이 계속 밀리지 않는 이유

Epoch가 16번의 실제 처리 결정을 거치면 모든 4-bit 주소가 한 번씩 정확한 최우선 주소가 된다. 어떤 뉴런의 이벤트가 계속 `pending`에 남아 있다면, 늦어도 자신의 주소가 최우선이 되는 차례에는 반드시 선택된다.

따라서 지속적으로 기다리는 이벤트는 최대 16번의 service decision 안에 처리된다. 여기서 service decision은 clock 수가 아니다. `out_ready=0`이어도 비어 있던 output register에는 이벤트 하나를 미리 실을 수 있지만, register가 찬 뒤에는 receiver가 현재 이벤트를 소비할 때까지 추가 선택이 진행되지 않는다. 따라서 receiver stall 시간 자체는 이 상한에 포함하지 않는다.

### 5.4 이벤트를 저장하는 위치

P7-GE는 source마다 `pending` 1 bit를 가지므로 16개의 source-indexed 대기칸이 있다. 수신기로 보낼 주소를 보관하는 output register 한 칸도 별도로 존재한다. 따라서 controller가 접수했지만 아직 수신기로 넘기지 않은 이벤트는 최대 17개까지 존재할 수 있다.

이 저장 능력은 P4-C와 같다. P7-GE의 면적 감소는 필요한 저장소를 뉴런이나 외부 회로로 옮겨서 얻은 결과가 아니라, 다음 이벤트를 고르는 중재 상태와 조합 논리를 줄인 결과다.

![P7-GE Gray-epoch AER 컨트롤러 구조](docs/architecture/aer_p7_gray_epoch_structure.svg)

## 6. 기능 검증 결과

### 6.1 이벤트 유실과 중복 확인

단일 요청, 16개 동시 요청, 반복 burst, 수신기 정지, 포화 입력, 특정 source 집중 입력과 reset 상황을 포함해 139개 이벤트를 보냈다. P7-GE는 139개를 모두 한 번씩 출력했고 오류는 0이었다.

이 결과는 source가 ACK까지 request를 유지하고, source당 한 번에 요청 하나만 제시하는 검증 계약 안에서 성립한다. ACK 전에 사라지는 짧은 pulse나 같은 source의 무제한 burst까지 보장한다는 뜻은 아니다.

Clock edge 전후의 여러 시점에 비동기 요청을 넣는 디지털 CDC 시험도 수행했다. RTL과 합성 후 gate netlist에서 각각 192개 요청을 모두 한 번씩 전달했다. 이 시험은 요청 유지 규약과 동기화 구조의 디지털 동작을 확인한 것이며, 실제 실리콘의 준안정성 발생 확률을 직접 측정한 것은 아니다.

### 6.2 공정성 확인

16개 source가 모두 기다릴 때 출력 순서는 예상한 Gray 순서와 정확히 일치했다. 가장 불리한 위치에 둔 source도 16번째 service decision에서 처리됐다. 서로 다른 64개 대기 요청 조합에서도 선택 결과와 event accounting 오류는 0이었다.

### 6.3 P4-C와 같은 조건에서 비교

ACK 속도 때문에 다음 요청 시점이 달라지면 latency 비교가 왜곡될 수 있다. 이를 막기 위해 두 설계에 동일한 101-event 입력 도착 시각을 주고, source 바깥의 대기 시간부터 최종 출력까지 측정했다.

| 항목 | P4-C | P7-GE | 해석 |
|---|---:|---:|---|
| 전달 이벤트 / 오류 | 101 / 0 | 101 / 0 | 두 설계 모두 유실·중복 없음 |
| 포화 구간 출력 시간 | 630 ns | 630 ns | 최대 처리율 동일 |
| 수신기 정지 중 미리 ACK한 이벤트 | 5 | 5 | 내부 저장 능력 동일 |
| 포화 구간 평균 도착-출력 지연 | 354 ns | 354 ns | 실제 end-to-end 지연 동일 |
| 전체 output address bit 전환 | 174회 | **106회** | P7-GE 39.08% 감소 |
| 포화 구간 주소 bit 전환 | 118회 | **63회** | 매 인접 전송에서 정확히 1 bit 전환 |

같은 것은 입력 이벤트와 도착 시각이다. 두 중재기가 이벤트를 내보내는 순서는 서로 다르며, P7-GE는 이 순서를 Gray 형태로 만들어 주소선의 전환을 줄인다. 39.08%는 이 101-event workload에서 측정한 값이며 모든 sparse 발화 패턴에서 같은 감소율을 보장하지 않는다.

## 7. TSMC 180 nm 구현 결과

P4-C와 P7-GE를 같은 Artisan TSMC 0.18 µm 표준셀, 10 ns clock, 0.2 ns clock uncertainty, Metal1-Metal6 조건으로 합성하고 배치·배선했다.

### 7.1 논리 합성 결과

| 항목 | P4-C | P7-GE | 변화 |
|---|---:|---:|---:|
| 표준셀 수 | 308 | **236** | -23.38% |
| 셀 면적 | 8,568.807 µm² | **7,248.226 µm²** | -15.41% |
| 가장 긴 내부 계산 경로 | 2.990 ns | **2.508 ns** | -16.12% |
| 10 ns 목표에서 남은 시간 | +6.853 ns | **+7.268 ns** | +0.415 ns |
| 기본 활동률 전력 추정 | 1.165790 mW | **0.887720 mW** | -23.85% |

중재 상태를 10 bit에서 4 bit로 줄였고, 16개 요청을 고르는 회로도 작은 단계로 나뉘었다. 그 결과 플립플롭뿐 아니라 조합 셀과 가장 긴 계산 경로도 함께 감소했다.

### 7.2 배치·배선 결과

| 항목 | P4-C | P7-GE | 변화 |
|---|---:|---:|---:|
| 배치 후 셀 수 | 362 | **292** | -19.34% |
| 배치 후 셀 면적 | 9,353.837 µm² | **8,063.194 µm²** | -13.80% |
| setup 시간 여유 | +3.547 ns | **+4.350 ns** | +0.803 ns |
| hold 시간 여유 | +0.004 ns | **+0.006 ns** | +0.002 ns |
| 기본 활동률 전력 추정 | 0.960680 mW | **0.856192 mW** | -10.88% |
| DRC 오류 / 연결 오류 | 0 / 0 | **0 / 0** | 모두 통과 |

Reset은 비동기적으로 시작되지만 내부 회로에서는 clock에 맞춰 해제되도록 2단 reset synchronizer를 넣었다. 배치·배선 후 recovery 시간 여유는 +8.366 ns, removal 시간 여유는 +0.340 ns였다. RTL과 Genus netlist의 출력 21개와 상태점 75개, 총 96개 비교점도 모두 일치했다.

### 7.3 실제 Innovus 화면

아래 이미지는 발표용 예상도가 아니다. 최종 배치·배선 database를 Cadence Innovus에서 다시 열어 직접 출력한 화면이다. 가운데의 작은 사각형은 표준 논리 셀이고, 여러 색의 선은 전원망과 신호 배선이다.

![P7-GE TSMC 180 nm Innovus post-route 화면](docs/architecture/p7ge_180nm_innovus_postroute.png)

참고로 T0-PPA도 같은 180 nm 흐름으로 구현했다.

![T0-PPA TSMC 180 nm Innovus post-route 화면](docs/architecture/t0_paa_180nm_innovus_postroute.png)

T0-PPA는 100 cells, 1,397.088 µm², 0.03483881 mW로 훨씬 작다. 그러나 T0-PPA에는 2FF CDC, 16개 pending, 공정한 중재와 clock당 1-event 출력이 없다. 두 구조의 기능 범위와 시간 기준이 다르므로 숫자만 보고 같은 기능의 회로라고 해석해서는 안 된다.

## 8. 결과가 의미하는 것

P7-GE의 개선은 버스를 늘리거나 clock을 높여 얻은 것이 아니다. P4-C와 같은 4-bit 출력 버스 하나, 같은 16개 pending, 같은 registered output과 1 event/clock 최대 처리율을 유지한다. 다음 차례를 표현하는 방법과 후보를 찾는 회로만 바꿔 다음 효과를 얻었다.

- 모든 지속 요청에 처리 기회를 제공한다.
- 주소선의 불필요한 전환을 줄인다.
- 중재 상태와 조합 회로를 줄여 면적과 전력 추정치를 낮춘다.
- 가장 긴 계산 경로를 줄여 setup 여유를 늘린다.

더 빠른 출력도 실험했다. 중재 결과를 output register를 거치지 않고 바로 내보내는 P7-GE-FT는 수신기가 준비된 경우 latency를 1 clock 줄였다. 그러나 10 ns 조건에서 출력 timing slack이 -2.380 ns로 실패했다. 기능상 빠르더라도 물리 구현 조건을 만족하지 못했으므로 최종 설계에서 제외했다.

## 9. 적용 범위와 한계

- P7-GE는 먼저 도착한 이벤트를 항상 먼저 보내는 FCFS 구조가 아니다. 처리 순서가 중요한 후속 연산에는 timestamp 또는 순서 보존 구조가 추가로 필요하다.
- Source 하나의 `pending`에는 이벤트 하나만 저장된다. 같은 뉴런의 더 큰 burst를 흡수하려면 source-side accumulator나 추가 FIFO가 필요하다.
- Post-route 전력은 기본 신호 활동률을 사용한 도구 추정값이다. 실제 ECG 또는 SNN spike trace의 실측 energy/event가 아니다.
- 동일 입력 workload의 신호 전환을 기록한 VCD(Value Change Dump) 전력 보조 비교도 수행했다. 다만 합성 회로 신호 가운데 VCD 활동값이 연결된 비율(annotation coverage)이 두 설계에서 달라 sign-off 수치로 사용하지 않는다.
- 현재 완료 범위는 디지털 코어 RTL, 논리 합성, 배치·배선과 timing 분석이다. 패드 링, 패키지, 제조용 sign-off DRC/LVS, 실제 제작과 실리콘 측정은 포함하지 않는다.

## 10. 2차 설계과제에서의 재사용

P7-GE는 응용 계산을 포함하지 않은 독립 이벤트 전송 IP다. 2차 설계에서는 다음과 같이 전단부로 재사용할 수 있다.

```text
뉴런 또는 센서 이벤트
    → P7-GE가 수집·저장·중재
    → source ID + valid/ready 출력
    → 좌표 변환, N×M 메모리 또는 후속 연산
```

후속 블록은 원래 source ID를 그대로 받으므로 Gray decoder가 필요하지 않다. 현재 RTL은 16 sources, 4-bit 주소와 4단 선택 tree로 고정되어 있다. 다른 크기의 시스템에 사용하려면 source 수와 주소 폭을 parameter화하도록 RTL을 수정한 뒤 공정성, CDC와 PPA를 다시 검증해야 한다.

## 11. 주요 파일과 재현 방법

| 내용 | 경로 |
|---|---|
| 최종 P7-GE RTL | [rtl/improved/aer_pending_gray_epoch.sv](rtl/improved/aer_pending_gray_epoch.sv) |
| 전통적 baseline RTL | [rtl/traditional_async/aer_traditional_latch_paa.sv](rtl/traditional_async/aer_traditional_latch_paa.sv) |
| 대회용 상세 보고서 | [reports/AER_COMPETITION_REPORT_KR.md](reports/AER_COMPETITION_REPORT_KR.md) |
| P7-GE 검증 결과 | [results/P7_PENDING_GRAY_EPOCH_2026-08-20.md](results/P7_PENDING_GRAY_EPOCH_2026-08-20.md) |
| P7-GE 증거 manifest | [results/P7_PENDING_GRAY_EPOCH_MANIFEST_2026-08-20.md](results/P7_PENDING_GRAY_EPOCH_MANIFEST_2026-08-20.md) |
| 180 nm 결과 요약 | [reports/pending_gray_epoch/cadence/pnr_180nm/SUMMARY.txt](reports/pending_gray_epoch/cadence/pnr_180nm/SUMMARY.txt) |
| RTL 기능·공정성 실행 | [scripts/run_pending_gray_epoch_verification.ps1](scripts/run_pending_gray_epoch_verification.ps1) |
| 동일 workload 비교 | [scripts/run_aer_contract_fairness.ps1](scripts/run_aer_contract_fairness.ps1) |
| Cadence bundle과 실행 순서 | [scripts/cadence/P7GE_FLOW.md](scripts/cadence/P7GE_FLOW.md) |

README는 전체 설계의 흐름을 설명하고, `results/`와 `reports/`는 수치와 도구 출력의 근거를 보존한다. 결과를 인용할 때는 요약 수치뿐 아니라 해당 측정 조건과 한계를 함께 확인해야 한다.
