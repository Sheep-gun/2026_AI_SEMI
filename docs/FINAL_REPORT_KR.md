# T0 전통 AER와 P9 개선 AER 최종 기술 보고서

## 1. 이 설계가 해결하는 문제

입력은 16개 뉴런의 발화 신호다. 각 뉴런이 발화할 때 파형 전체를 보내는 것이
아니라 “몇 번 뉴런이 발화했는가”라는 주소만 전송한다. 이것이
AER(Address-Event Representation)이다.

16개 뉴런의 번호는 4 bit로 표현할 수 있다. 따라서 16개의 요청선을 하나의 4-bit
주소 버스로 모을 수 있다. 다만 여러 뉴런이 동시에 발화하면 한 번에 하나를
선택해야 하므로 중재기가 필요하다.

이 회로의 payload는 4-bit source 번호다. 발화 크기, 막전위, timestamp는 싣지
않는다. Timestamp는 이벤트가 발생한 시각을 나타내는 별도 정보이며 이 설계의
주소와 같은 값이 아니다.

## 2. 4-phase handshake

4-phase handshake는 clock 횟수를 세지 않고 REQ와 ACK의 상태 변화 네 단계로
이벤트 하나를 확실하게 주고받는 약속이다.

1. Source가 REQ를 1로 올린다.
2. Controller가 이벤트를 접수하고 ACK를 1로 올린다.
3. Source가 ACK를 확인한 뒤 REQ를 0으로 내린다.
4. Controller가 ACK를 0으로 내려 다음 이벤트를 받을 준비를 한다.

Source는 ACK가 올 때까지 REQ를 유지해야 한다. 짧은 pulse만 만들었다가 내리면
동기식 P9의 clock이 요청을 보지 못할 수 있다.

![4-phase handshake](figures/aer_4phase_handshake.svg)

## 3. 비교 기준 T0: 전통적 비동기 AER

T0에는 전체 동작을 지휘하는 공통 clock이 없다. REQ가 들어오면 조합논리가 가장
작은 source 번호를 선택하고, latch가 선택 주소와 busy 상태를 보관한다. 주소가
먼저 안정되고 aer_req가 나중에 올라가도록 특성화된 지연 셀을 둔다.

![T0 구조](figures/t0_structure.svg)

T0의 주요 특성은 다음과 같다.

- 16개 비동기 source
- 4-bit 공유 주소 버스 하나
- 고정 우선순위: source 0이 가장 높음
- source별 pending이나 FIFO 없음
- source 쪽과 receiver 쪽 모두 return-to-zero 4-phase handshake
- TLATX1 latch 5개와 DLY4X1 지연 셀 6개 사용
- MUTEX 없음

Latch 내부에는 서로의 출력을 다시 입력으로 사용하는 교차 결합 되먹임 회로가
있다. 한쪽이 1이 되면 다른 쪽을 0으로 밀고, 그 0이 다시 첫 번째 쪽의 1을
강화한다. 그래서 입력 조건이 끝난 뒤에도 0 또는 1을 기억한다.

T0가 작은 이유는 단순하기 때문이다. 그러나 그 단순함에는 다음 비용이 따른다.

- 낮은 번호가 반복 요청하면 높은 번호가 오래 기다릴 수 있다.
- 내부 대기칸이 없으므로 선택되지 않은 source가 REQ를 계속 유지해야 한다.
- Receiver가 멈추면 현재 transaction과 source도 함께 멈춘다.
- REQ와 ACK가 모두 0으로 돌아오는 빈 전송 구간이 필요하다. 이 빈 구간을
  bubble이라고 부를 수 있다.
- MUTEX가 없으므로 거의 동시에 도착한 요청의 transistor-level metastability
  안전성을 주장하지 않는다.

T0는 결함을 숨긴 최종 제품이 아니라, 전통 구조가 작동하는 방식과 개선 필요성을
측정하는 baseline이다.

