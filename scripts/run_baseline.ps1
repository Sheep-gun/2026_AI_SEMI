param(
    [string]$VivadoBin = 'C:\Xilinx\Vivado\2020.2\bin'
)

$ErrorActionPreference = 'Stop'
$projectRoot = (Resolve-Path -LiteralPath "$PSScriptRoot\..").Path
$xvlog = Join-Path $VivadoBin 'xvlog.bat'
$xelab = Join-Path $VivadoBin 'xelab.bat'
$xsim = Join-Path $VivadoBin 'xsim.bat'
$work = Join-Path $projectRoot 'sim\work'
$logs = Join-Path $projectRoot 'sim\logs'
$waves = Join-Path $projectRoot 'sim\waves'
$compileLog = Join-Path $logs 'baseline_compile.log'
$elabLog = Join-Path $logs 'baseline_elaborate.log'
$runLog = Join-Path $logs 'baseline.log'
$snapshot = 'aer_traditional_sim'

foreach ($tool in @($xvlog, $xelab, $xsim)) {
    if (!(Test-Path -LiteralPath $tool)) {
        throw "Vivado Simulator tool not found at $tool"
    }
}

New-Item -ItemType Directory -Force -Path $work, $logs, $waves | Out-Null

$rtl = Join-Path $projectRoot 'rtl\baseline\aer_traditional.sv'
$tb = Join-Path $projectRoot 'tb\aer_traditional_tb.sv'

Push-Location $work
try {
    & $xvlog --sv -d AER_ENABLE_SVA --work worklib --log $compileLog $rtl $tb
    if ($LASTEXITCODE -ne 0) { throw "xvlog failed with exit code $LASTEXITCODE" }

    & $xelab worklib.aer_traditional_tb -s $snapshot --debug typical --log $elabLog
    if ($LASTEXITCODE -ne 0) { throw "xelab failed with exit code $LASTEXITCODE" }

    # Vivado Simulator 2020.2 can split absolute arguments containing spaces
    # when it builds the internal xsimk command. Use work-relative paths here.
    & $xsim $snapshot --tclbatch '../../scripts/xsim_baseline.tcl' `
        --wdb '../waves/aer_traditional.wdb' --log '../logs/baseline.log'
    if ($LASTEXITCODE -ne 0) { throw "xsim failed with exit code $LASTEXITCODE" }

    if (!(Select-String -LiteralPath $runLog -SimpleMatch 'TEST_PASS baseline')) {
        throw 'Simulation returned zero but TEST_PASS marker was not found.'
    }
} finally {
    Pop-Location
}
