# 2026 AI SEMI - AER Digital First-Round Design

This repository contains a clean-room AER communication design for team **최태원의 검**. It intentionally contains no ECG, SNN ECG Classifier, or previous ECG SoC RTL.

## Current artifacts

- `PROJECT_CONTEXT.md`: confirmed scope, facts, assumptions, and live status.
- `DESIGN_DECISIONS.md`: baseline definition, alternatives, and frozen decisions.
- `WORKLOG.md`: commands and observed results.
- `docs/requirements/SPECIFICATION.md`: comparison specification and metrics.
- `docs/architecture/AER_BASELINE_AND_CANDIDATES.md`: tutorial and bottleneck analysis.
- `docs/architecture/aer_4phase_handshake_flow.svg`: B0-v1 source/AER four-phase sequence diagram.
- `docs/references/REFERENCES.md`: source-backed bibliography and claim map.
- `rtl/baseline/aer_traditional.sv`: synthesizable traditional AER baseline.
- `tb/aer_traditional_tb.sv`: self-checking baseline testbench.
- `scripts/run_baseline.ps1`: Vivado Simulator batch compile/simulation runner.
- `scripts/server_inventory.sh`: read-only Cadence/library inventory for an authenticated server shell.

## Local baseline simulation

From PowerShell in the repository root:

```powershell
.\scripts\run_baseline.ps1
```

The script uses Vivado Simulator 2020.2 by default. It writes separate compile, elaboration, and run logs in `sim/logs/`, plus `aer_traditional.wdb` and `aer_traditional.vcd` in `sim/waves/`. A successful run ends with `TEST_PASS` and exits with status 0.

## Vivado synthesis sanity check

```powershell
.\scripts\run_vivado_synth_baseline.ps1
```

This creates reports under `reports/baseline/vivado_sanity/`. It is an FPGA structural check only; do not use its LUT/FF/timing values as ASIC PPA.

## Cadence environment inventory

Do not add a password to a script. After establishing an interactive or key-based SSH session, run:

```sh
csh -f scripts/server_inventory.sh
```

Copy the resulting non-secret tool/library path inventory into `reports/environment/` before writing synthesis Tcl. Exact libraries and PVT corners must be discovered, not guessed.

## Result integrity rules

- Simulation metrics, synthesis PPA, and theoretical targets are separate evidence classes.
- Baseline and improved designs use the same source count, address width, receiver readiness trace, constraints, library/PVT, output load, and activity window.
- Vectorless power is labeled vectorless. VCD/SAIF-based power records its activity window and mapping coverage.
- Raw logs and reports are retained. Summary tables link back to those files.
