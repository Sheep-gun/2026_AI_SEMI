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
$wrapper = Join-Path $repoRoot 'tb\aer_p8_candidate_wrappers.sv'

$candidates = @(
    @{
        Name = 'sparse_reset'
        Rtl = Join-Path $repoRoot 'rtl\improved\aer_pending_gray_epoch_sparse_reset.sv'
        Netlist = Join-Path $repoRoot 'reports\p8_candidates\vivado_sparse_reset\aer_pending_gray_epoch_sparse_reset_post_synth.v'
        Define = @()
    },
    @{
        Name = 'direct_gray'
        Rtl = Join-Path $repoRoot 'rtl\improved\aer_pending_direct_gray_sparse_reset.sv'
        Netlist = Join-Path $repoRoot 'reports\p8_candidates\vivado_direct_gray\aer_pending_direct_gray_sparse_reset_post_synth.v'
        Define = @('--define', 'P8_DIRECT_GRAY')
    }
)

$tests = @(
    @{
        Name = 'regression'
        Top = 'aer_source_resident_tb'
        Sources = @((Join-Path $repoRoot 'tb\aer_source_resident_tb.sv'))
        Marker = 'SOURCE_RESIDENT_TEST_PASS'
    },
    @{
        Name = 'fair'
        Top = 'aer_pending_gray_epoch_fair_tb'
        Sources = @((Join-Path $repoRoot 'tb\aer_pending_gray_epoch_fair_tb.sv'))
        Marker = 'P7_GRAY_EPOCH_FAIR_TEST_PASS'
    },
    @{
        Name = 'cdc'
        Top = 'aer_improved_cdc_phase_tb'
        Sources = @((Join-Path $repoRoot 'tb\aer_improved_cdc_phase_tb.sv'))
        Marker = 'CDC_PHASE_TEST_PASS trials=192'
    }
)

function Invoke-P8Test {
    param($Candidate, $Test, [ValidateSet('rtl','gate')][string]$RunMode)

    $workDir = Join-Path $repoRoot "sim\p8_$($Candidate.Name)_$($Test.Name)_${RunMode}_work"
    $snapshot = "p8_$($Candidate.Name)_$($Test.Name)_${RunMode}_sim"
    $logPath = Join-Path $logDir "p8_$($Candidate.Name)_$($Test.Name)_${RunMode}.log"
    New-Item -ItemType Directory -Force -Path $workDir | Out-Null

    Push-Location $workDir
    try {
        if ($RunMode -eq 'rtl') {
            & $xvlog --sv --work worklib @($Candidate.Define) $Candidate.Rtl $wrapper @($Test.Sources)
        } else {
            if (!(Test-Path -LiteralPath $Candidate.Netlist)) {
                throw "Missing P8 gate netlist: $($Candidate.Netlist)"
            }
            & $xvlog --work worklib $Candidate.Netlist
            if ($LASTEXITCODE -ne 0) { throw "P8 $($Candidate.Name) gate netlist compile failed" }
            & $xvlog --sv --work worklib @($Candidate.Define) $wrapper @($Test.Sources)
        }
        if ($LASTEXITCODE -ne 0) { throw "P8 $($Candidate.Name) $($Test.Name) $RunMode compile failed" }

        if ($RunMode -eq 'gate') {
            & $xelab "worklib.$($Test.Top)" worklib.glbl -L unisims_ver -s $snapshot --debug typical
        } else {
            & $xelab "worklib.$($Test.Top)" -s $snapshot --debug typical
        }
        if ($LASTEXITCODE -ne 0) { throw "P8 $($Candidate.Name) $($Test.Name) $RunMode elaboration failed" }

        & $xsim $snapshot --runall --log $logPath
        if ($LASTEXITCODE -ne 0) { throw "P8 $($Candidate.Name) $($Test.Name) $RunMode simulation failed" }
        if (!(Select-String -LiteralPath $logPath -SimpleMatch $Test.Marker)) {
            throw "P8 $($Candidate.Name) $($Test.Name) $RunMode PASS marker missing"
        }
    } finally {
        Pop-Location
    }
}

$runModes = if ($Mode -eq 'all') { @('rtl','gate') } else { @($Mode) }
foreach ($candidate in $candidates) {
    foreach ($runMode in $runModes) {
        foreach ($test in $tests) {
            Invoke-P8Test -Candidate $candidate -Test $test -RunMode $runMode
        }
    }
}
