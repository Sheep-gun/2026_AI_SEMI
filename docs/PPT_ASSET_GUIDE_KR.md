# 최종 PPT 제작 안내

이 문서는 문장을 짧게 줄이는 요약본이 아니다. 각 슬라이드에서 청중이 가져야 할
질문, 회로가 실제로 하는 일, 제시할 수치, 사용할 그림과 주장의 한계를 함께
제시한다. 비교 대상은 T0, P9-GRR, P9-OHT 세 개다.

## 전체 발표의 한 문장

> 전통적 AER T0의 fixed priority, event 보관 부재, receiver backpressure와
> 비동기 입력 경계를 분석하고, 이를 2FF·Pending·Early ACK·Gray 공정 중재로
> 해결한 P9를 면적형 GRR과 속도·전력형 OHT로 구현해 GPDK45 post-route까지
> 검증하였다.

## 1장 — 작품의 목표

### 청중이 이해해야 할 질문

여러 뉴런이 서로 다른 순간에 발화할 때, 배선을 과도하게 늘리지 않고 어느
뉴런이 발화했는지 어떻게 전달할 것인가?

### 본문 설명

16개 뉴런이 각각 전용 주소 버스를 가지면 같은 배선이 16번 반복된다. 본 작품은
각 뉴런의 요청은 개별 선으로 받되, 실제로 전달하는 event 정보는 발화한 source
번호 하나로 만든다. Source 0~15는 4 bit로 표현할 수 있으므로 공용 주소 버스는
하나면 된다.

### 제시할 수치

- 16 asynchronous sources
- 4-bit source address
- 공유 주소 버스 1개
- 최종 비교군 3개

### 사용할 그림

[AER 필요성 및 source 6 예](figures/aer_concept.svg)

### 발표 문장

> 이 회로는 뉴런 계산기가 아니라 여러 뉴런의 발화 알림을 하나의 주소 버스로
> 모아 전달하는 event 통신 controller입니다.

## 2장 — AER이 정확히 무엇인가

### 청중이 이해해야 할 질문

뉴런의 무엇을 event로 전송하는가?

### 본문 설명

AER(Address-Event Representation)은 파형 전체나 막전위 값을 보내지 않고
발화한 뉴런의 번호를 보낸다. Source 6이 발화하면 controller는 주소 0110을
출력하고 receiver는 6번 뉴런 event로 해석한다.

Timestamp는 event 발생 시각을 나타내는 별도 정보다. 이 RTL에는 timestamp가
없으므로 실제 arrival-time FCFS 순서를 복원하지 않는다. Gray rank도 timestamp나
payload가 아니라 내부 우선순위 순서표다.

### 제시할 예

    source 6 발화 → src_req[6]=1 → out_addr=4'b0110

### 사용할 그림

[AER 개념도](figures/aer_concept.svg)의 오른쪽 source 6 흐름

### 주의할 표현

- “Gray code를 payload에 싣는다”라고 말하지 않는다.
- “발화 시각을 전달한다”라고 말하지 않는다.

## 3장 — 4-phase handshake

### 청중이 이해해야 할 질문

공통 clock이 없는 T0는 상대가 event를 받았다는 것을 어떻게 판단하는가?

### 본문 설명

REQ↑ → ACK↑ → REQ↓ → ACK↓의 네 상태 변화로 transaction 하나를 끝낸다.
Source는 ACK가 올 때까지 REQ를 유지한다. REQ와 ACK가 모두 0으로 돌아가야
다음 event를 시작할 수 있으므로 return-to-zero 과정에 빈 전송 구간이 생긴다.

### 설명 순서

1. Source가 REQ를 올린다.
2. 주소가 선택되고 receiver 요청이 올라간다.
3. Receiver가 주소를 읽고 ACK한다.
4. Source와 receiver가 REQ·ACK를 순서대로 내린다.

### 사용할 그림

[4-phase handshake](figures/aer_4phase_handshake.svg)

### 이어서 설명할 차이

T0 source ACK는 receiver 완료 뒤 발생한다. P9 Early ACK는 내부 buffer에 event
소유권을 기록한 뒤 발생한다. 이 차이는 7장에서 stall timeline으로 다시 설명한다.

## 4장 — T0 전통적 AER의 실제 회로

### 청중이 이해해야 할 질문

Clock 없이 16개 요청 중 하나를 어떻게 선택하고 주소를 유지하는가?

