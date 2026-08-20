$ErrorActionPreference = 'Stop'
$repoRoot = (Resolve-Path -LiteralPath "$PSScriptRoot\..").Path
$output = Join-Path $repoRoot 'results\P8_DG_SCR_MANIFEST_2026-08-21.md'

$files = @(
    'rtl/improved/aer_pending_direct_gray_sync_core_reset.sv',
    'tb/aer_p8_dgscr_wrappers.sv',
    'tb/aer_p8_dgscr_reset_tb.sv',
    'scripts/run_p8_dgscr_verification.ps1',
    'scripts/run_vivado_synth_p8_dgscr.ps1',
    'scripts/vivado_synth_p8_dgscr.tcl',
    'scripts/run_p8_contract_fairness.ps1',
    'scripts/prepare_p8dgscr_cadence_bundle.ps1',
    'scripts/cadence/P8DGSCR_FLOW_NOTES.md',
    'scripts/cadence/p8dgscr_genus_explore.tcl',
    'scripts/cadence/p8dgscr_genus_contract_vcd_power.tcl',
    'scripts/cadence/p7ge_genus_contract_vcd_power_rtl2gate.tcl',
    'scripts/cadence/p8dgscr_lec.tcl',
    'scripts/cadence/p8dgscr_pnr.sdc',
    'scripts/cadence/p8dgscr_pnr.view',
    'scripts/cadence/p8dgscr_innovus.tcl',
    'scripts/cadence/p8dgscr_innovus_capture.tcl',
    'sim/waves/contract_fairness_p8_direct_gray_sync_core_reset.vcd',
    'sim/waves/contract_fairness_p7ge.vcd',
    'rtl/improved/aer_pending_gray_epoch.sv',
    'sim/logs/p8_dgscr_regression_rtl.log',
    'sim/logs/p8_dgscr_regression_gate.log',
    'sim/logs/p8_dgscr_fair_rtl.log',
    'sim/logs/p8_dgscr_fair_gate.log',
    'sim/logs/p8_dgscr_cdc_rtl.log',
    'sim/logs/p8_dgscr_cdc_gate.log',
    'sim/logs/p8_dgscr_reset_rtl.log',
    'sim/logs/p8_dgscr_reset_gate.log',
    'reports/p8_candidates/vivado_direct_gray_sync_core_reset/aer_pending_direct_gray_sync_core_reset_post_synth.v',
    'reports/p8_candidates/vivado_direct_gray_sync_core_reset/summary.txt',
    'reports/p8_candidates/vivado_direct_gray_sync_core_reset/utilization.rpt',
    'reports/p8_candidates/vivado_direct_gray_sync_core_reset/reg2reg_timing.rpt',
    'reports/p8_candidates/vivado_direct_gray_sync_core_reset/timing_summary.rpt',
    'reports/p8_candidates/vivado_direct_gray_sync_core_reset/check_timing.rpt',
    'docs/architecture/aer_p8_dgscr_structure.svg',
    'docs/architecture/p8dgscr_180nm_innovus_postroute.png',
    'results/P8_DG_SCR_2026-08-21.md',
    'reports/p8_dg_scr/cadence/pnr_180nm/SUMMARY.txt',
    'reports/p8_dg_scr/cadence/pnr_180nm/genus/genus_area.rpt',
    'reports/p8_dg_scr/cadence/pnr_180nm/genus/genus_gates.rpt',
    'reports/p8_dg_scr/cadence/pnr_180nm/genus/genus_timing.rpt',
    'reports/p8_dg_scr/cadence/pnr_180nm/genus/genus_power.rpt',
    'reports/p8_dg_scr/cadence/pnr_180nm/genus/genus_qor.rpt',
    'reports/p8_dg_scr/cadence/pnr_180nm/contract_vcd_power/p7ge_genus_power_vcd_rtl2gate.rpt',
    'reports/p8_dg_scr/cadence/pnr_180nm/contract_vcd_power/p7ge_read_vcd_rtl2gate.log',
    'reports/p8_dg_scr/cadence/pnr_180nm/contract_vcd_power/p8dgscr_genus_power_vcd_rtl2gate.rpt',
    'reports/p8_dg_scr/cadence/pnr_180nm/contract_vcd_power/p8dgscr_read_vcd_rtl2gate.log',
    'reports/p8_dg_scr/cadence/pnr_180nm/pnr/p8dgscr_lec.rpt',
    'reports/p8_dg_scr/cadence/pnr_180nm/pnr/postroute_area.rpt',
    'reports/p8_dg_scr/cadence/pnr_180nm/pnr/postroute_setup_timing.rpt',
    'reports/p8_dg_scr/cadence/pnr_180nm/pnr/postroute_core_setup_timing.rpt',
    'reports/p8_dg_scr/cadence/pnr_180nm/pnr/postroute_cdc_setup_timing.rpt',
    'reports/p8_dg_scr/cadence/pnr_180nm/pnr/postroute_cdc_hold_timing.rpt',
    'reports/p8_dg_scr/cadence/pnr_180nm/pnr/postroute_clock_tree.rpt',
    'reports/p8_dg_scr/cadence/pnr_180nm/pnr/cdc_pair_placement.rpt',
    'reports/p8_dg_scr/cadence/pnr_180nm/pnr/postroute_hold_timing.rpt',
    'reports/p8_dg_scr/cadence/pnr_180nm/pnr/postroute_recovery_timing.rpt',
    'reports/p8_dg_scr/cadence/pnr_180nm/pnr/postroute_removal_timing.rpt',
    'reports/p8_dg_scr/cadence/pnr_180nm/pnr/postroute_power.rpt',
    'reports/p8_dg_scr/cadence/pnr_180nm/pnr/postroute_drc.rpt',
    'reports/p8_dg_scr/cadence/pnr_180nm/pnr/postroute_connectivity.rpt',
    'reports/p8_dg_scr/cadence/pnr_180nm/pnr/reset_timing_command_status.txt',
    'reports/p8_dg_scr/cadence/pnr_180nm/outputs/aer_pending_direct_gray_sync_core_reset_postroute.def',
    'reports/p8_dg_scr/cadence/pnr_180nm/outputs/aer_pending_direct_gray_sync_core_reset_postroute.v',
    'reports/p8_dg_scr/cadence/pnr_180nm/outputs/aer_pending_direct_gray_sync_core_reset_postroute.sdf',
    'reports/p8_dg_scr/cadence/pnr_180nm/outputs/aer_pending_direct_gray_sync_core_reset_postroute.spef',
    'reports/p8_dg_scr/cadence/pnr_180nm/logs/p8dgscr_xcelium_regression.log',
    'reports/p8_dg_scr/cadence/pnr_180nm/logs/p8dgscr_xcelium_fair.log',
    'reports/p8_dg_scr/cadence/pnr_180nm/logs/p8dgscr_xcelium_cdc.log',
    'reports/p8_dg_scr/cadence/pnr_180nm/logs/p8dgscr_xcelium_reset.log'
)

