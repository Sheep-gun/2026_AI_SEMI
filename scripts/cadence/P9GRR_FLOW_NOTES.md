# P9-GRR Cadence 180 nm 재현 순서

모든 Tcl은 현재 shell의 `pwd`가 아니라 Tcl 파일 자신의 위치에서 bundle root를
계산한다. 따라서 bundle 밖의 임의 디렉터리에서 절대 경로로 호출해도 같은 입력과
출력 디렉터리를 사용한다.

현재 signoff 대상 RTL의 SHA-256은
`e59ef53c7f5b56155030b02a3ff6854b8da8762ebbcee31982f784cf4da8df68`이다.
Bundle 생성기는 복사 전후 모든 입력 파일의 SHA-256이 같은지도 검사한다.

```bash
BUNDLE=/absolute/path/to/p9grr_cadence_bundle

# 정적 입력과 bundle layout 검사
tclsh "$BUNDLE/scripts/cadence/p9grr_bundle_selfcheck.tcl" static

# RTL synthesis 및 vectorless PPA
genus -files "$BUNDLE/scripts/cadence/p9grr_genus_explore.tcl"
tclsh "$BUNDLE/scripts/cadence/p9grr_bundle_selfcheck.tcl" post_genus

# 동일 101-event VCD power
genus -files "$BUNDLE/scripts/cadence/p9grr_genus_contract_vcd_power.tcl"

# RTL 대 mapped netlist 순차 등가성
lec -nogui -dofile "$BUNDLE/scripts/cadence/p9grr_lec.tcl"

# 180 nm placement, CTS, routing 및 signoff-style reports
innovus -no_gui -files "$BUNDLE/scripts/cadence/p9grr_innovus.tcl"
tclsh "$BUNDLE/scripts/cadence/p9grr_bundle_selfcheck.tcl" post_innovus

# Genus가 VCD에서 만든 mapped SAIF를 최종 post-route DB에 적용
innovus -no_gui -files "$BUNDLE/scripts/cadence/p9grr_postroute_saif_power.tcl"

# Innovus GUI가 가능한 session에서 실제 post-route 화면 출력
innovus -files "$BUNDLE/scripts/cadence/p9grr_innovus_capture.tcl"
```

주요 출력 위치:

- `inputs/aer_pending_gray_rank_reuse_sync_core_reset_pnr.v`
- `reports/p9grr/`: Genus area, timing, vectorless power, QoR
- `reports/p9grr_contract_vcd/`: RTLStim2Gate VCD power와 mapped SAIF
- `reports/p9grr_pnr/`: post-route timing, vectorless/SAIF power, DRC, connectivity, clock, CDC
- `outputs/p9grr_pnr/`: DEF, Verilog, SDF, SPEF
- `db/`: Innovus post-route database
- `outputs/p9grr_180nm_innovus_postroute.png`: Innovus native capture

현재 재현 기준은 논문 기반 P10 후보와 같은 절차로 다시 탐색한 hold target
`0.008 ns`의 full clean run이다. Post-route에서 263 instances,
6,742.613 µm², vectorless power 0.76127733 mW, mapped-SAIF power
0.57559566 mW, overall/core setup `+0.317/+4.844 ns`, overall/CDC hold
`+0.001/+0.001 ns`를 얻었다. `0.007 ns` run은 hold/CDC hold
`-0.001/-0.001 ns`로 실패해 경계가 확인됐다. DRC/connectivity/clock
violations는 `0/0/0`이고, Conformal은 primary output 21개와 state point
71개를 모두 equivalent로 판정했다. 최신 원시 보고서는
`reports/p10_final/p9grr_h008/`에 보존한다.

이것은 FPR 180 nm reference 환경의 비교 결과이며 공식 제출 PDK sign-off를 뜻하지
않는다. 다른 library 또는 corner로 이관하면 CDC pair constraint, clock driver,
hold target, recovery/removal을 다시 닫아야 한다.
