param(
    [string]$VivadoBin = 'C:\Xilinx\Vivado\2020.2\bin'
)

$ErrorActionPreference = 'Stop'
$repoRoot = (Resolve-Path -LiteralPath "$PSScriptRoot\..").Path
$runs = @(
    @{
        Name='onehot_tree';
        Rtl='rtl/improved/aer_pending_direct_gray_scr_onehot_tree.sv';
        Top='aer_pending_direct_gray_scr_onehot_tree'
    },
    @{
        Name='loop_reduce';
        Rtl='rtl/improved/aer_pending_direct_gray_scr_loop_reduce.sv';
        Top='aer_pending_direct_gray_scr_loop_reduce'
    },
    @{
        Name='onehot_decode';
        Rtl='rtl/improved/aer_pending_direct_gray_scr_onehot_decode.sv';
        Top='aer_pending_direct_gray_scr_onehot_decode'
    }
)

Push-Location $repoRoot
try {
    foreach ($run in $runs) {
        $report = "reports/p9_candidates/vivado_$($run.Name)"
        New-Item -ItemType Directory -Force -Path $report | Out-Null
        & (Join-Path $VivadoBin 'vivado.bat') -mode batch `
            -log "$report/vivado.log" -journal "$report/vivado.jou" `
            -source scripts/vivado_synth_p9_candidate.tcl `
            -tclargs $run.Rtl $run.Top $report
        if ($LASTEXITCODE -ne 0) {
            throw "P9 $($run.Name) synthesis failed with exit code $LASTEXITCODE"
        }
    }
} finally {
    Pop-Location
}
