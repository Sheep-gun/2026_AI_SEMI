param(
    [ValidateSet('rtl', 'gate')]
    [string]$Mode = 'rtl',
    [string]$VivadoBin = 'C:\Xilinx\Vivado\2020.2\bin'
)

$ErrorActionPreference = 'Stop'
$root = (Resolve-Path -LiteralPath "$PSScriptRoot\..").Path
$work = Join-Path $root "sim\improved_cdc_phase_${Mode}_work"
$logs = Join-Path $root 'sim\logs'
New-Item -ItemType Directory -Force -Path $work, $logs | Out-Null

$xvlog = Join-Path $VivadoBin 'xvlog.bat'
$xelab = Join-Path $VivadoBin 'xelab.bat'
$xsim = Join-Path $VivadoBin 'xsim.bat'
$tb = Join-Path $root 'tb\aer_improved_cdc_phase_tb.sv'
$runLog = Join-Path $logs "improved_cdc_phase_${Mode}.log"
$snapshot = "improved_cdc_phase_${Mode}_sim"

Push-Location $work
try {
    if ($Mode -eq 'rtl') {
        & $xvlog --sv --work worklib `
            --log (Join-Path $logs 'improved_cdc_phase_rtl_compile.log') `
            (Join-Path $root 'rtl\improved\aer_improved_hybrid.sv') $tb
        if ($LASTEXITCODE -ne 0) { throw 'RTL compile failed.' }
        & $xelab worklib.aer_improved_cdc_phase_tb -s $snapshot --debug typical `
            --log (Join-Path $logs 'improved_cdc_phase_rtl_elaborate.log')
    } else {
        & $xvlog --work worklib `
            --log (Join-Path $logs 'improved_cdc_phase_gate_compile.log') `
            (Join-Path $root 'reports\improved\vivado_sanity\aer_improved_hybrid_post_synth.v')
        if ($LASTEXITCODE -ne 0) { throw 'Gate netlist compile failed.' }
        & $xvlog --sv --work worklib --define AER_IMPROVED_GATE_NETLIST `
            --log (Join-Path $logs 'improved_cdc_phase_gate_tb_compile.log') $tb
        if ($LASTEXITCODE -ne 0) { throw 'Gate testbench compile failed.' }
        & $xelab worklib.aer_improved_cdc_phase_tb worklib.glbl -s $snapshot `
            --debug typical -L unisims_ver `
            --log (Join-Path $logs 'improved_cdc_phase_gate_elaborate.log')
    }
    if ($LASTEXITCODE -ne 0) { throw 'Elaboration failed.' }

    & $xsim $snapshot --tclbatch '../../scripts/xsim_improved_cdc_phase.tcl' `
        --log $runLog
    if ($LASTEXITCODE -ne 0) { throw 'Simulation failed.' }
    if (!(Select-String -LiteralPath $runLog -SimpleMatch 'CDC_PHASE_TEST_PASS')) {
        throw "CDC phase test did not pass in $Mode mode."
    }
} finally {
    Pop-Location
}

