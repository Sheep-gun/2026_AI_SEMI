param([string]$VivadoBin = 'C:\Xilinx\Vivado\2020.2\bin')
$ErrorActionPreference = 'Stop'
$root = (Resolve-Path -LiteralPath "$PSScriptRoot\..").Path
$logs = Join-Path $root 'sim\logs'
New-Item -ItemType Directory -Force -Path $logs | Out-Null
Push-Location $root
try {
    & (Join-Path $VivadoBin 'vivado.bat') -mode batch -notrace `
        -source scripts/vivado_synth_improved_homeostatic.tcl `
        -log (Join-Path $logs 'vivado_synth_improved_homeostatic.log') `
        -journal (Join-Path $logs 'vivado_synth_improved_homeostatic.jou')
    if ($LASTEXITCODE -ne 0) { throw 'P4 Vivado synthesis failed.' }
    if (!(Select-String -LiteralPath (Join-Path $root 'reports\improved_homeostatic\vivado_sanity\summary.txt') -SimpleMatch 'P4_SYNTH_PASS')) {
        throw 'P4 synthesis pass marker missing.'
    }
} finally { Pop-Location }
