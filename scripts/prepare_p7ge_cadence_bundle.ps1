param(
    [string]$OutputDirectory = ''
)

$ErrorActionPreference = 'Stop'
$repoRoot = (Resolve-Path -LiteralPath "$PSScriptRoot\..").Path
if ([string]::IsNullOrWhiteSpace($OutputDirectory)) {
    $OutputDirectory = Join-Path $repoRoot 'tmp\p7ge_cadence_bundle'
}

$bundleRoot = [IO.Path]::GetFullPath($OutputDirectory)
$repoPrefix = $repoRoot.TrimEnd('\') + '\'
if (!$bundleRoot.StartsWith($repoPrefix, [StringComparison]::OrdinalIgnoreCase)) {
    throw "OutputDirectory must stay inside the repository: $bundleRoot"
}

foreach ($directory in @('rtl','tb','scripts','waves','reports','inputs','outputs','db','logs')) {
    New-Item -ItemType Directory -Force -Path (Join-Path $bundleRoot $directory) | Out-Null
}

$copies = @{
    'rtl\aer_pending_gray_epoch.sv' = 'rtl\improved\aer_pending_gray_epoch.sv'
    'rtl\aer_improved_cutthrough.sv' = 'rtl\improved\aer_improved_cutthrough.sv'
    'tb\aer_source_resident_tb.sv' = 'tb\aer_source_resident_tb.sv'
    'tb\aer_pending_gray_epoch_regression_wrapper.sv' = 'tb\aer_pending_gray_epoch_regression_wrapper.sv'
    'tb\aer_pending_gray_epoch_frozen_wrapper.sv' = 'tb\aer_pending_gray_epoch_frozen_wrapper.sv'
    'tb\aer_pending_gray_epoch_fair_tb.sv' = 'tb\aer_pending_gray_epoch_fair_tb.sv'
    'scripts\p7ge_genus_explore.tcl' = 'scripts\cadence\p7ge_genus_explore.tcl'
    'scripts\p7ge_innovus.tcl' = 'scripts\cadence\p7ge_innovus.tcl'
    'scripts\p7ge_innovus_capture.tcl' = 'scripts\cadence\p7ge_innovus_capture.tcl'
    'scripts\p7ge_lec.tcl' = 'scripts\cadence\p7ge_lec.tcl'
    'scripts\p7ge_pnr.sdc' = 'scripts\cadence\p7ge_pnr.sdc'
    'scripts\p7ge_pnr.view' = 'scripts\cadence\p7ge_pnr.view'
    'scripts\p7ge_genus_contract_vcd_power.tcl' = 'scripts\cadence\p7ge_genus_contract_vcd_power.tcl'
    'scripts\p4c_genus_contract_vcd_power.tcl' = 'scripts\cadence\p4c_genus_contract_vcd_power.tcl'
    'waves\contract_fairness_p4c.vcd' = 'sim\waves\contract_fairness_p4c.vcd'
    'waves\contract_fairness_p7ge.vcd' = 'sim\waves\contract_fairness_p7ge.vcd'
}

foreach ($entry in $copies.GetEnumerator()) {
    $source = Join-Path $repoRoot $entry.Value
    $destination = Join-Path $bundleRoot $entry.Key
    if (!(Test-Path -LiteralPath $source)) {
        throw "Missing bundle input: $source"
    }
    Copy-Item -LiteralPath $source -Destination $destination -Force
}

"P7GE_CADENCE_BUNDLE_READY=$bundleRoot"
