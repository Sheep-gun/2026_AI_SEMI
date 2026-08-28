# 최종 PPT 제작 안내

PPT와 메인 README는 같은 순서로 진행한다. 앞 슬라이드에서 정의하지 않은 회로 이름이나
수치를 먼저 사용하지 않는다.

## 1부. AER이란 무엇인가?

### 슬라이드 1 — 왜 AER이 필요한가?

**청중의 질문:** 여러 뉴런의 발화를 적은 배선으로 어떻게 전달하는가?

**설명 순서:**

1. 뉴런마다 전용 주소 버스를 두면 배선이 반복된다.
2. Source별 요청은 받되, 실제 event 정보는 하나의 4-bit 주소 버스로 보낸다.
3. 16개 source는 4 bit로 표현할 수 있다.

**그림:** [AER 개념도](figures/aer_concept.svg)

**수치:** 16 sources, 4-bit 주소, 공유 bus 1개

**발표 문장:**

> 이 회로는 뉴런의 막전위를 계산하는 블록이 아니라, 어느 뉴런이 발화했는지를
> 하나의 주소 버스로 모아 전달하는 event 통신 controller입니다.

### 슬라이드 2 — AER이 전송하는 정보

**청중의 질문:** 뉴런의 무엇을 보내는가?

**예:**

    source 6 발화 → src_req[6]=1 → 공용 주소 0110

**설명:**

- Payload는 원래 source 번호다.
- 막전위와 발화 크기는 보내지 않는다.
- Timestamp도 포함하지 않는다.
- 여러 request가 동시에 들어오므로 단순 encoder가 아니라 arbiter가 필요하다.

**주의:**

- Gray code가 payload라고 하지 않는다.
- 출력 순서만으로 실제 발화 시각을 복원한다고 하지 않는다.

## 2부. 동기식과 비동기식

### 슬라이드 3 — Clock이 있는 회로와 없는 회로

**청중의 질문:** 계산이 끝났다는 기준은 무엇인가?

**동기식:**

    edge N에서 입력 저장
      → 조합논리 계산
      → edge N+1 전에 안정
      → 다음 edge에서 결과 저장

동기식은 실제 완료를 매번 감지하지 않는다. 가장 느린 경로가 clock 주기 안에
끝나도록 STA로 확인한다.

**비동기식:**

    요청 발생
      → 회로 반응
      → 상대 회로가 ACK
      → 다음 transaction

Clock이 없어도 gate와 배선 지연은 존재한다. Data와 request의 상대 도착 순서도
검증해야 한다.

**표:**

| 항목 | 동기식 | 비동기식 |
|---|---|---|
| 상태 기준 | Clock edge | Request/ACK |
| 완료 기준 | 다음 edge 전 timing | 상대 회로 ACK |
| 검증 | Setup/hold | Protocol/relative timing |
| 주요 난점 | Clock power | 중재와 metastability |

**핵심 문장:**

> 한 시스템 안에서 비동기 interface와 동기식 계산 core를 함께 사용할 수도
> 있습니다.

## 3부. 4-phase handshake

### 슬라이드 4 — Clock 없이 전달 완료를 확인하는 방법

**청중의 질문:** 공통 clock이 없는데 상대가 받았다는 것을 어떻게 아는가?

**네 단계:**

1. REQ↑
2. ACK↑
3. REQ↓
4. ACK↓

**그림:** [4-phase handshake](figures/aer_4phase_handshake.svg)

**설명:**

- Source는 ACK가 올 때까지 REQ를 유지한다.
- REQ와 ACK가 모두 0으로 돌아와야 다음 event를 시작한다.
- Receiver는 ACK를 늦춰 backpressure를 걸 수 있다.
- Return-to-zero 과정은 연속 event 사이에 bubble을 만든다.

**주의:**

Handshake는 전달 protocol이다. 동시에 들어온 여러 request 중 누구를 선택할지는
별도 중재기가 결정한다.

## 4부. 전통적인 AER T0

### 슬라이드 5 — T0 구현

**청중의 질문:** Clock 없이 16개 요청 중 하나를 어떻게 고르고 주소를 유지하는가?

**동작:**

    src_req
      → fixed priority
      → grant latch
      → 주소 안정
      → DLY4X1 chain
      → aer_req
      → receiver aer_ack
      → source src_ack

