param([string]$VivadoBin='C:\Xilinx\Vivado\2020.2\bin')
$ErrorActionPreference='Stop'
$root=(Resolve-Path -LiteralPath "$PSScriptRoot\..").Path
$work=Join-Path $root 'sim\epoch_variants_work'
$log=Join-Path $root 'sim\logs\epoch_variants.log'
New-Item -ItemType Directory -Force -Path $work,(Split-Path $log) | Out-Null
Push-Location $work
try {
    & (Join-Path $VivadoBin 'xvlog.bat') --sv --work worklib `
        (Join-Path $root 'rtl\experiments\aer_pending_epoch_variants.sv') `
        (Join-Path $root 'tb\aer_pending_epoch_variants_tb.sv')
    if($LASTEXITCODE-ne0){throw 'Epoch variant RTL compile failed.'}
    & (Join-Path $VivadoBin 'xelab.bat') `
        worklib.aer_pending_epoch_variants_tb -s epoch_variants_sim
    if($LASTEXITCODE-ne0){throw 'Epoch variant elaboration failed.'}
    & (Join-Path $VivadoBin 'xsim.bat') epoch_variants_sim --runall --log $log
    if($LASTEXITCODE-ne0 -or !(Select-String -LiteralPath $log `
        -SimpleMatch 'P7_EPOCH_VARIANTS_TEST_PASS')){
        throw 'Epoch variant self-check failed.'
    }
} finally { Pop-Location }

Push-Location $root
try {
    & (Join-Path $VivadoBin 'vivado.bat') -mode batch -notrace `
        -source scripts/vivado_synth_epoch_variants.tcl `
        -log reports/epoch_variants/vivado.log `
        -journal reports/epoch_variants/vivado.jou
    if($LASTEXITCODE-ne0){throw 'Epoch variant synthesis failed.'}
} finally { Pop-Location }
