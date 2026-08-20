# P7-GE 증거 manifest

아래 SHA-256은 P7-GE 최종 검증·합성·배치·배선에 사용한 핵심 파일을 고정한다.
공개 저장소용 text artifact에서는 account, host와 workspace 절대경로만 placeholder로
치환했으며 회로 netlist, 수치, timing path와 pass/fail 내용은 바꾸지 않았다.

| 파일 | SHA-256 | byte |
|---|---|---:|
| `rtl/improved/aer_pending_gray_epoch.sv` | `9d2f8ad576026bbbffbb28ddb6f2ace66c3b4c9ac61499ddfa1ab625ae8472e8` | 5757 |
| `rtl/improved/aer_pending_gray_epoch_fallthrough.sv` | `b5dc39cfe5ffb56fa2d12b54e3fc39139da0296c96e3ba4f9c06f84d74ed7264` | 5196 |
| `tb/aer_pending_gray_epoch_fair_tb.sv` | `f0a68e5a74b0924ee6afc485f855a3b12b413e965b8beb5ae0270367fc97e055` | 12834 |
| `tb/aer_contract_fairness_tb.sv` | `5b9db01e3b2fc9526c81e1739f791f062f67f0cd952c68c81873cbd5518ef1f4` | 24093 |
| `tb/aer_pending_gray_epoch_cdc_wrapper.sv` | `614fcd854665c1ffa6efd61244d0d9dbe3c3f3aa882ab3d4864c555264920d92` | 794 |
| `scripts/run_pending_gray_epoch_verification.ps1` | `c5cbaa09c2fac4f6d53da13d10aa5e57ab7de51d6b41a8c27cc24ecde94f1cdf` | 1959 |
| `scripts/run_pending_gray_epoch_gate_verification.ps1` | `f17e0dc95478d187ce46627b4a0920884caaf2fef79fe419fb3e6d0d73511c93` | 1609 |
| `scripts/run_pending_gray_epoch_cdc_phase.ps1` | `a3d732c8a9e911e0de2532862e2ecf24a91e97434a42e43b5a5ac472c848db6b` | 2454 |
| `scripts/run_aer_contract_fairness.ps1` | `ae2b0e51b2667e3781270afdce68cda6601b95a45277f013ff69da360d47716c` | 3993 |
| `scripts/prepare_p7ge_cadence_bundle.ps1` | `67e413461bedaa727dc180ca31e3f4c365bf61ffcb13069d174741dcccbdb2ed` | 2376 |
| `scripts/cadence/P7GE_FLOW.md` | `59da1088a41e339f2a9d3377602a3588521b61832e42d501abc5d3fa1e29f89a` | 1560 |
| `scripts/vivado_synth_pending_gray_epoch_robust.tcl` | `958ea22997f9803fa0657cf1b911973e75078aa0b1306effb927a090aa4dec32` | 1737 |
| `scripts/cadence/p7ge_genus_explore.tcl` | `31934295b78329ea06ed9e0accf2a7d3849bbeb1bc1a58bbcf69bb6e31431e86` | 1054 |
| `scripts/cadence/p7ge_innovus.tcl` | `df4a94f168adc2cc6859c31c7b8f0920bd20a766456ff3e9d56da9080e46bfa7` | 3301 |
| `scripts/cadence/p7ge_pnr.sdc` | `062428e9d6565000db571dc887754c422582a16367328cdf9182e5c9cacbdc92` | 425 |
| `scripts/cadence/p7ge_pnr.view` | `8afc8528b5bd1796452546fb320d2abcc0d28cd4b5c40842270c80f10339a24b` | 1158 |
| `scripts/cadence/p7ge_lec.tcl` | `cbfe9f2a880f2d84b6981d261ef7a4be6d2b903cf60d533fd237461c001cf068` | 1277 |
| `docs/architecture/aer_p7_gray_epoch_structure.svg` | `83eee1884b370643a89451962ab23c06260917b0f4612669954ece94169d29be` | 10331 |
| `docs/architecture/p7ge_180nm_innovus_postroute.png` | `177476400cd9db2966beda963be72b442ecf737657a8894069cfcd22e7e2cab9` | 187604 |
| `results/P7_PENDING_GRAY_EPOCH_2026-08-20.md` | `297a271340c4c61a7f868711028c1923f29d0b3c22762aa4056b2642586aafdd` | 8580 |
| `reports/pending_gray_epoch/cadence/pnr_180nm/SUMMARY.txt` | `4de06e4287b6b74c4daf09c42884d1c8d2814aef5bcd8e3caddcd9aed2a01034` | 3284 |
| `reports/pending_gray_epoch/cadence/pnr_180nm/p7ge/genus_area.rpt` | `cc02e7dfce6537db321b3f4614051fd7abbc07732740cb13b677664cb802bd9d` | 772 |
| `reports/pending_gray_epoch/cadence/pnr_180nm/p7ge/genus_power.rpt` | `de8eaa6ba7bf571a88460de79bf5c6aee7962ec9ed2a369803adc1de76d217bc` | 1216 |
| `reports/pending_gray_epoch/cadence/pnr_180nm/p7ge_pnr/postroute_area.rpt` | `a2bdacc136221977edf0f4d3371cdf5187a42ea9da332d1a7dd79e54494abd42` | 225 |
| `reports/pending_gray_epoch/cadence/pnr_180nm/p7ge_pnr/postroute_setup_timing.rpt` | `d6d61118d5083cc420aa7c8aaa2b18af90b738f6577d9391d2499e8b80c6d93f` | 100076 |
| `reports/pending_gray_epoch/cadence/pnr_180nm/p7ge_pnr/postroute_hold_timing.rpt` | `1b45294402b22e8b233c90609e7079c4aa5762a7d6caa39097dd67eff8ec5fd5` | 74538 |
| `reports/pending_gray_epoch/cadence/pnr_180nm/p7ge_pnr/postroute_recovery_timing.rpt` | `a36f1b7c8fd260862be2c52bb80579642f1bccfe07412dcaf9c965b434d12a9e` | 29897 |
| `reports/pending_gray_epoch/cadence/pnr_180nm/p7ge_pnr/postroute_removal_timing.rpt` | `4525ba1e5b4094d77365a56573ced55a131ae717d6dd00de416ff3e1487b2584` | 29886 |
| `reports/pending_gray_epoch/cadence/pnr_180nm/p7ge_pnr/postroute_power.rpt` | `51e9d15efb13adc0c890286aea6142af46730466b54ebc53a8a12a144bf71811` | 4324 |
| `reports/pending_gray_epoch/cadence/pnr_180nm/p7ge_pnr/postroute_drc.rpt` | `0aa610605eb748f3efec3e1756b902b893d813bda43cb2002feb87232dcec905` | 437 |
| `reports/pending_gray_epoch/cadence/pnr_180nm/p7ge_pnr/postroute_connectivity.rpt` | `7700e1ca9d8704a6ef2094d27e8a1efa73e628c19dda354b1967d34bb2bb1287` | 619 |
| `reports/pending_gray_epoch/cadence/pnr_180nm/p7ge_pnr/p7ge_lec.rpt` | `f7a2055f7f4273e9802fbc17181760025ff610a4c2d2e4ba576072daaf840adb` | 8295 |
| `reports/pending_gray_epoch/cadence/pnr_180nm/contract_vcd_power/p4c_read_vcd.log` | `59f57ce89d5b4bdadc614a342b70c7dea8fa97f13c94cb28ab717cb40ca307fc` | 140954 |
| `reports/pending_gray_epoch/cadence/pnr_180nm/contract_vcd_power/p7ge_read_vcd.log` | `1fab9247b8cc5c8f8bf98f288289ab2dddedf03625b7aee698726cf7c45bb078` | 109999 |
