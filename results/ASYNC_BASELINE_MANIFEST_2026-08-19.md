# A0-functional Evidence Manifest

SHA-256 values bind the clockless functional RTL, verification flow and synthesis-probe evidence.

| SHA-256 | Bytes | File |
|---|---:|---|
| `64AC2610AE5EDE476FDCE2A5CCCA8BBBD3472D0F456C79B51C262E74384129F4` | 4375 | `rtl/async_baseline/aer_traditional_async.sv` |
| `BF7405FFC651519F7B7D81921968FEF10FB8CA26165F2275C3A0452B0EBFB321` | 14091 | `tb/aer_traditional_async_tb.sv` |
| `67A78BADE6DCC7BE7F091C7FC599548AB8D8A6847DF275C991349B934064D7DD` | 1802 | `scripts/run_async_baseline.ps1` |
| `BF0C4FE5632424D893D8B3A53167D6E1BBC8E9F67F858C93D5FC17F73A476C25` | 142 | `scripts/xsim_async_baseline.tcl` |
| `EB389429B6FAA189F4038F0E3740AF8518E1AB45EF3A98CDD7D2E3298769C662` | 1231 | `scripts/run_vivado_synth_async_probe.ps1` |
| `0BD37007E9B9502D54F2BB3CDA15E023541F76E58C8E8821BE11374B3BC4A0DB` | 1759 | `scripts/vivado_synth_async_probe.tcl` |
| `0C7D23338458462B16D0A66A57B98E3322ED886AB8E6FA77435415B9C1126050` | 2757 | `sim/logs/async_baseline.log` |
| `BF10DD22A43784D981AC08CEC38666253AA0E7FD4242C284F03C0293E9A5A047` | 42047 | `sim/waves/aer_traditional_async.vcd` |
| `9FDB1708C3516452550945CFC8FBD19A419C11F17575AF26AC8EF9A9BF0B3451` | 285 | `reports/async_baseline/vivado_probe/summary.txt` |
| `F54F08D8D80D4F6E86CBAF9E1EB1C84069CC007C2B1DF18B9BA27F421F71CA0D` | 1411 | `reports/async_baseline/vivado_probe/utilization.rpt` |
| `D16890CC60137B4D2897A56022A3F5EAEFF92C2FDE79B1CF6922E22D45CD0A70` | 6853 | `reports/async_baseline/vivado_probe/check_timing.rpt` |

The manifest describes `A0-functional`, not a metastability-safe asynchronous ASIC implementation. Intentional regeneration requires a new dated manifest.
