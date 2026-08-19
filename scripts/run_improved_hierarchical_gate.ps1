param(
    [string]$VivadoBin = 'C:\Xilinx\Vivado\2020.2\bin'
)

$ErrorActionPreference = 'Stop'
$root = (Resolve-Path -LiteralPath "$PSScriptRoot\..").Path
$work = Join-Path $root 'sim\improved_hierarchical_gate_work'
$logs = Join-Path $root 'sim\logs'
New-Item -ItemType Directory -Force -Path $work, $logs | Out-Null

Push-Location $work
try {
    & (Join-Path $VivadoBin 'xvlog.bat') --work worklib `
        --log (Join-Path $logs 'improved_hierarchical_gate_compile.log') `
        (Join-Path $root 'reports\improved_hierarchical\vivado_sanity\aer_improved_hierarchical_post_synth.v')
    if ($LASTEXITCODE -ne 0) { throw 'P2 gate netlist compile failed.' }

    & (Join-Path $VivadoBin 'xvlog.bat') --sv --work worklib `
        --define P2_GATE_NETLIST --define AER_IMPROVED_GATE_NETLIST `
        --log (Join-Path $logs 'improved_hierarchical_gate_tb_compile.log') `
        (Join-Path $root 'tb\aer_improved_hierarchical_test_wrapper.sv') `
        (Join-Path $root 'tb\aer_improved_hybrid_tb.sv')
    if ($LASTEXITCODE -ne 0) { throw 'P2 gate testbench compile failed.' }

    & (Join-Path $VivadoBin 'xelab.bat') worklib.aer_improved_hybrid_tb worklib.glbl `
        -s improved_hierarchical_gate_sim --debug typical -L unisims_ver `
        --log (Join-Path $logs 'improved_hierarchical_gate_elaborate.log')
    if ($LASTEXITCODE -ne 0) { throw 'P2 gate elaboration failed.' }

    & (Join-Path $VivadoBin 'xsim.bat') improved_hierarchical_gate_sim `
        --tclbatch '../../scripts/xsim_improved_hierarchical_gate.tcl' `
        --log '../logs/improved_hierarchical_gate.log'
    if ($LASTEXITCODE -ne 0) { throw 'P2 gate simulation failed.' }
    if (!(Select-String -LiteralPath (Join-Path $logs 'improved_hierarchical_gate.log') `
            -SimpleMatch 'TEST_PASS improved')) {
        throw 'P2 gate simulation did not report TEST_PASS.'
    }
} finally {
    Pop-Location
}

