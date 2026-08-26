param([string]$VivadoBin='C:\Xilinx\Vivado\2020.2\bin')
$ErrorActionPreference='Stop'
$root=(Resolve-Path -LiteralPath "$PSScriptRoot\..").Path
$work=Join-Path $root 'sim\t0_paa_45nm_work'
$log=Join-Path $root 'sim\logs\t0_paa_45nm_rtl.log'
New-Item -ItemType Directory -Force $work,(Split-Path $log)|Out-Null
Push-Location $work
try{
    & (Join-Path $VivadoBin 'xvlog.bat') --sv --work worklib `
        (Join-Path $root 'tb\gsclib045_latch_delay_models.sv') `
        (Join-Path $root 'rtl\traditional_async\aer_traditional_latch_paa_45nm.sv') `
        (Join-Path $root 'tb\aer_traditional_latch_paa_45nm_wrapper.sv') `
        (Join-Path $root 'tb\aer_traditional_async_tb.sv')
    if($LASTEXITCODE-ne0){throw 'T0-45 compile failed'}
    & (Join-Path $VivadoBin 'xelab.bat') worklib.aer_traditional_async_tb -s t0_paa_45nm_sim --debug typical
    if($LASTEXITCODE-ne0){throw 'T0-45 elaborate failed'}
    & (Join-Path $VivadoBin 'xsim.bat') t0_paa_45nm_sim --runall --log $log
    if($LASTEXITCODE-ne0-or!(Select-String -LiteralPath $log -SimpleMatch 'TEST_PASS async_baseline')){
        throw 'T0-45 simulation failed'
    }
}finally{Pop-Location}
"T0_PAA_45NM_RTL_PASS log=$log"
