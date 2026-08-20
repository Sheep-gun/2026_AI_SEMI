param(
    [string]$OutputDirectory = ''
)

$ErrorActionPreference = 'Stop'
$repoRoot = (Resolve-Path -LiteralPath "$PSScriptRoot\..").Path
if ([string]::IsNullOrWhiteSpace($OutputDirectory)) {
    $OutputDirectory = Join-Path $repoRoot 'tmp\p8dgscr_cadence_bundle'
}

$bundleRoot = [IO.Path]::GetFullPath($OutputDirectory)
$repoPrefix = $repoRoot.TrimEnd('\') + '\'
if (!$bundleRoot.StartsWith($repoPrefix, [StringComparison]::OrdinalIgnoreCase)) {
    throw "OutputDirectory must stay inside the repository: $bundleRoot"
}

$directories = @(
    'rtl\improved', 'tb', 'scripts\cadence', 'sim\waves',
    'reports', 'inputs', 'outputs', 'db', 'logs'
)
foreach ($directory in $directories) {
    New-Item -ItemType Directory -Force -Path (Join-Path $bundleRoot $directory) | Out-Null
}

$relativeFiles = @(
    'rtl\improved\aer_pending_direct_gray_sync_core_reset.sv',
    'rtl\improved\aer_pending_gray_epoch.sv',
    'tb\aer_p8_dgscr_wrappers.sv',
    'tb\aer_p8_dgscr_reset_tb.sv',
    'tb\aer_source_resident_tb.sv',
    'tb\aer_pending_gray_epoch_fair_tb.sv',
    'tb\aer_improved_cdc_phase_tb.sv',
    'scripts\cadence\p8dgscr_genus_explore.tcl',
    'scripts\cadence\p7ge_genus_contract_vcd_power_rtl2gate.tcl',
    'scripts\cadence\p8dgscr_genus_contract_vcd_power.tcl',
    'scripts\cadence\p8dgscr_lec.tcl',
    'scripts\cadence\p8dgscr_pnr.sdc',
    'scripts\cadence\p8dgscr_pnr.view',
    'scripts\cadence\p8dgscr_innovus.tcl',
    'scripts\cadence\p8dgscr_innovus_capture.tcl',
    'sim\waves\contract_fairness_p8_direct_gray_sync_core_reset.vcd',
    'sim\waves\contract_fairness_p7ge.vcd'
)

foreach ($relativeFile in $relativeFiles) {
    $source = Join-Path $repoRoot $relativeFile
    $destination = Join-Path $bundleRoot $relativeFile
    if (!(Test-Path -LiteralPath $source)) {
        throw "Missing bundle input: $source"
    }
    Copy-Item -LiteralPath $source -Destination $destination -Force
}

"P8DGSCR_CADENCE_BUNDLE_READY=$bundleRoot"
