param(
    [string]$VivadoBin = 'C:\Xilinx\Vivado\2020.2\bin'
)

$ErrorActionPreference = 'Stop'
$root = (Resolve-Path -LiteralPath "$PSScriptRoot\..").Path
$work = Join-Path $root 'sim\improved_gate_work'
$logs = Join-Path $root 'sim\logs'
New-Item -ItemType Directory -Force -Path $work, $logs | Out-Null

$xvlog = Join-Path $VivadoBin 'xvlog.bat'
$xelab = Join-Path $VivadoBin 'xelab.bat'
$xsim = Join-Path $VivadoBin 'xsim.bat'
$netlist = Join-Path $root 'reports\improved\vivado_sanity\aer_improved_hybrid_post_synth.v'
$tb = Join-Path $root 'tb\aer_improved_hybrid_tb.sv'
$runLog = Join-Path $logs 'improved_gate.log'

Push-Location $work
try {
    & $xvlog --work worklib --log (Join-Path $logs 'improved_gate_compile.log') $netlist
    if ($LASTEXITCODE -ne 0) { throw 'Gate netlist compile failed.' }
    & $xvlog --sv --work worklib --define AER_IMPROVED_GATE_NETLIST `
        --log (Join-Path $logs 'improved_gate_tb_compile.log') $tb
    if ($LASTEXITCODE -ne 0) { throw 'Gate testbench compile failed.' }
    & $xelab worklib.aer_improved_hybrid_tb worklib.glbl `
        -s improved_gate_sim --debug typical -L unisims_ver `
        --log (Join-Path $logs 'improved_gate_elaborate.log')
    if ($LASTEXITCODE -ne 0) { throw 'Gate elaboration failed.' }
    & $xsim improved_gate_sim --tclbatch '../../scripts/xsim_improved_gate.tcl' `
        --log '../logs/improved_gate.log'
    if ($LASTEXITCODE -ne 0) { throw 'Gate simulation failed.' }
    if (!(Select-String -LiteralPath $runLog -SimpleMatch 'TEST_PASS improved')) {
        throw 'Post-synthesis simulation did not report TEST_PASS.'
    }
} finally {
    Pop-Location
}