### 본문 설명

T0의 combinational fixed-priority encoder는 stable request 중 가장 작은 번호를
고른다. Grant 4 bit와 busy 1 bit는 TLATX1 latch 5개에 저장한다. 주소가 먼저
안정되고 aer_req가 나중에 올라가도록 DLY4X1 delay cell 6개를 실제 netlist에
보존한다.

    src_req
      → fixed priority
      → grant latch
      → address stable
      → delay chain
      → aer_req
      → receiver aer_ack
      → selected source src_ack

### 제시할 수치

- TLATX1 5개
- DLY4X1 6개
- Pending 0개
- Fixed priority
- MUTEX 없음

### 사용할 그림

[T0 구조](figures/t0_structure.svg)

### 전문성 경계

일반적인 latch의 저장 원리는 교차 결합 되먹임으로 설명할 수 있지만, 공개
Liberty/RTL만으로 TLATX1의 내부 transistor topology를 확인했다고 주장하지
않는다.

Delay chain은 clock의 대체물이 아니라 주소가 request보다 먼저 안정되도록 하는
bundled-data relative-timing assumption을 구현한다.

## 5장 — T0가 작은 이유와 그 대가

### 청중이 이해해야 할 질문

T0가 가장 작고 전력이 낮은데 왜 개선해야 하는가?

### 본문 설명

T0에는 2FF, Pending, 공정성 pointer와 clocked output이 없다. 그래서 회로가
작지만 다음 기능도 없다.

1. Source 0이 계속 요청하면 source 15가 굶을 수 있다.
2. 내부 대기칸이 없어 receiver stall이 source까지 전파된다.
3. 매 transaction마다 return-to-zero bubble이 필요하다.
4. MUTEX가 없어 near-simultaneous request의 analog metastability 안전성을
   주장하지 않는다.

### 제시할 수치

- RTL 139/139 events, assertion error 0
- Post-route 92 instances
- Cell area 214.092 µm²
- Vectorless power 0.002127 mW
- DRC/connectivity 0/0

### 해석

이 수치는 최소 baseline의 비용이다. P9와 같은 기능을 더 작은 PPA로 제공했다는
뜻이 아니다.

### timing 주의

T0는 선택한 5 ns I/O max-delay에서 +4.126 ns를 만족했지만 내부 latch path 일부는
unconstrained다. 완전한 asynchronous bundled-data sign-off라고 표현하지 않는다.

## 6장 — P9 하이브리드 구조와 2FF

### 청중이 이해해야 할 질문

Clock과 무관하게 들어오는 뉴런 발화를 동기식 core가 어떻게 받아들이는가?

### 본문 설명

P9의 source 측은 level-held 4-phase protocol이고 내부와 receiver는 10 ns clock의
valid/ready protocol이다. 각 REQ는 FF1과 FF2를 차례로 통과한다.

FF1은 clock edge와 겹친 입력 때문에 metastable해질 수 있다. FF2는 다음 clock에
FF1을 다시 읽으므로 FF1이 0 또는 1로 안정될 시간을 확보한다. 2FF는 확률을
0으로 만들지 않으며, Source가 ACK까지 REQ를 유지해야 짧은 pulse가 사라지지
않는다.

### 제시할 수치

- 16 sources × 2FF = 32 FF
- Clock 10 ns = 100 MHz
- Reset release 2 FF

### 사용할 그림

[비동기-동기 경계](figures/p9_hybrid_boundary.svg)

### 주의할 표현

- P9를 완전 비동기라고 하지 않는다.
- 2FF가 metastability를 제거한다고 하지 않는다.
- 다중 bit bus를 각각 2FF에 넣는 일반 기술로 확대하지 않는다.

## 7장 — Pending, Early ACK와 Output Register

### 청중이 이해해야 할 질문

Receiver가 멈춰도 source를 먼저 풀어주고 event를 잃지 않을 수 있는가?

### 본문 설명

Pending은 source마다 하나씩 둔 event 보조 주머니다. pending[6]=1은 source 6
event를 controller가 책임지고 보관한다는 뜻이다.

    accept = req_sync AND NOT ack AND NOT pending
    ack_next = (ack AND req_sync) OR accept

Accept가 발생하면 같은 REQ-high 구간을 중복 저장하지 않도록 ACK를 유지한다.
Output이 비어 있으면 event를 바로 output register로 보내고, 막혀 있으면
Pending에 남긴다.

