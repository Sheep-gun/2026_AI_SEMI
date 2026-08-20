# P8-DG-SCR 180 nm Cadence 후속 흐름

이 흐름은 P7-GE 및 P8-DG와 동일한 FPR 180 nm, 10 ns clock, I/O delay,
floorplan 조건에서 `aer_pending_direct_gray_sync_core_reset`을 구현한다. 기존
Cadence 파일은 변경하지 않으며 결과도 `p8dgscr` 전용 경로에 기록한다.

## Bundle 구조

```text
bundle-root/
├─ rtl/improved/aer_pending_direct_gray_sync_core_reset.sv
├─ scripts/cadence/
│  ├─ p8dgscr_genus_explore.tcl
│  ├─ p8dgscr_lec.tcl
│  ├─ p8dgscr_pnr.sdc
│  ├─ p8dgscr_pnr.view
│  ├─ p8dgscr_innovus.tcl
│  └─ p8dgscr_innovus_capture.tcl
├─ inputs/
├─ reports/
├─ outputs/
└─ db/
```

각 Tcl 파일은 `scripts/cadence`에서 두 단계 위를 bundle root로 계산한다.
저장소 상대 디렉터리 구조를 평탄화하면 안 된다.

## 실행 순서

Windows workspace에서 repo 상대 구조를 유지한 bundle을 먼저 만든다.

```powershell
.\scripts\prepare_p8dgscr_cadence_bundle.ps1
```

기본 출력은 gitignored 경로 `tmp/p8dgscr_cadence_bundle/`이다. 이 directory
전체를 Cadence 서버로 복사한 뒤 bundle root에서 실행한다.

Cadence Xcelium RTL 교차 검증은 다음 네 명령으로 재현한다.

```csh
xrun -64bit -sv rtl/improved/aer_pending_direct_gray_sync_core_reset.sv \
  tb/aer_p8_dgscr_wrappers.sv tb/aer_source_resident_tb.sv \
  -top aer_source_resident_tb -clean

xrun -64bit -sv rtl/improved/aer_pending_direct_gray_sync_core_reset.sv \
  tb/aer_p8_dgscr_wrappers.sv tb/aer_pending_gray_epoch_fair_tb.sv \
  -top aer_pending_gray_epoch_fair_tb -clean

xrun -64bit -sv rtl/improved/aer_pending_direct_gray_sync_core_reset.sv \
  tb/aer_p8_dgscr_wrappers.sv tb/aer_improved_cdc_phase_tb.sv \
  -top aer_improved_cdc_phase_tb -clean

xrun -64bit -sv rtl/improved/aer_pending_direct_gray_sync_core_reset.sv \
  tb/aer_p8_dgscr_wrappers.sv tb/aer_p8_dgscr_reset_tb.sv \
  -top aer_p8_dgscr_reset_tb -clean
```

```csh
genus -files scripts/cadence/p8dgscr_genus_explore.tcl
lec -nogui -dofile scripts/cadence/p8dgscr_lec.tcl
innovus -no_gui -files scripts/cadence/p8dgscr_innovus.tcl
genus -files scripts/cadence/p8dgscr_genus_contract_vcd_power.tcl
genus -files scripts/cadence/p7ge_genus_contract_vcd_power_rtl2gate.tcl
```

Native layout 이미지는 다음과 같이 생성한다.

```csh
setenv QT_X11_NO_MITSHM 1
xvfb-run -a -s '-screen 0 1920x1600x24 -ac +extension GLX +render -noreset' \
  innovus -files scripts/cadence/p8dgscr_innovus_capture.tcl
```

Pass marker는 `P8DGSCR_GENUS_DONE`, `P8DGSCR_LEC_PASS`,
`P8DGSCR_INNOVUS_180NM_DONE`, `P8DGSCR_INNOVUS_NATIVE_CAPTURE_DONE`,
`P8DGSCR_CONTRACT_VCD_POWER_DONE`, `P7GE_CONTRACT_VCD_RTL2GATE_DONE`이다.
Xcelium marker는
`SOURCE_RESIDENT_TEST_PASS`, `P7_GRAY_EPOCH_FAIR_TEST_PASS`,
`CDC_PHASE_TEST_PASS trials=192`, `P8_DGSCR_RESET_TEST_PASS`다.

## Reset 구조와 STA 해석

총 75개 상태 FF는 reset 방식에 따라 다음 세 종류로 나뉜다.

