param([string]$VivadoBin = 'C:\Xilinx\Vivado\2020.2\bin')

$ErrorActionPreference = 'Stop'
$repoRoot = (Resolve-Path -LiteralPath "$PSScriptRoot\..").Path
$rtl = 'rtl/experiments/aer_pending_direct_gray_oht_epoch_variants.sv'
$runs = @(
    @{Name='case'; Top='aer_pending_direct_gray_oht_epoch_case'},
    @{Name='boolean'; Top='aer_pending_direct_gray_oht_epoch_boolean'},
    @{Name='grant_toggle'; Top='aer_pending_direct_gray_oht_epoch_grant_toggle'}
)

Push-Location $repoRoot
try {
    foreach ($run in $runs) {
        $report = "reports/p9_epoch_variants/vivado_$($run.Name)"
        New-Item -ItemType Directory -Force -Path $report | Out-Null
        & (Join-Path $VivadoBin 'vivado.bat') -mode batch `
            -log "$report/vivado.log" -journal "$report/vivado.jou" `
            -source scripts/vivado_synth_p9_candidate.tcl `
            -tclargs $rtl $run.Top $report
        if ($LASTEXITCODE -ne 0) {
            throw "P9 epoch $($run.Name) synthesis failed with exit code $LASTEXITCODE"
        }
    }
} finally {
    Pop-Location
}