**그림:** [T0 구조](figures/t0_structure.svg)

**구현 수치:**

- TLATX1 5개: grant 4 + busy 1
- DLY4X1 6개
- Fixed priority
- Source별 event 대기칸 0개
- MUTEX 없음

**전문성 경계:**

Delay cell은 clock을 흉내 내는 것이 아니라 주소가 request보다 먼저 안정되도록
bundled-data 상대시간을 만든다.

### 슬라이드 6 — T0의 장점과 한계

**장점:**

- 전역 clock 없음
- 상태가 latch 5개로 작음
- Source와 receiver가 4-phase로 직접 transaction 완료
- Post-route 92 instances, 214.092 µm², vectorless 0.002127 mW

**한계:**

- 낮은 번호가 반복 요청하면 높은 번호가 굶을 수 있음
- Source별 대기칸 없음
- Receiver stall이 source까지 전파
- Return-to-zero bubble
- Characterized MUTEX 없음
- 내부 self-timed path 일부 unconstrained

**핵심 문장:**

> T0가 작은 이유에는 뒤에서 추가할 입력 보호, 저장, 공정성과 연속 출력 기능이
> 없다는 점도 포함됩니다.

**주의:**

T0의 +4.126 ns는 선택한 5 ns I/O max-delay 결과다. 전체 비동기 timing
sign-off라고 말하지 않는다.

## 5부. P9-GRR과 P9-OHT

### 슬라이드 7 — T0에서 도출한 개선 아이디어

이 슬라이드에서 처음 P9라는 이름을 정의한다.

| T0 문제 | 개선 아이디어 |
|---|---|
| 비동기 입력을 직접 중재 | 2FF 입력 경계 |
| Event 저장 없음 | Pending + output register |
| Fixed priority | Gray 기반 공정 중재 |
| Receiver bubble | Registered valid/ready |

**정의:**

> 이 네 개선을 결합한 controller를 P9라고 부르고, 중재 구현에 따라 면적형 GRR과
> 속도·전력형 OHT 두 최종안으로 나눴습니다.

**그림:** [비동기-동기 경계](figures/p9_hybrid_boundary.svg)

### 슬라이드 8 — 공통 개선 기술

**2FF:**

- FF1은 metastable해질 수 있다.
- FF2가 다음 clock에 읽어 안정 시간을 제공한다.
- 16×2=32 FF의 면적과 clock 비용을 지불한다.
- 확률을 0으로 만드는 것은 아니다.

**Pending과 Early ACK:**

    accept = req_sync AND NOT ack AND NOT pending

- Pending은 source별 event 보조 주머니다.
- Pending 16 + output 1 = 최대 17 events
- Early ACK는 receiver 완료가 아니라 내부 보관 완료다.

**출력:**

- valid=1, ready=0이면 주소와 valid 유지
- valid=1, ready=1인 edge에서 event 소비
- Full backlog에서 1 event/clock

**그림:** [T0와 개선형 stall timeline](figures/t0_p9_stall_timeline.svg)

### 슬라이드 9 — P9-GRR

**핵심 질문:** 같은 개선 기능을 어떻게 가장 작은 상태로 구현했는가?

**Source 6 예:**

    source 6 ↔ Gray rank 4
    req_rank[4] ↔ ack_rank[4] ↔ pending_rank[4]

Rank 4가 선택되면 같은 Pending 위치를 바로 지운다. Out_rank 4 FF는 현재 출력과
다음 strict-cyclic 탐색 pointer를 겸한다.

**상태:**

    공통 67 + out_rank 4 = 71

**선택기:**

- Rank 16개를 네 개씩 네 group으로 나눔
- 현재 group tail을 먼저 검색
- 없으면 다음 non-empty group 선택

**그림:**

- [GRR 구조](figures/p9_grr_structure.svg)
- [Rank와 상태 구성](figures/p9_state_and_rank.svg)

### 슬라이드 10 — P9-OHT

**핵심 질문:** 왜 상태를 더 쓰면 timing과 switching이 줄어드는가?

**Tree:**

    Candidate 16
      → Pair 8
      → Quarter 4
      → Half 2
      → Source one-hot

최종 one-hot은 주소를 만들면서 Pending clear mask로도 사용한다.

