param([string]$VivadoBin = 'C:\Xilinx\Vivado\2020.2\bin')
$ErrorActionPreference = 'Stop'
$root = (Resolve-Path -LiteralPath "$PSScriptRoot\..").Path
$work = Join-Path $root 'sim\improved_homeostatic_behavior_work'
$logs = Join-Path $root 'sim\logs'
New-Item -ItemType Directory -Force -Path $work, $logs | Out-Null
Push-Location $work
try {
    & (Join-Path $VivadoBin 'xvlog.bat') --sv --work worklib `
        --log (Join-Path $logs 'improved_homeostatic_behavior_compile.log') `
        (Join-Path $root 'rtl\improved\aer_improved_homeostatic.sv') `
        (Join-Path $root 'tb\aer_improved_homeostatic_behavior_tb.sv')
    if ($LASTEXITCODE -ne 0) { throw 'P4 behavior compile failed.' }
    & (Join-Path $VivadoBin 'xelab.bat') worklib.aer_improved_homeostatic_behavior_tb `
        -s improved_homeostatic_behavior_sim --debug typical `
        --log (Join-Path $logs 'improved_homeostatic_behavior_elaborate.log')
    if ($LASTEXITCODE -ne 0) { throw 'P4 behavior elaboration failed.' }
    & (Join-Path $VivadoBin 'xsim.bat') improved_homeostatic_behavior_sim `
        --runall --log (Join-Path $logs 'improved_homeostatic_behavior.log')
    if ($LASTEXITCODE -ne 0) { throw 'P4 behavior simulation failed.' }
    if (!(Select-String -LiteralPath (Join-Path $logs 'improved_homeostatic_behavior.log') -SimpleMatch 'P4_BEHAVIOR_TEST_PASS')) {
        throw 'P4 behavior pass marker missing.'
    }
} finally { Pop-Location }