$lines = @(
    '# P8-DG-SCR evidence manifest — 2026-08-21',
    '',
    '아래 SHA-256과 byte 수는 최종 P8-DG-SCR RTL, 검증, 합성, LEC와 배치·배선 근거를 고정한다.',
    '180 nm 산출물은 서버 제공 FPR reference kit의 잠정 비교이며 주최측 공식 공정 sign-off가 아니다.',
    '',
    '| 파일 | bytes | SHA-256 |',
    '|---|---:|---|'
)

foreach ($relativePath in $files) {
    $nativePath = Join-Path $repoRoot ($relativePath -replace '/', '\')
    if (!(Test-Path -LiteralPath $nativePath -PathType Leaf)) {
        throw "Missing manifest input: $relativePath"
    }

    # Hash the exact staged blob, not the Windows working-tree bytes.  Git may
    # normalize CRLF to LF on add; a public manifest must match a clean clone.
    $startInfo = New-Object System.Diagnostics.ProcessStartInfo
    $startInfo.FileName = 'git'
    $startInfo.Arguments = "show :$relativePath"
    $startInfo.WorkingDirectory = $repoRoot
    $startInfo.UseShellExecute = $false
    $startInfo.CreateNoWindow = $true
    $startInfo.RedirectStandardOutput = $true
    $startInfo.RedirectStandardError = $true

    $process = New-Object System.Diagnostics.Process
    $process.StartInfo = $startInfo
    [void]$process.Start()
    $stream = New-Object IO.MemoryStream
    $process.StandardOutput.BaseStream.CopyTo($stream)
    $stderr = $process.StandardError.ReadToEnd()
    $process.WaitForExit()
    if ($process.ExitCode -ne 0) {
        throw "Cannot read staged blob ${relativePath}: $stderr"
    }

    $bytes = $stream.ToArray()
    $stream.Dispose()
    $sha256 = [Security.Cryptography.SHA256]::Create()
    try {
        $hash = ([BitConverter]::ToString($sha256.ComputeHash($bytes))).Replace('-', '').ToLowerInvariant()
    } finally {
        $sha256.Dispose()
    }
    $lines += "| ``$relativePath`` | $($bytes.Length) | ``$hash`` |"
}

$utf8 = New-Object System.Text.UTF8Encoding($false)
[IO.File]::WriteAllLines($output, $lines, $utf8)
"P8DGSCR_MANIFEST_READY=$output files=$($files.Count)"