| 종류 | 상태 | 수량 | Timing 해석 |
|---|---|---:|---|
| 비동기 reset | `reset_release_q[1:0]` | 2 | Recovery/removal 대상 |
| resetless | request synchronizer 32개, `out_addr_q[3:0]` | 36 | Reset arc 없음 |
| 동기 clear | ACK 16개, pending 16개, Gray epoch 4개, `out_valid_q` | 37 | D 경로 setup/hold 대상 |

P7-GE처럼 `rst_n` 전체를 false-path 처리하면 P8-DG-SCR에 남은 유일한
recovery/removal 검사가 사라진다. 따라서 이 전용 SDC는 `rst_n`을 false-path로
지정하지 않는다. Post-route recovery/removal report에는
`reset_release_q[1:0]`만 나타나는 것이 정상이다.

외부 reset assertion 시 ACK와 valid는 `core_rst_n` isolation으로 clock 없이 즉시
0이 된다. 내부의 37개 core FF는 다음 clock에서 동기적으로 clear되며, reset release
synchronizer가 두 번째 edge에서 core를 unmask하기 전에 두 번 clear된다. 이 동작은
reset 해제 기간에 clock이 공급된다는 전제를 갖는다.

`out_addr_q`는 resetless이며 `out_valid=0`일 때 인터페이스상 무효다. Receiver와
testbench는 valid가 1일 때만 주소를 해석해야 한다.

## LEC와 별도 reset 검증

LEC는 P8-DG-SCR RTL과 그 Genus netlist의 구현 일치만 증명한다. Script는
resetless 또는 동기-clear state의 X 초기값을 0으로 강제하지 않는다. Mapping 문제를
숨기기 위해 `set_flatten_model -seq_constant_x_to 0`을 추가하면 안 된다.

다음 항목은 RTL 및 SDF reset-phase simulation으로 별도 확인한다.

- Clock의 여러 위상에서 비동기 reset assertion 및 release
- Assertion 직후 clock 없이 ACK와 valid가 즉시 0으로 isolation
- 첫 번째와 두 번째 release edge에서 37개 core state가 clear
- Reset 중 high인 요청이 release 뒤 정확히 한 번 접수
- Phantom ACK, pending 또는 valid가 발생하지 않음
- `out_valid=1 && !out_ready` 동안 주소와 valid가 안정적으로 유지

Recovery/removal report가 통과해도 위 동작 계약까지 자동으로 증명되는 것은 아니다.

## Cadence CDC 물리 제약

RTL의 `ASYNC_REG` 표기는 Vivado가 사용하지만 현재 Genus release는 이를
`Unused attribute`로 보고한다. 최종 Cadence flow는 이 표기에 의존하지 않는다.

- Genus mapping 직후 request synchronizer 32 FF와 reset-release 2 FF를
  `.preserve`로 고정한다.
- Innovus에서 동일 34 FF를 `dont_touch`로 보존한다.
- 16개 request pair와 reset-release pair를 각각 floating soft guide로 묶는다.
- `req_meta_q/Q → req_sync_q/D`에 0.9 ns, reset-release chain에 1.0 ns
  max-delay를 명시한다. Hold 검사는 끄지 않는다.
- Post-CTS/post-route hold target은 0.03 ns로 두고 최종 hold slack을 별도 확인한다.
- Post-route에서 pair별 setup/hold timing과 배치 Manhattan distance를 별도
  report로 남긴다.

이는 디지털 물리 구현에서 synchronizer의 resolution time을 과도한 배선 지연이
소모하지 않게 하는 제약이다. Foundry synchronizer characterization이나 silicon
MTBF sign-off를 대신하지 않는다.

## Clock root와 VCD power 주의

Clock root에는 `source_max_capacitance=0.250 pF`를 적용해 CCOpt가 legal driver를
삽입하도록 한다. `postroute_clock_tree.rpt`에서 cap violation 0을 확인해야 하며,
첫 실험에서 관찰된 bufferless/0.314 pF 결과는 최종 PPA로 사용하지 않는다.

Genus VCD flow는 `rtlstim2gate -load/-infer_rules`를 실행한 뒤 activity를 읽는다.
Sequential output과 RTL driver annotation이 100%여도 전체 gate driver-net coverage는
설계마다 다를 수 있다. 따라서 coverage가 다른 P7/P8 VCD 전력은 방향성 보조값으로
만 기록하고 clean matched-coverage 또는 sign-off 수치로 부르지 않는다.

Genus는 10 ns clock과 1 ns I/O delay를 사용하며 explicit clock uncertainty는 없다.
0.2 ns uncertainty는 Innovus SDC에만 적용된다.
