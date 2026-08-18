param(
    [string]$VivadoBin = 'C:\Xilinx\Vivado\2020.2\bin'
)

$ErrorActionPreference = 'Stop'
$projectRoot = (Resolve-Path -LiteralPath "$PSScriptRoot\..").Path
$xvlog = Join-Path $VivadoBin 'xvlog.bat'
$xelab = Join-Path $VivadoBin 'xelab.bat'
$xsim = Join-Path $VivadoBin 'xsim.bat'
$work = Join-Path $projectRoot 'sim\async_work'
$logs = Join-Path $projectRoot 'sim\logs'
$waves = Join-Path $projectRoot 'sim\waves'
$compileLog = Join-Path $logs 'async_baseline_compile.log'
$elabLog = Join-Path $logs 'async_baseline_elaborate.log'
$runLog = Join-Path $logs 'async_baseline.log'
$snapshot = 'aer_traditional_async_sim'

foreach ($tool in @($xvlog, $xelab, $xsim)) {
    if (!(Test-Path -LiteralPath $tool)) {
        throw "Vivado Simulator tool not found at $tool"
    }
}

New-Item -ItemType Directory -Force -Path $work, $logs, $waves | Out-Null

$rtl = Join-Path $projectRoot 'rtl\async_baseline\aer_traditional_async.sv'
$tb = Join-Path $projectRoot 'tb\aer_traditional_async_tb.sv'

Push-Location $work
try {
    & $xvlog --sv --work worklib --log $compileLog $rtl $tb
    if ($LASTEXITCODE -ne 0) { throw "xvlog failed with exit code $LASTEXITCODE" }

    & $xelab worklib.aer_traditional_async_tb -s $snapshot --debug typical --log $elabLog
    if ($LASTEXITCODE -ne 0) { throw "xelab failed with exit code $LASTEXITCODE" }

    & $xsim $snapshot --tclbatch '../../scripts/xsim_async_baseline.tcl' `
        --wdb '../waves/aer_traditional_async.wdb' --log '../logs/async_baseline.log'
    if ($LASTEXITCODE -ne 0) { throw "xsim failed with exit code $LASTEXITCODE" }

    if (!(Select-String -LiteralPath $runLog -SimpleMatch 'TEST_PASS async_baseline')) {
        throw 'Simulation returned zero but TEST_PASS async_baseline marker was not found.'
    }
} finally {
    Pop-Location
}
