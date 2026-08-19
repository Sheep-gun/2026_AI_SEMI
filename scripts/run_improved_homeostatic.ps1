param([string]$VivadoBin = 'C:\Xilinx\Vivado\2020.2\bin')
$ErrorActionPreference = 'Stop'
$root = (Resolve-Path -LiteralPath "$PSScriptRoot\..").Path
$work = Join-Path $root 'sim\improved_homeostatic_work'
$logs = Join-Path $root 'sim\logs'
$waves = Join-Path $root 'sim\waves'
New-Item -ItemType Directory -Force -Path $work, $logs, $waves | Out-Null
Push-Location $work
try {
    & (Join-Path $VivadoBin 'xvlog.bat') --sv --work worklib `
        --log (Join-Path $logs 'improved_homeostatic_compile.log') `
        (Join-Path $root 'rtl\improved\aer_improved_homeostatic.sv') `
        (Join-Path $root 'tb\aer_improved_homeostatic_test_wrapper.sv') `
        (Join-Path $root 'tb\aer_improved_hybrid_tb.sv')
    if ($LASTEXITCODE -ne 0) { throw 'P4 compile failed.' }
    & (Join-Path $VivadoBin 'xelab.bat') worklib.aer_improved_hybrid_tb `
        -s improved_homeostatic_sim --debug typical `
        --log (Join-Path $logs 'improved_homeostatic_elaborate.log')
    if ($LASTEXITCODE -ne 0) { throw 'P4 elaboration failed.' }
    & (Join-Path $VivadoBin 'xsim.bat') improved_homeostatic_sim `
        --tclbatch '../../scripts/xsim_improved_homeostatic.tcl' `
        --log '../logs/improved_homeostatic.log'
    if ($LASTEXITCODE -ne 0) { throw 'P4 simulation failed.' }
    if (!(Select-String -LiteralPath (Join-Path $logs 'improved_homeostatic.log') -SimpleMatch 'TEST_PASS improved')) {
        throw 'P4 did not report TEST_PASS.'
    }
} finally { Pop-Location }
