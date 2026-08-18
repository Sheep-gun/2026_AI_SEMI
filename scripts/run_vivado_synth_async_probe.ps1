param(
    [string]$VivadoBin = 'C:\Xilinx\Vivado\2020.2\bin'
)

$ErrorActionPreference = 'Stop'
$projectRoot = (Resolve-Path -LiteralPath "$PSScriptRoot\..").Path
$vivado = Join-Path $VivadoBin 'vivado.bat'
$reportDir = Join-Path $projectRoot 'reports\async_baseline\vivado_probe'
$summary = Join-Path $reportDir 'summary.txt'

if (!(Test-Path -LiteralPath $vivado)) {
    throw "Vivado not found at $vivado"
}

New-Item -ItemType Directory -Force -Path $reportDir | Out-Null

Push-Location $projectRoot
try {
    & $vivado -mode batch -notrace `
        -source 'scripts/vivado_synth_async_probe.tcl' `
        -journal 'reports/async_baseline/vivado_probe/vivado_async_probe.jou' `
        -log 'reports/async_baseline/vivado_probe/vivado_async_probe.log'
    if ($LASTEXITCODE -ne 0) {
        throw "Vivado asynchronous synthesis probe failed with exit code $LASTEXITCODE"
    }
    if (!(Test-Path -LiteralPath $summary)) {
        throw 'Vivado returned zero but async probe summary.txt was not generated.'
    }
    if (!(Select-String -LiteralPath $summary -SimpleMatch 'ASYNC_SYNTH_PROBE_PASS')) {
        throw 'Vivado returned zero but ASYNC_SYNTH_PROBE_PASS marker was not found.'
    }
} finally {
    Pop-Location
}
