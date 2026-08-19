param([string]$VivadoBin = 'C:\Xilinx\Vivado\2020.2\bin')
$ErrorActionPreference = 'Stop'
$root = (Resolve-Path -LiteralPath "$PSScriptRoot\..").Path
$work = Join-Path $root 'sim\improved_depth1_gate_work'
$logs = Join-Path $root 'sim\logs'
New-Item -ItemType Directory -Force -Path $work, $logs | Out-Null
Push-Location $work
try {
    & (Join-Path $VivadoBin 'xvlog.bat') --work worklib --log (Join-Path $logs 'improved_depth1_gate_compile.log') `
        (Join-Path $root 'reports\improved_depth1\vivado_sanity\aer_improved_depth1_post_synth.v')
    if ($LASTEXITCODE -ne 0) { throw 'P3 gate netlist compile failed.' }
    & (Join-Path $VivadoBin 'xvlog.bat') --sv --work worklib --define P3_GATE_NETLIST --define AER_IMPROVED_GATE_NETLIST `
        --log (Join-Path $logs 'improved_depth1_gate_tb_compile.log') `
        (Join-Path $root 'tb\aer_improved_depth1_test_wrapper.sv') `
        (Join-Path $root 'tb\aer_improved_hybrid_tb.sv')
    if ($LASTEXITCODE -ne 0) { throw 'P3 gate TB compile failed.' }
    & (Join-Path $VivadoBin 'xelab.bat') worklib.aer_improved_hybrid_tb worklib.glbl `
        -s improved_depth1_gate_sim --debug typical -L unisims_ver `
        --log (Join-Path $logs 'improved_depth1_gate_elaborate.log')
    if ($LASTEXITCODE -ne 0) { throw 'P3 gate elaboration failed.' }
    & (Join-Path $VivadoBin 'xsim.bat') improved_depth1_gate_sim --runall `
        --log (Join-Path $logs 'improved_depth1_gate.log')
    if ($LASTEXITCODE -ne 0) { throw 'P3 gate simulation failed.' }
    if (!(Select-String -LiteralPath (Join-Path $logs 'improved_depth1_gate.log') -SimpleMatch 'TEST_PASS improved')) {
        throw 'P3 gate TEST_PASS missing.'
    }
} finally { Pop-Location }

