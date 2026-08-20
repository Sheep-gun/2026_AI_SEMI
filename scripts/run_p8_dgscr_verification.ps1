param(
    [ValidateSet('rtl','gate','all')]
    [string]$Mode = 'all',
    [string]$VivadoBin = 'C:\Xilinx\Vivado\2020.2\bin'
)

$ErrorActionPreference = 'Stop'
$repoRoot = (Resolve-Path -LiteralPath "$PSScriptRoot\..").Path
$logDir = Join-Path $repoRoot 'sim\logs'
New-Item -ItemType Directory -Force -Path $logDir | Out-Null

$xvlog = Join-Path $VivadoBin 'xvlog.bat'
$xelab = Join-Path $VivadoBin 'xelab.bat'
$xsim = Join-Path $VivadoBin 'xsim.bat'
$rtl = Join-Path $repoRoot 'rtl\improved\aer_pending_direct_gray_sync_core_reset.sv'
$netlist = Join-Path $repoRoot 'reports\p8_candidates\vivado_direct_gray_sync_core_reset\aer_pending_direct_gray_sync_core_reset_post_synth.v'
$wrapper = Join-Path $repoRoot 'tb\aer_p8_dgscr_wrappers.sv'

$tests = @(
    @{
        Name = 'regression'; Top = 'aer_source_resident_tb'
        Source = Join-Path $repoRoot 'tb\aer_source_resident_tb.sv'
        Marker = 'SOURCE_RESIDENT_TEST_PASS'
    },
    @{
        Name = 'fair'; Top = 'aer_pending_gray_epoch_fair_tb'
        Source = Join-Path $repoRoot 'tb\aer_pending_gray_epoch_fair_tb.sv'
        Marker = 'P7_GRAY_EPOCH_FAIR_TEST_PASS'
    },
    @{
        Name = 'cdc'; Top = 'aer_improved_cdc_phase_tb'
        Source = Join-Path $repoRoot 'tb\aer_improved_cdc_phase_tb.sv'
        Marker = 'CDC_PHASE_TEST_PASS trials=192'
    },
    @{
        Name = 'reset'; Top = 'aer_p8_dgscr_reset_tb'
        Source = Join-Path $repoRoot 'tb\aer_p8_dgscr_reset_tb.sv'
        Marker = 'P8_DGSCR_RESET_TEST_PASS'
    }
)

function Invoke-P8DgscrTest {
    param($Test, [ValidateSet('rtl','gate')][string]$RunMode)

    $workDir = Join-Path $repoRoot "sim\p8_dgscr_$($Test.Name)_${RunMode}_work"
    $snapshot = "p8_dgscr_$($Test.Name)_${RunMode}_sim"
    $logPath = Join-Path $logDir "p8_dgscr_$($Test.Name)_${RunMode}.log"
    New-Item -ItemType Directory -Force -Path $workDir | Out-Null

    Push-Location $workDir
    try {
        if ($RunMode -eq 'rtl') {
            & $xvlog --sv --work worklib $rtl $wrapper $Test.Source
        } else {
            if (!(Test-Path -LiteralPath $netlist)) { throw "Missing P8-DG-SCR netlist: $netlist" }
            & $xvlog --work worklib $netlist
            if ($LASTEXITCODE -ne 0) { throw 'P8-DG-SCR gate netlist compile failed' }
            & $xvlog --sv --work worklib $wrapper $Test.Source
        }
        if ($LASTEXITCODE -ne 0) { throw "P8-DG-SCR $($Test.Name) $RunMode compile failed" }

        if ($RunMode -eq 'gate') {
            & $xelab "worklib.$($Test.Top)" worklib.glbl -L unisims_ver -s $snapshot --debug typical
        } else {
            & $xelab "worklib.$($Test.Top)" -s $snapshot --debug typical
        }
        if ($LASTEXITCODE -ne 0) { throw "P8-DG-SCR $($Test.Name) $RunMode elaboration failed" }

        & $xsim $snapshot --runall --log $logPath
        if ($LASTEXITCODE -ne 0) { throw "P8-DG-SCR $($Test.Name) $RunMode simulation failed" }
        if (!(Select-String -LiteralPath $logPath -SimpleMatch $Test.Marker)) {
            throw "P8-DG-SCR $($Test.Name) $RunMode PASS marker missing"
        }
    } finally {
        Pop-Location
    }
}

$runModes = if ($Mode -eq 'all') { @('rtl','gate') } else { @($Mode) }
foreach ($runMode in $runModes) {
    foreach ($test in $tests) {
        Invoke-P8DgscrTest -Test $test -RunMode $runMode
    }
}
