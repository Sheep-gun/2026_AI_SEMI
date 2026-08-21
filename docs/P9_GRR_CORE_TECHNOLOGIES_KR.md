# P9-GRR 핵심 기술 설명

이 문서는 P9-GRR을 네 개의 독립 기술로 잘게 나누지 않는다. 실제 회로 기능을
기준으로 다음 세 축으로 설명한다.

1. **Source별 2FF 입력 동기화**: 비동기 요청이 내부 회로로 불안정하게 퍼질
   확률을 낮춘다.
2. **Pending 16개 + 출력 register 1개의 2단 elastic buffer**: 이벤트를
   controller 안에 보관하고 source와 receiver의 정체를 분리한다.
3. **Gray-rank strict-cyclic 중재 + 출력 rank pointer 재사용**: starvation을
   막고 주소 전환을 줄이며 별도의 공정성 상태를 없앤다.

출력 register는 독립적인 네 번째 기술이 아니다. 이벤트를 보관하는 역할은 두
번째 저장 구조에 포함되고, 저장된 rank를 다음 중재 위치로 재사용하는 역할은 세
번째 Gray-rank 중재에 포함된다.

이 문서에서 PPA는 power(전력), performance(처리율·timing), area(셀 면적)를
뜻한다.

## 1. T0와 P9-GRR의 전체 구조 차이

전통적 T0-PPA는 공통 clock 없이 source 요청과 receiver 응답이 한 transaction을
직접 진행한다. `relative timing`은 전역 clock 대신 request·ACK의 순서와 회로의
특성화된 지연 관계로 동작 안전성을 정하는 방식이다.

```text
T0-PPA

비동기 source REQ
    → fixed-priority 중재
    → grant/address latch
    → AER 주소 + request
    → receiver ACK
    → source ACK 반환
```

Source는 transaction이 끝날 때까지 REQ를 유지하고, 현재 선택 결과도 receiver가
응답할 때까지 유지된다. 이 구조에는 source별 대기칸이나 P9와 같은 clocked output
buffer가 없다.

P9-GRR은 source 쪽 4-phase 규약은 유지하지만 controller 안쪽을 세 단계로
분리한다.

```text
P9-GRR

비동기 source REQ
    → 2FF 동기화
    → source별 pending 보관
    → Gray-rank 공정 중재
    → registered valid/ready 출력
    → receiver
```

따라서 P9-GRR은 T0보다 무조건 작고 저전력인 회로가 아니다. 2FF, pending,
clocked output과 공정성 상태가 추가되므로 raw 면적과 clock 전력은 증가한다.
P9의 목표는 그 비용으로 다음 기능을 얻는 것이다.

- 비동기 요청을 일반적인 synchronous ASIC flow에서 처리
- 동시 발화와 receiver stall 중 이벤트 보관
- fixed priority starvation 제거
- receiver가 준비됐을 때 최대 1 event/clock 전송
- stall 중 주소와 valid를 register로 고정

## 2. 첫 번째 축: Source별 2FF 입력 동기화

### 2.1 왜 비동기 REQ를 바로 쓰면 안 되는가

Flip-flop은 clock edge에서 입력 전압을 저장한다. 입력이 clock보다 충분히 먼저
안정되면 내부의 교차 되먹임 회로가 확실한 0 또는 1을 만든다.

```text
정상적인 1 저장

Q     ≈ 전원 전압
Q-bar ≈ 0 V
```

그러나 source REQ가 controller clock edge와 거의 동시에 바뀌면 내부 두 node가
중간 전압에 가까운 상태로 되먹임을 시작할 수 있다.

```text
Q     ≈ 0.5 × 전원 전압
Q-bar ≈ 0.5 × 전원 전압
```

이것이 metastability다. 저장 동작 자체는 시작됐지만 저장된 아날로그 상태가 아직
유효한 0이나 1이 아니다. 실제 transistor의 미세한 차이와 잡음이 작은 전압 차이를
만들고, 양의 되먹임이 그 차이를 확대하면서 결국 한쪽으로 안정된다.

```text
0.501 / 0.499
    → 0.55 / 0.45
    → 0.9 / 0.1
    → 1 / 0
```

