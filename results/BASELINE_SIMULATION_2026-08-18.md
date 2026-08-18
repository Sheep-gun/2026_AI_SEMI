# Traditional AER Baseline Simulation Result

Date: 2026-08-18 KST  
Simulator: Vivado Simulator 2020.2 (`xvlog`, `xelab`, `xsim`)  
Configuration: 16 sources, 4-bit implicit source address, one four-phase receiver link

## Reproduction

```powershell
.\scripts\run_baseline.ps1
```

The runner compiles and elaborates from source, runs the self-checking suite, and requires the `TEST_PASS baseline` marker.

## Verified result

| Metric | Result | Scope |
|---|---:|---|
| Issued events | 431 | All directed and random phases |
| Received events | 431 | All directed and random phases |
| Assertion errors | 0 | Procedural checkers plus enabled concurrent SVA |
| Average latency | 29.658 cycles | Suite-wide; includes stalls, reset, hotspot |
| Worst latency | 901 cycles | Suite-wide tail under fixed-priority contention |
| No-stall saturation interval | 4 cycles/event | 128-event all-source saturation phase |
| No-stall steady throughput | 0.25 event/cycle | Reciprocal of measured four-cycle event interval |
| Suite throughput | 0.244608 event/cycle | Includes reset, stall, saturation, hotspot, and random phases |
| Source-15 hotspot max latency | 49 cycles | Source-0 repeated-load characterization |

Raw pass marker:

```text
TEST_PASS baseline issued=431 received=431
```

## Covered scenarios

- Single event.
- Simultaneous request from all 16 sources.
- Twelve-event burst from source 5.
- Four simultaneous sources with seven-cycle receiver response delay.
- Repeated source-0 hotspot versus source 15.
- Request held across reset and completed after reset release.
- No-stall saturation: eight events from each of 16 continuously active sources.
- Sixteen independent randomized streams, 16 events per source.

## Interpretation boundary

The measured no-stall acceptance gap is exactly four cycles, giving a steady 0.25 event/cycle for this clocked four-phase implementation and testbench receiver. The suite average separately includes reset, stalls, and deliberately unfair traffic. The 901-cycle worst latency is not a simulator failure: all events drained, and the long tail demonstrates the expected fixed-priority service weakness under concurrent streams.

This run proves functional behavior of the clocked RTL baseline. It is not an ASIC timing, area, power, or Fmax result. Those require the exact Cadence standard-cell library and PVT corner.

## Vivado synthesis sanity check

The same RTL was synthesized separately with Vivado 2020.2 for `xc7a35tcpg236-1`:

- Synthesis: 0 errors, 0 critical warnings, 0 warnings.
- 41 LUTs, 10 FFs after `opt_design`.
- No combinational loops and no unconstrained internal endpoints.
- Estimated post-synthesis WNS: +1.401 ns at a 10 ns clock.

These values prove FPGA synthesis compatibility only. They are excluded from final ASIC PPA comparisons.

## Evidence files

- `sim/logs/baseline_compile.log`
- `sim/logs/baseline_elaborate.log`
- `sim/logs/baseline.log`
- `sim/waves/aer_traditional.wdb`
- `sim/waves/aer_traditional.vcd`
- `reports/baseline/vivado_sanity/summary.txt`
- `reports/baseline/vivado_sanity/utilization.rpt`
- `reports/baseline/vivado_sanity/timing_summary.rpt`
- `reports/baseline/vivado_sanity/check_timing.rpt`