**상태:**

    공통 67 + Gray epoch 4 + output address 4 = 75

Epoch는 마지막 선택 다음 번호 pointer가 아니다. Successful grant마다 Gray
schedule을 한 단계 이동시켜 tree branch 선호도를 바꾼다.

**전력 원인:**

- Sequential power는 4 FF 비용으로 증가
- Combinational total 약 45.3% 감소
- Switching component 약 37.2% 감소
- 결과적으로 total SAIF 4.189% 감소

**그림:** [OHT 구조](figures/p9_oht_structure.svg)

### 슬라이드 11 — 개선 결과와 PPA 분석

**기능 검증:**

| 설계 | Event | Error | LEC | DRC/Conn |
|---|---:|---:|---|---:|
| T0 | 139 | 0 | 21 outputs + 5 states | 0/0 |
| P9-GRR | 101 | 0 | 21 outputs + 71 states | 0/0 |
| P9-OHT | 101 | 0 | 21 outputs + 75 states | 0/0 |

**Post-route:**

| 항목 | T0 | GRR | OHT |
|---|---:|---:|---:|
| Cell area | 214.092 | 669.294 | 709.308 µm² |
| Vectorless | 0.002127 | 0.020641 | 0.019218 mW |
| SAIF | 없음 | 0.014382 | 0.013780 mW |
| Core slack | Clockless | +6.824 | +7.555 ns |

**해석 순서:**

1. T0와 개선형: 추가 기능과 비용 비교
2. GRR과 OHT: 동일 service contract의 직접 PPA 비교

**GRR 대비 OHT:**

- Area +5.979%
- SAIF −4.189%
- Core arrival −23.1%
- Core slack +0.731 ns

**그림:**

- [전통형·GRR·OHT 최종 PPA 비교](figures/final_comparison.svg)
- [GRR/OHT Pareto](figures/p9_pareto_comparison.svg)
- [검증 흐름](figures/verification_flow.svg)

**최종 선택:**

- 면적 우선: P9-GRR
- Timing·전력 우선: P9-OHT

## 6부. 향후 2차 과제에 적용

### 슬라이드 12 — 4×4 local tile의 계층형 재사용

현재 개선 IP는 16개 source를 처리한다. 이를 4×4 뉴런 tile의 local event
controller로 사용한다.

    16×16 sensor
      → 4×4 tile 16개
      → tile마다 P9 1개
      → 상위 tile arbiter
      → 8-bit global address

| 주소 필드 | 폭 |
|---|---:|
| Tile ID | 4 bit |
| Local source ID | 4 bit |
| 합계 | 8 bit |

**재사용하는 것:**

- Source-side 4-phase
- 2FF, Pending과 Early ACK
- Local 공정성
- Valid/ready output

**새로 검증하는 것:**

- Tile 간 공정성
- 동일-source burst
- Global 주소 매핑
- 상위 backpressure
- 실제 SNN traffic power
- 16×16 top-level PPA

**물리 그림:**

- [2차 과제 계층형 tile 구조](figures/second_task_tile_hierarchy.svg)
- [동일 축척 die 비교](figures/layout_scale_comparison.svg)
- T0, GRR, OHT의 DEF 기반 post-route PNG

**최종 문장:**

> 2차 과제에 재사용하는 것은 완성된 전체 시스템이 아니라 검증된 16-source local
> event 수집·중재 IP입니다. 상위 시스템은 tile 주소와 계층 중재를 추가합니다.

## 발표 자료의 원본 근거

- [메인 README](../README.md)
- [회로 동작 상세](CIRCUIT_OPERATION_KR.md)
- [주장-근거 대응표](CLAIM_EVIDENCE_MATRIX_KR.md)
- [45nm 수치](../reports/final_45nm/SUMMARY.md)

## 사용하면 안 되는 표현

- “P9가 T0보다 raw PPA가 좋다”
- “2FF가 metastability를 제거한다”
- “P9는 완전 비동기식이다”
- “OHT와 GRR의 모든 출력 순서가 같다”
- “Gray는 항상 한 bit만 바뀐다”
- “T0의 모든 비동기 timing이 sign-off됐다”
- “DEF 기반 PNG가 Innovus GUI 직접 screenshot이다”
- “Mapped-SAIF가 실리콘 실측 전력이다”
