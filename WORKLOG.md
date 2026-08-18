# WORKLOG

All times are Asia/Seoul unless otherwise stated.

## 2026-08-18

### Requirements and environment

- Rendered and visually inspected pages 2-3 of the supplied orientation PDF using Poppler.
- Confirmed digital first-round topic and required RTL/synthesis/timing/area/power/frequency deliverables.
- Inspected the workspace with `rg --files`, `Get-ChildItem`, and Git. No pre-existing design files were present.
- Checked local EDA executables. `iverilog`, `vvp`, `verilator`, and `yosys` were initially absent from `PATH`.
- Located Vivado Simulator 2020.2 at `C:\Xilinx\Vivado\2020.2\bin`. The batch verification flow now uses `xvlog`, `xelab`, and `xsim`.
- A workspace-local Icarus installer was downloaded after the initial tool check, but installation exited unsuccessfully and installed no tool files. The attempt was stopped once the existing Vivado installation was identified. The temporary installer remains only under git-ignored `tmp/` because the host blocked automated deletion.
- Attempted the following read-only, non-interactive server check:

  `C:\Windows\System32\OpenSSH\ssh.exe -o BatchMode=yes -o ConnectTimeout=10 -o StrictHostKeyChecking=yes <account>@<host> hostname`

  Result: authentication rejected because no approved non-interactive credential was available. The endpoint and account are intentionally omitted from the public repository. No server library or PVT claim has been made.

### Literature and architecture

- Read the Stanford-hosted Boahen 2000 point-to-point AER paper and Boahen 2004 burst-mode transmitter paper.
- Read Purohit and Manohar 2022 on AER arbitration/encoding topologies.
- Recorded the traditional baseline and selected the single-lane buffered round-robin elastic architecture.

### Implementation

- Created the required project directory structure and top-level state documents.
- Added the traditional four-phase baseline RTL and a self-checking SystemVerilog testbench.
- Vivado `xvlog` compilation and `xelab` elaboration passed. The first XSIM launch exposed a Vivado 2020.2 wrapper issue with space-containing absolute Tcl/WDB paths; the runner now uses work-relative paths.
- The first complete XSIM run passed all directed protocol phases but exposed a testbench-only long-random process-join bug: expected-event accounting advanced before all nested `fork/join_none` streams were launched. The random phase was rewritten as 16 explicit independent source streams.
- Final baseline XSIM rerun after adding a dedicated saturation phase: `TEST_PASS`, 431 issued and 431 received events, zero procedural assertion failures. The 128-event no-stall saturation window had a fixed four-cycle inter-event gap, or 0.25 event/cycle. Suite-wide average latency was 29.658 cycles, maximum latency 901 cycles, and throughput 0.244608 event/cycle. These suite-wide values include reset, receiver stalls, and deliberately unfair hotspot/random phases; they are not peak-throughput claims.
- Preserved `sim/logs/baseline_compile.log`, `sim/logs/baseline_elaborate.log`, `sim/logs/baseline.log`, `sim/waves/aer_traditional.wdb`, and `sim/waves/aer_traditional.vcd`.
- Enabled the two concurrent SVA properties during Vivado compilation and reran the complete regression successfully.
- First Vivado synthesis-sanity launch stopped before RTL parsing because Vivado 2020.2 truncated the space-containing absolute RTL path at `.../2026`. The Tcl flow was changed to repository-relative paths; the failed log is retained.
- Second synthesis-sanity launch synthesized `aer_traditional` successfully with 0 synthesis warnings/errors, then stopped in the report-constraint phase because `remove_from_collection` is a Synopsys command not supported by Vivado Tcl. Input selection was replaced with a Vivado `get_ports -filter` expression.
- Final Vivado synthesis-sanity run completed with `BASELINE_SANITY_PASS`: 0 synthesis errors/warnings, 41 LUTs, 10 FFs, no combinational loops, and no unconstrained internal endpoints. Estimated unplaced FPGA WNS was +1.401 ns at 10 ns. These values are labeled non-ASIC.
- Froze the traditional reference as `B0-v1` and recorded SHA-256 hashes for RTL, testbench, scripts, logs, waveform, reports, and checkpoint.
- Added `docs/architecture/aer_4phase_handshake_flow.svg`, a rendered/visually checked sequence diagram that separates the source-side handshake from the receiver-facing four AER phases.

### Repository hygiene and isolated B0-v1 reproduction

