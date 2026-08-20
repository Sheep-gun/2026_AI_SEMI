param(
    [string]$VivadoBin = 'C:\Xilinx\Vivado\2020.2\bin',
    [switch]$NoVcd
)

$ErrorActionPreference = 'Stop'
$repoRoot = (Resolve-Path -LiteralPath "$PSScriptRoot\..").Path
$workDir = Join-Path $repoRoot 'sim\p9_grr_contract_work'
$logPath = Join-Path $repoRoot 'sim\logs\p9_grr_contract.log'
$vcdPath = Join-Path $repoRoot 'sim\waves\p9_grr_contract.vcd'
$snapshot = 'p9_grr_contract_sim'

New-Item -ItemType Directory -Force -Path $workDir,(Split-Path $logPath),(Split-Path $vcdPath) | Out-Null
$xvlog = Join-Path $VivadoBin 'xvlog.bat'
$xelab = Join-Path $VivadoBin 'xelab.bat'
$xsim = Join-Path $VivadoBin 'xsim.bat'
$hadOriginalVcdPath = Test-Path Env:AER_FAIR_VCD_PATH
$originalVcdPath = $env:AER_FAIR_VCD_PATH

Push-Location $workDir
try {
    & $xvlog --sv --work worklib `
        (Join-Path $repoRoot 'rtl\experiments\aer_pending_gray_rank_reuse_sync_core_reset.sv') `
        (Join-Path $repoRoot 'tb\aer_p9_gray_rank_contract_wrapper.sv') `
        (Join-Path $repoRoot 'tb\aer_contract_fairness_tb.sv')
    if ($LASTEXITCODE -ne 0) { throw 'P9-GRR contract compile failed' }

    & $xelab worklib.aer_contract_fairness_tb -s $snapshot --debug typical
    if ($LASTEXITCODE -ne 0) { throw 'P9-GRR contract elaboration failed' }

    if ($NoVcd) {
        & $xsim $snapshot --runall --log $logPath
    } else {
        $env:AER_FAIR_VCD_PATH = $vcdPath.Replace('\','/')
        & $xsim $snapshot `
            -tclbatch (Join-Path $repoRoot 'scripts\xsim_aer_contract_fairness_vcd.tcl') `
            --log $logPath
    }
    if ($LASTEXITCODE -ne 0) { throw 'P9-GRR contract simulation failed' }
    if (!(Select-String -LiteralPath $logPath -SimpleMatch 'AER_CONTRACT_FAIRNESS_PASS')) {
        throw 'P9-GRR contract PASS marker missing'
    }
} finally {
    if ($hadOriginalVcdPath) {
        $env:AER_FAIR_VCD_PATH = $originalVcdPath
    } else {
        Remove-Item Env:AER_FAIR_VCD_PATH -ErrorAction SilentlyContinue
    }
    Pop-Location
}

"P9_GRR_CONTRACT_PASS log=$logPath vcd=$vcdPath"
