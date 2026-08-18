# A0-functional Clockless AER Simulation Result

Date: 2026-08-19 KST  
Simulator: Vivado Simulator 2020.2 (`xvlog`, `xelab`, `xsim`)  
Configuration: 16 sources, 4-bit address, no global clock, fixed priority, one 4-phase receiver link

## 재현

```powershell
.\scripts\run_async_baseline.ps1
```

성공한 run은 `TEST_PASS async_baseline` marker를 출력한다.

## 기능 검증 결과

| 지표 | 결과 | 해석 범위 |
|---|---:|---|
| Issued events | 139 | 모든 test phase |
| Received events | 139 | 모든 test phase |
| Loss / duplicate / assertion failure | 0 / 0 / 0 | Scoreboard와 protocol checker |
| Saturation events | 64 | source당 4 events |
| Saturation inter-event gap | 4 ns 고정 | TB delay가 결정한 기능 지표 |
| Saturation elapsed | 256 ns | TB delay가 결정한 기능 지표 |
| Average latency | 26.877 ns | suite 전체 TB 환경 |
| Worst latency | 241 ns | fixed-priority contention 포함 |
| Source-15 hotspot latency | 49 ns | fixed-priority 특성 |
| Pass marker | `TEST_PASS async_baseline issued=139 received=139` | 최종 run |

위 ns 값은 receiver acknowledge delay와 source model response delay를 포함한 simulation 환경 값이다. ASIC cell delay, post-layout latency, maximum events/s 또는 energy/event로 사용하지 않는다.

## Vivado 구조 synthesis probe

재현 명령:

```powershell
.\scripts\run_vivado_synth_async_probe.ps1
```

결과:

- 0 synthesis error, 0 critical warning, 2 expected latch-inference warnings
- 42 LUT
- latch primitive 6개 (`LD` 2, `LDC` 4)
- no-clock checks 80
- unconstrained internal endpoints 10
- ordinary combinational loops 0
- latch loops 2
- marker: `ASYNC_SYNTH_PROBE_PASS`

이 결과는 Vivado가 RTL을 latch 기반 구조로 변환했다는 probe일 뿐이다. Global clock과 asynchronous timing methodology가 없으므로 timing, Fmax와 FPGA/ASIC PPA signoff 결과가 아니다.

## 증거 파일

- `rtl/async_baseline/aer_traditional_async.sv`
- `tb/aer_traditional_async_tb.sv`
- `sim/logs/async_baseline_compile.log`
- `sim/logs/async_baseline_elaborate.log`
- `sim/logs/async_baseline.log`
- `sim/waves/aer_traditional_async.vcd`
- `reports/async_baseline/vivado_probe/summary.txt`
- `reports/async_baseline/vivado_probe/utilization.rpt`
- `reports/async_baseline/vivado_probe/check_timing.rpt`

## Claim boundary

이 run은 global clock 없는 4-phase protocol progress와 기능적 event accounting을 증명한다. Characterized MUTEX/C-element 부재로 인해 near-simultaneous physical arbitration의 metastability safety와 asynchronous ASIC signoff는 증명하지 않는다.
