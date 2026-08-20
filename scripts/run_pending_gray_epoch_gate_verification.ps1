param(
    [string]$VivadoBin = 'C:\Xilinx\Vivado\2020.2\bin'
)

$ErrorActionPreference = 'Stop'
$repoRoot = (Resolve-Path -LiteralPath "$PSScriptRoot\..").Path
$workDir = Join-Path $repoRoot 'sim\p7ge_gate_work'
$logDir = Join-Path $repoRoot 'sim\logs'
$netlist = Join-Path $repoRoot `
    'reports\pending_gray_epoch\vivado_robust\aer_pending_gray_epoch_robust_post_synth.v'
New-Item -ItemType Directory -Force -Path $workDir, $logDir | Out-Null

if (!(Test-Path -LiteralPath $netlist)) {
    throw "Missing P7-GE robust netlist: $netlist"
}

Push-Location $workDir
try {
    & (Join-Path $VivadoBin 'xvlog.bat') --work worklib $netlist
    if ($LASTEXITCODE -ne 0) { throw 'P7-GE gate netlist compile failed' }
    & (Join-Path $VivadoBin 'xvlog.bat') --sv --work worklib `
        (Join-Path $repoRoot 'tb\aer_pending_gray_epoch_gate_wrapper.sv') `
        (Join-Path $repoRoot 'tb\aer_pending_gray_epoch_fair_tb.sv')
    if ($LASTEXITCODE -ne 0) { throw 'P7-GE gate testbench compile failed' }

    & (Join-Path $VivadoBin 'xelab.bat') worklib.aer_pending_gray_epoch_fair_tb `
        worklib.glbl -L unisims_ver -s p7ge_gate_sim --debug typical
    if ($LASTEXITCODE -ne 0) { throw 'P7-GE gate elaboration failed' }

    $logPath = Join-Path $logDir 'p7ge_gate_fair.log'
    & (Join-Path $VivadoBin 'xsim.bat') p7ge_gate_sim --runall --log $logPath
    if ($LASTEXITCODE -ne 0) { throw 'P7-GE gate simulation failed' }
    if (!(Select-String -LiteralPath $logPath -SimpleMatch 'P7_GRAY_EPOCH_FAIR_TEST_PASS')) {
        throw 'P7-GE gate PASS marker was not found'
    }
} finally {
    Pop-Location
}
