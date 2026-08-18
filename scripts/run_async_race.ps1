param(
    [string]$VivadoBin = 'C:\Xilinx\Vivado\2020.2\bin'
)

$ErrorActionPreference = 'Stop'
$projectRoot = (Resolve-Path -LiteralPath "$PSScriptRoot\..").Path
$xvlog = Join-Path $VivadoBin 'xvlog.bat'
$xelab = Join-Path $VivadoBin 'xelab.bat'
$xsim = Join-Path $VivadoBin 'xsim.bat'
$work = Join-Path $projectRoot 'sim\async_race_work'
$logs = Join-Path $projectRoot 'sim\logs'
$waves = Join-Path $projectRoot 'sim\waves'
$runLog = Join-Path $logs 'async_race.log'
$snapshot = 'aer_traditional_async_race_sim'

foreach ($tool in @($xvlog, $xelab, $xsim)) {
    if (!(Test-Path -LiteralPath $tool)) {
        throw "Vivado Simulator tool not found at $tool"
    }
}

New-Item -ItemType Directory -Force -Path $work, $logs, $waves | Out-Null
$rtl = Join-Path $projectRoot 'rtl\async_baseline\aer_traditional_async.sv'
$tb = Join-Path $projectRoot 'tb\aer_traditional_async_race_tb.sv'

Push-Location $work
try {
    & $xvlog --sv --work worklib --log (Join-Path $logs 'async_race_compile.log') $rtl $tb
    if ($LASTEXITCODE -ne 0) { throw "xvlog failed with exit code $LASTEXITCODE" }

    & $xelab worklib.aer_traditional_async_race_tb -s $snapshot --debug typical `
        --log (Join-Path $logs 'async_race_elaborate.log')
    if ($LASTEXITCODE -ne 0) { throw "xelab failed with exit code $LASTEXITCODE" }

    & $xsim $snapshot --tclbatch '../../scripts/xsim_async_race.tcl' `
        --wdb '../waves/aer_traditional_async_race.wdb' --log '../logs/async_race.log'
    if ($LASTEXITCODE -ne 0) { throw "xsim failed with exit code $LASTEXITCODE" }

    if (!(Select-String -LiteralPath $runLog -SimpleMatch 'RACE_TEST_PASS digital_model')) {
        throw 'Simulation returned zero but RACE_TEST_PASS marker was not found.'
    }
} finally {
    Pop-Location
}
