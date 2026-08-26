# P10 논문 기반 AER PPA 재탐색 - 2026-08-21

## 1. 이번 탐색의 질문

P9-GRR은 이미 현재 기능 계약에서 필요한 71개 상태 비트의 하한에 도달했다.
따라서 이번에는 event 저장 용량이나 공정성을 줄이지 않고, 다음 두 부분을 다시
탐색했다.

1. 논문에서 제안된 빠른 round-robin 중재기가 P9의 16-input 중재기보다 작은가?
2. full Gray code의 XOR 세 개를 일부 제거하면 실제 180 nm PPA가 좋아지는가?

다음 기능은 모든 후보에서 그대로 유지했다.

- 비동기 4-phase REQ/ACK source 16개
- source마다 2FF 입력 동기화
- pending 16개와 registered output 1개, 최대 17-event 저장
- pending에 먼저 접수한 뒤 보내는 early ACK
- 수신기가 받을 수 있을 때 clock마다 최대 event 1개
- 계속 대기하는 source를 최대 16번의 service decision 안에 선택
- 단일 4-bit 주소 bus와 valid/ready 출력

## 2. 조사한 논문과 적용 범위

### 2.1 PRRA/IPRRA

Zheng과 Yang의 *Algorithm-Hardware Codesign of Fast Parallel Round-Robin
Arbiters*는 round-robin 선택을 binary search tree로 만들었다. PRRA는 요청 정보를
leaf에서 root로 모은 뒤 선택 결과를 다시 내리고, IPRRA는 각 subtree의 결정을
미리 병렬 계산해 이 두 단계를 겹친다. 논문은 O(log N) delay와 O(N) gate를
보였고, 0.18 um standard-cell 비교에서 큰 입력 수의 기존 programmable priority
encoder보다 timing과 area가 좋았다고 보고했다.

원문: <https://oasis.library.unlv.edu/ece_fac_articles/682/>

이번에는 논문의 식을 16-input strict-cyclic selector로 구현했다. 별도 one-hot
pointer 16개를 추가하지 않고 P9의 4-bit last-rank register에서 head 위치를 만든
뒤, 15개 tree node가 local left/right 결정을 병렬 계산하도록 구성했다.

### 2.2 Parallel-prefix round-robin

Ugurdag 등의 TC-PPA는 빠른 adder의 parallel-prefix OR network를 round-robin
arbiter에 사용한다. 논문 자체가 54-input 이상에서 timing 장점이 커진다고
보고하므로, 16-input P9에는 우선순위가 낮다. 이미 구현된 encoded-mask selector도
selector-only Vivado에서 46 LUT로 P9 grouped selector의 18 LUT보다 2.56배 컸다.
따라서 full-core 180 nm P&R 후보로 올리지 않았다.

원문: <https://doi.org/10.1016/j.mejo.2012.04.005>

### 2.3 Hierarchical token ring과 완전 비동기 AER

Purohit과 Manohar의 hierarchical token ring은 sparse event에는 tree처럼 동작하고,
공간적으로 모인 burst에는 ring처럼 빠르게 훑는 구조다. 다만 원문의 회로는
non-deterministic selection에 latch와 metastability filter를 포함한 asynchronous
arbiter를 사용한다. 현재 standard-cell library에는 검증된 MUTEX가 없고, P9의
동기식 pending/early-ACK 계약과도 회로 경계가 다르다. 따라서 2차 과제의 source
array와 함께 다시 설계할 system-level 후보이지, 현재 P9에 그대로 넣을 수 있는
drop-in PPA 개선으로 취급하지 않았다.

원문: <https://csl.yale.edu/~rajit/ps/htr.pdf>

2026년의 synthesizable asynchronous AER encoder도 tree와 bundled-data pipeline을
사용하지만, cross-coupled NAND random-priority arbiter를 포함한다. 현재의
`MUTEX 사용 안 함` 조건에서는 주 설계에 넣지 않았다.

원문: <https://yihuicalm.github.io/assets/pdf/aer_mwscas_2026.pdf>

## 3. 구현한 세 후보

### 3.1 P10-IPRRA

- 주소 순서: P9와 같은 full Gray cycle
- 상태: P9와 같은 71 FF
- 변경점: 4-group/4-lane selector를 논문식 IPRRA binary tree로 교체
- 기대효과: up-trace와 down-trace를 겹쳐 긴 selector path 단축

