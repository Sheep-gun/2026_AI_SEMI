# AER 45 nm 이관과 8x8 IPRRA 분석

## 결론부터

주최측 답변을 더 기다리지 않고 서버 제공 GPDK045/GSCLIB045를 잠정 제출 공정으로
동결했다. 기존 핵심 후보를 동일 제약으로 다시 합성하고, Pareto 후보를 Innovus까지
완료했다. 현재 45 nm 주 설계는 **P9-GRR**, timing·저전력 대안은 **P9-OHT**다.

2차 과제 확장을 위해 64-source, 즉 8x8 입력의 grouped strict round-robin과
논문식 IPRRA를 동일 기능으로 구현했다. 예상과 달리 IPRRA는 64-input에서도
면적·timing·실제 workload power가 모두 나빠 탈락했다. 따라서 현재 2차 과제의
안전한 기본 단위는 검증된 4x4 P9 tile이고, 8x8 전체 입력은 grouped 8x8 중재기로
처리하는 방향이 타당하다.

## 45 nm 조건을 이렇게 정한 이유

서버에는 다음 deliverable이 실제로 존재한다.

- slow 0.9 V/125°C, fast 1.1 V/0°C Liberty
- GSCLIB045 technology/macro/multibit LEF
- GPDK045 QRC technology
- standard-cell functional Verilog
- GDS/CDL
- ICG, DFF2/DFF4, HVT/LVT library

Setup은 가장 느린 slow corner, hold는 가장 빠른 fast corner를 사용했다. 기존 구조
효과를 분리하기 위해 10 ns clock과 1 ns I/O delay를 유지했다. 초기 SDC에서 0.2 ns
uncertainty가 hold에도 적용되는 오류를 발견해 setup 0.20 ns, hold 0.02 ns로 분리했다.
Reset release에는 min 0.10 ns 입력 가정을 두고 recovery/removal을 별도 보고했다.

Power ring은 처음 0.5/1.0 µm spacing에서 Metal10 장거리 spacing 2건이 발생했다.
2.0 µm로 확장한 v4 run에서 모든 후보의 DRC와 connectivity가 0이 됐다.

## 64-source 구조

공통 상태는 다음과 같다.

```text
request 2FF CDC      128
ACK                  64
pending              64
output/last rank      6
valid                 1
reset release         2
------------------------
합계                265 FF
```

Grouped 후보는 8개 row의 요청 유무를 병렬 계산하고, 마지막 주소 뒤의 같은 row tail을
먼저 본 뒤 다음 nonempty row의 첫 column을 선택한다. IPRRA 후보는 64 leaves에서
6-level binary tree의 local branch 결정을 병렬 계산한다.

Selector 시험은 empty/full, 모든 one-hot, last-rank 64개와 random mask를 합쳐
36,992 case를 비교했다. 두 selector 모두 strict-cyclic reference와 error 0이었다.
통합 시험도 64-source 동시 요청, receiver stall, 1 event/clock saturation, ring wrap,
ACK와 출력 lockstep을 통과했다.

그러나 45 nm 결과는 grouped의 승리였다.

```text
grouped: 2,421.018 µm² / 3.528 ns / 0.048288 mW VCD
IPRRA : 2,727.108 µm² / 4.334 ns / 0.048399 mW VCD
```

IPRRA의 O(log N) 이론은 큰 programmable priority encoder에 대한 확장성 장점이지,
현재의 8x8 row-tail 전용 selector보다 반드시 작고 빠르다는 뜻은 아니었다. 64개의
one-hot grant path를 여섯 branch 결정과 AND하는 비용이 이 library에서는 컸다.

## 2차 과제에 적용할 규격 판단

4x4는 전체 센서 크기가 아니라 local tile 크기로 유지한다.

```text
권장 1단계: 16x16 sensor = 4x4 P9 tile 16개 + tile-level arbiter
검증 확장: 32x32 sensor = 4x4 tile 64개 + 다단 grouped arbiter
```

8x8 IPRRA가 탈락했으므로 local tile을 8x8 IPRRA로 키울 근거는 현재 없다. 다만
64-source grouped 결과는 8x8 sensor block 자체의 구현 가능성을 증명한다. 최종
16x16 시스템에서는 4x4 P9 tile을 재사용하는 계층형 구조와 8x8 grouped block을
직접 쓰는 구조를 system-level 배선과 memory interface까지 포함해 다시 비교한다.

정량 근거는 [`reports/aer45_final/SUMMARY.md`](../reports/aer45_final/SUMMARY.md)에
보존한다.