문제는 안정되는 시간이 매번 같지 않다는 것이다. 이 출력이 여러 상태 FF와
조합논리로 바로 퍼지면 어떤 회로는 0, 다른 회로는 1로 해석할 수 있다.

### 2.2 2FF가 하는 일

P9는 각 source REQ를 FF 두 개에 연속으로 통과시킨다.

```text
src_req_async[i] → FF1(req_meta[i]) → FF2(req_sync[i]) → controller
```

- FF1은 비동기 신호를 직접 받으므로 metastability에 빠질 수 있다.
- FF1의 출력은 controller 전체가 아니라 FF2 한 개에만 연결한다.
- FF2는 다음 clock edge에서 FF1을 읽는다.
- FF1에는 거의 한 clock 동안 0 또는 1로 안정될 시간이 생긴다.

예를 들어 clock 주기가 10 ns라면 다음과 같이 동작한다.

```text
0 ns     REQ와 clock edge가 겹쳐 FF1이 불안정할 수 있음
0~10 ns  FF1이 0 또는 1로 안정될 시간
10 ns    FF2가 안정된 FF1 출력을 저장
이후     controller는 FF2만 사용
```

Metastability가 다음 clock까지 남을 확률은 안정 시간을 늘릴수록 지수적으로
감소하지만 수학적으로 정확히 0이 되지는 않는다. 따라서 2FF는 metastability를
없애는 회로가 아니라, 불안정한 아날로그 상태가 controller로 퍼질 확률을 현실적인
수준으로 낮추는 회로다.

### 2.3 4-phase 요청 유지와 함께 써야 하는 이유

2FF는 너무 짧은 pulse를 놓칠 수 있다. P9에서는 source가 ACK를 받을 때까지
REQ를 유지한다.

```text
source: REQ↑
        ACK가 올 때까지 REQ=1 유지
controller: 여러 clock에 걸쳐 같은 1을 관찰
```

첫 sampling이 불확실하게 끝나더라도 다음 clock에는 REQ가 여전히 1이므로 다시
확인할 수 있다. 따라서 P9의 입력 안전성은 2FF와 REQ 유지 규약이 함께 만든다.

### 2.4 PPA 비용과 범위

16개 source마다 FF 두 개가 필요하므로 request synchronizer는 32 FF다.

```text
16 source × 2 FF = 32 FF
```

이는 PPA 절감 기술이 아니다. T0 대비 다음 비용을 지불한다.

- 32개 FF 면적
- 32개 clock pin의 clock-tree 부하
- 1~2 clock의 입력 관찰 지연

대신 비동기 중재를 직접 수행하지 않고 일반적인 synchronous STA·합성·배치 흐름을
사용할 수 있다. 또한 이 방법은 서로 독립적인 1-bit REQ에 적합하다. 여러 비트가
한 데이터로 동시에 넘어오는 bus를 bit별 2FF로 통과시키면 서로 다른 clock에
잡힐 수 있으므로 그대로 적용하면 안 된다.

## 3. 두 번째 축: Pending과 출력 register를 합친 2단 elastic buffer

쉽게 말하면 pending은 source별 이벤트 보조 주머니이고, 출력 register는 현재
receiver에게 넘길 이벤트를 올려놓는 전송 쟁반이다.

```text
pending 16개 = 대기실의 source별 주머니
출력 register 1개 = receiver 앞의 전송 쟁반
```

둘은 모두 이벤트를 보관하므로 하나의 2단 저장 구조로 묶는다.

여기서 `elastic`은 압축이라는 뜻이 아니다. 앞단 source나 뒷단 receiver 중 한쪽이
잠시 멈춰도 중간 저장칸이 시간 차이를 흡수해 양쪽이 즉시 함께 멈추지 않는다는
뜻이다.

```text
2FF → pending 16 → output register 1 → receiver
```

### 3.1 Pending이 저장하는 것

논리적으로는 source마다 한 bit가 있고, bit 위치 자체가 어떤 source의 이벤트인지
나타낸다.

```text
pending[source 3] = 1
→ source 3의 이벤트 하나가 controller 안에서 기다리는 중
```