## 4. P9 공통 기술 1: Source별 2FF 동기화

P9의 source REQ는 controller clock과 관계없는 순간에 변할 수 있다. REQ가
flip-flop의 clock edge와 거의 동시에 바뀌면 첫 번째 FF 내부의 두 node가 잠시
0과 1의 중간 전압에 머물 수 있다. 이것이 metastability다.

첫 번째 FF에 값이 저장됐다는 말은 출력이 즉시 완전한 0 또는 1이 됐다는 뜻이
아니다. 내부 되먹임은 미세한 전압 차이를 계속 확대하면서 결국 한쪽으로
안정시킨다. 문제는 안정되는 시간이 매번 같지 않다는 점이다.

P9는 요청마다 FF 두 개를 직렬로 둔다.

    비동기 REQ → FF1 → FF2 → controller logic

- FF1은 비동기 입력을 직접 받으므로 metastability가 생길 수 있다.
- FF1의 출력은 전체 회로가 아니라 FF2에만 연결한다.
- FF2는 다음 clock에서 FF1을 읽는다.
- FF1에는 거의 한 clock 동안 0 또는 1로 안정될 시간이 생긴다.

2FF는 metastability 확률을 수학적으로 0으로 만들지 않는다. 불안정 상태가 다음
clock까지 남아 전체 회로로 퍼질 확률을 현실적으로 매우 작게 만든다. 또한 source가
ACK까지 REQ를 유지하므로 첫 sampling이 애매해도 다음 clock에서 다시 1을 볼 수
있다.

16개 source에 FF가 두 개씩 필요하므로 이 부분만 32 FF다. 즉 2FF는 면적 절감
기술이 아니라 안전성을 위해 치르는 비용이다.

## 5. P9 공통 기술 2: Pending과 Early ACK

Pending은 쉽게 말해 source별 이벤트 보조 주머니다.

    pending[6] = 1
    → source 6의 이벤트 하나가 controller 안에서 기다리는 중

Bit 위치 자체가 source 번호이므로 pending마다 4-bit 주소를 따로 저장하지 않는다.
일반적인 16-entry 주소 FIFO가 주소만 64 bit와 pointer를 요구하는 것과 달리
source별 pending은 16 bit로 한 번씩의 대기 이벤트를 표현한다.

출력 register는 receiver 앞의 전송 쟁반이다. 현재 보낼 주소 4 bit와 valid 1 bit를
보관한다.

    pending 16개 + 출력 register 1개 = 최대 17개 이벤트 보관

P9는 이벤트가 pending이나 출력 register에 안전하게 기록되는 순간 source에 ACK를
보낸다. 이것이 Early ACK다. “Receiver가 이미 처리했다”는 뜻이 아니라
“Controller가 이벤트를 넘겨받아 잊지 않고 책임진다”는 뜻이다.

Receiver가 ready를 내리면 출력 주소와 valid는 그대로 멈춘다. 그동안 비어 있는
다른 pending에는 새 이벤트를 받을 수 있다. Receiver가 다시 준비되면 현재 출력을
소비하는 clock에 다음 pending을 채울 수 있으므로 backlog가 충분할 때 최대
1 event/clock을 유지한다.

같은 source의 pending에는 한 이벤트만 들어간다. 같은 뉴런이 ACK 왕복보다 빠르게
여러 번 발화하는 경우에는 source 쪽 accumulator나 별도 FIFO가 추가로 필요하다.

## 6. P9 공통 기술 3: 굶주림을 막는 Gray 순번

고정 우선순위 T0와 달리 P9는 우선순위를 계속 순환시킨다. 마지막으로 처리한
위치 다음부터 찾으므로 어떤 source가 계속 요청해도 다른 source의 차례가 돌아온다.
지속 요청은 receiver stall 시간을 제외한 최대 16번의 처리 결정 안에 선택된다.

