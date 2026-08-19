param([string]$VivadoBin = 'C:\Xilinx\Vivado\2020.2\bin')
$ErrorActionPreference = 'Stop'
$root = (Resolve-Path -LiteralPath "$PSScriptRoot\..").Path
$work = Join-Path $root 'sim\improved_depth1_work'
$logs = Join-Path $root 'sim\logs'
$waves = Join-Path $root 'sim\waves'
New-Item -ItemType Directory -Force -Path $work, $logs, $waves | Out-Null
Push-Location $work
try {
    & (Join-Path $VivadoBin 'xvlog.bat') --sv --work worklib `
        --log (Join-Path $logs 'improved_depth1_compile.log') `
        (Join-Path $root 'rtl\improved\aer_improved_depth1.sv') `
        (Join-Path $root 'tb\aer_improved_depth1_test_wrapper.sv') `
        (Join-Path $root 'tb\aer_improved_hybrid_tb.sv')
    if ($LASTEXITCODE -ne 0) { throw 'P3 compile failed.' }
    & (Join-Path $VivadoBin 'xelab.bat') worklib.aer_improved_hybrid_tb `
        -s improved_depth1_sim --debug typical `
        --log (Join-Path $logs 'improved_depth1_elaborate.log')
    if ($LASTEXITCODE -ne 0) { throw 'P3 elaboration failed.' }
    & (Join-Path $VivadoBin 'xsim.bat') improved_depth1_sim `
        --tclbatch '../../scripts/xsim_improved_depth1.tcl' `
        --log '../logs/improved_depth1.log'
    if ($LASTEXITCODE -ne 0) { throw 'P3 simulation failed.' }
    if (!(Select-String -LiteralPath (Join-Path $logs 'improved_depth1.log') -SimpleMatch 'TEST_PASS improved')) {
        throw 'P3 did not report TEST_PASS.'
    }
} finally { Pop-Location }

