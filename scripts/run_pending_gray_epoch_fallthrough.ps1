param(
    [string]$VivadoBin = 'C:\Xilinx\Vivado\2020.2\bin'
)

$ErrorActionPreference = 'Stop'
$repoRoot = (Resolve-Path -LiteralPath "$PSScriptRoot\..").Path
$workDir = Join-Path $repoRoot 'sim\p7ge_ft_work'
$logDir = Join-Path $repoRoot 'sim\logs'
$reportDir = Join-Path $repoRoot 'reports\pending_gray_epoch_fallthrough\vivado_robust'
New-Item -ItemType Directory -Force -Path $workDir, $logDir, $reportDir | Out-Null

Push-Location $workDir
try {
    & (Join-Path $VivadoBin 'xvlog.bat') --sv --work worklib `
        (Join-Path $repoRoot 'rtl\improved\aer_pending_gray_epoch.sv') `
        (Join-Path $repoRoot 'rtl\improved\aer_pending_gray_epoch_fallthrough.sv') `
        (Join-Path $repoRoot 'tb\aer_pending_gray_epoch_fallthrough_tb.sv')
    if ($LASTEXITCODE -ne 0) { throw 'P7-GE-FT compile failed' }
    & (Join-Path $VivadoBin 'xelab.bat') `
        worklib.aer_pending_gray_epoch_fallthrough_tb -s p7ge_ft_sim --debug typical
    if ($LASTEXITCODE -ne 0) { throw 'P7-GE-FT elaboration failed' }

    $simulationLog = Join-Path $logDir 'p7ge_ft.log'
    & (Join-Path $VivadoBin 'xsim.bat') p7ge_ft_sim --runall --log $simulationLog
    if ($LASTEXITCODE -ne 0) { throw 'P7-GE-FT simulation failed' }
    if (!(Select-String -LiteralPath $simulationLog -SimpleMatch `
            'P7_GRAY_EPOCH_FALLTHROUGH_TEST_PASS')) {
        throw 'P7-GE-FT PASS marker was not found'
    }
} finally {
    Pop-Location
}

Push-Location $repoRoot
try {
    & (Join-Path $VivadoBin 'vivado.bat') -mode batch `
        -source scripts/vivado_synth_pending_gray_epoch_fallthrough.tcl `
        -log reports/pending_gray_epoch_fallthrough/vivado_robust/vivado.log `
        -journal reports/pending_gray_epoch_fallthrough/vivado_robust/vivado.jou
    if ($LASTEXITCODE -ne 0) { throw 'P7-GE-FT synthesis failed' }
} finally {
    Pop-Location
}
