# 뉴런 발화 이벤트를 빠르고 공정하게 전달하는 AER 컨트롤러

이 저장소는 16개 뉴런의 비동기 발화 요청을 하나의 4-bit 주소 버스로 모으는 AER
컨트롤러를 다룬다. 최종 비교 대상은 세 개뿐이다.

- **T0**: clock 없이 4-phase handshake로 움직이는 전통적 AER baseline
- **P9-GRR**: 상태와 feedback 회로를 줄인 면적 중심 주 설계
- **P9-OHT**: one-hot tree로 속도와 전력을 개선한 Pareto 대안

중간 후보를 제거한 것은 설명 깊이를 줄이기 위해서가 아니다. 본문에서는 AER과
4-phase handshake부터 회로 상태식, event 하나의 처리 순서, 45nm PPA가 달라진
이유와 검증 범위까지 설명한다.

## 1. AER은 무엇을 전송하는가

AER은 Address-Event Representation의 약자다. 뉴런이 발화했을 때 막전위 파형
전체를 보내는 대신 “몇 번 뉴런이 발화했는가”라는 주소를 event로 보낸다.

16개 뉴런의 번호는 0~15이므로 4 bit면 표현할 수 있다.

    뉴런 6 발화
        → src_req[6] 상승
        → controller가 요청을 접수하고 중재
        → out_addr = 4'b0110
        → receiver가 6번 뉴런의 event로 해석

이 RTL의 payload는 4-bit source ID뿐이다. 발화 크기, 막전위와 timestamp는
포함하지 않는다. Timestamp는 event가 발생한 시각을 뜻하는 별도 정보다. P9는
timestamp를 저장하지 않으므로 서로 다른 source가 실제로 어느 순서로 발화했는지
정확한 FCFS 순서를 복원하지 않는다.

뉴런마다 전용 주소 버스를 만들면 source 수가 늘수록 배선과 핀이 증가한다.
AER은 요청선 16개를 유지하되 실제 event 정보는 하나의 공용 4-bit 주소 버스로
전달한다. 여러 요청이 겹칠 수 있으므로 단순 encoder가 아니라 하나를 선택하고
나머지를 보존하는 중재기가 필요하다.

![AER 공용 주소 버스 개념](docs/figures/aer_concept.svg)

## 2. 4-phase handshake는 무엇인가

Handshake는 공통 clock 횟수를 세는 대신 REQ와 ACK의 상태 변화로 “보냈다”와
“받았다”를 확인하는 약속이다.

1. Source가 REQ를 0→1로 올린다.
2. Controller 또는 receiver가 ACK를 0→1로 올린다.
3. Source가 ACK를 확인한 뒤 REQ를 1→0으로 내린다.
4. ACK가 1→0으로 내려가며 다음 요청을 받을 idle 상태로 돌아간다.

![전통 AER 4-phase handshake](docs/figures/aer_4phase_handshake.svg)

REQ와 ACK가 모두 0으로 돌아오므로 return-to-zero 방식이라고 부른다. Source는
ACK를 받을 때까지 REQ를 유지해야 한다. REQ를 짧은 pulse로만 만들면 P9의
동기화 FF가 한 번도 1을 읽지 못하거나 T0가 주소를 latch하기 전에 요청이
사라질 수 있다.

T0와 P9의 source ACK 의미는 다르다.

    T0: receiver가 현재 주소 transaction을 완료한 뒤 source ACK

    P9: controller 내부 Pending 또는 Output에 event 보관을 확정한 뒤 Early ACK
        실제 receiver 소비는 나중에 가능

따라서 P9의 ACK는 “최종 전송 완료”가 아니라 “controller가 event의 소유권을
넘겨받았다”는 뜻이다.

## 3. T0: 전통적 clockless AER

![T0 구조](docs/figures/t0_structure.svg)

T0에는 전체 동작을 지휘하는 공통 clock이 없다. REQ가 바뀌면 조합논리와 latch의
물리 지연을 따라 다음 신호가 바뀌고, receiver ACK가 돌아오면 transaction이
끝난다.

T0의 한 event는 다음 순서로 전달된다.

    src_req
      → fixed-priority selector
      → grant/address latch
      → 주소 안정
      → delay cell을 거쳐 aer_req 상승
      → receiver가 주소를 읽고 aer_ack 상승
      → 선택된 source에 src_ack 반환
      → REQ↓, aer_req↓, aer_ack↓