실제 P9-GRR RTL에서는 이 16개 위치를 Gray rank 순서로 재배열한다. 예를 들어
source 6은 `pending_rank[4]`에 연결된다. 그래도 각 위치와 source의 관계가 설계
시 고정돼 있으므로 pending마다 별도의 4-bit 주소 payload를 저장하지 않는다는
점은 같다.

일반적인 16-entry FIFO라면 각 칸에 4-bit source ID와 read/write pointer를
저장해야 한다. Source별 pending은 위치가 주소이므로 이벤트 주소 저장만 보면
16 bit면 된다.

```text
source별 pending: 16 bit
16-entry 주소 FIFO: 주소만 최소 16 × 4 = 64 bit + pointer/control
```

대신 한 source의 pending 주머니에는 이벤트 하나만 들어간다.

### 3.2 새 요청을 한 번만 접수하는 조건

논리적인 source `i`의 새 이벤트를 받을 조건은 다음과 같다. P9-GRR 내부에서는
같은 식을 고정 매핑된 rank `i` 위치에 적용한다.

```text
accept[i]
= req_sync[i]
  AND NOT ack[i]
  AND NOT pending[i]
```

- `req_sync=1`: 동기화된 요청이 들어왔다.
- `ack=0`: 현재 REQ-high 구간을 아직 접수하지 않았다.
- `pending=0`: 해당 source의 대기 주머니가 비어 있다.

한 번 접수하면 ACK가 1이 되므로 source가 REQ를 계속 유지해도 같은 요청을 매
clock 중복 저장하지 않는다.

ACK의 다음 상태는 다음 의미를 가진다.

```text
ack_next[i] = (ack[i] AND req_sync[i]) OR accept[i]
```

- `accept=1`이면 새 요청을 접수하며 ACK를 올린다.
- Source가 REQ를 유지하는 동안 기존 ACK를 유지한다.
- 동기화된 REQ가 0이 되면 ACK를 내린다.

ACK와 pending은 같은 bit로 합칠 수 없다. 한 source에는 다음 네 상태가 실제로
모두 필요하다.

| ACK | Pending | 의미 |
|---:|---:|---|
| 0 | 0 | 새 요청과 대기 이벤트가 없음 |
| 1 | 1 | 요청을 접수했고 이벤트가 pending에서 대기; source는 아직 REQ 유지 |
| 0 | 1 | Source handshake는 끝났지만 이벤트는 아직 pending에서 대기 |
| 1 | 0 | 이벤트는 output으로 이동했지만 source가 아직 REQ를 내리지 않음 |

따라서 ACK는 현재 4-phase 요청의 접수 상태이고, pending은 실제 이벤트가 아직
output으로 이동하지 않았다는 저장 상태다.

### 3.3 Early ACK의 정확한 의미

T0의 source ACK는 현재 비동기 link transaction의 receiver 응답과 직접 연결된다.
P9의 ACK는 이벤트가 pending 또는 출력 register에 안전하게 들어간 순간 올라간다.

```text
T0
receiver가 현재 주소 transaction을 완료
    → source ACK

P9
controller가 이벤트 소유권을 pending/output에 기록
    → source ACK
    → 실제 receiver 전송은 나중에 가능
```

따라서 P9의 ACK는 “receiver가 이미 소비했다”가 아니라 “controller가 이 이벤트를
잊지 않고 책임진다”는 뜻이다.

Source는 ACK를 확인한 뒤 REQ를 내리고, 동기화된 REQ-low가 들어오면 controller도
ACK를 내린다.

```text
REQ↑ → ACK↑ → REQ↓ → ACK↓
```

Source handshake가 끝난 뒤에도 이벤트는 pending에서 기다릴 수 있다.

```text
REQ=0, ACK=0, pending=1
→ source와의 handshake는 끝났지만 이벤트는 아직 내부 대기 중
```

### 3.4 출력이 비어 있으면 바로 이동하는 cut-through

새 요청이 들어왔고 출력 register가 비어 있으면 pending에 한 clock 머물 필요가
없다. P9는 새 accept 결과를 같은 중재 후보에 포함한다.

```text
출력이 비어 있음:
REQ → accept → 같은 다음 clock edge에서 output register

출력이 막혀 있음:
REQ → accept → pending에 저장
```

