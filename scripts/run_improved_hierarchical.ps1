param(
    [string]$VivadoBin = 'C:\Xilinx\Vivado\2020.2\bin'
)

$ErrorActionPreference = 'Stop'
$root = (Resolve-Path -LiteralPath "$PSScriptRoot\..").Path
$work = Join-Path $root 'sim\improved_hierarchical_work'
$logs = Join-Path $root 'sim\logs'
$waves = Join-Path $root 'sim\waves'
New-Item -ItemType Directory -Force -Path $work, $logs, $waves | Out-Null

Push-Location $work
try {
    & (Join-Path $VivadoBin 'xvlog.bat') --sv --work worklib `
        --log (Join-Path $logs 'improved_hierarchical_compile.log') `
        (Join-Path $root 'rtl\improved\aer_improved_hierarchical.sv') `
        (Join-Path $root 'tb\aer_improved_hierarchical_test_wrapper.sv') `
        (Join-Path $root 'tb\aer_improved_hybrid_tb.sv')
    if ($LASTEXITCODE -ne 0) { throw 'P2 RTL compile failed.' }

    & (Join-Path $VivadoBin 'xelab.bat') worklib.aer_improved_hybrid_tb `
        -s improved_hierarchical_sim --debug typical `
        --log (Join-Path $logs 'improved_hierarchical_elaborate.log')
    if ($LASTEXITCODE -ne 0) { throw 'P2 RTL elaboration failed.' }

    & (Join-Path $VivadoBin 'xsim.bat') improved_hierarchical_sim `
        --tclbatch '../../scripts/xsim_improved_hierarchical.tcl' `
        --log '../logs/improved_hierarchical.log'
    if ($LASTEXITCODE -ne 0) { throw 'P2 RTL simulation failed.' }
    if (!(Select-String -LiteralPath (Join-Path $logs 'improved_hierarchical.log') `
            -SimpleMatch 'TEST_PASS improved')) {
        throw 'P2 RTL simulation did not report TEST_PASS.'
    }
} finally {
    Pop-Location
}

