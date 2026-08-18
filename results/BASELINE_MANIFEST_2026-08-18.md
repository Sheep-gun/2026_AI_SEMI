# B0-v1 Evidence Manifest

SHA-256 values bind the current baseline RTL, verification flow, logs, and synthesis-sanity evidence.

| SHA-256 | Bytes | File |
|---|---:|---|
| `3DC1D48E5A8CB241536676B3F23E0D280BBD4E29F942B737B5EBD96B4B501383` | 3477 | `rtl/baseline/aer_traditional.sv` |
| `F006821FCD2E018DB0C4D2365E5509B752E7DF02EC434B757005456DCD078EC5` | 17540 | `tb/aer_traditional_tb.sv` |
| `D7022B7FE3334324496E7BF026BE5409DCD49251EB657814C208E8203C60FF26` | 1883 | `scripts/run_baseline.ps1` |
| `A2B38604A13B3ED579581ACF071B85F8E5E47600C779A2134ACEA4B96DD3FB65` | 130 | `scripts/xsim_baseline.tcl` |
| `5399DEBBA1AA2F8060D7F2BBAD4FF5A885FC32332A4BEF114ABE5D0EFE578F7D` | 1150 | `scripts/run_vivado_synth_baseline.ps1` |
| `B4F14A0E4FD6B9C6704E29C47A8A66821C541CC24D9F41014DECB10CC87B4F4F` | 2699 | `scripts/vivado_synth_baseline.tcl` |
| `49F3499DBBAA336B175106EED56C2A53DFE63ABFDF8D613CB9901D1C5FCE92D8` | 3198 | `sim/logs/baseline.log` |
| `452DE7F7DCBA6FFB7219B4C4E28EE88373D533F361ADA00869FEA4A57408E521` | 287168 | `sim/waves/aer_traditional.vcd` |
| `E1BDACBA989D3B30BBED8CEB84A9C520A5DAD504645D9DDF92B6ED25005B4298` | 268 | `reports/baseline/vivado_sanity/summary.txt` |
| `9AEA610C50EB4A5C1E94E8CE06BE59F9BEC54DA5A2770005EF1F415102FD16DC` | 1360 | `reports/baseline/vivado_sanity/utilization.rpt` |
| `C279E50D8DBF0033BF0C4C73B0EE5CDAAC3F11B3E120BC12BECF7C138EA05EF0` | 72521 | `reports/baseline/vivado_sanity/timing_summary.rpt` |
| `E4BA340633D21ADBBCFF58DD2CADD1480056B974CE64E309305E1C6ACBA78AE2` | 3071 | `reports/baseline/vivado_sanity/check_timing.rpt` |
| `4FC7C8A85A9E13379A118BCAC6D76A563AEDCFEC721DEFCA5E66B2846335F4F1` | 32240 | `reports/baseline/vivado_sanity/aer_traditional_synth.dcp` |

The manifest describes `B0-v1`. Regenerating waveforms or reports can change hashes even when behavior is identical; a future intentional regeneration must create a new dated manifest.