어느 경우든 이벤트가 controller 상태에 표현된 뒤에만 ACK가 올라간다.

### 3.5 출력 register와 valid/ready

출력 register는 4-bit rank와 1-bit valid를 저장한다.

```text
out_rank  4 FF
out_valid 1 FF
```

실제 전송은 `out_valid=1`과 `out_ready=1`이 같은 clock edge에 만날 때 일어난다.

| Valid | Ready | 동작 |
|---:|---:|---|
| 0 | 0 또는 1 | 출력 이벤트 없음 |
| 1 | 0 | receiver가 멈춤; 주소와 valid 유지 |
| 1 | 1 | 이벤트 한 개 전송 완료 |

Receiver가 100 clock 동안 멈추면 출력 register는 같은 이벤트를 100 clock 동안
유지한다. 그동안 비어 있는 pending 주머니에는 다른 source의 이벤트를 받을 수
있다.

```text
output register: source 6 이벤트 유지
pending: source 1, 3, 8 이벤트 추가 보관
```

Receiver가 다시 준비되면 현재 출력을 소비하는 같은 edge에 다음 pending 이벤트를
채울 수 있어 full backlog에서 빈 clock 없이 최대 1 event/clock을 유지한다.

### 3.6 왜 최대 17개인가

```text
pending 16개
+ output register 1개
= controller가 접수했지만 아직 receiver가 소비하지 않은 이벤트 최대 17개
```

같은 source의 이전 이벤트가 출력 register에 있고 다음 이벤트가 그 source의
pending에 있을 수도 있다. 그러나 같은 source pending에는 한 개만 저장되므로 더
긴 burst에는 source-side accumulator나 별도 FIFO가 필요하다.

### 3.7 T0 대비 얻는 것과 지불하는 것

T0는 source REQ와 grant latch를 현재 transaction이 끝날 때까지 유지한다. 별도의
source별 pending과 clocked output buffer가 없으므로 receiver stall이 현재 source와
중재에 직접 전파된다.

P9의 2단 buffer는 다음을 얻는다.

- receiver stall을 pending 여유만큼 흡수
- source ACK를 receiver 소비보다 먼저 반환
- 여러 source의 동시 발화를 내부에 보관
- stall 중 registered output 주소 고정
- receiver가 준비됐을 때 최대 1 event/clock

대신 pending 16 FF, ACK 16 FF, output 5 FF와 관련 clock/control 비용을 지불한다.
따라서 이 구조도 T0 대비 순수한 PPA 절감 기술은 아니다. 필요한 기능을 bit-per-
source 저장 방식으로 비교적 작게 구현한 것이다.

## 4. 세 번째 축: Gray-rank strict-cyclic 중재와 출력 rank 재사용

### 4.1 Gray 순서는 주소 전환을 줄이는 순서표

일반 binary 순서에서는 7에서 8로 바뀔 때 4 bit가 모두 전환된다.

```text
7 = 0111
8 = 1000
```

Gray 순서에서는 이웃한 source ID가 한 bit만 다르도록 순서를 정한다.

```text
0 → 1 → 3 → 2 → 6 → 7 → 5 → 4
→ 12 → 13 → 15 → 14 → 10 → 11 → 9 → 8 → 0
```

배선과 gate 입력에는 capacitance가 있으므로 bit가 바뀔 때마다 충·방전 에너지가
필요하다.

```text
동적 전력 ≈ 전환 활동률 × capacitance × 전압² × 주파수
```

16개 source를 이웃 순서대로 한 바퀴 처리하면 binary 순서는 약 30 bit 전환,
Gray 순서는 16 bit 전환이다. 단, sparse traffic에서 중간 rank를 건너뛰면 여러
bit가 바뀔 수 있으므로 절감량은 workload에 따라 달라진다.

### 4.2 Gray code를 payload로 보내는 것이 아니다

P9는 실제 source ID에 Gray 순서의 내부 rank를 붙인다.

| 내부 rank | 실제 source ID |
|---:|---:|
| 0 | 0 |
| 1 | 1 |
| 2 | 3 |
| 3 | 2 |
| 4 | 6 |
| 5 | 7 |

