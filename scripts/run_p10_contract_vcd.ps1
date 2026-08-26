param(
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
$tb=Join-Path $root 'tb\aer_contract_fairness_tb.sv'
$vcdTcl=(Join-Path $root 'scripts\xsim_aer_contract_fairness_vcd.tcl').Replace('\','/')
$all=@(
    @{Key='iprra';Define='P10_IPRRA'},
    @{Key='xor1';Define='P10_XOR1'},
    @{Key='xor2';Define='P10_XOR2'}
)
$selected=if($Candidate-eq'all'){$all}else{@($all|Where-Object Key -eq $Candidate)}
$hadOriginal=Test-Path Env:AER_FAIR_VCD_PATH
$original=$env:AER_FAIR_VCD_PATH
try {
    foreach($item in $selected){
        $work=Join-Path $root "sim\p10_$($item.Key)_vcd_work"
        $log=Join-Path $root "sim\logs\p10_$($item.Key)_contract_vcd.log"
        $vcd=Join-Path $root "sim\waves\p10_$($item.Key)_contract.vcd"
        New-Item -ItemType Directory -Force $work,(Split-Path $log),(Split-Path $vcd)|Out-Null
        Push-Location $work
        try {
            & $xvlog --sv --define $item.Define --work worklib $rtl $wrapper $tb
            if($LASTEXITCODE-ne0){throw 'P10 VCD compile failed'}
            $snapshot="p10_$($item.Key)_contract_vcd_sim"
            & $xelab worklib.aer_contract_fairness_tb -s $snapshot --debug typical
            if($LASTEXITCODE-ne0){throw 'P10 VCD elaboration failed'}
            $env:AER_FAIR_VCD_PATH=$vcd.Replace('\','/')
            & $xsim $snapshot -tclbatch $vcdTcl --log $log
            if($LASTEXITCODE-ne0-or!(Select-String -LiteralPath $log -SimpleMatch 'AER_CONTRACT_FAIRNESS_PASS')){
                throw "P10 $($item.Key) contract VCD failed"
            }
        } finally {Pop-Location}
    }
} finally {
    if($hadOriginal){$env:AER_FAIR_VCD_PATH=$original}
    else{Remove-Item Env:AER_FAIR_VCD_PATH -ErrorAction SilentlyContinue}
}
Write-Output "P10_CONTRACT_VCD_PASS candidates=$Candidate"
