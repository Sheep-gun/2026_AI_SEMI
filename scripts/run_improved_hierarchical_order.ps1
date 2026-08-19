param(
    [ValidateSet('rtl', 'gate')]
    [string]$Mode = 'rtl',
    [string]$VivadoBin = 'C:\Xilinx\Vivado\2020.2\bin'
)

$ErrorActionPreference = 'Stop'
$root = (Resolve-Path -LiteralPath "$PSScriptRoot\..").Path
$work = Join-Path $root "sim\improved_hierarchical_order_${Mode}_work"
$logs = Join-Path $root 'sim\logs'
New-Item -ItemType Directory -Force -Path $work, $logs | Out-Null

$xvlog = Join-Path $VivadoBin 'xvlog.bat'
$xelab = Join-Path $VivadoBin 'xelab.bat'
$xsim = Join-Path $VivadoBin 'xsim.bat'
$tb = Join-Path $root 'tb\aer_improved_hierarchical_order_tb.sv'
$snapshot = "improved_hierarchical_order_${Mode}_sim"
$runLog = Join-Path $logs "improved_hierarchical_order_${Mode}.log"

Push-Location $work
try {
    if ($Mode -eq 'rtl') {
        & $xvlog --sv --work worklib `
            --log (Join-Path $logs 'improved_hierarchical_order_rtl_compile.log') `
            (Join-Path $root 'rtl\improved\aer_improved_hierarchical.sv') $tb
        if ($LASTEXITCODE -ne 0) { throw 'P2 order RTL compile failed.' }
        & $xelab worklib.aer_improved_hierarchical_order_tb -s $snapshot --debug typical `
            --log (Join-Path $logs 'improved_hierarchical_order_rtl_elaborate.log')
    } else {
        & $xvlog --work worklib `
            --log (Join-Path $logs 'improved_hierarchical_order_gate_compile.log') `
            (Join-Path $root 'reports\improved_hierarchical\vivado_sanity\aer_improved_hierarchical_post_synth.v')
        if ($LASTEXITCODE -ne 0) { throw 'P2 order gate compile failed.' }
        & $xvlog --sv --work worklib --define P2_GATE_NETLIST `
            --log (Join-Path $logs 'improved_hierarchical_order_gate_tb_compile.log') $tb
        if ($LASTEXITCODE -ne 0) { throw 'P2 order gate testbench compile failed.' }
        & $xelab worklib.aer_improved_hierarchical_order_tb worklib.glbl -s $snapshot `
            --debug typical -L unisims_ver `
            --log (Join-Path $logs 'improved_hierarchical_order_gate_elaborate.log')
    }
    if ($LASTEXITCODE -ne 0) { throw 'P2 order elaboration failed.' }
    & $xsim $snapshot --runall --log $runLog
    if ($LASTEXITCODE -ne 0) { throw 'P2 order simulation failed.' }
    if (!(Select-String -LiteralPath $runLog -SimpleMatch 'P2_ORDER_TEST_PASS')) {
        throw "P2 order test did not pass in $Mode mode."
    }
} finally {
    Pop-Location
}

