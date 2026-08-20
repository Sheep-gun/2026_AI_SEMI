param(
    [ValidateSet('rtl','gate','all')][string]$Mode = 'all',
    [string]$VivadoBin = 'C:\Xilinx\Vivado\2020.2\bin'
)

$ErrorActionPreference = 'Stop'
$repoRoot = (Resolve-Path -LiteralPath "$PSScriptRoot\..").Path
$logDir = Join-Path $repoRoot 'sim\logs'
New-Item -ItemType Directory -Force -Path $logDir | Out-Null
$xvlog = Join-Path $VivadoBin 'xvlog.bat'
$xelab = Join-Path $VivadoBin 'xelab.bat'
$xsim = Join-Path $VivadoBin 'xsim.bat'
$rtl = Join-Path $repoRoot 'rtl\experiments\aer_pending_direct_gray_oht_epoch_variants.sv'
$wrapper = Join-Path $repoRoot 'tb\aer_p9_epoch_variant_wrappers.sv'

$candidates = @(
    @{Name='case'; Macro='P9_EPOCH_CASE'; Top='aer_pending_direct_gray_oht_epoch_case'},
    @{Name='boolean'; Macro='P9_EPOCH_BOOLEAN'; Top='aer_pending_direct_gray_oht_epoch_boolean'},
    @{Name='grant_toggle'; Macro='P9_EPOCH_GRANT_TOGGLE'; Top='aer_pending_direct_gray_oht_epoch_grant_toggle'}
)
$tests = @(
    @{Name='broad'; Top='aer_source_resident_tb'; Source='tb\aer_source_resident_tb.sv'; Marker='SOURCE_RESIDENT_TEST_PASS'},
    @{Name='fair'; Top='aer_pending_gray_epoch_fair_tb'; Source='tb\aer_pending_gray_epoch_fair_tb.sv'; Marker='P7_GRAY_EPOCH_FAIR_TEST_PASS'},
    @{Name='cdc'; Top='aer_improved_cdc_phase_tb'; Source='tb\aer_improved_cdc_phase_tb.sv'; Marker='CDC_PHASE_TEST_PASS trials=192'},
    @{Name='reset'; Top='aer_p8_dgscr_reset_tb'; Source='tb\aer_p8_dgscr_reset_tb.sv'; Marker='P8_DGSCR_RESET_TEST_PASS'},
    @{Name='contract'; Top='aer_contract_fairness_tb'; Source='tb\aer_contract_fairness_tb.sv'; Marker='AER_CONTRACT_FAIRNESS_PASS'}
)

function Invoke-EpochTest {
    param($Candidate, $Test, [string]$RunMode)
    $work = Join-Path $repoRoot "sim\p9_epoch_$($Candidate.Name)_$($Test.Name)_${RunMode}_work"
    $snapshot = "p9_epoch_$($Candidate.Name)_$($Test.Name)_${RunMode}_sim"
    $log = Join-Path $logDir "p9_epoch_$($Candidate.Name)_$($Test.Name)_${RunMode}.log"
    New-Item -ItemType Directory -Force -Path $work | Out-Null
    Push-Location $work
    try {
        if ($RunMode -eq 'rtl') {
            & $xvlog --sv --work worklib --define $Candidate.Macro `
                $rtl $wrapper (Join-Path $repoRoot $Test.Source)
        } else {
            $netlist = Join-Path $repoRoot "reports\p9_epoch_variants\vivado_$($Candidate.Name)\$($Candidate.Top)_post_synth.v"
            if (!(Test-Path -LiteralPath $netlist)) { throw "Missing netlist: $netlist" }
            & $xvlog --work worklib $netlist
            if ($LASTEXITCODE -ne 0) { throw 'P9 epoch netlist compile failed' }
            & $xvlog --sv --work worklib --define $Candidate.Macro `
                $wrapper (Join-Path $repoRoot $Test.Source)
        }
        if ($LASTEXITCODE -ne 0) { throw 'P9 epoch test compile failed' }
        if ($RunMode -eq 'gate') {
            & $xelab "worklib.$($Test.Top)" worklib.glbl -L unisims_ver -s $snapshot --debug typical
        } else {
            & $xelab "worklib.$($Test.Top)" -s $snapshot --debug typical
        }
        if ($LASTEXITCODE -ne 0) { throw 'P9 epoch elaboration failed' }
        & $xsim $snapshot --runall --log $log
        if ($LASTEXITCODE -ne 0) { throw 'P9 epoch simulation failed' }
        if (!(Select-String -LiteralPath $log -SimpleMatch $Test.Marker)) {
            throw "P9 epoch $($Candidate.Name) $($Test.Name) marker missing"
        }
    } finally { Pop-Location }
}

$runModes = if ($Mode -eq 'all') { @('rtl','gate') } else { @($Mode) }
foreach ($runMode in $runModes) {
    foreach ($candidate in $candidates) {
        foreach ($test in $tests) {
            Invoke-EpochTest $candidate $test $runMode
        }
    }
}

if ($Mode -ne 'gate') {
    $work = Join-Path $repoRoot 'sim\p9_epoch_cycle_equivalence_work'
    $snapshot = 'p9_epoch_cycle_equivalence_sim'
    $log = Join-Path $logDir 'p9_epoch_cycle_equivalence_rtl.log'
    New-Item -ItemType Directory -Force -Path $work | Out-Null
    Push-Location $work
    try {
        & $xvlog --sv --work worklib `
            (Join-Path $repoRoot 'rtl\improved\aer_pending_direct_gray_scr_onehot_tree.sv') `
            $rtl (Join-Path $repoRoot 'tb\aer_p9_epoch_cycle_equivalence_tb.sv')
        if ($LASTEXITCODE -ne 0) { throw 'P9 epoch lockstep compile failed' }
        & $xelab worklib.aer_p9_epoch_cycle_equivalence_tb -s $snapshot --debug typical
        if ($LASTEXITCODE -ne 0) { throw 'P9 epoch lockstep elaboration failed' }
        & $xsim $snapshot --runall --log $log
        if ($LASTEXITCODE -ne 0) { throw 'P9 epoch lockstep simulation failed' }
        if (!(Select-String -LiteralPath $log -SimpleMatch 'P9_EPOCH_CYCLE_EQUIVALENCE_PASS')) {
            throw 'P9 epoch lockstep marker missing'
        }
    } finally { Pop-Location }
}
