param(
    [string]$VivadoBin = 'C:\Xilinx\Vivado\2020.2\bin'
)

$ErrorActionPreference = 'Stop'
$repoRoot = (Resolve-Path -LiteralPath "$PSScriptRoot\..").Path
$reportDir = Join-Path $repoRoot 'reports\p8_candidates\vivado_direct_gray_sync_core_reset'
New-Item -ItemType Directory -Force -Path $reportDir | Out-Null

Push-Location $repoRoot
try {
    & (Join-Path $VivadoBin 'vivado.bat') -mode batch `
        -source scripts/vivado_synth_p8_dgscr.tcl `
        -log reports/p8_candidates/vivado_direct_gray_sync_core_reset/vivado.log `
        -journal reports/p8_candidates/vivado_direct_gray_sync_core_reset/vivado.jou
    if ($LASTEXITCODE -ne 0) {
        throw "P8-DG-SCR synthesis failed with exit code $LASTEXITCODE"
    }
} finally {
    Pop-Location
}
