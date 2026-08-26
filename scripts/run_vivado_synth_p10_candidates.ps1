param([string]$VivadoBin='C:\Xilinx\Vivado\2020.2\bin')
$ErrorActionPreference='Stop'
$repoRoot=(Resolve-Path -LiteralPath "$PSScriptRoot\..").Path
$vivado=Join-Path $VivadoBin 'vivado.bat'
New-Item -ItemType Directory -Force (Join-Path $repoRoot 'reports\p10_final')|Out-Null
Push-Location $repoRoot
try {
    & $vivado -mode batch -source scripts/vivado_synth_p10_candidates.tcl `
        -log reports/p10_final/vivado_synth.log `
        -journal reports/p10_final/vivado_synth.jou
    if($LASTEXITCODE-ne0){throw 'P10 candidate synthesis failed'}
} finally { Pop-Location }
