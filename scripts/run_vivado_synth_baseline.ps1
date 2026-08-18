param(
    [string]$VivadoBin = 'C:\Xilinx\Vivado\2020.2\bin'
)

$ErrorActionPreference = 'Stop'
$projectRoot = (Resolve-Path -LiteralPath "$PSScriptRoot\..").Path
$vivado = Join-Path $VivadoBin 'vivado.bat'
$reportDir = Join-Path $projectRoot 'reports\baseline\vivado_sanity'
$summary = Join-Path $reportDir 'summary.txt'

if (!(Test-Path -LiteralPath $vivado)) {
    throw "Vivado not found at $vivado"
}

New-Item -ItemType Directory -Force -Path $reportDir | Out-Null

Push-Location $projectRoot
try {
    & $vivado -mode batch -notrace `
        -source 'scripts/vivado_synth_baseline.tcl' `
        -journal 'reports/baseline/vivado_sanity/vivado.jou' `
        -log 'reports/baseline/vivado_sanity/vivado.log'
    if ($LASTEXITCODE -ne 0) {
        throw "Vivado synthesis sanity check failed with exit code $LASTEXITCODE"
    }
    if (!(Test-Path -LiteralPath $summary)) {
        throw 'Vivado returned zero but summary.txt was not generated.'
    }
    if (!(Select-String -LiteralPath $summary -SimpleMatch 'SANITY_PASS')) {
        throw 'Vivado returned zero but SANITY_PASS marker was not found.'
    }
} finally {
    Pop-Location
}

