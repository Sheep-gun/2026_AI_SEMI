param([string]$VivadoBin='C:\Xilinx\Vivado\2020.2\bin')
$ErrorActionPreference='Stop'
$root=(Resolve-Path -LiteralPath "$PSScriptRoot\..").Path
$xvlog=Join-Path $VivadoBin 'xvlog.bat'
$xelab=Join-Path $VivadoBin 'xelab.bat'
$xsim=Join-Path $VivadoBin 'xsim.bat'
$logDir=Join-Path $root 'sim\logs'
New-Item -ItemType Directory -Force -Path $logDir|Out-Null

$candidates=@(
    @{Name='xor2';Netlist='reports\p8_pareto\vivado\aer_pending_xor2_sparse_reset\aer_pending_xor2_sparse_reset_post_synth.v';Define=@()},
    @{Name='ring';Netlist='reports\p8_pareto\vivado\aer_pending_gray_ring_sparse_reset\aer_pending_gray_ring_sparse_reset_post_synth.v';Define=@('--define','P8_PARETO_RING')}
)
$tests=@(
    @{Name='regression';Top='aer_source_resident_tb';Tb='tb\aer_source_resident_tb.sv';Marker='SOURCE_RESIDENT_TEST_PASS'},
    @{Name='cdc';Top='aer_improved_cdc_phase_tb';Tb='tb\aer_improved_cdc_phase_tb.sv';Marker='CDC_PHASE_TEST_PASS trials=192'}
)
foreach($candidate in $candidates){foreach($test in $tests){
    $work=Join-Path $root "sim\p8_pareto_$($candidate.Name)_$($test.Name)_gate_work"
    New-Item -ItemType Directory -Force -Path $work|Out-Null
    Push-Location $work
    try{
        & $xvlog --work worklib (Join-Path $root $candidate.Netlist)
        if($LASTEXITCODE-ne0){throw 'P8 Pareto gate netlist compile failed'}
        & $xvlog --sv --work worklib @($candidate.Define) `
            (Join-Path $root 'tb\aer_p8_pareto_wrappers.sv') `
            (Join-Path $root $test.Tb)
        if($LASTEXITCODE-ne0){throw 'P8 Pareto gate wrapper compile failed'}
        $snapshot="p8_pareto_$($candidate.Name)_$($test.Name)_gate_sim"
        & $xelab "worklib.$($test.Top)" worklib.glbl -L unisims_ver -s $snapshot
        if($LASTEXITCODE-ne0){throw 'P8 Pareto gate elaboration failed'}
        $log=Join-Path $logDir "p8_pareto_$($candidate.Name)_$($test.Name)_gate.log"
        & $xsim $snapshot --runall --log $log
        if($LASTEXITCODE-ne0 -or !(Select-String -LiteralPath $log -SimpleMatch $test.Marker)){
            throw "P8 Pareto $($candidate.Name) $($test.Name) gate failed"
        }
    }finally{Pop-Location}
}}
