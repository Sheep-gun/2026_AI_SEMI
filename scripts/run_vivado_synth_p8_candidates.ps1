param(
    [string]$VivadoBin = 'C:\Xilinx\Vivado\2020.2\bin'
)

$ErrorActionPreference = 'Stop'
$repoRoot = (Resolve-Path -LiteralPath "$PSScriptRoot\..").Path
$vivado = Join-Path $VivadoBin 'vivado.bat'

$runs = @(
    @{ Name = 'sparse_reset'; Script = 'scripts/vivado_synth_p8_sparse_reset.tcl' },
    @{ Name = 'direct_gray'; Script = 'scripts/vivado_synth_p8_direct_gray.tcl' }
)

Push-Location $repoRoot
try {
    foreach ($run in $runs) {
        $reportDir = Join-Path $repoRoot "reports\p8_candidates\vivado_$($run.Name)"
        New-Item -ItemType Directory -Force -Path $reportDir | Out-Null
        & $vivado -mode batch -source $run.Script `
            -log "reports/p8_candidates/vivado_$($run.Name)/vivado.log" `
            -journal "reports/p8_candidates/vivado_$($run.Name)/vivado.jou"
        if ($LASTEXITCODE -ne 0) {
            throw "P8 $($run.Name) synthesis failed with exit code $LASTEXITCODE"
        }
    }
} finally {
    Pop-Location
}
