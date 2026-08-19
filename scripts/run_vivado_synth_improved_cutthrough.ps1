param([string]$VivadoBin='C:\Xilinx\Vivado\2020.2\bin')
$ErrorActionPreference='Stop';$root=(Resolve-Path -LiteralPath "$PSScriptRoot\..").Path
$logs=Join-Path $root 'sim\logs';New-Item -ItemType Directory -Force -Path $logs|Out-Null
Push-Location $root
try{
    & (Join-Path $VivadoBin 'vivado.bat') -mode batch -notrace -source scripts/vivado_synth_improved_cutthrough.tcl `
        -log (Join-Path $logs 'vivado_synth_improved_cutthrough.log') -journal (Join-Path $logs 'vivado_synth_improved_cutthrough.jou')
    if($LASTEXITCODE-ne0){throw 'P4-C synthesis failed.'}
    if(!(Select-String -LiteralPath 'reports\improved_cutthrough\vivado_sanity\summary.txt' -SimpleMatch 'P4C_SYNTH_PASS')){throw 'P4-C synth marker missing.'}
}finally{Pop-Location}
