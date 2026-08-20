param([string]$VivadoBin='C:\Xilinx\Vivado\2020.2\bin')
$ErrorActionPreference='Stop'
$root=(Resolve-Path -LiteralPath "$PSScriptRoot\..").Path
$xvlog=Join-Path $VivadoBin 'xvlog.bat'
$xelab=Join-Path $VivadoBin 'xelab.bat'
$xsim=Join-Path $VivadoBin 'xsim.bat'
$logDir=Join-Path $root 'sim\logs'
New-Item -ItemType Directory -Force -Path $logDir | Out-Null

# Dedicated full-backlog order and receiver-stall test for both candidates.
$work=Join-Path $root 'sim\p8_pareto_order_work'
New-Item -ItemType Directory -Force -Path $work | Out-Null
Push-Location $work
try {
    & $xvlog --sv --work worklib `
        (Join-Path $root 'rtl\improved\aer_pending_xor2_sparse_reset.sv') `
        (Join-Path $root 'rtl\improved\aer_pending_gray_ring_sparse_reset.sv') `
        (Join-Path $root 'tb\aer_p8_pareto_order_tb.sv')
    if($LASTEXITCODE-ne0){throw 'P8 Pareto order compile failed'}
    & $xelab worklib.aer_p8_pareto_order_tb -s p8_pareto_order_sim
    if($LASTEXITCODE-ne0){throw 'P8 Pareto order elaboration failed'}
    $log=Join-Path $logDir 'p8_pareto_order.log'
    & $xsim p8_pareto_order_sim --runall --log $log
    if($LASTEXITCODE-ne0 -or !(Select-String -LiteralPath $log -SimpleMatch 'P8_PARETO_ORDER_TEST_PASS')){
        throw 'P8 Pareto order test failed'
    }
} finally {Pop-Location}

$candidates=@(
    @{Name='xor2';Rtl='rtl\improved\aer_pending_xor2_sparse_reset.sv';Define=@()},
    @{Name='ring';Rtl='rtl\improved\aer_pending_gray_ring_sparse_reset.sv';Define=@('--define','P8_PARETO_RING')}
)
$tests=@(
    @{Name='regression';Top='aer_source_resident_tb';Tb='tb\aer_source_resident_tb.sv';Marker='SOURCE_RESIDENT_TEST_PASS'},
    @{Name='cdc';Top='aer_improved_cdc_phase_tb';Tb='tb\aer_improved_cdc_phase_tb.sv';Marker='CDC_PHASE_TEST_PASS trials=192'}
)
foreach($candidate in $candidates){foreach($test in $tests){
    $work=Join-Path $root "sim\p8_pareto_$($candidate.Name)_$($test.Name)_work"
    New-Item -ItemType Directory -Force -Path $work|Out-Null
    Push-Location $work
    try{
        & $xvlog --sv --work worklib @($candidate.Define) `
            (Join-Path $root $candidate.Rtl) `
            (Join-Path $root 'tb\aer_p8_pareto_wrappers.sv') `
            (Join-Path $root $test.Tb)
        if($LASTEXITCODE-ne0){throw 'P8 Pareto compile failed'}
        $snapshot="p8_pareto_$($candidate.Name)_$($test.Name)_sim"
        & $xelab "worklib.$($test.Top)" -s $snapshot
        if($LASTEXITCODE-ne0){throw 'P8 Pareto elaboration failed'}
        $log=Join-Path $logDir "p8_pareto_$($candidate.Name)_$($test.Name).log"
        & $xsim $snapshot --runall --log $log
        if($LASTEXITCODE-ne0 -or !(Select-String -LiteralPath $log -SimpleMatch $test.Marker)){
            throw "P8 Pareto $($candidate.Name) $($test.Name) failed"
        }
    }finally{Pop-Location}
}}

# Fixed-demand contract-fair comparison.  This uses an upstream FIFO so demand
# timing does not move with the DUT's ACK behavior.
foreach($candidate in $candidates){
    $work=Join-Path $root "sim\p8_pareto_$($candidate.Name)_contract_work"
    New-Item -ItemType Directory -Force -Path $work|Out-Null
    Push-Location $work
    try{
        & $xvlog --sv --work worklib @($candidate.Define) `
            (Join-Path $root $candidate.Rtl) `
            (Join-Path $root 'tb\aer_p8_pareto_contract_wrapper.sv') `
            (Join-Path $root 'tb\aer_contract_fairness_tb.sv')
        if($LASTEXITCODE-ne0){throw 'P8 Pareto contract compile failed'}
        $snapshot="p8_pareto_$($candidate.Name)_contract_sim"
        & $xelab worklib.aer_contract_fairness_tb -s $snapshot
        if($LASTEXITCODE-ne0){throw 'P8 Pareto contract elaboration failed'}
        $log=Join-Path $logDir "p8_pareto_$($candidate.Name)_contract.log"
        & $xsim $snapshot --runall --log $log
        if($LASTEXITCODE-ne0 -or !(Select-String -LiteralPath $log `
            -SimpleMatch 'AER_CONTRACT_FAIRNESS_PASS')){
            throw "P8 Pareto $($candidate.Name) contract failed"
        }
    }finally{Pop-Location}
}

Push-Location $root
try{
    New-Item -ItemType Directory -Force -Path 'reports\p8_pareto'|Out-Null
    & (Join-Path $VivadoBin 'vivado.bat') -mode batch -notrace `
        -source scripts/vivado_synth_p8_pareto.tcl `
        -log reports/p8_pareto/vivado.log `
        -journal reports/p8_pareto/vivado.jou
    if($LASTEXITCODE-ne0){throw 'P8 Pareto synthesis failed'}
}finally{Pop-Location}