Source 6은 내부 rank 4다. P9는 `out_rank=4`를 저장하고 외부에는 다음 식으로
원래 source ID 6을 제시한다.

```text
out_addr = out_rank XOR (out_rank >> 1)
Gray(4) = 6
```

Receiver는 원래 source ID를 받으므로 별도 Gray decoder가 필요 없다.

### 4.3 REQ·ACK·pending을 rank 위치에 고정 배선한다

Source 6 요청은 내부 rank 4 위치에 연결된다.

```text
req_rank[4] = req_sync[source 6]
src_ack[source 6] = ack_rank[4]
```

이 permutation은 매 cycle 계산하는 encoder가 아니라 합성 시 정해지는 wire 연결이다.
실제 wire capacitance와 routing은 존재하지만 변환 standard cell은 필요하지 않다.

중재기가 rank 4를 선택하면 같은 위치의 pending을 바로 지운다.

```text
selected_rank = 4
→ pending_rank[4] = 0
```

Source 번호 기준 저장을 유지했다면 selected rank를 실제 source ID로 바꾼 뒤
해당 source pending을 지워야 한다. Rank-indexed 저장은 그 변환을 pending
feedback 경로에서 제거한다.

### 4.4 T0 fixed priority를 strict cyclic으로 바꾼다

T0는 요청이 동시에 있으면 고정 우선순위에 따라 낮은 우선순위 source를 계속
뒤로 미룰 수 있다. 마지막 처리 위치를 기억하지 않으므로 starvation 상한이 없다.

P9는 마지막 rank 바로 다음부터 원형으로 pending을 찾는다.

```text
마지막 rank 4 처리
→ 5, 6, 7, ... 15, 0, 1, ... 4 순서로 첫 pending 선택
```

계속 pending인 source는 최대 15개의 다른 성공적인 service decision 뒤, 16번째
이내에 반드시 선택된다. 이것은 16 clock 보장이 아니다. Receiver가 `ready=0`으로
멈춰 실제 전송·교체가 진행되지 않는 시간은 service decision 횟수에 포함되지
않는다. 또한 실제 발화 시간순서를 보존하는 FCFS도 아니다.

### 4.5 출력 register를 별도 기술로 세지 않는 이유

출력 register의 첫 번째 역할은 이벤트를 receiver 앞에 보관하는 것이다. 이 역할은
두 번째 elastic buffer 축에 포함된다.

P9-GRR은 같은 `out_rank`를 마지막 처리 위치로도 사용한다.

```text
out_rank
├─ 현재 출력 source ID를 만드는 저장 상태
└─ 다음 strict-cyclic 탐색의 last-rank pointer
```

예를 들어 source 6을 출력 중이면 `out_rank=4`다.

```text
현재 출력: Gray(4) = source 6
다음 탐색: rank 5부터 시작
```

Receiver stall 중에는 out_rank를 유지하므로 주소도 안정되고 pointer도 움직이지
않는다. 모든 이벤트를 처리해 `out_valid=0`이 돼도 out_rank는 마지막 값을
보존한다. 외부에서는 valid가 0이라 주소를 무시하고, 내부에서는 다음 공정성 탐색의
책갈피로 사용한다.

Reset 때 out_rank를 15로 두면 첫 탐색은 15 다음인 rank 0부터 시작한다.

### 4.6 PPA에서 무엇을 얻고 무엇을 지불하는가

Gray 자체는 면적 절감 기술이 아니다. 4-bit rank를 Gray source ID로 바꾸려면 XOR
gate 약 3개가 필요하다. Strict-cyclic selector도 T0의 fixed-priority selector보다
복잡하다.

대신 P9는 출력 rank를 pointer로 재사용해 별도의 4-bit 공정성 register를 두지
않는다. 4 FF가 줄면 FF cell 면적, clock pin 부하, 관련 next-state 배선이 줄어든다.

내부 `out_rank` 자체는 binary rank이므로 rank 7에서 8로 갈 때 여러 data bit가
동시에 바뀔 수 있다.

```text
out_rank: 0111 → 1000   4 bit 전환 가능
out_addr: Gray(7) → Gray(8)   이웃 순서에서는 1 bit 전환
```

