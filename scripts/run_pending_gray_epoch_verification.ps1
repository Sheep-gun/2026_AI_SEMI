param(
    [string]$VivadoBin = 'C:\Xilinx\Vivado\2020.2\bin'
)

$ErrorActionPreference = 'Stop'
$repoRoot = (Resolve-Path -LiteralPath "$PSScriptRoot\..").Path
$logDir = Join-Path $repoRoot 'sim\logs'
New-Item -ItemType Directory -Force -Path $logDir | Out-Null

$xvlog = Join-Path $VivadoBin 'xvlog.bat'
$xelab = Join-Path $VivadoBin 'xelab.bat'
$xsim = Join-Path $VivadoBin 'xsim.bat'
$rtl = Join-Path $repoRoot 'rtl\improved\aer_pending_gray_epoch.sv'

function Invoke-P7RtlTest {
    param(
        [string]$Name,
        [string]$Top,
        [string[]]$Sources,
        [string]$PassMarker
    )

    $workDir = Join-Path $repoRoot "sim\p7ge_${Name}_work"
    $snapshot = "p7ge_${Name}_sim"
    $logPath = Join-Path $logDir "p7ge_${Name}.log"
    New-Item -ItemType Directory -Force -Path $workDir | Out-Null

    Push-Location $workDir
    try {
        & $xvlog --sv --work worklib $rtl @Sources
        if ($LASTEXITCODE -ne 0) { throw "P7-GE $Name compile failed" }

        & $xelab "worklib.$Top" -s $snapshot --debug typical
        if ($LASTEXITCODE -ne 0) { throw "P7-GE $Name elaboration failed" }

        & $xsim $snapshot --runall --log $logPath
        if ($LASTEXITCODE -ne 0) { throw "P7-GE $Name simulation failed" }
        if (!(Select-String -LiteralPath $logPath -SimpleMatch $PassMarker)) {
            throw "P7-GE $Name PASS marker missing: $PassMarker"
        }
    } finally {
        Pop-Location
    }
}

Invoke-P7RtlTest -Name 'regression' -Top 'aer_source_resident_tb' -Sources @(
    (Join-Path $repoRoot 'tb\aer_pending_gray_epoch_regression_wrapper.sv'),
    (Join-Path $repoRoot 'tb\aer_source_resident_tb.sv')
) -PassMarker 'SOURCE_RESIDENT_TEST_PASS'

Invoke-P7RtlTest -Name 'fair' -Top 'aer_pending_gray_epoch_fair_tb' -Sources @(
    (Join-Path $repoRoot 'tb\aer_pending_gray_epoch_frozen_wrapper.sv'),
    (Join-Path $repoRoot 'tb\aer_pending_gray_epoch_fair_tb.sv')
) -PassMarker 'P7_GRAY_EPOCH_FAIR_TEST_PASS'