Early ACK는 receiver 완료가 아니라 controller 내부 소유권 기록을 뜻한다.

### 제시할 수치

- Pending 16 + Output 1 = 최대 17 events
- Source별 Pending은 1개
- Stall phase에서 receiver 소비 전 ACK 5개 관찰
- Full backlog에서 최대 1 event/clock

### 사용할 그림

[T0와 P9 stall timeline](figures/t0_p9_stall_timeline.svg)

### 추가 설명

같은 source의 이전 event가 output에 있고 다음 event 하나가 Pending에 있을 수
있다. 그보다 긴 동일-source burst에는 accumulator나 FIFO가 필요하다.

## 8장 — Gray 공정성과 GRR

### 청중이 이해해야 할 질문

어떻게 starvation을 막고, 그 공정성 상태의 면적까지 줄였는가?

### 본문 설명

GRR은 마지막으로 처리한 rank 다음부터 strict cyclic으로 탐색한다. 지속 Pending은
receiver stall을 제외한 최대 16번의 service 안에 선택된다.

Source 6은 Gray rank 4다.

    req_rank[4] ↔ ack_rank[4] ↔ pending_rank[4]

Rank 4가 선택되면 같은 pending_rank[4]를 바로 지운다. Out_rank 4 FF는 외부
주소 6을 만드는 동시에 다음 탐색을 rank 5부터 시작하게 하는 pointer다.

16개 rank는 4개씩 네 group으로 나눠 현재 group tail과 다음 non-empty group을
병렬로 찾는다.

### 상태 수치

    공통 67 + out_rank 4 = 71 states

### 사용할 그림

- [GRR 구조](figures/p9_grr_structure.svg)
- [Rank 매핑과 상태 구성](figures/p9_state_and_rank.svg)

### Gray 설명의 범위

Full backlog에서 이웃 rank의 외부 주소는 한 bit만 바뀐다. Sparse traffic에서는
rank를 건너뛰므로 여러 bit가 바뀔 수 있고, 내부 out_rank도 binary라 여러 bit가
바뀔 수 있다. GRR 면적 이점은 Gray 자체보다 rank-indexed feedback과 register
reuse에서 나온다.

## 9장 — OHT의 one-hot tree

### 청중이 이해해야 할 질문

왜 상태와 면적을 더 쓰면 timing과 전력을 줄일 수 있는가?

### 본문 설명

OHT는 16개 후보를 half→quarter→pair→source의 top-down tree에서 병렬로 좁힌다.
최종 one-hot vector는 선택 주소와 pending clear mask로 동시에 사용한다.

OHT는 별도 Gray epoch 4 FF와 output address 4 FF를 가진다.

    공통 67 + epoch 4 + output address 4 = 75 states

Epoch는 방금 선택한 source 다음을 가리키는 pointer가 아니다. Successful grant마다
Gray schedule을 한 step 전진시키고 각 tree level의 선호 branch를 정한다.
따라서 GRR과 같은 exact sparse output order는 아니지만 같은 ≤16 successful-grant
starvation bound를 가진다.

### 제시할 수치

- 278 instances
- 709.308 µm²
- Mapped-SAIF 0.013780 mW
- Core arrival 2.159 ns, slack +7.555 ns
- GRR 대비 area +5.979%, SAIF −4.189%, core arrival −23.1%

### 전력 원인

OHT의 sequential total은 4 FF 비용 때문에 증가한다. 반면 combinational total은
약 45.3%, 전체 switching component는 약 37.2% 줄어 총전력이 낮아졌다.

### 사용할 그림

- [OHT 구조](figures/p9_oht_structure.svg)
- [상태 구성](figures/p9_state_and_rank.svg)

## 10장 — 기능 검증과 ASIC 흐름

### 청중이 이해해야 할 질문

RTL이 맞다는 것과 배치·배선 후 구현 가능하다는 것을 어떻게 확인했는가?

### 검증 흐름

RTL simulation → Genus 합성 → VCD/SAIF activity mapping → Conformal LEC →
Innovus placement/routing → post-route timing/power/DRC/connectivity

### 제시할 수치

| 설계 | 기능 시험 | LEC | 물리 검사 |
|---|---|---|---|
| T0 | 139 events, error 0 | 21 output + 5 state | DRC/conn 0/0 |
| P9-GRR | 101 events, error 0 | 21 output + 71 state | Setup/hold 양수, DRC/conn 0/0 |
| P9-OHT | 101 events, error 0 | 21 output + 75 state | Setup/hold 양수, DRC/conn 0/0 |

