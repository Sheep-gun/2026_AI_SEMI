param(
    [ValidateSet('rtl','gate','all')]
    [string]$Mode = 'all',
    [string]$VivadoBin = 'C:\Xilinx\Vivado\2020.2\bin'
)

$ErrorActionPreference = 'Stop'
$repoRoot = (Resolve-Path -LiteralPath "$PSScriptRoot\..").Path
$logRoot = Join-Path $repoRoot 'sim\logs'
New-Item -ItemType Directory -Force -Path $logRoot | Out-Null

$xvlog = Join-Path $VivadoBin 'xvlog.bat'
$xelab = Join-Path $VivadoBin 'xelab.bat'
$xsim = Join-Path $VivadoBin 'xsim.bat'
$wrapper = Join-Path $repoRoot 'tb\aer_pending_gray_epoch_cdc_wrapper.sv'
$testbench = Join-Path $repoRoot 'tb\aer_improved_cdc_phase_tb.sv'

function Invoke-P7CdcPhase {
    param([ValidateSet('rtl','gate')][string]$RunMode)

    $work = Join-Path $repoRoot "sim\p7ge_cdc_${RunMode}_work"
    $snapshot = "p7ge_cdc_${RunMode}_sim"
    $runLog = Join-Path $logRoot "p7ge_cdc_${RunMode}.log"
    New-Item -ItemType Directory -Force -Path $work | Out-Null

    Push-Location $work
    try {
        if ($RunMode -eq 'rtl') {
            & $xvlog --sv --work worklib `
                (Join-Path $repoRoot 'rtl\improved\aer_pending_gray_epoch.sv') `
                $wrapper $testbench
            if ($LASTEXITCODE -ne 0) { throw 'P7-GE CDC RTL compile failed' }
            & $xelab worklib.aer_improved_cdc_phase_tb -s $snapshot --debug typical
        } else {
            & $xvlog --work worklib `
                (Join-Path $repoRoot 'reports\pending_gray_epoch\vivado_robust\aer_pending_gray_epoch_robust_post_synth.v')
            if ($LASTEXITCODE -ne 0) { throw 'P7-GE CDC gate compile failed' }
            & $xvlog --sv --work worklib --define AER_IMPROVED_GATE_NETLIST `
                $wrapper $testbench
            if ($LASTEXITCODE -ne 0) { throw 'P7-GE CDC gate TB compile failed' }
            & $xelab worklib.aer_improved_cdc_phase_tb worklib.glbl -s $snapshot `
                --debug typical -L unisims_ver
        }
        if ($LASTEXITCODE -ne 0) { throw "P7-GE CDC $RunMode elaboration failed" }

        & $xsim $snapshot --runall --log $runLog
        if ($LASTEXITCODE -ne 0) { throw "P7-GE CDC $RunMode simulation failed" }
        if (!(Select-String -LiteralPath $runLog -SimpleMatch 'CDC_PHASE_TEST_PASS trials=192')) {
            throw "P7-GE CDC $RunMode PASS marker missing"
        }
    } finally {
        Pop-Location
    }
}

$runs = if ($Mode -eq 'all') { @('rtl','gate') } else { @($Mode) }
foreach ($run in $runs) {
    Invoke-P7CdcPhase -RunMode $run
}