### 3.1 고정 우선순위

T0는 가장 작은 번호의 요청을 먼저 고른다. Source 1, 6, 12가 동시에 요청하면
source 1을 선택한다. Source 0이 반복 요청하면 source 15는 계속 밀릴 수 있다.
이를 starvation이라고 하며 T0에는 대기 시간 상한이 없다.

### 3.2 Latch와 교차 결합 되먹임

선택 주소가 receiver transaction 중 흔들리지 않도록 grant 4 bit와 busy 1 bit를
TLATX1 latch 5개에 저장한다. Latch 내부의 교차 결합 되먹임은 한쪽 node가
높아지면 반대쪽을 낮추고, 낮아진 반대쪽이 다시 첫 번째 node를 높이는 양의
되먹임이다. 입력 gate가 닫힌 뒤에도 0 또는 1을 유지할 수 있다.

### 3.3 Delay cell과 bundled-data

Receiver는 aer_req 상승을 보고 주소를 읽는다. 따라서 주소가 먼저 안정되고
aer_req가 나중에 올라가야 한다.

    Data path: REQ → priority → grant latch → aer_addr
    Control path: REQ → DLY4X1 chain → busy → aer_req

GPDK45 T0는 capture 경로 5개와 request launch 1개, 총 DLY4X1 6개를 보존한다.
설정한 5 ns 입력-출력 max-delay 검사에서는 최악 slack +4.126 ns를 만족했다.

다만 내부 latch gate/data 경로 일부는 Genus 보고서에서 unconstrained다. 현재
45nm 결과는 선택한 I/O max-delay와 물리 배치·배선이 완료됐다는 증거이지,
모든 bundled-data 상대시간 조건과 arbitrary asynchronous 경합을 sign-off했다는
뜻이 아니다.

### 3.4 T0에 남은 한계

- Fixed priority starvation
- Source별 Pending 또는 FIFO 없음
- Receiver stall이 현재 source까지 직접 전파
- 매 transaction마다 REQ와 ACK를 0으로 되돌리는 빈 구간
- Characterized MUTEX 부재
- Near-simultaneous request의 transistor-level metastability MTBF 미검증

T0는 이 한계를 숨기지 않고 전통적 AER의 구조와 비용을 측정하는 baseline으로
사용한다.

## 4. P9: 비동기 입력과 동기식 core를 결합한다

P9는 source 쪽 4-phase protocol을 유지하지만 내부 중재와 receiver 출력은
10 ns clock 기반으로 구성한다.

![P9 비동기-동기 경계](docs/figures/p9_hybrid_boundary.svg)

    비동기 source REQ
      → Source별 2FF
      → ACK + Pending
      → 공정한 중재
      → registered address + valid/ready
      → receiver

Source와 P9 사이는 level-held 4-phase이고, P9와 receiver 사이는 동기식
valid/ready다. 이 protocol 변환이 return-to-zero bubble과 receiver backpressure를
source에서 분리한다.

### 4.1 Source별 2FF

비동기 REQ가 clock edge와 거의 동시에 바뀌면 FF1 내부 node가 잠시 0과 1의
중간 전압에 머물 수 있다. 저장은 시작됐지만 아직 유효한 digital 값이 아닌
metastable 상태다.

    src_req_async[i] → FF1(req_meta) → FF2(req_sync) → core

FF1의 출력은 넓은 조합논리가 아니라 FF2 하나에만 연결된다. FF2가 다음 clock에
읽을 때까지 FF1에는 거의 한 clock 동안 안정될 시간이 생긴다. 2FF는
metastability 확률을 0으로 만들지 않지만 불안정한 값이 전체 회로로 퍼질 확률을
크게 낮춘다.

16 source × 2 FF = 32 FF이므로 면적과 clock 전력이 추가된다. 안전성을 위해
지불하는 비용이다. 또한 2FF는 독립적인 1-bit REQ에 적용한 것이며 여러 bit
payload bus를 bit별로 2FF에 넣는 방식과는 다르다.

### 4.2 Pending과 중복 접수 방지

Pending은 source별 event 보조 주머니다.

    pending[6]=1
      → source 6 event 하나가 controller 안에서 대기 중

새 event는 다음 조건에서만 접수한다.

    accept = req_sync AND NOT ack AND NOT pending

REQ가 1이어도 이미 ACK했거나 Pending이 차 있으면 다시 접수하지 않는다.

    ack_next = (ack AND req_sync) OR accept