P9 101 events는 sparse 16 + stall 8 + saturation 64 + hotspot 13이다. Saturation
64개는 630 ns output span으로 63×10 ns 간격에 해당한다.

### 사용할 그림

[검증 흐름](figures/verification_flow.svg)

### 검증 범위

- LEC는 RTL과 Genus mapped netlist 비교
- DRC/connectivity는 routing DB 검사
- LVS, IR drop, EM, antenna와 silicon measurement는 미수행

## 11장 — 동일 기능 PPA Pareto

### 청중이 이해해야 할 질문

GRR과 OHT 중 어떤 설계를 선택해야 하는가?

### 직접 비교

| 항목 | P9-GRR | P9-OHT | OHT 변화 |
|---|---:|---:|---:|
| Cell area | 669.294 µm² | 709.308 µm² | +5.979% |
| Vectorless | 0.020641 mW | 0.019218 mW | −6.892% |
| Mapped-SAIF | 0.014382 mW | 0.013780 mW | −4.189% |
| Core arrival | 2.807 ns | 2.159 ns | −23.1% |
| Core slack | +6.824 ns | +7.555 ns | +0.731 ns |

둘 다 10 ns clock에서 최대 1 event/clock이다. OHT의 timing 이점은 더 큰
frequency headroom이며 별도 Fmax sweep을 했다는 뜻은 아니다.

### 사용할 그림

[GRR/OHT Pareto 비교](figures/p9_pareto_comparison.svg)

### 최종 선택

- 최소 면적과 균형: P9-GRR 주 설계
- 속도·전력 우선: P9-OHT Pareto 대안

## 12장 — 물리설계와 최종 결론

### 사용할 그림

- [T0 DEF 기반 post-route](figures/t0_45nm_postroute.png)
- [P9-GRR DEF 기반 post-route](figures/p9_grr_45nm_postroute.png)
- [P9-OHT DEF 기반 post-route](figures/p9_oht_45nm_postroute.png)
- [동일 축척 die 크기 비교](figures/layout_scale_comparison.svg)

세 이미지는 Innovus GUI screenshot이 아니라 Innovus post-route DEF의 실제 cell
중심과 routing 좌표를 재렌더링한 시각화라고 표시한다.

### 결론 문장

> T0는 작은 clockless baseline이지만 starvation, event 보관 부재, receiver
> backpressure와 경합 안전성 한계가 남습니다. P9는 2FF, Pending, Early ACK,
> registered output과 Gray 공정 중재로 이를 해결했습니다. 동일 기능 안에서
> GRR은 면적형 주 설계, OHT는 속도·전력형 대안입니다.

### 공정 조건

- Generic GPDK045/GSCLIB045
- Setup slow 0.9 V, 125℃
- Hold fast 1.1 V, 0℃
- P9 clock 10 ns
- Density 60%
- Signal Metal1~Metal9

### 최종 한계

- Generic PDK 비교이며 foundry sign-off가 아님
- T0 내부 async path 일부 unconstrained
- 2FF MTBF와 T0 near-simultaneous arbitration의 transistor-level 실측 없음
- Mapped-SAIF는 101-event activity 기반 도구 추정
- Pad ring, filler/decap, production clock buffer, IR/EM/LVS/GDS sign-off 미완료

## 발표 자료 원본 확인

- [최종 설계 보고서](FINAL_REPORT_KR.md)
- [회로 동작 상세 설명](CIRCUIT_OPERATION_KR.md)
- [주장-근거 대응표](CLAIM_EVIDENCE_MATRIX_KR.md)
- [45nm 원본 요약](../reports/final_45nm/SUMMARY.md)

## 발표에서 사용하면 안 되는 표현

- “P9가 T0보다 raw PPA가 좋다”
- “2FF가 metastability를 제거한다”
- “P9는 완전 비동기 회로다”
- “OHT가 GRR과 모든 source 출력 순서까지 동일하다”
- “Gray를 쓰면 항상 한 bit만 바뀐다”
- “T0의 모든 비동기 timing이 sign-off됐다”
- “Post-route PNG가 Innovus GUI 직접 캡처다”
- “GPDK45 결과가 파운드리 tape-out sign-off다”
- “Mapped-SAIF가 실리콘 실측 전력이다”
