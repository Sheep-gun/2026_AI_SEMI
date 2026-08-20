param([ValidateSet('rtl','gate','all')][string]$Mode='all',[string]$VivadoBin='C:\Xilinx\Vivado\2020.2\bin')
$ErrorActionPreference='Stop';$root=(Resolve-Path -LiteralPath "$PSScriptRoot\..").Path
$xvlog=Join-Path $VivadoBin 'xvlog.bat';$xelab=Join-Path $VivadoBin 'xelab.bat';$xsim=Join-Path $VivadoBin 'xsim.bat'
$base=Join-Path $root 'rtl\experiments\aer_pending_gray_rank_reuse_sync_core_reset.sv'
$rtl=Join-Path $root 'rtl\experiments\aer_pending_gray_rank_reuse_operand_isolated.sv'
$net=Join-Path $root 'reports\p9_state_compression\vivado_grr_oi\aer_pending_gray_rank_reuse_operand_isolated_post_synth.v'
$wrap=Join-Path $root 'tb\aer_p9_grr_oi_wrappers.sv';$logdir=Join-Path $root 'sim\logs';New-Item -ItemType Directory -Force $logdir|Out-Null
$tests=@(@{N='regression';T='aer_source_resident_tb';S='tb\aer_source_resident_tb.sv';M='SOURCE_RESIDENT_TEST_PASS'},@{N='fair';T='aer_p9_gray_rank_fair_tb';S='tb\aer_p9_gray_rank_fair_tb.sv';M='P9_GRAY_RANK_FAIR_TEST_PASS'},@{N='cdc';T='aer_improved_cdc_phase_tb';S='tb\aer_improved_cdc_phase_tb.sv';M='CDC_PHASE_TEST_PASS trials=192'},@{N='reset';T='aer_p8_dgscr_reset_tb';S='tb\aer_p8_dgscr_reset_tb.sv';M='P8_DGSCR_RESET_TEST_PASS'})
$modes=if($Mode-eq'all'){@('rtl','gate')}else{@($Mode)}
foreach($run in $modes){foreach($t in $tests){$work=Join-Path $root "sim\p9_grr_oi_$($t.N)_${run}_work";New-Item -ItemType Directory -Force $work|Out-Null;Push-Location $work;try{
 if($run-eq'rtl'){&$xvlog --sv --work worklib $base $rtl $wrap (Join-Path $root $t.S)}else{&$xvlog --work worklib $net;if($LASTEXITCODE-ne0){throw'net compile'};&$xvlog --sv --define P9_GATE --work worklib $wrap (Join-Path $root $t.S)}
 if($LASTEXITCODE-ne0){throw'compile'};$snap="p9_grr_oi_$($t.N)_${run}_sim";if($run-eq'gate'){&$xelab "worklib.$($t.T)" worklib.glbl -L unisims_ver -s $snap}else{&$xelab "worklib.$($t.T)" -s $snap};if($LASTEXITCODE-ne0){throw'elab'}
 $log=Join-Path $logdir "p9_grr_oi_$($t.N)_${run}.log";&$xsim $snap --runall --log $log;if($LASTEXITCODE-ne0-or!(Select-String -LiteralPath $log -SimpleMatch $t.M)){throw"test $($t.N) $run"}
}finally{Pop-Location}}}
