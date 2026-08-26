# T0 / P9-GRR / P9-OHT 최종 45nm 근거

## 공통 조건

- PDK: Cadence GPDK045 + GSCLIB045 generic digital kit
- Setup: slow 0.9 V, 125°C
- Hold: fast 1.1 V, 0°C
- P9 clock: 10 ns
- Clock uncertainty: setup 0.20 ns, hold 0.02 ns
- I/O delay: 1 ns
- CDC FF1→FF2 max delay: 0.8 ns
- Placement density: 60%
- Signal routing: Metal1–Metal9
- VDD/VSS ring: Metal9/Metal10, width 1 µm, spacing 2 µm

이 PDK는 교육·비교용 generic 환경이며 특정 파운드리 sign-off를 뜻하지 않는다.

## Post-route 결과

| 항목 | T0 | P9-GRR | P9-OHT |
|---|---:|---:|---:|
| Instances | 92 | **263** | 278 |
| Cell area | 214.092 µm² | **669.294 µm²** | 709.308 µm² |
| Vectorless power | **0.002127 mW** | 0.020641 mW | **0.019218 mW** |
| Mapped-SAIF power | 해당 없음 | 0.014382 mW | **0.013780 mW** |
| Overall setup | clockless | +0.472 ns | +0.458 ns |
| Core setup | clockless | +6.824 ns | **+7.555 ns** |
| Hold | 상대시간 검증 | +0.024 ns | +0.024 ns |
| Recovery / removal | 해당 없음 | +9.386 / +0.061 ns | +9.380 / +0.061 ns |
| DRC / connectivity | 0 / 0 | 0 / 0 | 0 / 0 |
| LEC | 21 output + 5 state 통과 | 21 output + 71 state 통과 | 21 output + 75 state 통과 |

T0의 작은 면적과 전력은 P9의 기능을 같은 비용으로 구현했다는 뜻이 아니다. T0에는
2FF, source별 pending, 공정성 보장과 동기식 1 event/clock 출력이 없다.

P9-GRR과 P9-OHT는 같은 입출력·저장·공정성 계약을 사용하므로 직접 비교할 수 있다.
OHT는 GRR보다 면적이 5.979% 크지만 vectorless 전력은 6.892%, mapped-SAIF 전력은
4.189% 낮고 core setup 여유는 0.731 ns 크다.

## 기능 검증

- T0: 139개 이벤트 입력/수신 일치, assertion error 0
- P9-GRR: sparse, receiver stall, saturation, hotspot 총 101개 이벤트, error 0
- P9-OHT: 같은 101개 이벤트 workload, error 0
- P9 두 설계: full backlog에서 1 event/clock, stall 중 주소·valid 유지

## 근거 디렉터리

    synthesis/t0, p9_grr, p9_oht       Genus netlist와 area/timing/power
    synthesis/*_activity               동일 workload SAIF와 power
    pnr/t0, p9_grr, p9_oht             Innovus DEF/SDF/SPEF/netlist와 signoff reports
    lec/t0, p9_grr, p9_oht             RTL-to-mapped equivalence

설계 해석과 발표용 문장은 [최종 기술 보고서](../../docs/FINAL_REPORT_KR.md)를 따른다.