Accept가 발생하면 ACK를 올리고, source가 REQ를 유지하는 동안 ACK도 유지한다.
REQ가 내려가면 ACK가 내려가 다음 event를 받을 준비를 한다.

ACK와 Pending은 서로 다른 상태다.

| ACK | Pending | 의미 |
|---:|---:|---|
| 0 | 0 | 요청과 대기 event 없음 |
| 1 | 1 | 요청 접수, event 대기, source가 REQ 유지 |
| 0 | 1 | Source handshake 종료, event는 내부 대기 |
| 1 | 0 | Event는 Output으로 이동, source가 아직 REQ 유지 |

### 4.3 최대 17개와 Early ACK

Pending 16개와 output register 1개를 합쳐 최대 17개 event를 보관한다.
Output이 비어 있으면 새 accept를 같은 다음 clock edge에 바로 output으로 보내는
cut-through가 가능하다. Output이 막혀 있으면 Pending에 보관한다.

어느 경우든 state에 event가 기록된 뒤에만 Early ACK를 올린다.

한 source pending에는 한 event만 들어간다. 같은 source의 더 빠른 burst에는
source-side accumulator 또는 별도 FIFO가 필요하다.

### 4.4 Valid/ready와 1 event/clock

Output은 4-bit 주소와 1-bit valid를 register에 저장한다.

| Valid | Ready | 동작 |
|---:|---:|---|
| 0 | 0 또는 1 | 출력 event 없음 |
| 1 | 0 | Receiver stall, 주소와 valid 유지 |
| 1 | 1 | Clock edge에서 event 한 개 소비 |

Receiver가 stall이면 현재 output은 고정되지만 비어 있는 다른 Pending에는 event를
접수할 수 있다. Backlog가 충분하고 ready=1이면 현재 output을 소비하는 clock에
다음 Pending을 채워 빈 clock 없이 최대 1 event/clock을 유지한다.

## 5. Gray 순번은 무엇을 바꾸는가

P9의 공정성 순서는 reflected Gray 관계를 이용한다.

    0 → 1 → 3 → 2 → 6 → 7 → 5 → 4
      → 12 → 13 → 15 → 14 → 10 → 11 → 9 → 8 → 0

이웃 주소는 한 bit만 다르므로 인접 순번을 연속 처리할 때 주소 bus의 충·방전
전환 수를 줄일 수 있다. 그러나 sparse traffic에서 중간 순번을 건너뛰면 여러
bit가 바뀔 수 있다. “Gray를 사용하면 모든 내부 signal이 항상 한 bit만
바뀐다”는 뜻이 아니다.

Gray는 payload나 timestamp가 아니다. 원래 source ID를 어떤 순서로 우선할지
정하는 내부 순번표다.

## 6. P9-GRR: 면적을 줄인 방법

GRR은 Gray-rank Register Reuse의 약자다.

![P9-GRR 구조](docs/figures/p9_grr_structure.svg)

### 6.1 Rank-indexed REQ·ACK·Pending

Source 6의 Gray rank는 4다.

    source 6 REQ     → req_rank[4]
    source 6 ACK     ← ack_rank[4]
    source 6 Pending → pending_rank[4]

중재기가 rank 4를 고르면 pending_rank[4]를 바로 지운다. Rank를 source 번호로
되돌린 뒤 어떤 pending bit인지 다시 찾는 feedback 회로가 필요 없다. 이 순서
재배열은 고정 배선이므로 추가 state나 동적 gate가 아니다.

### 6.2 4×4 Grouped strict-cyclic selector

16개 rank를 네 개씩 네 group으로 나눈다. 현재 group의 last rank 뒤쪽 tail을
먼저 확인하고, 없으면 다음 non-empty group과 그 안의 첫 rank를 고른다. 긴
16단 linear scan을 피하면서 실제 마지막 선택 다음부터 도는 strict cyclic
순서를 유지한다.

### 6.3 Output rank pointer 재사용

Out_rank 4 FF는 현재 출력 주소와 다음 중재 시작점을 동시에 나타낸다.

    out_rank=4
      → out_addr=Gray(4)=source 6
      → 다음 탐색은 rank 5부터

별도 output address 4 FF와 fairness pointer 4 FF를 따로 두지 않는다.

GRR state 구성:

    Request synchronizer 32
    ACK                 16
    Pending             16
    Output rank          4
    Output valid         1
    Reset release        2
    -----------------------
    합계                 71

