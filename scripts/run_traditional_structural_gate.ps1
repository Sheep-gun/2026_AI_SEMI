param(
    [ValidateSet('main', 'race')]
    [string]$Suite = 'main',
    [string]$VivadoBin = 'C:\Xilinx\Vivado\2020.2\bin'
)

$ErrorActionPreference = 'Stop'
$root = (Resolve-Path -LiteralPath "$PSScriptRoot\..").Path
$work = Join-Path $root 'sim\traditional_async_gate_work'
$logs = Join-Path $root 'sim\logs'
New-Item -ItemType Directory -Force -Path $work, $logs | Out-Null

$xvlog = Join-Path $VivadoBin 'xvlog.bat'
$xelab = Join-Path $VivadoBin 'xelab.bat'
$xsim = Join-Path $VivadoBin 'xsim.bat'
$netlist = Join-Path $root 'reports\traditional_async\vivado_probe\aer_traditional_structural_post_synth.v'
$wrapper = Join-Path $root 'tb\aer_traditional_structural_test_wrapper.sv'

if ($Suite -eq 'main') {
    $tb = Join-Path $root 'tb\aer_traditional_async_tb.sv'
    $top = 'worklib.aer_traditional_async_tb'
    $snapshot = 'traditional_structural_gate_sim'
    $runLog = Join-Path $logs 'traditional_structural_gate.log'
    $passMarker = 'TEST_PASS async_baseline'
} else {
    $tb = Join-Path $root 'tb\aer_traditional_structural_race_tb.sv'
    $top = 'worklib.aer_traditional_structural_race_tb'
    $snapshot = 'traditional_structural_gate_race_sim'
    $runLog = Join-Path $logs 'traditional_structural_gate_race.log'
    $passMarker = 'RACE_TEST_PASS digital_model'
}

Push-Location $work
try {
    & $xvlog --work worklib --log (Join-Path $logs "traditional_structural_gate_${Suite}_compile.log") $netlist
    if ($LASTEXITCODE -ne 0) { throw 'Gate netlist compile failed.' }
    & $xvlog --sv --work worklib --define TRAD_STRUCT_GATE_NETLIST `
        --define AER_GATE_NETLIST `
        --log (Join-Path $logs "traditional_structural_gate_${Suite}_tb_compile.log") `
        $wrapper $tb
    if ($LASTEXITCODE -ne 0) { throw 'Gate testbench compile failed.' }
    & $xelab $top worklib.glbl -s $snapshot --debug typical -L unisims_ver `
        --log (Join-Path $logs "traditional_structural_gate_${Suite}_elaborate.log")
    if ($LASTEXITCODE -ne 0) { throw 'Gate elaboration failed.' }
    & $xsim $snapshot --runall --log $runLog
    if ($LASTEXITCODE -ne 0) { throw 'Gate simulation failed.' }
    if (!(Select-String -LiteralPath $runLog -SimpleMatch $passMarker)) {
        throw "Post-synthesis $Suite simulation did not report its pass marker."
    }
} finally {
    Pop-Location
}

