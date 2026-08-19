param([ValidateSet('rtl','gate')][string]$Mode='rtl',[string]$VivadoBin='C:\Xilinx\Vivado\2020.2\bin')
$ErrorActionPreference='Stop';$root=(Resolve-Path -LiteralPath "$PSScriptRoot\..").Path
$work=Join-Path $root "sim\improved_homeostatic_order_${Mode}_work";$logs=Join-Path $root 'sim\logs'
New-Item -ItemType Directory -Force -Path $work,$logs|Out-Null
$xvlog=Join-Path $VivadoBin 'xvlog.bat';$xelab=Join-Path $VivadoBin 'xelab.bat';$xsim=Join-Path $VivadoBin 'xsim.bat'
$wrapper=Join-Path $root 'tb\aer_improved_homeostatic_order_wrapper.sv';$tb=Join-Path $root 'tb\aer_improved_hierarchical_order_tb.sv'
$snapshot="improved_homeostatic_order_${Mode}_sim";$runLog=Join-Path $logs "improved_homeostatic_order_${Mode}.log"
Push-Location $work
try{
    if($Mode-eq'rtl'){
        & $xvlog --sv --work worklib --log (Join-Path $logs 'improved_homeostatic_order_rtl_compile.log') `
            (Join-Path $root 'rtl\improved\aer_improved_homeostatic.sv') $wrapper $tb
        if($LASTEXITCODE-ne0){throw 'P4 order RTL compile failed.'}
        & $xelab worklib.aer_improved_hierarchical_order_tb -s $snapshot --debug typical `
            --log (Join-Path $logs 'improved_homeostatic_order_rtl_elaborate.log')
    }else{
        & $xvlog --work worklib --log (Join-Path $logs 'improved_homeostatic_order_gate_compile.log') `
            (Join-Path $root 'reports\improved_homeostatic\vivado_sanity\aer_improved_homeostatic_post_synth.v')
        if($LASTEXITCODE-ne0){throw 'P4 order gate compile failed.'}
        & $xvlog --sv --work worklib --define P4_GATE_NETLIST --define P2_GATE_NETLIST `
            --log (Join-Path $logs 'improved_homeostatic_order_gate_tb_compile.log') $wrapper $tb
        if($LASTEXITCODE-ne0){throw 'P4 order gate TB compile failed.'}
        & $xelab worklib.aer_improved_hierarchical_order_tb worklib.glbl -s $snapshot --debug typical -L unisims_ver `
            --log (Join-Path $logs 'improved_homeostatic_order_gate_elaborate.log')
    }
    if($LASTEXITCODE-ne0){throw 'P4 order elaboration failed.'}
    & $xsim $snapshot --runall --log $runLog
    if($LASTEXITCODE-ne0){throw 'P4 order simulation failed.'}
    if(!(Select-String -LiteralPath $runLog -SimpleMatch 'P2_ORDER_TEST_PASS')){throw 'P4 order pass marker missing.'}
}finally{Pop-Location}
