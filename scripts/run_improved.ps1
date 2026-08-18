param(
    [string]$VivadoBin = 'C:\Xilinx\Vivado\2020.2\bin'
)

$ErrorActionPreference = 'Stop'
$root = (Resolve-Path -LiteralPath "$PSScriptRoot\..").Path
$work = Join-Path $root 'sim\improved_work'
$logs = Join-Path $root 'sim\logs'
$waves = Join-Path $root 'sim\waves'
New-Item -ItemType Directory -Force -Path $work, $logs, $waves | Out-Null

Push-Location $work
try {
    & (Join-Path $VivadoBin 'xvlog.bat') --sv --work worklib `
        --log (Join-Path $logs 'improved_compile.log') `
        (Join-Path $root 'rtl\improved\aer_improved_hybrid.sv') `
        (Join-Path $root 'tb\aer_improved_hybrid_tb.sv')
    if ($LASTEXITCODE -ne 0) { throw "xvlog failed with exit code $LASTEXITCODE" }

    & (Join-Path $VivadoBin 'xelab.bat') worklib.aer_improved_hybrid_tb `
        -s aer_improved_hybrid_sim --debug typical `
        --log (Join-Path $logs 'improved_elaborate.log')
    if ($LASTEXITCODE -ne 0) { throw "xelab failed with exit code $LASTEXITCODE" }

    & (Join-Path $VivadoBin 'xsim.bat') aer_improved_hybrid_sim `
        --tclbatch '../../scripts/xsim_improved.tcl' `
        --wdb '../waves/aer_improved_hybrid.wdb' --log '../logs/improved.log'
    if ($LASTEXITCODE -ne 0) { throw "xsim failed with exit code $LASTEXITCODE" }

    if (!(Select-String -LiteralPath (Join-Path $logs 'improved.log') -SimpleMatch 'TEST_PASS improved')) {
        throw 'Simulation returned zero but TEST_PASS improved marker was not found.'
    }
} finally {
    Pop-Location
}