![Gray rank와 GRR/OHT 상태 구성](docs/figures/p9_state_and_rank.svg)

GRR의 면적 이점은 Gray 자체보다 rank-indexed feedback과 pointer 재사용에서
발생한다.

## 7. P9-OHT: 속도와 전력을 얻은 방법

OHT는 One-Hot Top-down Tree의 약자다.

![P9-OHT 구조](docs/figures/p9_oht_structure.svg)

OHT는 source 번호 순서로 ACK와 Pending을 저장하고 16개 후보를 다음처럼 좁힌다.

    Candidate 16
      → Pair valid 8
      → Quarter valid 4
      → Half valid 2
      → Selected source one-hot

One-hot은 선택된 위치 하나만 1인 16-bit 표현이다.

    Source 6 선택
    selected_onehot = 0000_0000_0100_0000

이 값은 출력 주소를 만드는 동시에 Pending clear mask가 된다. Receiver stall 중에는
can_load_output=0이므로 clear mask도 0이 되어 Pending을 잘못 지우지 않는다.

OHT는 다음 선호 branch를 나타내는 Gray epoch 4 FF와 output address 4 FF를
별도로 저장한다.

OHT state 구성:

    Request synchronizer 32
    ACK                 16
    Pending             16
    Gray epoch           4
    Output address       4
    Output valid         1
    Reset release        2
    -----------------------
    합계                 75

GRR보다 4 FF와 관련 배선이 많아 면적은 커진다. 대신 half→quarter→pair→source
branch를 병렬로 판단해 critical path가 짧아지고 특정 workload의 switching이
감소했다.

동일 101-event 시험의 주소 bit 전환 합은 GRR 114회, OHT 106회였다. 이 숫자
하나가 전체 전력 차이를 모두 설명하지는 않지만 OHT의 낮은 mapped-SAIF 전력과
방향이 일치한다.

## 8. 세 설계의 기능 비교

![최종 기능 비교](docs/figures/final_comparison.svg)

| 항목 | T0 | P9-GRR | P9-OHT |
|---|---|---|---|
| Source interface | 비동기 4-phase | 비동기 4-phase | 비동기 4-phase |
| Receiver interface | 비동기 4-phase | 동기식 valid/ready | 동기식 valid/ready |
| 입력 보호 | Relative timing 조건 | Source별 2FF | Source별 2FF |
| Event 저장 | Source별 없음 | Pending 16 + Output 1 | Pending 16 + Output 1 |
| ACK 의미 | Receiver 완료 | 내부 보관 완료 | 내부 보관 완료 |
| 중재 | Fixed priority | Last rank 기반 strict cyclic | 별도 Gray epoch 기반 tree |
| Starvation 상한 | 없음 | Stall 제외 ≤16 decisions | Stall 제외 ≤16 grants |
| 최대 출력 | Handshake 지연에 의존 | Full backlog 1 event/clock | Full backlog 1 event/clock |

## 9. GPDK45 검증 조건

- Setup: slow 0.9 V, 125°C
- Hold: fast 1.1 V, 0°C
- P9 clock: 10 ns
- Setup/hold uncertainty: 0.20/0.02 ns
- I/O delay: 1 ns
- CDC FF1→FF2 max delay: 0.8 ns
- Placement density: 60%
- Signal routing: Metal1~Metal9
- Power ring: Metal9/Metal10, width 1 µm, spacing 2 µm

GPDK045는 generic 교육용 PDK다. 특정 파운드리 sign-off나 실리콘 실측을 뜻하지
않는다.

## 10. 기능 검증 결과

| 설계 | 시험 | 표본 | 결과 | 증명하는 범위 |
|---|---|---:|---|---|
| T0 | 단일·동시·burst·stall·saturation·hotspot·reset | 139 events | 139/139, error 0 | Digital protocol에서 loss/duplicate 없음 |
| P9-GRR | Sparse·stall·saturation·hotspot | 101 events | 101/101, error 0 | Early ACK, 저장, 공정성과 1 event/clock |
| P9-OHT | GRR과 동일 workload | 101 events | 101/101, error 0 | 같은 기능 계약과 OHT 선택 경로 |

P9 saturation phase는 64 events를 10 ns clock에서 630 ns output span으로
처리했다. 첫 event 이후 63개 간격이 각각 한 clock이므로 full backlog
1 event/clock과 일치한다.

## 11. GPDK45 post-route PPA

