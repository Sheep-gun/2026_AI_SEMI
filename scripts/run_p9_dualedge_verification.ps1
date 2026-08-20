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
$rtl = Join-Path $repoRoot 'rtl\experiments\aer_pending_direct_gray_dual_edge_cdc.sv'
$wrapper = Join-Path $repoRoot 'tb\aer_p9_dualedge_wrappers.sv'

$tests = @(
    @{ Name='regression'; Top='aer_source_resident_tb'; Source='tb\aer_source_resident_tb.sv'; Marker='SOURCE_RESIDENT_TEST_PASS' },
    @{ Name='fair'; Top='aer_pending_gray_epoch_fair_tb'; Source='tb\aer_pending_gray_epoch_fair_tb.sv'; Marker='P7_GRAY_EPOCH_FAIR_TEST_PASS' },
    @{ Name='cdc'; Top='aer_improved_cdc_phase_tb'; Source='tb\aer_improved_cdc_phase_tb.sv'; Marker='CDC_PHASE_TEST_PASS trials=192' },
    @{ Name='reset'; Top='aer_p8_dgscr_reset_tb'; Source='tb\aer_p8_dgscr_reset_tb.sv'; Marker='P8_DGSCR_RESET_TEST_PASS' }
)

foreach ($test in $tests) {
    $workDir = Join-Path $repoRoot "sim\p9_de_$($test.Name)_work"
    $snapshot = "p9_de_$($test.Name)_sim"
    $logPath = Join-Path $logDir "p9_de_$($test.Name).log"
    $source = Join-Path $repoRoot $test.Source
    New-Item -ItemType Directory -Force -Path $workDir | Out-Null

    Push-Location $workDir
    try {
        & $xvlog --sv --work worklib $rtl $wrapper $source
        if ($LASTEXITCODE -ne 0) { throw "$($test.Name) compile failed" }
        & $xelab "worklib.$($test.Top)" -s $snapshot --debug typical
        if ($LASTEXITCODE -ne 0) { throw "$($test.Name) elaborate failed" }
        & $xsim $snapshot --runall --log $logPath
        if ($LASTEXITCODE -ne 0) { throw "$($test.Name) simulation failed" }
        if (!(Select-String -LiteralPath $logPath -SimpleMatch $test.Marker)) {
            throw "$($test.Name) PASS marker missing"
        }
        "P9_DUALEDGE_PASS test=$($test.Name) log=$logPath"
    } finally {
        Pop-Location
    }
}
