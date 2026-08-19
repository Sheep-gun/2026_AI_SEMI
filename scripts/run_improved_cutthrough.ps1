param([string]$VivadoBin='C:\Xilinx\Vivado\2020.2\bin')
$ErrorActionPreference='Stop';$root=(Resolve-Path -LiteralPath "$PSScriptRoot\..").Path
$work=Join-Path $root 'sim\improved_cutthrough_work';$logs=Join-Path $root 'sim\logs';$waves=Join-Path $root 'sim\waves'
New-Item -ItemType Directory -Force -Path $work,$logs,$waves|Out-Null
Push-Location $work
try{
    & (Join-Path $VivadoBin 'xvlog.bat') --sv --work worklib --log (Join-Path $logs 'improved_cutthrough_compile.log') `
        (Join-Path $root 'rtl\improved\aer_improved_cutthrough.sv') `
        (Join-Path $root 'tb\aer_improved_cutthrough_test_wrapper.sv') `
        (Join-Path $root 'tb\aer_improved_hybrid_tb.sv')
    if($LASTEXITCODE-ne0){throw 'P4-C compile failed.'}
    & (Join-Path $VivadoBin 'xelab.bat') worklib.aer_improved_hybrid_tb -s improved_cutthrough_sim --debug typical `
        --log (Join-Path $logs 'improved_cutthrough_elaborate.log')
    if($LASTEXITCODE-ne0){throw 'P4-C elaboration failed.'}
    & (Join-Path $VivadoBin 'xsim.bat') improved_cutthrough_sim --runall --log (Join-Path $logs 'improved_cutthrough.log')
    if($LASTEXITCODE-ne0){throw 'P4-C simulation failed.'}
    if(!(Select-String -LiteralPath (Join-Path $logs 'improved_cutthrough.log') -SimpleMatch 'TEST_PASS improved')){throw 'P4-C pass marker missing.'}
}finally{Pop-Location}
