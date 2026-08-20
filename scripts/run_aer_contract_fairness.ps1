param(
    [ValidateSet('P4C','P6W','P6GE','P7GE','P4vsP7','All')]
    [string]$Design = 'All',
    [string]$VivadoBin = 'C:\Xilinx\Vivado\2020.2\bin',
    [switch]$Vcd
)

$ErrorActionPreference = 'Stop'
$repoRoot = (Resolve-Path -LiteralPath "$PSScriptRoot\..").Path
$logRoot = Join-Path $repoRoot 'sim\logs'
New-Item -ItemType Directory -Force -Path $logRoot | Out-Null

$xvlog = Join-Path $VivadoBin 'xvlog.bat'
$xelab = Join-Path $VivadoBin 'xelab.bat'
$xsim = Join-Path $VivadoBin 'xsim.bat'
$wrapper = Join-Path $repoRoot 'tb\aer_contract_fairness_wrapper.sv'
$testbench = Join-Path $repoRoot 'tb\aer_contract_fairness_tb.sv'
$vcdTclForXsim = '../../scripts/xsim_aer_contract_fairness_vcd.tcl'
$waveRoot = Join-Path $repoRoot 'sim\waves'
New-Item -ItemType Directory -Force -Path $waveRoot | Out-Null

function Invoke-FairComparison {
    param([string]$Name)

    switch ($Name) {
        'P4C' {
            $rtl = Join-Path $repoRoot 'rtl\improved\aer_improved_cutthrough.sv'
            $define = 'FAIR_DUT_P4C'
            $key = 'p4c'
        }
        'P6W' {
            $rtl = Join-Path $repoRoot 'rtl\improved\aer_source_resident_wavefront.sv'
            $define = 'FAIR_DUT_P6W'
            $key = 'p6w'
        }
        'P6GE' {
            $rtl = Join-Path $repoRoot 'rtl\improved\aer_source_resident_gray_epoch.sv'
            $define = 'FAIR_DUT_P6GE'
            $key = 'p6ge'
        }
        'P7GE' {
            $rtl = Join-Path $repoRoot 'rtl\improved\aer_pending_gray_epoch.sv'
            $define = 'FAIR_DUT_P7GE'
            $key = 'p7ge'
        }
        default { throw "Unsupported design: $Name" }
    }

    $work = Join-Path $repoRoot "sim\contract_fairness_${key}_work"
    $runLog = Join-Path $logRoot "contract_fairness_${key}.log"
    $compileLog = Join-Path $logRoot "contract_fairness_${key}_compile.log"
    $elaborateLog = Join-Path $logRoot "contract_fairness_${key}_elaborate.log"
    $snapshot = "contract_fairness_${key}_sim"
    New-Item -ItemType Directory -Force -Path $work | Out-Null

    Push-Location $work
    try {
        & $xvlog --sv --work worklib --define $define --log $compileLog `
            $rtl $wrapper $testbench | Out-Host
        if ($LASTEXITCODE -ne 0) { throw "$Name fairness compile failed" }

        & $xelab worklib.aer_contract_fairness_tb -s $snapshot --debug typical `
            --log $elaborateLog | Out-Host
        if ($LASTEXITCODE -ne 0) { throw "$Name fairness elaboration failed" }

        $writeVcd = $Vcd -and (($Name -eq 'P4C') -or ($Name -eq 'P7GE'))
        if ($writeVcd) {
            $vcdPath = Join-Path $waveRoot "contract_fairness_${key}.vcd"
            $oldVcdPath = $env:AER_FAIR_VCD_PATH
            try {
                $env:AER_FAIR_VCD_PATH = $vcdPath.Replace('\','/')
                & $xsim $snapshot --tclbatch $vcdTclForXsim --log $runLog | Out-Host
            } finally {
                $env:AER_FAIR_VCD_PATH = $oldVcdPath
            }
        } else {
            & $xsim $snapshot --runall --log $runLog | Out-Host
            $vcdPath = $null
        }
        if ($LASTEXITCODE -ne 0) { throw "$Name fairness simulation failed" }
        if (!(Select-String -LiteralPath $runLog -SimpleMatch 'AER_CONTRACT_FAIRNESS_PASS')) {
            throw "$Name fairness pass marker missing"
        }
    } finally {
        Pop-Location
    }

    [pscustomobject]@{ Name = $Name; Key = $key; Log = $runLog; Vcd = $vcdPath }
}

$requested = if ($Design -eq 'All') {
    @('P4C','P6W','P6GE','P7GE')
} elseif ($Design -eq 'P4vsP7') {
    @('P4C','P7GE')
} else {
    @($Design)
}
$runs = foreach ($name in $requested) { Invoke-FairComparison -Name $name }

foreach ($run in $runs) {
    "FAIR_SUMMARY design=$($run.Name) log=$($run.Log)"
    if ($run.Vcd) { "FAIR_VCD design=$($run.Name) path=$($run.Vcd)" }
    Get-Content -LiteralPath $run.Log |
        Where-Object { $_ -match '^(FAIR_METRIC|FAIR_PHASE|AER_CONTRACT_)' } |
        ForEach-Object { "[$($run.Name)] $_" }
}
