param([ValidateSet('rtl','gate')][string]$Mode='rtl', [string]$VivadoBin='C:\Xilinx\Vivado\2020.2\bin')
$ErrorActionPreference='Stop'
$root=(Resolve-Path -LiteralPath "$PSScriptRoot\..").Path
$work=Join-Path $root "sim\improved_homeostatic_cdc_${Mode}_work"
$logs=Join-Path $root 'sim\logs'
New-Item -ItemType Directory -Force -Path $work,$logs|Out-Null
$xvlog=Join-Path $VivadoBin 'xvlog.bat';$xelab=Join-Path $VivadoBin 'xelab.bat';$xsim=Join-Path $VivadoBin 'xsim.bat'
$wrapper=Join-Path $root 'tb\aer_improved_homeostatic_test_wrapper.sv';$tb=Join-Path $root 'tb\aer_improved_cdc_phase_tb.sv'
$runLog=Join-Path $logs "improved_homeostatic_cdc_${Mode}.log";$snapshot="improved_homeostatic_cdc_${Mode}_sim"
Push-Location $work
try {
    if($Mode -eq 'rtl'){
        & $xvlog --sv --work worklib --log (Join-Path $logs 'improved_homeostatic_cdc_rtl_compile.log') `
            (Join-Path $root 'rtl\improved\aer_improved_homeostatic.sv') $wrapper $tb
        if($LASTEXITCODE -ne 0){throw 'P4 CDC RTL compile failed.'}
        & $xelab worklib.aer_improved_cdc_phase_tb -s $snapshot --debug typical `
            --log (Join-Path $logs 'improved_homeostatic_cdc_rtl_elaborate.log')
    } else {
        & $xvlog --work worklib --log (Join-Path $logs 'improved_homeostatic_cdc_gate_compile.log') `
            (Join-Path $root 'reports\improved_homeostatic\vivado_sanity\aer_improved_homeostatic_post_synth.v')
        if($LASTEXITCODE -ne 0){throw 'P4 CDC gate compile failed.'}
        & $xvlog --sv --work worklib --define P4_GATE_NETLIST --define AER_IMPROVED_GATE_NETLIST `
            --log (Join-Path $logs 'improved_homeostatic_cdc_gate_tb_compile.log') $wrapper $tb
        if($LASTEXITCODE -ne 0){throw 'P4 CDC gate TB compile failed.'}
        & $xelab worklib.aer_improved_cdc_phase_tb worklib.glbl -s $snapshot --debug typical -L unisims_ver `
            --log (Join-Path $logs 'improved_homeostatic_cdc_gate_elaborate.log')
    }
    if($LASTEXITCODE -ne 0){throw 'P4 CDC elaboration failed.'}
    & $xsim $snapshot --tclbatch '../../scripts/xsim_improved_cdc_phase.tcl' --log $runLog
    if($LASTEXITCODE -ne 0){throw 'P4 CDC simulation failed.'}
    if(!(Select-String -LiteralPath $runLog -SimpleMatch 'CDC_PHASE_TEST_PASS')){throw 'P4 CDC pass marker missing.'}
} finally {Pop-Location}
