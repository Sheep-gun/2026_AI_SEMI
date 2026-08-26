param(
    [ValidateSet('all', 't0', 'p9-grr', 'p9-oht')]
    [string]$Design = 'all',
    [string]$VivadoBin = 'C:\Xilinx\Vivado\2020.2\bin'
)

$ErrorActionPreference = 'Stop'
$repoRoot = (Resolve-Path -LiteralPath "$PSScriptRoot\..").Path
$xvlog = Join-Path $VivadoBin 'xvlog.bat'
$xelab = Join-Path $VivadoBin 'xelab.bat'
$xsim = Join-Path $VivadoBin 'xsim.bat'
$workRoot = Join-Path $repoRoot 'sim\work'
$logRoot = Join-Path $repoRoot 'sim\final\logs'
New-Item -ItemType Directory -Force -Path $workRoot, $logRoot | Out-Null

function Invoke-Simulation {
    param(
        [string]$Name,
        [string[]]$Sources,
        [string]$Top,
        [string]$PassMarker
    )

    $work = Join-Path $workRoot $Name
    $log = Join-Path $logRoot "$Name.log"
    New-Item -ItemType Directory -Force -Path $work | Out-Null
    Push-Location $work
    try {
        $resolvedSources = $Sources | ForEach-Object { Join-Path $repoRoot $_ }
        & $xvlog --sv --work worklib $resolvedSources
        if ($LASTEXITCODE -ne 0) { throw "$Name compile failed" }

        $snapshot = "${Name}_sim"
        & $xelab "worklib.$Top" -s $snapshot --debug typical
        if ($LASTEXITCODE -ne 0) { throw "$Name elaboration failed" }

        & $xsim $snapshot --runall --log $log
        if ($LASTEXITCODE -ne 0) { throw "$Name simulation failed" }
        if (!(Select-String -LiteralPath $log -SimpleMatch $PassMarker)) {
            throw "$Name PASS marker missing"
        }
        Write-Output "PASS $Name log=$log"
    } finally {
        Pop-Location
    }
}

$selected = if ($Design -eq 'all') { @('t0', 'p9-grr', 'p9-oht') } else { @($Design) }
foreach ($item in $selected) {
    switch ($item) {
        't0' {
            Invoke-Simulation -Name 't0_rtl' -Top 'aer_traditional_async_tb' `
                -PassMarker 'TEST_PASS async_baseline' -Sources @(
                    'tb\final\gsclib045_models.sv',
                    'rtl\final\aer_t0_traditional_async.sv',
                    'tb\final\aer_t0_wrapper.sv',
                    'tb\final\aer_t0_tb.sv'
                )
        }
        'p9-grr' {
            Invoke-Simulation -Name 'p9_grr_contract' -Top 'aer_contract_fairness_tb' `
                -PassMarker 'AER_CONTRACT_FAIRNESS_PASS' -Sources @(
                    'rtl\final\aer_p9_grr.sv',
                    'tb\final\aer_p9_grr_wrapper.sv',
                    'tb\final\aer_p9_contract_tb.sv'
                )
        }
        'p9-oht' {
            Invoke-Simulation -Name 'p9_oht_contract' -Top 'aer_contract_fairness_tb' `
                -PassMarker 'AER_CONTRACT_FAIRNESS_PASS' -Sources @(
                    'rtl\final\aer_p9_oht.sv',
                    'tb\final\aer_p9_oht_wrapper.sv',
                    'tb\final\aer_p9_contract_tb.sv'
                )
        }
    }
}
