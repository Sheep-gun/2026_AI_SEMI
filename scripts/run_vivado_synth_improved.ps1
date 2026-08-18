param(
    [string]$VivadoBin = 'C:\Xilinx\Vivado\2020.2\bin'
)

$ErrorActionPreference = 'Stop'
$root = (Resolve-Path -LiteralPath "$PSScriptRoot\..").Path
$reportDir = Join-Path $root 'reports\improved\vivado_sanity'
New-Item -ItemType Directory -Force -Path $reportDir | Out-Null

Push-Location $root
try {
    & (Join-Path $VivadoBin 'vivado.bat') -mode batch -notrace `
        -source 'scripts/vivado_synth_improved.tcl' `
        -journal 'reports/improved/vivado_sanity/vivado_improved.jou' `
        -log 'reports/improved/vivado_sanity/vivado_improved.log'
    if ($LASTEXITCODE -ne 0) { throw "Vivado improved synthesis failed with exit code $LASTEXITCODE" }
    if (!(Select-String -LiteralPath (Join-Path $reportDir 'summary.txt') -SimpleMatch 'IMPROVED_SYNTH_PASS')) {
        throw 'Vivado returned zero but IMPROVED_SYNTH_PASS marker was not found.'
    }
} finally {
    Pop-Location
}
