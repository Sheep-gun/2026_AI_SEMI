# GPDK45 최종 재현 흐름

이 디렉터리에는 T0, P9-GRR, P9-OHT의 최종 결과를 다시 만드는 최소 스크립트만
남긴다. 서버 계정, 비밀번호와 절대 사용자 경로는 포함하지 않는다.

## 환경

- Cadence Genus 23.14
- Cadence Innovus 23.14
- Cadence Conformal
- GPDK045/GSCLIB045 digital kit
- PDK root: HOME/aer_2026/pdk45_digital

## 파일 역할

| 파일 | 역할 |
|---|---|
| genus_p9.tcl | P9 합성, timing·area·vectorless power |
| power_activity_p9.tcl | RTL VCD를 gate activity로 변환해 power와 SAIF 생성 |
| innovus_p9.tcl | P9 floorplan, placement, CTS, routing, extraction과 최종 보고서 |
| postroute_power_p9.tcl | 최종 Innovus DB에 mapped SAIF를 적용한 전력 |
| lec_p9.tcl | P9 RTL과 합성 netlist 등가성 검증 |
| p9.sdc / p9.view | P9 timing와 MMMC 조건 |
| genus_t0.tcl | Clockless T0 합성과 relative max-delay 조건 |
| innovus_t0.tcl | T0 placement, routing, extraction과 최종 보고서 |
| t0.sdc / t0.view | T0 MMMC 조건 |

P9-GRR과 P9-OHT는 같은 스크립트에 RTL top과 출력 경로를 환경변수로 넘겨 실행한다.
두 설계에 같은 10 ns clock, I/O delay, PDK corner와 배치 밀도를 적용해야 직접 PPA
비교가 성립한다.

최종 정량 근거는 [reports/final_45nm](../../../reports/final_45nm/SUMMARY.md)에
보존한다. Generic PDK 결과이므로 실제 tape-out 전에는 공식 PDK corner와 sign-off
규칙으로 다시 실행해야 한다.
