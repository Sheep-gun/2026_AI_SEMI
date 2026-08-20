param(
    [string]$OutputDirectory = '',
    [string]$Tclsh = ''
)

$ErrorActionPreference = 'Stop'
$repoRoot = (Resolve-Path -LiteralPath "$PSScriptRoot\..").Path
if ([string]::IsNullOrWhiteSpace($OutputDirectory)) {
    $OutputDirectory = Join-Path $repoRoot 'tmp\p9grr_cadence_bundle'
}

$bundleRoot = [IO.Path]::GetFullPath($OutputDirectory)
$repoPrefix = $repoRoot.TrimEnd('\') + '\'
if (!$bundleRoot.StartsWith($repoPrefix, [StringComparison]::OrdinalIgnoreCase)) {
    throw "OutputDirectory must stay inside the repository: $bundleRoot"
}

$directories = @(
    'rtl\experiments', 'scripts\cadence', 'sim\waves',
    'reports\p9grr', 'reports\p9grr_contract_vcd',
    'reports\p9grr_pnr', 'inputs', 'outputs\p9grr_pnr',
    'db', 'logs'
)
foreach ($directory in $directories) {
    New-Item -ItemType Directory -Force -Path (Join-Path $bundleRoot $directory) | Out-Null
}

$relativeFiles = @(
    'rtl\experiments\aer_pending_gray_rank_reuse_sync_core_reset.sv',
    'sim\waves\p9_grr_contract.vcd',
    'scripts\cadence\p9grr_genus_explore.tcl',
    'scripts\cadence\p9grr_genus_contract_vcd_power.tcl',
    'scripts\cadence\p9grr_postroute_saif_power.tcl',
    'scripts\cadence\p9grr_lec.tcl',
    'scripts\cadence\p9grr_pnr.sdc',
    'scripts\cadence\p9grr_pnr.view',
    'scripts\cadence\p9grr_innovus.tcl',
    'scripts\cadence\p9grr_innovus_capture.tcl',
    'scripts\cadence\p9grr_bundle_selfcheck.tcl',
    'scripts\cadence\P9GRR_FLOW_NOTES.md'
)
$expectedRtlSha256 = 'E59EF53C7F5B56155030B02A3FF6854B8DA8762EBBCEE31982F784CF4DA8DF68'

foreach ($relativeFile in $relativeFiles) {
    $source = Join-Path $repoRoot $relativeFile
    $destination = Join-Path $bundleRoot $relativeFile
    if (!(Test-Path -LiteralPath $source)) {
        throw "Missing P9-GRR bundle input: $source"
    }
    Copy-Item -LiteralPath $source -Destination $destination -Force
    $sourceHash = (Get-FileHash -LiteralPath $source -Algorithm SHA256).Hash
    $destinationHash = (Get-FileHash -LiteralPath $destination -Algorithm SHA256).Hash
    if ($relativeFile -eq 'rtl\experiments\aer_pending_gray_rank_reuse_sync_core_reset.sv' -and
        $sourceHash -ne $expectedRtlSha256) {
        throw "P9-GRR signoff RTL hash changed: expected=$expectedRtlSha256 actual=$sourceHash"
    }
    if ($sourceHash -ne $destinationHash) {
        throw "P9-GRR bundle copy hash mismatch: $relativeFile"
    }
}

# Reject the old remote workaround explicitly.  Every standalone Tcl that
# resolves files must derive its root from [info script], never [pwd].
$standaloneTcl = $relativeFiles | Where-Object { $_ -like '*.tcl' }
foreach ($relativeFile in $standaloneTcl) {
    $path = Join-Path $bundleRoot $relativeFile
    if (Select-String -LiteralPath $path -SimpleMatch '[pwd]') {
        throw "Bundle-relative path violation ([pwd]) in $relativeFile"
    }
}

if ([string]::IsNullOrWhiteSpace($Tclsh)) {
    $command = Get-Command tclsh -ErrorAction SilentlyContinue
    if ($null -eq $command) {
        $command = Get-Command xtclsh.bat -ErrorAction SilentlyContinue
    }
    if ($null -ne $command) {
        $Tclsh = $command.Source
    } else {
        $knownVivadoTclsh = 'C:\Xilinx\Vivado\2020.2\bin\xtclsh.bat'
        if (Test-Path -LiteralPath $knownVivadoTclsh) {
            $Tclsh = $knownVivadoTclsh
        }
    }
}
if ([string]::IsNullOrWhiteSpace($Tclsh) -or !(Test-Path -LiteralPath $Tclsh)) {
    throw 'A Tcl interpreter is required for the bundle self-check. Use -Tclsh.'
}

$selfCheck = Join-Path $bundleRoot 'scripts\cadence\p9grr_bundle_selfcheck.tcl'
$foreignWorkingDirectory = Join-Path $repoRoot 'rtl'
Push-Location $foreignWorkingDirectory
try {
    & $Tclsh $selfCheck static
    if ($LASTEXITCODE -ne 0) {
        throw "P9-GRR Tcl bundle self-check failed with exit code $LASTEXITCODE"
    }
} finally {
    Pop-Location
}

"P9GRR_CADENCE_BUNDLE_READY=$bundleRoot"
"P9GRR_CADENCE_BUNDLE_SELFCHECK=PASS_FROM_FOREIGN_CWD"
"P9GRR_RUN=genus -files $bundleRoot/scripts/cadence/p9grr_genus_explore.tcl"
"P9GRR_RUN=genus -files $bundleRoot/scripts/cadence/p9grr_genus_contract_vcd_power.tcl"
"P9GRR_RUN=lec -nogui -dofile $bundleRoot/scripts/cadence/p9grr_lec.tcl"
"P9GRR_RUN=innovus -no_gui -files $bundleRoot/scripts/cadence/p9grr_innovus.tcl"
"P9GRR_RUN=innovus -no_gui -files $bundleRoot/scripts/cadence/p9grr_postroute_saif_power.tcl"
