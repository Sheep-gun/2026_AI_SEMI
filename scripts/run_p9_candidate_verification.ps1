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
$wrapper = Join-Path $repoRoot 'tb\aer_p9_candidate_wrappers.sv'

$candidates = @(
    @{
        Name='onehot_tree'; Macro='P9_ONEHOT_TREE';
        Rtl='rtl\improved\aer_pending_direct_gray_scr_onehot_tree.sv';
        Top='aer_pending_direct_gray_scr_onehot_tree'
    },
    @{
        Name='loop_reduce'; Macro='P9_LOOP_REDUCE';
        Rtl='rtl\improved\aer_pending_direct_gray_scr_loop_reduce.sv';
        Top='aer_pending_direct_gray_scr_loop_reduce'
    },
    @{
        Name='onehot_decode'; Macro='P9_ONEHOT_DECODE';
        Rtl='rtl\improved\aer_pending_direct_gray_scr_onehot_decode.sv';
        Top='aer_pending_direct_gray_scr_onehot_decode'
    }
)

$tests = @(
    @{Name='broad'; Top='aer_source_resident_tb'; Source='tb\aer_source_resident_tb.sv'; Marker='SOURCE_RESIDENT_TEST_PASS'},
    @{Name='fair'; Top='aer_pending_gray_epoch_fair_tb'; Source='tb\aer_pending_gray_epoch_fair_tb.sv'; Marker='P7_GRAY_EPOCH_FAIR_TEST_PASS'},
    @{Name='cdc'; Top='aer_improved_cdc_phase_tb'; Source='tb\aer_improved_cdc_phase_tb.sv'; Marker='CDC_PHASE_TEST_PASS trials=192'},
    @{Name='reset'; Top='aer_p8_dgscr_reset_tb'; Source='tb\aer_p8_dgscr_reset_tb.sv'; Marker='P8_DGSCR_RESET_TEST_PASS'},
    @{Name='contract'; Top='aer_contract_fairness_tb'; Source='tb\aer_contract_fairness_tb.sv'; Marker='AER_CONTRACT_FAIRNESS_PASS'}
)

function Invoke-P9Test {
    param($Candidate, $Test, [ValidateSet('rtl','gate')][string]$RunMode)
    $work = Join-Path $repoRoot "sim\p9_$($Candidate.Name)_$($Test.Name)_${RunMode}_work"
    $snapshot = "p9_$($Candidate.Name)_$($Test.Name)_${RunMode}_sim"
    $log = Join-Path $logDir "p9_$($Candidate.Name)_$($Test.Name)_${RunMode}.log"
    New-Item -ItemType Directory -Force -Path $work | Out-Null

    Push-Location $work
    try {
        if ($RunMode -eq 'rtl') {
            & $xvlog --sv --work worklib --define $Candidate.Macro `
                (Join-Path $repoRoot $Candidate.Rtl) $wrapper (Join-Path $repoRoot $Test.Source)
        } else {
            $netlist = Join-Path $repoRoot "reports\p9_candidates\vivado_$($Candidate.Name)\$($Candidate.Top)_post_synth.v"
            if (!(Test-Path -LiteralPath $netlist)) { throw "Missing P9 netlist: $netlist" }
            & $xvlog --work worklib $netlist
            if ($LASTEXITCODE -ne 0) { throw "P9 $($Candidate.Name) netlist compile failed" }
            & $xvlog --sv --work worklib --define $Candidate.Macro `
                $wrapper (Join-Path $repoRoot $Test.Source)
        }
        if ($LASTEXITCODE -ne 0) { throw "P9 $($Candidate.Name) $($Test.Name) compile failed" }

        if ($RunMode -eq 'gate') {
            & $xelab "worklib.$($Test.Top)" worklib.glbl -L unisims_ver -s $snapshot --debug typical
        } else {
            & $xelab "worklib.$($Test.Top)" -s $snapshot --debug typical
        }
        if ($LASTEXITCODE -ne 0) { throw "P9 $($Candidate.Name) $($Test.Name) elaboration failed" }
        & $xsim $snapshot --runall --log $log
        if ($LASTEXITCODE -ne 0) { throw "P9 $($Candidate.Name) $($Test.Name) simulation failed" }
        if (!(Select-String -LiteralPath $log -SimpleMatch $Test.Marker)) {
            throw "P9 $($Candidate.Name) $($Test.Name) PASS marker missing"
        }
    } finally {
        Pop-Location
    }
}

$runModes = if ($Mode -eq 'all') { @('rtl','gate') } else { @($Mode) }
foreach ($runMode in $runModes) {
    foreach ($candidate in $candidates) {
        foreach ($test in $tests) {
            Invoke-P9Test -Candidate $candidate -Test $test -RunMode $runMode
        }
    }
}

if ($Mode -ne 'gate') {
    $work = Join-Path $repoRoot 'sim\p9_cycle_equivalence_work'
    $snapshot = 'p9_cycle_equivalence_sim'
    $log = Join-Path $logDir 'p9_cycle_equivalence_rtl.log'
    New-Item -ItemType Directory -Force -Path $work | Out-Null
    Push-Location $work
    try {
        & $xvlog --sv --work worklib `
            (Join-Path $repoRoot 'rtl\improved\aer_pending_direct_gray_sync_core_reset.sv') `
            (Join-Path $repoRoot 'rtl\improved\aer_pending_direct_gray_scr_onehot_tree.sv') `
            (Join-Path $repoRoot 'rtl\improved\aer_pending_direct_gray_scr_loop_reduce.sv') `
            (Join-Path $repoRoot 'rtl\improved\aer_pending_direct_gray_scr_onehot_decode.sv') `
            (Join-Path $repoRoot 'tb\aer_p9_cycle_equivalence_tb.sv')
        if ($LASTEXITCODE -ne 0) { throw 'P9 cycle-equivalence compile failed' }
        & $xelab worklib.aer_p9_cycle_equivalence_tb -s $snapshot --debug typical
        if ($LASTEXITCODE -ne 0) { throw 'P9 cycle-equivalence elaboration failed' }
        & $xsim $snapshot --runall --log $log
        if ($LASTEXITCODE -ne 0) { throw 'P9 cycle-equivalence simulation failed' }
        if (!(Select-String -LiteralPath $log -SimpleMatch 'P9_CYCLE_EQUIVALENCE_PASS')) {
            throw 'P9 cycle-equivalence PASS marker missing'
        }
    } finally {
        Pop-Location
    }
}
