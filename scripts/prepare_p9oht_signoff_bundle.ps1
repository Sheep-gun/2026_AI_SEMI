param(
    [string]$OutputDirectory = ''
)

$ErrorActionPreference = 'Stop'
$repoRoot = (Resolve-Path -LiteralPath "$PSScriptRoot\..").Path
if ([string]::IsNullOrWhiteSpace($OutputDirectory)) {
    $OutputDirectory = Join-Path $repoRoot 'tmp\p9oht_signoff_bundle'
}

$bundleRoot = [IO.Path]::GetFullPath($OutputDirectory)
$repoPrefix = $repoRoot.TrimEnd('\') + '\'
if (!$bundleRoot.StartsWith($repoPrefix, [StringComparison]::OrdinalIgnoreCase)) {
    throw "OutputDirectory must stay inside the repository: $bundleRoot"
}

$directories = @(
    'rtl\improved', 'scripts\cadence', 'sim\waves',
    'reports\p9oht', 'reports\p9oht_contract_vcd', 'reports\p9oht_pnr',
    'inputs', 'outputs\p9oht_pnr', 'db', 'logs'
)
foreach ($directory in $directories) {
    New-Item -ItemType Directory -Force -Path (Join-Path $bundleRoot $directory) | Out-Null
}

$relativeFiles = @(
    'rtl\improved\aer_pending_direct_gray_sync_core_reset.sv',
    'rtl\improved\aer_pending_direct_gray_scr_onehot_tree.sv',
    'sim\waves\p9_onehot_tree_contract.vcd',
    'scripts\cadence\p9oht_genus_explore.tcl',
    'scripts\cadence\p9oht_genus_contract_vcd_power.tcl',
    'scripts\cadence\p9oht_lec.tcl',
    'scripts\cadence\p9oht_p8_seq_lec.tcl',
    'scripts\cadence\p9oht_pnr.sdc',
    'scripts\cadence\p9oht_pnr.view',
    'scripts\cadence\p9oht_innovus.tcl',
    'scripts\cadence\p9oht_postroute_saif_power.tcl',
    'scripts\cadence\p9oht_innovus_capture.tcl'
)

foreach ($relativeFile in $relativeFiles) {
    $source = Join-Path $repoRoot $relativeFile
    $destination = Join-Path $bundleRoot $relativeFile
    if (!(Test-Path -LiteralPath $source)) {
        throw "Missing bundle input: $source"
    }
    Copy-Item -LiteralPath $source -Destination $destination -Force
}

"P9OHT_SIGNOFF_BUNDLE_READY=$bundleRoot"
"P9OHT_SIGNOFF_RUN=genus -files scripts/cadence/p9oht_genus_explore.tcl"
"P9OHT_SIGNOFF_RUN=genus -files scripts/cadence/p9oht_genus_contract_vcd_power.tcl"
"P9OHT_SIGNOFF_RUN=lec -nogui -dofile scripts/cadence/p9oht_lec.tcl"
"P9OHT_SIGNOFF_RUN=lec -nogui -dofile scripts/cadence/p9oht_p8_seq_lec.tcl"
"P9OHT_SIGNOFF_RUN=innovus -no_gui -files scripts/cadence/p9oht_innovus.tcl"
"P9OHT_SIGNOFF_RUN=innovus -no_gui -files scripts/cadence/p9oht_postroute_saif_power.tcl"