P9가 사용하는 순번은 다음 Gray 관계를 따른다.

    0 → 1 → 3 → 2 → 6 → 7 → 5 → 4
      → 12 → 13 → 15 → 14 → 10 → 11 → 9 → 8 → 0

이웃한 두 번호는 한 bit만 다르다. 예를 들어 binary의 7→8은 0111→1000으로
네 bit가 바뀌지만 Gray 이웃은 한 bit만 바뀐다. 배선과 gate 입력은 bit가 전환될
때마다 충·방전되므로 전환 수를 줄이면 동적 전력을 줄일 가능성이 있다.

Gray 순번은 timestamp가 아니며 별도의 payload도 아니다. 어떤 source를 다음에
선호할지 정하는 내부 순서표다. 외부 receiver에는 원래 source 번호가 출력된다.

## 7. P9-GRR: 상태와 변환 회로를 줄이는 방법

GRR은 Gray-rank Register Reuse의 약자다.

![P9-GRR 구조](figures/p9_grr_structure.svg)

### 7.1 REQ·ACK·Pending을 같은 rank 순서로 배치

Source 6의 Gray rank가 4라면 REQ, ACK, Pending을 모두 4번 위치에 고정 배선한다.

    source 6 REQ     → req_rank[4]
    source 6 ACK     ← ack_rank[4]
    source 6 pending → pending_rank[4]

중재기가 rank 4를 선택하면 pending_rank[4]를 바로 지운다. 선택 rank를 다시
source 번호로 변환한 뒤 어떤 pending bit인지 재탐색할 필요가 없다. 순서 재배열은
설계할 때 정해진 배선이므로 추가 상태 register가 아니다.

### 7.2 출력 rank를 공정성 pointer로 재사용

out_rank는 현재 receiver에게 보여 줄 source와 다음 탐색 시작점을 동시에 나타낸다.

    현재 out_rank = 4
    → 외부 주소는 source 6
    → 다음 중재는 rank 5부터 시작

별도 output address 4 FF와 fairness epoch 4 FF를 따로 두는 대신 out_rank 4 FF
하나가 두 역할을 맡는다. 이 재사용으로 P9-OHT보다 상태를 4 FF 줄인다.

### 7.3 4×4 grouped selector

16개 요청을 네 개씩 네 group으로 나눈다. 현재 group에서 마지막 rank 뒤쪽을 먼저
확인하고, 없으면 다음 요청이 있는 group과 그 안의 첫 요청을 고른다. 16개를
일렬로 길게 훑는 회로보다 논리 깊이를 줄이면서 정확한 순환 순서를 유지한다.

GRR의 목적은 같은 P9 기능을 가장 작은 면적으로 구현하는 것이다.

## 8. P9-OHT: 면적을 더 써서 속도와 전력을 얻는 방법

OHT는 One-Hot Top-down Tree의 약자다.

![P9-OHT 구조](figures/p9_oht_structure.svg)

OHT는 16개 후보를 다음처럼 위에서 아래로 좁힌다.

    16 sources
      → 어느 half가 유효한가
      → 어느 quarter가 유효한가
      → 어느 pair가 유효한가
      → 어느 source인가

각 단계의 선택 결과를 one-hot 형태로 유지한다. One-hot은 선택된 위치 하나만 1이고
나머지는 0인 표현이다. 최종 one-hot 값이 곧 지워야 할 pending bit mask가 되므로
별도 동적 index clear 회로가 필요 없다.

OHT는 다음에 선호할 방향을 나타내는 Gray epoch 4 FF와 현재 출력 주소 4 FF를
따로 가진다. GRR보다 상태와 셀이 많아 면적은 커지지만 branch 판단을 병렬화해
critical path가 짧고 특정 workload에서 불필요한 switching이 적다.

동일 101-event 시험에서 주소 bit 전환은 GRR 114회, OHT 106회였다. 이것만으로
전체 전력 차이를 전부 설명할 수는 없지만 OHT의 낮은 활동 기반 전력과 방향이
일치한다.

