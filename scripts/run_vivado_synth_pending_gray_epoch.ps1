param(
    [string]$VivadoBin = 'C:\Xilinx\Vivado\2020.2\bin'
)

$ErrorActionPreference = 'Stop'
$repoRoot = (Resolve-Path -LiteralPath "$PSScriptRoot\..").Path
$vivado = Join-Path $VivadoBin 'vivado.bat'
$robustReportDir = Join-Path $repoRoot 'reports\pending_gray_epoch\vivado_robust'
$rawReportDir = Join-Path $repoRoot 'reports\pending_gray_epoch\vivado_raw_reset'
New-Item -ItemType Directory -Force -Path $robustReportDir, $rawReportDir | Out-Null

Push-Location $repoRoot
try {
    & $vivado -mode batch -source scripts/vivado_synth_pending_gray_epoch_robust.tcl `
        -log reports/pending_gray_epoch/vivado_robust/vivado.log `
        -journal reports/pending_gray_epoch/vivado_robust/vivado.jou
    if ($LASTEXITCODE -ne 0) {
        throw "P7-GE robust synthesis failed with exit code $LASTEXITCODE"
    }

    & $vivado -mode batch -source scripts/vivado_synth_pending_gray_epoch_raw.tcl `
        -log reports/pending_gray_epoch/vivado_raw_reset/vivado.log `
        -journal reports/pending_gray_epoch/vivado_raw_reset/vivado.jou
    if ($LASTEXITCODE -ne 0) {
        throw "P7-GE raw-reset synthesis failed with exit code $LASTEXITCODE"
    }
} finally {
    Pop-Location
}
