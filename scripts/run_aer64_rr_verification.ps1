param([string]$VivadoBin='C:\Xilinx\Vivado\2020.2\bin',[switch]$Vcd)
$ErrorActionPreference='Stop'
$root=(Resolve-Path -LiteralPath "$PSScriptRoot\..").Path
$work=Join-Path $root 'sim\aer64_rr_work'
$log=Join-Path $root 'sim\logs\aer64_rr_rtl.log'
$vcdPath=Join-Path $root 'sim\waves\aer64_rr.vcd'
New-Item -ItemType Directory -Force $work,(Split-Path $log)|Out-Null
Push-Location $work
try{
    & (Join-Path $VivadoBin 'xvlog.bat') --sv --work worklib `
        (Join-Path $root 'rtl\scalable\aer64_pending_rr_candidates.sv') `
        (Join-Path $root 'tb\aer64_pending_rr_tb.sv')
    if($LASTEXITCODE-ne0){throw 'AER64 compile failed'}
    & (Join-Path $VivadoBin 'xelab.bat') worklib.aer64_pending_rr_tb -s aer64_rr_sim --debug typical
    if($LASTEXITCODE-ne0){throw 'AER64 elaborate failed'}
    if($Vcd){
        New-Item -ItemType Directory -Force (Split-Path $vcdPath)|Out-Null
        $env:AER64_VCD_PATH=$vcdPath.Replace('\','/')
        & (Join-Path $VivadoBin 'xsim.bat') aer64_rr_sim `
            -tclbatch ((Join-Path $root 'scripts\xsim_aer64_vcd.tcl').Replace('\','/')) --log $log
        Remove-Item Env:AER64_VCD_PATH -ErrorAction SilentlyContinue
    }else{
        & (Join-Path $VivadoBin 'xsim.bat') aer64_rr_sim --runall --log $log
    }
    if($LASTEXITCODE-ne0-or!(Select-String -LiteralPath $log -SimpleMatch 'AER64_PENDING_RR_TEST_PASS')){
        throw 'AER64 verification failed'
    }
}finally{Pop-Location}
"AER64_RR_VERIFICATION_PASS log=$log"
