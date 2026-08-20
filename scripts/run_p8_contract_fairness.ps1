param(
    [ValidateSet('SparseReset','DirectGray','DirectGraySharedTree','DirectGraySplitReset','DirectGraySyncCoreReset','Xor2','GrayRing','All','Pareto')]
    [string]$Design = 'All',
    [string]$VivadoBin = 'C:\Xilinx\Vivado\2020.2\bin',
    [switch]$Vcd
)

$ErrorActionPreference = 'Stop'
$repoRoot = (Resolve-Path -LiteralPath "$PSScriptRoot\..").Path
$logRoot = Join-Path $repoRoot 'sim\logs'
$waveRoot = Join-Path $repoRoot 'sim\waves'
New-Item -ItemType Directory -Force -Path $logRoot, $waveRoot | Out-Null

$xvlog = Join-Path $VivadoBin 'xvlog.bat'
$xelab = Join-Path $VivadoBin 'xelab.bat'
$xsim = Join-Path $VivadoBin 'xsim.bat'
$wrapper = Join-Path $repoRoot 'tb\aer_p8_contract_wrapper.sv'
$testbench = Join-Path $repoRoot 'tb\aer_contract_fairness_tb.sv'
$vcdTcl = '../../scripts/xsim_aer_contract_fairness_vcd.tcl'

function Invoke-P8Contract {
    param([string]$Name)

    switch ($Name) {
        'DirectGray' {
            $rtl = Join-Path $repoRoot 'rtl\improved\aer_pending_direct_gray_sparse_reset.sv'
            $defineArgs = @('--define','P8_CONTRACT_DIRECT_GRAY')
            $key = 'p8_direct_gray'
        }
        'DirectGraySharedTree' {
            $rtl = Join-Path $repoRoot 'rtl\improved\aer_pending_direct_gray_shared_tree.sv'
            $defineArgs = @('--define','P8_CONTRACT_DIRECT_GRAY_SHARED_TREE')
            $key = 'p8_direct_gray_shared_tree'
        }
        'DirectGraySplitReset' {
            $rtl = Join-Path $repoRoot 'rtl\improved\aer_pending_direct_gray_split_reset.sv'
            $defineArgs = @('--define','P8_CONTRACT_DIRECT_GRAY_SPLIT_RESET')
            $key = 'p8_direct_gray_split_reset'
        }
        'DirectGraySyncCoreReset' {
            $rtl = Join-Path $repoRoot 'rtl\improved\aer_pending_direct_gray_sync_core_reset.sv'
            $defineArgs = @('--define','P8_CONTRACT_DIRECT_GRAY_SYNC_CORE_RESET')
            $key = 'p8_direct_gray_sync_core_reset'
        }
        'Xor2' {
            $rtl = Join-Path $repoRoot 'rtl\improved\aer_pending_xor2_sparse_reset.sv'
            $defineArgs = @('--define','P8_CONTRACT_XOR2')
            $key = 'p8_xor2_sparse_reset'
        }
        'GrayRing' {
            $rtl = Join-Path $repoRoot 'rtl\improved\aer_pending_gray_ring_sparse_reset.sv'
            $defineArgs = @('--define','P8_CONTRACT_GRAY_RING')
            $key = 'p8_gray_ring_sparse_reset'
        }
        default {
            $rtl = Join-Path $repoRoot 'rtl\improved\aer_pending_gray_epoch_sparse_reset.sv'
            $defineArgs = @()
            $key = 'p8_sparse_reset'
        }
    }

    $work = Join-Path $repoRoot "sim\contract_fairness_${key}_work"
    $snapshot = "contract_fairness_${key}_sim"
    $runLog = Join-Path $logRoot "contract_fairness_${key}.log"
    New-Item -ItemType Directory -Force -Path $work | Out-Null

    Push-Location $work
    try {
        & $xvlog --sv --work worklib @defineArgs $rtl $wrapper $testbench
        if ($LASTEXITCODE -ne 0) { throw "$Name contract compile failed" }
        & $xelab worklib.aer_contract_fairness_tb -s $snapshot --debug typical
        if ($LASTEXITCODE -ne 0) { throw "$Name contract elaboration failed" }

        if ($Vcd) {
            $vcdPath = Join-Path $waveRoot "contract_fairness_${key}.vcd"
            $oldVcdPath = $env:AER_FAIR_VCD_PATH
            try {
                $env:AER_FAIR_VCD_PATH = $vcdPath.Replace('\','/')
                & $xsim $snapshot --tclbatch $vcdTcl --log $runLog
            } finally {
                $env:AER_FAIR_VCD_PATH = $oldVcdPath
            }
        } else {
            $vcdPath = $null
            & $xsim $snapshot --runall --log $runLog
        }

        if ($LASTEXITCODE -ne 0) { throw "$Name contract simulation failed" }
        if (!(Select-String -LiteralPath $runLog -SimpleMatch 'AER_CONTRACT_FAIRNESS_PASS')) {
            throw "$Name contract PASS marker missing"
        }
    } finally {
        Pop-Location
    }

    "P8_CONTRACT_PASS design=$Name log=$runLog"
    if ($vcdPath) { "P8_CONTRACT_VCD design=$Name path=$vcdPath" }
    Get-Content -LiteralPath $runLog |
        Where-Object { $_ -match '^(FAIR_METRIC|FAIR_PHASE)' }
}

$runs = switch ($Design) {
    'All' { @('SparseReset','DirectGray','DirectGraySharedTree','DirectGraySplitReset','DirectGraySyncCoreReset','Xor2','GrayRing') }
    'Pareto' { @('DirectGraySharedTree','DirectGraySplitReset','DirectGraySyncCoreReset','Xor2','GrayRing') }
    default { @($Design) }
}
foreach ($run in $runs) { Invoke-P8Contract -Name $run }