- The continuation handoff requested `C:\Users\YangGeon\Documents\2026_ai_semi_aer`, but `Test-Path -LiteralPath` returned false. The complete repository was found at the active workspace `C:\Users\YangGeon\Documents\2026_AI_SEMI`; it was used in place without moving or duplicating files.
- Ran `git status --short --branch`, `git remote -v`, and `rg --files -uu -g '!.git/**'`. The repository had no commits and no configured remote. All project files were untracked; Vivado/XSIM and review/install temporary products were also present locally.
- Expanded `.gitignore` for `tmp/`, workspace-local tools, `.Xil`, XSIM work/snapshots, WDB/PB/XPR files, Vivado project directories, journals, backup logs, and Cadence Xcelium/Genus/Innovus runtime state. Existing files were preserved locally; none were deleted.
- Added `.gitattributes` to keep text artifacts LF-stable across Windows/Linux checkouts, mark DCP/WDB/media as binary, and exempt fixed-width generated reports plus intentional Markdown hard breaks from whitespace rewriting. This preserves manifest-bound bytes.
- Ran `git ls-files --others --exclude-standard` and scanned the 30 candidate files for private-key headers, known cloud-token prefixes, credential assignments, and credential-bearing URLs. Result: zero pattern hits. The scan intentionally applies to Git candidates; ignored browser/tool state under `tmp/` is outside repository scope.
- Parsed all rows of `results/BASELINE_MANIFEST_2026-08-18.md` and checked each path with `Get-FileHash -Algorithm SHA256` plus byte length. Result before reproduction: 13/13 pass.
- Copied the six manifest-bound RTL/TB/runner files into the Git-ignored `tmp/codex_b0_v1_recheck_20260818/` workspace and ran:

  `tmp\codex_b0_v1_recheck_20260818\scripts\run_baseline.ps1`

  Result: Vivado Simulator 2020.2 passed with `TEST_PASS baseline issued=431 received=431`; saturation throughput 0.25 event/cycle, average latency 29.658 cycles, worst latency 901 cycles, and source-15 hotspot maximum 49 cycles, matching the frozen result.
- Ran:

  `tmp\codex_b0_v1_recheck_20260818\scripts\run_vivado_synth_baseline.ps1`

  Result: `BASELINE_SANITY_PASS`; 41 LUTs, 10 FFs, WNS +1.401 ns, estimated data-path delay 5.161 ns, 0 warnings, 0 critical warnings, 0 errors, 0 combinational loops, and 0 unconstrained internal endpoints. This remains an FPGA structural sanity result, not ASIC PPA.
- Revalidated the original manifest after both isolated runs. Result: 13/13 pass, confirming the source-of-truth evidence was not overwritten.
- Initial local snapshot command: `git commit -m "feat: establish B0-v1 traditional AER baseline"`. No remote push is possible until a private remote URL is supplied.

- Next design step after the initial snapshot: implement `B1 round-robin-only` without changing source count, address width, output-lane count, FIFO depth, receiver protocol, traffic, or backpressure trace.

## 2026-08-19

### Korean public repository documentation

- Verified `origin=https://github.com/Sheep-gun/2026_AI_SEMI.git`, the public visibility, and `master` as the default branch using `git remote -v`, `git ls-remote --heads origin`, and the GitHub public repository API.
- Rewrote `README.md` in Korean around the sequence: project goal and staged comparison plan, traditional AER definition, B0-v1 controller structure, 4-phase handshake, baseline bottlenecks, frozen results, reproduction, and evidence boundaries.
- Rewrote `docs/architecture/AER_BASELINE_AND_CANDIDATES.md` in Korean while preserving the explicit scope boundary that B0-v1 is one reproducible traditional comparison point, not every historical AER circuit.
- Added `docs/architecture/aer_baseline_controller_structure.svg` from the actual RTL structure: 16 source requests, fixed-priority encoder, `grant_q`, four-state FSM, one-hot source acknowledge decode, one shared address link, and receiver acknowledgement feedback.
- Rendered both architecture SVGs to ignored review PNGs with headless Edge and visually inspected them. Corrected the controller diagram's FSM order to `IDLE → WAIT_SINK_ACK → WAIT_SOURCE_RELEASE → WAIT_SINK_RELEASE → IDLE` and corrected `src_ack`/`aer_ack` arrow directions against the RTL.
- Embedded both the controller-structure SVG and the existing `aer_4phase_handshake_flow.svg` directly in the public README and detailed architecture document.
- Because the repository is public, removed the Cadence endpoint/account identifiers from current public-facing text and parameterized `scripts/server_inventory.sh` with `$HOME`, `AER_CADENCE_ENV`, and `AER_CADENCE_ROOT`. Passwords and private keys remain forbidden.
- Validation results before commit: both SVGs parsed as XML, zero broken local Markdown links, original B0-v1 manifest 13/13 pass, zero current operational endpoint/account identifier matches, and `git diff --check` pass.
- Publish command after commit: `git push -u origin master`.

### Baseline structure diagram readability correction

- A GitHub-width review exposed label/arrow collisions in the first controller-structure SVG. Replaced the dense drawing with a sparse three-column datapath (`sources → encoder → grant → output → receiver`) and a separate horizontal FSM state sequence.
- Kept only architecture-defining labels, moved the four bottlenecks into independent cards, and routed `src_req`, `src_ack`, `aer_ack`, and `state_q` without crossing text or block titles.
- Rendered the replacement at its native 1500 px width and inside a 1200 px GitHub-style container. Both views were visually inspected for clipping, overlap, signal direction, and FSM order before replacement.

