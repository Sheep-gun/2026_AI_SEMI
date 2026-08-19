param(
    [string]$VivadoBin = 'C:\Xilinx\Vivado\2020.2\bin'
)

$ErrorActionPreference = 'Stop'
$root = (Resolve-Path -LiteralPath "$PSScriptRoot\..").Path
$logs = Join-Path $root 'sim\logs'
New-Item -ItemType Directory -Force -Path $logs | Out-Null

Push-Location $root
try {
    & (Join-Path $VivadoBin 'vivado.bat') -mode batch -notrace `
        -source scripts/vivado_synth_improved_hierarchical.tcl `
        -log (Join-Path $logs 'vivado_synth_improved_hierarchical.log') `
        -journal (Join-Path $logs 'vivado_synth_improved_hierarchical.jou')
    if ($LASTEXITCODE -ne 0) { throw 'P2 Vivado synthesis failed.' }
    if (!(Select-String -LiteralPath `
            (Join-Path $root 'reports\improved_hierarchical\vivado_sanity\summary.txt') `
            -SimpleMatch 'P2_SYNTH_PASS')) {
        throw 'P2 synthesis pass marker was not found.'
    }
} finally {
    Pop-Location
}

