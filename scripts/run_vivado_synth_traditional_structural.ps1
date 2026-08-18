param(
    [string]$VivadoBin = 'C:\Xilinx\Vivado\2020.2\bin'
)

$ErrorActionPreference = 'Stop'
$root = (Resolve-Path -LiteralPath "$PSScriptRoot\..").Path
$vivado = Join-Path $VivadoBin 'vivado.bat'
$reportDir = Join-Path $root 'reports\traditional_async\vivado_probe'
$summary = Join-Path $reportDir 'summary.txt'
New-Item -ItemType Directory -Force -Path $reportDir | Out-Null

Push-Location $root
try {
    & $vivado -mode batch -notrace `
        -source 'scripts/vivado_synth_traditional_structural.tcl' `
        -journal 'reports/traditional_async/vivado_probe/vivado_traditional_structural.jou' `
        -log 'reports/traditional_async/vivado_probe/vivado_traditional_structural.log'
    if ($LASTEXITCODE -ne 0) {
        throw "Vivado structural asynchronous synthesis failed with exit code $LASTEXITCODE"
    }
    if (!(Select-String -LiteralPath $summary -SimpleMatch 'TRADITIONAL_STRUCTURAL_SYNTH_PASS')) {
        throw 'Synthesis returned zero but pass marker was not found.'
    }
} finally {
    Pop-Location
}
