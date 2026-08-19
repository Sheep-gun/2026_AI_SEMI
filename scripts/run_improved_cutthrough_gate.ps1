param([string]$VivadoBin='C:\Xilinx\Vivado\2020.2\bin')
$ErrorActionPreference='Stop';$root=(Resolve-Path -LiteralPath "$PSScriptRoot\..").Path
$work=Join-Path $root 'sim\improved_cutthrough_gate_work';$logs=Join-Path $root 'sim\logs'
New-Item -ItemType Directory -Force -Path $work,$logs|Out-Null
Push-Location $work
try{
    & (Join-Path $VivadoBin 'xvlog.bat') --work worklib --log (Join-Path $logs 'improved_cutthrough_gate_compile.log') `
        (Join-Path $root 'reports\improved_cutthrough\vivado_sanity\aer_improved_cutthrough_post_synth.v')
    if($LASTEXITCODE-ne0){throw 'P4-C gate netlist compile failed.'}
    & (Join-Path $VivadoBin 'xvlog.bat') --sv --work worklib --define P4C_GATE_NETLIST --define AER_IMPROVED_GATE_NETLIST `
        --log (Join-Path $logs 'improved_cutthrough_gate_tb_compile.log') `
        (Join-Path $root 'tb\aer_improved_cutthrough_test_wrapper.sv') `
        (Join-Path $root 'tb\aer_improved_hybrid_tb.sv')
    if($LASTEXITCODE-ne0){throw 'P4-C gate TB compile failed.'}
    & (Join-Path $VivadoBin 'xelab.bat') worklib.aer_improved_hybrid_tb worklib.glbl -s improved_cutthrough_gate_sim --debug typical -L unisims_ver `
        --log (Join-Path $logs 'improved_cutthrough_gate_elaborate.log')
    if($LASTEXITCODE-ne0){throw 'P4-C gate elaboration failed.'}
    & (Join-Path $VivadoBin 'xsim.bat') improved_cutthrough_gate_sim --runall --log (Join-Path $logs 'improved_cutthrough_gate.log')
    if($LASTEXITCODE-ne0){throw 'P4-C gate simulation failed.'}
    if(!(Select-String -LiteralPath (Join-Path $logs 'improved_cutthrough_gate.log') -SimpleMatch 'TEST_PASS improved')){throw 'P4-C gate pass marker missing.'}
}finally{Pop-Location}
