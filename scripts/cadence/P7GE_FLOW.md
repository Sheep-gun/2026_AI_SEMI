# P7-GE Cadence 재현 절차

Cadence 서버에는 저장소의 중첩 경로 대신 작은 self-contained bundle을 올린다.
Windows workspace에서 다음 명령으로 bundle을 만든다.

```powershell
.\scripts\prepare_p7ge_cadence_bundle.ps1
```

기본 출력은 gitignored 경로 `tmp/p7ge_cadence_bundle/`이다. 이 디렉터리 전체를
Cadence 환경으로 복사한 뒤 bundle root에서 아래 순서로 실행한다.

```csh
xrun -64bit -sv rtl/aer_pending_gray_epoch.sv \
  tb/aer_pending_gray_epoch_regression_wrapper.sv \
  tb/aer_source_resident_tb.sv \
  -top aer_source_resident_tb -clean

xrun -64bit -sv rtl/aer_pending_gray_epoch.sv \
  tb/aer_pending_gray_epoch_frozen_wrapper.sv \
  tb/aer_pending_gray_epoch_fair_tb.sv \
  -top aer_pending_gray_epoch_fair_tb -clean

genus -files scripts/p7ge_genus_explore.tcl
lec -nogui -dofile scripts/p7ge_lec.tcl
innovus -no_gui -files scripts/p7ge_innovus.tcl

genus -files scripts/p4c_genus_contract_vcd_power.tcl
genus -files scripts/p7ge_genus_contract_vcd_power.tcl
```

Innovus 이미지는 X display가 없는 서버에서 24-bit virtual display를 사용한다.

```csh
setenv QT_X11_NO_MITSHM 1
xvfb-run -a -s '-screen 0 1920x1600x24 -ac +extension GLX +render -noreset' \
  innovus -files scripts/p7ge_innovus_capture.tcl
```

Pass 기준:

- Xcelium regression: `SOURCE_RESIDENT_TEST_PASS`
- Xcelium fairness: `P7_GRAY_EPOCH_FAIR_TEST_PASS`
- Genus: `P7GE_GENUS_DONE`
- Conformal: `P7GE_LEC_PASS`
- Innovus: `P7GE_INNOVUS_180NM_DONE`
- Capture: `P7GE_INNOVUS_NATIVE_CAPTURE_DONE`