따라서 “모든 내부 FF가 항상 1 bit만 바뀐다”는 뜻이 아니다. Gray의 직접적인
전환 이점은 외부 주소와 그 후단 배선에 나타나고, 내부 PPA 이점은 별도 pointer
FF 제거와 rank-indexed feedback 단순화까지 합쳐서 평가해야 한다.

```text
제거: 별도 공정성 상태 4 FF와 일부 feedback 변환
추가: Gray 출력 XOR와 strict-cyclic selector
```

따라서 최종 손익은 합성·배치 후 판단해야 한다. P9-GRR의 최종 FPR 180 nm
결과는 281 instances, 6,988.766 µm², vectorless 0.77624020 mW,
mapped-SAIF 0.57886987 mW, core setup slack +4.810 ns였다. 이 수치는 공식 PDK
sign-off가 아니라 현재 reference 환경의 비교값이다.

## 5. 세 기술이 한 이벤트를 처리하는 전체 순서

Source 6이 발화하고 receiver가 잠시 멈춘 상황을 한 번에 보면 다음과 같다.

```text
1. source 6이 REQ를 올리고 ACK까지 유지
2. FF1이 요청을 받고 FF2가 다음 clock에 안정된 값을 전달
3. source 6에 해당하는 rank 4의 pending 주머니가 비었는지 확인
4. 이벤트를 pending_rank[4] 또는 비어 있는 output register에 접수
5. 접수 사실이 state에 기록된 뒤 source 6에 early ACK
6. receiver가 막혀 있으면 output register는 현재 주소를 유지하고 pending은 대기
7. strict-cyclic 중재기가 마지막 out_rank 다음부터 첫 pending rank를 선택
8. rank 4를 출력하면 out_addr=Gray(4)=source ID 6
9. valid와 ready가 함께 1인 clock edge에서 receiver가 이벤트 소비
10. 같은 out_rank는 다음 탐색의 last-rank pointer로 재사용
```

## 6. T0 대비 최종 정리

| 항목 | 전통 T0-PPA | P9-GRR |
|---|---|---|
| 비동기 요청 처리 | 비동기 중재·relative timing | Source별 2FF 뒤 synchronous core |
| 이벤트 대기 공간 | Source별 pending 없음 | Pending 16 + output 1, 최대 17 |
| Source ACK | Receiver transaction과 직접 연결 | Controller 내부 접수 뒤 early ACK |
| 중재 | Fixed priority | Gray-rank strict cyclic |
| Starvation 상한 | 없음 | Stall 제외 최대 16 service decisions |
| Receiver 정체 | 현재 link와 source에 직접 전파 | Output이 유지되고 빈 pending까지 흡수 |
| 출력 안정 | REQ/grant latch와 handshake 유지 | Clocked output register |
| 최대 후단 처리율 | 4-phase transaction 간격 | Full backlog에서 1 event/clock |
| PPA 성격 | 기능이 적어 매우 작음 | 안정성·저장·공정성을 위해 더 큰 비용 |

P9-GRR은 T0보다 모든 PPA 수치가 무조건 작아진 구조가 아니다. T0에 없던 안전성,
저장 능력, 공정성과 동기식 후단 처리율을 추가한 뒤, Gray-rank 배열과 출력 rank
재사용으로 그 추가 비용을 줄인 구조다.

## 7. 적용 조건과 남은 한계

- Source는 ACK를 받을 때까지 REQ를 유지해야 한다.
- 한 source pending에는 이벤트 한 개만 들어간다.
- 같은 source의 더 긴 burst에는 source-side accumulator나 FIFO가 필요하다.
- Strict cyclic은 starvation을 막지만 실제 도착 순서를 보존하는 FCFS가 아니다.
- Timestamp를 전송하지 않으므로 발화 시각 차이는 복원할 수 없다.
- 2FF CDC 시험은 디지털 phase sweep이며 실리콘 MTBF sign-off가 아니다.
- Mapped-SAIF 전력은 한 101-event workload의 도구 추정이며 실제 ECG traffic이나
  silicon 측정값이 아니다.
- 현재 RTL은 16 source와 4-bit 주소에 고정돼 있어 규모를 바꾸면 다시 검증해야
  한다.