### 3.2 P10-X1

P9의 full Gray 변환은 다음 세 XOR를 사용한다.

```text
y3 = x3
y2 = x3 XOR x2
y1 = x2 XOR x1
y0 = x1 XOR x0
```

P10-X1은 아래처럼 최하위 pair만 Gray 순서로 바꾼다.

```text
y3 = x3
y2 = x2
y1 = x1
y0 = x1 XOR x0
```

따라서 출력 encoder는 XOR 3개에서 1개로 줄지만, 16-address 한 바퀴의 bit
전환은 16회에서 22회로 늘어난다. REQ, ACK와 pending은 이 순서에 맞게 고정
배선하므로 추가 decoder는 없다.

### 3.3 P10-X2

```text
y3 = x3
y2 = x2
y1 = x2 XOR x1
y0 = x1 XOR x0
```

XOR 2개를 사용하며 한 바퀴 전환은 18회다. X1과 full Gray 사이의 절충점이다.

## 4. 기능 검증

| 시험 | IPRRA | X1 | X2 |
|---|---:|---:|---:|
| selector 16 x 65,536 전수검증 | 1,048,576 / error 0 | 1,048,576 / error 0 | 1,048,576 / error 0 |
| RTL broad regression | 139/139, error 0 | 139/139, error 0 | 139/139, error 0 |
| RTL CDC phase | 192/192, error 0 | 192/192, error 0 | 192/192, error 0 |
| RTL reset/restart | PASS | PASS | PASS |
| RTL fixed-demand contract | 101/101, error 0 | 101/101, error 0 | 101/101, error 0 |
| post-synthesis 위 시험 전체 | PASS | PASS | PASS |

X1은 Conformal RTL-to-mapped LEC에서도 21 primary output과 71 DFF가 모두
equivalent였고 nonequivalent/abort/unknown은 모두 0이었다.

## 5. FPGA 및 Genus screening

### 5.1 Vivado proxy

| 설계 | LUT | FF | reg-to-reg datapath |
|---|---:|---:|---:|
| P9-GRR | 91 | 71 | 5.881 ns |
| P10-IPRRA | 151 | 71 | 7.359 ns |
| P10-X1 | **90** | 71 | 5.881 ns |
| P10-X2 | **90** | 71 | 5.881 ns |

IPRRA는 논문처럼 큰 arbiter를 위한 scalable 구조지만, 16-input P9에서는 local
node와 one-hot grant path 비용이 더 컸다. 따라서 physical-design 후보에서
탈락시켰다.

### 5.2 FPR 180 nm Genus

| 설계 | cells | area | vectorless power | 101-event VCD power | setup slack |
|---|---:|---:|---:|---:|---:|
| P9-GRR | 220 | 6,087.312 um2 | 0.905723 mW | **0.601712 mW** | +7.426 ns |
| P10-IPRRA | 274 | 6,582.946 um2 | **0.900520 mW** | 0.609361 mW | +7.479 ns |
| P10-X1, flat top | 225 | 6,097.291 um2 | 0.911721 mW | 0.604852 mW | +7.443 ns |
| P10-X2, screening hierarchy | 224 | 6,010.805 um2 | 0.929037 mW | 0.608360 mW | +7.531 ns |

X1과 X2는 encoder XOR를 줄였지만 실제 workload의 주소 전환이 늘어 VCD power가
P9보다 높았다. IPRRA도 area와 VCD power가 모두 P9보다 커 탈락했다.

## 6. Innovus에서 드러난 공정 비교 문제

처음에는 X1만 hold target을 0.013 ns까지 낮춰 배치·배선했고 P9는 기존 0.020 ns
결과와 비교했다. 이때 X1의 면적이 더 작아 보였지만, 이는 서로 다른 hold 보정량을
비교한 것이었다. P9도 같은 절차로 실패 경계까지 다시 탐색했다.

### 6.1 X1 hold sweep

