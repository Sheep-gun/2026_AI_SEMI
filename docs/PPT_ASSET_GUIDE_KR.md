# 최종 PPT 제작 안내

## 권장 발표 흐름

### 1장 — 문제 정의

제목: 여러 뉴런의 발화를 적은 배선으로 전달하려면?

핵심 문장:

> 16개 뉴런이 각각 버스를 갖는 대신, 발화한 뉴런의 4-bit 주소만 하나의 공용
> 버스로 전송한다.

사용 그림: [최종 구조 비교](figures/final_comparison.svg)의 제목 부분 또는 직접
그린 16→1 주소 버스 아이콘.

### 2장 — 전통 AER과 4-phase handshake

핵심 문장:

> AER은 발화 크기가 아니라 발화한 뉴런의 번호를 이벤트로 보낸다. T0 Source는
> REQ를 올리고 ACK를 확인한 뒤 REQ를 내리며, ACK까지 0으로 돌아오면 한 번의
> 전송이 끝난다.

사용 그림: [4-phase handshake](figures/aer_4phase_handshake.svg)

주의: Timestamp가 payload에 포함된다고 설명하지 않는다. 이 RTL의 payload는
4-bit source 번호뿐이다. P9에서는 내부 Pending에 보관된 순간 Early ACK를 보내므로
T0의 receiver 완료 ACK와 의미가 다르다는 점은 4장에서 이어서 설명한다.

### 3장 — 전통적 T0와 문제점

핵심 문장:

> T0는 clock 없이 요청 변화로 직접 움직여 작고 단순하지만, 고정 우선순위,
> 내부 대기칸 부재, return-to-zero 빈 구간과 동시 경합 안전성 한계가 남는다.

사용 그림: [T0 구조](figures/t0_structure.svg)

발표 포인트:

- 낮은 번호가 반복 요청하면 높은 번호가 굶을 수 있음
- Receiver stall이 source까지 바로 전파됨
- MUTEX가 없으므로 near-simultaneous 경합의 transistor-level 안전성은 미주장

### 4장 — P9가 추가한 세 가지

핵심 문장:

> P9는 2FF로 비동기 요청을 안전하게 받아들이고, Pending에 이벤트를 보관하며,
> Gray 순번으로 우선순위를 돌려 모든 뉴런에 처리 기회를 준다.

사용 그림: [P9-GRR 구조](figures/p9_grr_structure.svg)

설명 순서:

1. 2FF: 불안정한 값이 전체 회로로 퍼질 확률 감소
2. Pending: source별 이벤트 보조 주머니
3. Early ACK: 내부 보관이 확정되면 source를 먼저 해제
4. Gray 순번: 한 source의 독점 방지
5. Output register: stall 중 주소 고정, 준비되면 1 event/clock

### 5장 — P9-GRR의 면적 최적화

핵심 문장:

> REQ·ACK·Pending을 같은 Gray rank 위치에 두고, 현재 출력 rank를 다음 중재
> pointer로도 재사용해 변환 회로와 별도 상태 4 FF를 없앴다.

사용 그림: [P9-GRR 구조](figures/p9_grr_structure.svg)

강조할 숫자:

- 263 instances
- 669.294 µm²
- P9 두 후보 중 최소 면적

### 6장 — P9-OHT의 속도·전력 최적화

핵심 문장:

> OHT는 별도 Gray epoch를 유지해 면적은 늘지만, one-hot tree가 후보를 병렬로
> 좁혀 critical path와 switching을 줄인다.

사용 그림: [P9-OHT 구조](figures/p9_oht_structure.svg)

GRR 대비:

- 면적 +5.979%
- 실제 workload SAIF 전력 −4.189%
- core setup 여유 +0.731 ns

### 7장 — PPA와 검증 결과

사용 그림: [세 설계 최종 비교](figures/final_comparison.svg)

표에 사용할 값:

| 설계 | Area | Vectorless | SAIF | Core setup |
|---|---:|---:|---:|---:|
| T0 | 214.092 µm² | 0.002127 mW | 해당 없음 | clockless |
| P9-GRR | 669.294 µm² | 0.020641 mW | 0.014382 mW | +6.824 ns |
| P9-OHT | 709.308 µm² | 0.019218 mW | 0.013780 mW | +7.555 ns |

반드시 붙일 설명:

> T0는 P9의 추가 기능이 없는 최소 baseline이므로 raw PPA로 직접 승패를 정하지
> 않는다. 동일 기능의 직접 비교는 GRR과 OHT 사이에서 수행한다.

### 8장 — 실제 물리설계와 결론

사용 그림:

- [T0 post-route](figures/t0_45nm_postroute.png)
- [P9-GRR post-route](figures/p9_grr_45nm_postroute.png)
- [P9-OHT post-route](figures/p9_oht_45nm_postroute.png)

결론 문장:

> T0의 구조적 한계를 2FF, 이벤트 저장과 공정 중재로 해결했다. 그 위에서
> P9-GRR을 면적 중심 주 설계로, P9-OHT를 속도·전력 중심 대안으로 확보했다.

검증 문장:

> 세 설계 모두 RTL 기능검증과 RTL-to-netlist 등가성 검증을 통과했고, 45nm
> 배치·배선 후 DRC와 connectivity 위반은 0이었다.

## 발표에서 피해야 할 표현

- “P9가 T0보다 면적과 전력이 작다”  
  실제로 P9가 더 크다. 대신 기능과 안정성, 처리 능력이 크게 늘었다.
- “2FF가 metastability를 완전히 제거한다”  
  다음 단계로 퍼질 확률을 매우 낮추지만 수학적으로 0은 아니다.
- “P9는 완전 비동기 회로다”  
  Source 쪽은 비동기 4-phase이고 내부 중재와 출력은 clock 기반인 하이브리드다.
- “Gray code가 timestamp다”  
  Gray는 내부 선택 순서이며 timestamp와 무관하다.
- “GPDK45 결과가 파운드리 sign-off다”  
  Generic 교육용 PDK에서의 구조 비교 결과다.

## 원본 수치 확인 위치

- [45nm 최종 요약](../reports/final_45nm/SUMMARY.md)
- [최종 기술 보고서](FINAL_REPORT_KR.md)
- [P9-GRR RTL](../rtl/final/aer_p9_grr.sv)
- [P9-OHT RTL](../rtl/final/aer_p9_oht.sv)
- [T0 RTL](../rtl/final/aer_t0_traditional_async.sv)