## 9. 45nm PPA 결과

Power, Performance, Area를 묶어 PPA라고 한다.

- Area: 배치된 표준셀 면적
- Performance: 10 ns 목표에서 남은 timing 여유. 양수면 제약을 만족한다.
- Vectorless power: 실제 파형 없이 기본 전환율을 가정한 전력
- Mapped-SAIF power: 101-event 시험의 실제 신호 전환을 gate에 대응시켜 계산한 전력

| 항목 | T0 | P9-GRR | P9-OHT |
|---|---:|---:|---:|
| Instances | 92 | **263** | 278 |
| Cell area | 214.092 µm² | **669.294 µm²** | 709.308 µm² |
| Vectorless power | 0.002127 mW | 0.020641 mW | **0.019218 mW** |
| Mapped-SAIF power | 해당 없음 | 0.014382 mW | **0.013780 mW** |
| Core setup 여유 | clockless | +6.824 ns | **+7.555 ns** |
| Hold 여유 | 상대시간 검증 | +0.024 ns | +0.024 ns |
| DRC / connectivity | 0 / 0 | 0 / 0 | 0 / 0 |

T0와 P9는 기능이 다르므로 “P9가 T0보다 PPA가 나쁘다”라고 단순 결론 내리면 안
된다. T0의 숫자는 최소 전통 구조의 비용이고, P9의 추가 면적과 clock 전력은
안전한 clock-domain crossing, 17-event 저장, 공정성, stall 격리와 1 event/clock
처리 능력의 비용이다.

같은 기능인 GRR과 OHT는 직접 비교할 수 있다.

- OHT 면적: GRR보다 5.979% 큼
- OHT vectorless power: 6.892% 낮음
- OHT mapped-SAIF power: 4.189% 낮음
- OHT core setup 여유: 0.731 ns 큼

따라서 GRR은 면적 중심의 균형형 주 설계이고 OHT는 속도·전력 중심 대안이다.

## 10. 검증과 한계

- T0 RTL: 139개 이벤트 입력과 수신 일치, assertion error 0
- P9-GRR/OHT RTL: sparse, receiver stall, saturation, hotspot 101개 이벤트, error 0
- Conformal LEC: 세 RTL과 합성 netlist 등가
- Innovus: 세 설계 모두 route DRC 0, connectivity 0
- P9: setup, hold, recovery, removal 모두 양수

실제 post-route 배치와 배선은 다음 그림에 보존했다.

![T0 post-route](figures/t0_45nm_postroute.png)

![P9-GRR post-route](figures/p9_grr_45nm_postroute.png)

![P9-OHT post-route](figures/p9_oht_45nm_postroute.png)

그림은 Innovus가 출력한 최종 DEF의 실제 cell 중심과 routing 좌표를 렌더링한 것이다.
색은 발표 가독성을 위한 것이며 layer의 실제 공정 색을 뜻하지 않는다.

GPDK045는 generic 교육용 PDK다. 특정 파운드리 sign-off, transistor-level
metastability MTBF 또는 제작된 실리콘의 실측 전력을 주장하지 않는다.

## 11. 최종 판단

T0는 전통적 AER가 왜 작고 단순한지, 동시에 왜 starvation과 backpressure 문제가
생기는지 보여 주는 baseline으로 사용한다.

P9-GRR은 추가 기능을 가장 작은 면적으로 구현한 최종 주 설계다. P9-OHT는 동일
기능에서 면적을 조금 더 허용할 때 속도와 전력을 개선할 수 있음을 보여 주는
Pareto 대안이다. 대회 발표에서는 “T0를 단순히 작게 만든 것”이 아니라 “T0의
구조적 한계를 저장·동기화·공정 중재로 해결하고, 그 개선 구조 안에서 면적형과
속도·전력형 두 구현점을 찾아냈다”는 흐름으로 설명한다.