| hold target | instances | area | vectorless power | actual hold | 판정 |
|---:|---:|---:|---:|---:|---|
| 0.020 | 289 | 7,055.294 um2 | 0.77782447 mW | +0.013 ns | PASS |
| 0.015 | 285 | 6,998.746 um2 | 0.77566775 mW | +0.002 ns | PASS |
| 0.014 | 284 | 6,995.419 um2 | 0.77453241 mW | +0.002 ns | PASS |
| **0.013** | **279** | **6,942.197 um2** | **0.77227874 mW** | **+0.002 ns** | **PASS** |
| 0.012 | 275 | 6,898.954 um2 | 0.76916310 mW | -0.001 ns | FAIL |

### 6.2 P9-GRR 추가 hold sweep

| hold target | instances | area | vectorless power | actual hold | 판정 |
|---:|---:|---:|---:|---:|---|
| 기존 0.020 | 281 | 6,988.766 um2 | 0.77624020 mW | +0.012 ns | PASS |
| 0.013 | 269 | 6,842.405 um2 | 0.76680198 mW | +0.007 ns | PASS |
| 0.012 | 268 | 6,822.446 um2 | 0.76587171 mW | +0.007 ns | PASS |
| 0.011 | 266 | 6,792.509 um2 | 0.76469414 mW | +0.003 ns | PASS |
| 0.010 | 265 | 6,775.877 um2 | 0.76388478 mW | +0.003 ns | PASS |
| 0.009 | 265 | 6,769.224 um2 | 0.76348084 mW | +0.001 ns | PASS |
| **0.008** | **263** | **6,742.613 um2** | **0.76127733 mW** | **+0.001 ns** | **PASS** |
| 0.007 | 262 | 6,725.981 um2 | 0.76033515 mW | -0.001 ns | FAIL |

0.008 ns가 확인된 최소 통과점이고 0.007 ns가 실패점이다.

## 7. 최종 PPA 판정

| post-route 항목 | 기존 P9 / 0.020 | P10-X1 / 0.013 | 재최적화 P9 / 0.008 |
|---|---:|---:|---:|
| instances | 281 | 279 | **263** |
| cell area | 6,988.766 um2 | 6,942.197 um2 | **6,742.613 um2** |
| vectorless power | 0.77624020 mW | 0.77227874 mW | **0.76127733 mW** |
| mapped-SAIF power | 0.57886987 mW | 0.58111653 mW | **0.57559566 mW** |
| core setup slack | +4.810 ns | **+4.971 ns** | +4.844 ns |
| overall/CDC setup slack | +0.159 ns | +0.198 ns | **+0.317 ns** |
| hold / CDC hold | +0.012 ns | +0.002 ns | +0.001 ns |
| DRC / connectivity / clock violation | 0 / 0 / 0 | 0 / 0 / 0 | 0 / 0 / 0 |

재최적화 P9는 기존 P9보다 instances 6.4057%, area 3.5221%, vectorless power
1.9276%, mapped-SAIF power 0.5656%를 줄였다. Core path도 0.034 ns 좋아졌고
overall/CDC setup slack은 0.158 ns 늘었다.

X1과 비교해도 재최적화 P9는 instances 5.7348%, area 2.8749%, vectorless power
1.4245%, mapped-SAIF power 0.9500%가 낮다. X1은 core path만 0.127 ns 더 빠르지만,
101-event 주소 전환이 P9의 114회보다 24.56% 많은 142회다.

## 8. 결론

이번 논문 기반 탐색에서 새로운 RTL이 P9-GRR을 전면적으로 이기지는 못했다.

- IPRRA는 16-input에서는 지나치게 컸다.
- X1/X2는 XOR 수를 줄였지만 주소 전환 증가로 workload power가 나빠졌다.
- HTR과 완전 비동기 tree는 MUTEX/비동기 arbiter와 system-level protocol 변경이
  필요해 현재 주 설계의 drop-in 후보가 아니다.

대신 비교를 공정하게 다시 수행하는 과정에서 P9-GRR의 물리 최적화가 덜 끝났음을
찾았다. 현재 FPR 180 nm 잠정 기준의 새 주력점은 **동일 P9-GRR RTL + hold target
0.008 ns**다. 이 결론은 서버 제공 FPR 180 nm reference kit의 도구 결과이며,
주최측 공식 PDK나 silicon sign-off 결과를 뜻하지 않는다. 공식 45 nm 환경이
확정되면 P9-GRR, X1 timing ablation, IPRRA 연구 후보를 동일 제약으로 다시
합성해야 한다.