T0와 P9의 숫자는 기능이 달라 직접적인 우열 표가 아니다. P9 기능을 추가하는 데
들어간 비용을 보여 준다. 동일 기능의 직접 비교는 GRR과 OHT 사이에서 수행한다.

| 항목 | T0 | P9-GRR | P9-OHT |
|---|---:|---:|---:|
| Instances | 92 | **263** | 278 |
| Cell area | 214.092 µm² | **669.294 µm²** | 709.308 µm² |
| Vectorless power | 0.002127 mW | 0.020641 mW | **0.019218 mW** |
| Mapped-SAIF power | 해당 없음 | 0.014382 mW | **0.013780 mW** |
| Core setup slack | Clockless | +6.824 ns | **+7.555 ns** |
| Hold slack | N/A | +0.024 ns | +0.024 ns |
| DRC / connectivity | 0 / 0 | 0 / 0 | 0 / 0 |
| LEC | 21 output + 5 state | 21 output + 71 state | 21 output + 75 state |

OHT는 GRR보다 면적이 5.979% 크지만 vectorless 전력은 6.892%, 실제 workload
mapped-SAIF 전력은 4.189% 낮고 core setup 여유는 0.731 ns 크다.

![P9-GRR/P9-OHT PPA Pareto](docs/figures/p9_pareto_comparison.svg)

- 면적 우선: P9-GRR
- Timing·전력 우선: P9-OHT
- 전통 구조 기준점: T0

T0의 hold는 동기식 hold slack으로 표시할 수 없다. 선택한 5 ns I/O max-delay는
통과했지만 latch 내부에 unconstrained 경로가 남아 있으므로 완전한 asynchronous
relative-timing sign-off로 주장하지 않는다.

## 12. 실제 물리설계

- [T0 45nm post-route](docs/figures/t0_45nm_postroute.png)
- [P9-GRR 45nm post-route](docs/figures/p9_grr_45nm_postroute.png)
- [P9-OHT 45nm post-route](docs/figures/p9_oht_45nm_postroute.png)

세 그림은 Innovus GUI 화면을 임의로 그린 것이 아니라 최종 Innovus DEF의 실제
cell 중심과 routing 좌표를 렌더링한 것이다. 색은 발표 가독성을 위한 표시다.

[동일 축척 die 크기 비교](docs/figures/layout_scale_comparison.svg)에서는 T0,
GRR과 OHT의 DIEAREA를 같은 물리 축척으로 확인할 수 있다.

## 13. 결론

T0는 작은 clockless 회로로 전통 AER transaction을 수행하지만 fixed priority,
no-pending, return-to-zero bubble, receiver backpressure와 경합 안전성 한계가
남는다.

P9는 Source별 2FF, Pending, Early ACK, registered output과 Gray 기반 공정
중재를 결합해 event를 보관하고 starvation을 막으며 최대 1 event/clock을
달성한다.

P9-GRR은 rank-indexed 저장과 output-rank 재사용으로 면적을 줄인 주 설계다.
P9-OHT는 별도 Gray epoch와 one-hot tree로 면적을 더 쓰지만 timing과 전력을
개선한 대안이다.

## 14. 문서와 근거를 읽는 순서

1. [최종 설계 보고서](docs/FINAL_REPORT_KR.md)  
   참가신청서 형식에 맞춘 설계 목표·회로 구성·검증·PPA·완성도 설명
2. [회로 동작 상세 설명](docs/CIRCUIT_OPERATION_KR.md)  
   2FF, ACK/Pending 상태식, cut-through, Gray rank, GRR/OHT의 clock별 동작
3. [주장-근거 대응표](docs/CLAIM_EVIDENCE_MATRIX_KR.md)  
   발표 문장과 원본 simulation/Genus/Innovus/LEC 파일 연결
4. [PPT 자산 안내](docs/PPT_ASSET_GUIDE_KR.md)  
   권장 슬라이드 흐름과 사용할 SVG·PNG
5. [45nm 정량 요약](reports/final_45nm/SUMMARY.md)

로컬 RTL 재검증:

    powershell -ExecutionPolicy Bypass -File scripts/run_final_rtl_verification.ps1

저장소에는 T0, P9-GRR, P9-OHT의 최종 RTL·검증·물리 근거만 유지한다. 과거 탐색
내용은 Git 이력에서 복구할 수 있지만 최종 발표의 비교군에는 포함하지 않는다.