### Cadence asynchronous-cell library audit

- Connected with Windows OpenSSH through a password prompt/standard input only. No credential was written to a file, script, repository, or reported output.
- Verified Genus 23.14-s090_1, Innovus 23.14-s088_1 and Xcelium 23.09-s013. Genus checked out `Genus_Synthesis`, loaded `typical.lib`, and recognized 470 cells.
- Verified three project corners: fast 1.98 V/0 °C, typical 1.80 V/25 °C, and slow 1.62 V/125 °C, plus active LEF, QRC technology and capacitance-table artifacts.
- Searched the project Liberty/LEF/CDB/documentation and relevant installed component material for MUTEX, Muller C-element, asynchronous arbiter and metastability-related cells. No characterized project cell was found.
- Found `RSLAT*` in Liberty, but Genus reported missing-clock warnings and the corresponding LEF macro blocks are commented out. Found active `DLY1X1`~`DLY4X1`, ordinary transparent latches and combinational gates.
- Confirmed that installed `CW_arbiter_fcfs` is clocked and `CW_asymfifo_*` means asymmetric data width, not asynchronous operation; both are synchronous components.
- Recorded the sanitized evidence and design boundary in `reports/environment/CADENCE_ASYNC_LIBRARY_AUDIT_2026-08-19.md`.

### A0-functional clockless baseline

- Added `rtl/async_baseline/aer_traditional_async.sv` with no `clk` port. Fixed-priority grant and four-phase state progress are driven by source/receiver handshake changes and latch state.
- Added a self-checking asynchronous testbench covering single, simultaneous-16, burst, receiver delay, saturation, fixed-priority hotspot, held request across reset and 16 independent streams.
- The first XSIM run exposed a delta-cycle request glitch between two request-high states and Vivado task sensitivity limits. Replaced multi-assignment outputs with single continuous expressions and used explicit source-model response delay.
- The second run exposed that `always_latch` did not re-enter after its own IDLE state update when requests were already high. Replaced it with an explicit clockless event sensitivity including `state_q`, allowing an already-pending request to launch immediately after link release.
- Final command `scripts/run_async_baseline.ps1` passed: 139 issued, 139 received, zero loss/duplicate/assertion failures, average TB latency 26.877 ns, maximum 241 ns, and `TEST_PASS async_baseline`.
- Ran `scripts/run_vivado_synth_async_probe.ps1`. Vivado produced 42 LUTs and six latch primitives with two expected latch-inference warnings, plus 80 no-clock checks, 10 unconstrained internal endpoints and two latch loops. This is a structure probe, not timing/PPA signoff.
- Froze the evidence as `A0-functional` and recorded its scope, result and SHA-256 manifest. The fixed-priority encoder is not a metastability-safe MUTEX and no such claim is made.

### Custom MUTEX/C-element feasibility audit

- Reconnected through password standard input only and searched the configured custom-IC environment without writing credentials.
- Confirmed Spectre 23.1.0.275.isr2 is installed. Virtuoso, Liberate, Cadence PVS, Assura, Pegasus and Calibre were not available; `/usr/sbin/pvs` was confirmed to be the Linux LVM utility.
- Searched project and shared paths for transistor models, GDS/GDSII, CDL, DRC/LVS rule decks, technology libraries and PDK directories. Project-qualified artifacts were not found.
- `.scs` and `.tf` files under shared tool paths were limited to Cadence product examples/samples/documentation, including generic AMS `gpdk` examples; they are not project foundry PDK evidence.
- Re-inspected orientation PDF pages 2-3. Digital submission requires RTL/synthesis/timing/area/power/frequency, while analog explicitly includes layout/RC extraction. The document neither permits nor forbids digital custom cells.
- Recorded the sanitized evidence and required organizer questions in `reports/environment/CADENCE_CUSTOM_CELL_FEASIBILITY_2026-08-19.md`.

### A0 race and post-synthesis stability test

- Added `tb/aer_traditional_async_race_tb.sv` and `scripts/run_async_race.ps1` for source pairs `0/15` and `3/7`, request skew from -20 ps to +20 ps, exact simultaneous requests and two 1 ps X-window cases.
- RTL result: 84 trials, zero loss/duplicate/deadlock, zero unknown output, zero short pulse, and `RACE_TEST_PASS digital_model trials=84`.
- Exported the Vivado post-synthesis LUT/latch netlist and SDF. Full SDF annotation failed because LDCE latch timing arcs could not map to the simulator primitive model.
- Removed six LDCE blocks and 87 unsupported PATHPULSE statements only for diagnosis. Partial LUT/IO SDF annotation succeeded, but the first trial deadlocked with state fixed at IDLE.
- Ran the post-synthesis functional netlist without SDF. All 84 trials completed zero receiver events, with 84 missing winners, two unknown-output observations and 170 assertion failures.
- Marked A0 as RTL-only protocol evidence and rejected it as a physical implementation/PPA baseline. Recorded details in `results/ASYNC_RACE_STRESS_2026-08-19.md`.
