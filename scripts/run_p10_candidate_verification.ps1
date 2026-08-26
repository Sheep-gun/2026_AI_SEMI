param(
    [ValidateSet('rtl','gate','all')][string]$Mode='all',
    [ValidateSet('iprra','xor1','xor2','all')][string]$Candidate='all',
    [string]$VivadoBin='C:\Xilinx\Vivado\2020.2\bin'
)
$ErrorActionPreference='Stop'
$root=(Resolve-Path -LiteralPath "$PSScriptRoot\..").Path
$xvlog=Join-Path $VivadoBin 'xvlog.bat'
$xelab=Join-Path $VivadoBin 'xelab.bat'
$xsim=Join-Path $VivadoBin 'xsim.bat'
$rtl=Join-Path $root 'rtl\experiments\aer_pending_rank_reuse_p10_candidates.sv'
$wrapper=Join-Path $root 'tb\aer_p10_candidate_wrappers.sv'
$logDir=Join-Path $root 'sim\logs'
New-Item -ItemType Directory -Force $logDir|Out-Null

$allCandidates=@(
    @{Key='iprra';Define='P10_IPRRA';Top='aer_pending_gray_rank_iprra_sync_core_reset'},
    @{Key='xor1';Define='P10_XOR1';Top='aer_pending_xor1_rank_reuse_sync_core_reset'},
    @{Key='xor2';Define='P10_XOR2';Top='aer_pending_xor2_rank_reuse_sync_core_reset'}
)
$selected=if($Candidate-eq'all'){$allCandidates}else{@($allCandidates|Where-Object Key -eq $Candidate)}
$modes=if($Mode-eq'all'){@('rtl','gate')}else{@($Mode)}
$tests=@(
    @{Name='broad';Top='aer_source_resident_tb';Source='tb\aer_source_resident_tb.sv';Marker='SOURCE_RESIDENT_TEST_PASS'},
    @{Name='fair';Top='aer_p10_candidate_fair_tb';Source='tb\aer_p10_candidate_fair_tb.sv';Marker='P10_CANDIDATE_FAIR_TEST_PASS'},
    @{Name='cdc';Top='aer_improved_cdc_phase_tb';Source='tb\aer_improved_cdc_phase_tb.sv';Marker='CDC_PHASE_TEST_PASS trials=192'},
    @{Name='reset';Top='aer_p8_dgscr_reset_tb';Source='tb\aer_p8_dgscr_reset_tb.sv';Marker='P8_DGSCR_RESET_TEST_PASS'},
    @{Name='contract';Top='aer_contract_fairness_tb';Source='tb\aer_contract_fairness_tb.sv';Marker='AER_CONTRACT_FAIRNESS_PASS'}
)

foreach($candidateItem in $selected){
    $net=Join-Path $root "reports\p10_final\vivado\$($candidateItem.Key)\$($candidateItem.Top)_post_synth.v"
    foreach($run in $modes){
        if($run-eq'gate'-and!(Test-Path -LiteralPath $net)){throw "missing gate netlist $net"}
        foreach($test in $tests){
            $work=Join-Path $root "sim\p10_$($candidateItem.Key)_$($test.Name)_${run}_work"
            New-Item -ItemType Directory -Force $work|Out-Null
            Push-Location $work
            try {
                $defines=@('--define',$candidateItem.Define)
                if($run-eq'rtl'){
                    & $xvlog --sv @defines --work worklib $rtl $wrapper (Join-Path $root $test.Source)
                }else{
                    & $xvlog --work worklib $net
                    if($LASTEXITCODE-ne0){throw 'gate netlist compile failed'}
                    & $xvlog --sv @defines --define P10_GATE --work worklib $wrapper (Join-Path $root $test.Source)
                }
                if($LASTEXITCODE-ne0){throw 'testbench compile failed'}
                $snapshot="p10_$($candidateItem.Key)_$($test.Name)_${run}_sim"
                if($run-eq'gate'){
                    & $xelab "worklib.$($test.Top)" worklib.glbl -L unisims_ver -s $snapshot
                }else{& $xelab "worklib.$($test.Top)" -s $snapshot}
                if($LASTEXITCODE-ne0){throw 'elaboration failed'}
                $log=Join-Path $logDir "p10_$($candidateItem.Key)_$($test.Name)_${run}.log"
                & $xsim $snapshot --runall --log $log
                if($LASTEXITCODE-ne0-or!(Select-String -LiteralPath $log -SimpleMatch $test.Marker)){
                    throw "P10 $($candidateItem.Key) $($test.Name) $run failed"
                }
            } finally {Pop-Location}
        }
    }
}
Write-Output "P10_CANDIDATE_VERIFICATION_PASS candidates=$Candidate mode=$Mode"
