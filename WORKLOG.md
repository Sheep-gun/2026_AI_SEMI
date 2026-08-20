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

- The continuation handoff requested `<LOCAL_HANDOFF_PATH>`, but `Test-Path -LiteralPath` returned false. The complete repository was found at `<LOCAL_WORKSPACE>`; it was used in place without moving or duplicating files.
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

### T0 structural clockless baseline

- Added `rtl/traditional_async/aer_traditional_structural.sv` with explicit cross-coupled NOR SR storage, fixed-priority request capture, no global clock and no MUTEX.
- Reused the frozen asynchronous workload through a wrapper. Vivado RTL and post-synthesis functional runs each passed 139/139 events with zero assertions.
- Ran an 82-trial request-skew sweep for source pairs 0/15 and 3/7. RTL and post-synthesis functional runs completed all trials without loss, duplicate, X output or short request pulses.
- Back-annotated Vivado SDF after removing unsupported `PATHPULSE` records for the diagnostic copy. All 82 events completed, but 40 trials selected the lower-number fixed-priority source even when the higher-number source arrived 1-20 ps earlier.
- Vivado synthesized 70 LUT and 0 FF while preserving eight feedback timing loops and six `LUTLP-1` DRC violations.
- Cadence Xcelium zero-delay simulation did not converge. A simulation-only 1 ps primitive delay exposed repeated address changes while request remained high. Genus mapped 108 cells and area 1,353.845 only by inserting loop breakers; no valid constrained timing/Fmax was available.
- Classified T0 as the traditional structural baseline and preserved instability as an explicit improvement target.

### P1 buffered round-robin hybrid improvement

- Added `rtl/improved/aer_improved_hybrid.sv`: 16 asynchronous held-request inputs, two-flop request synchronizers, source-local depth-2 queues, round-robin arbitration and a one-entry registered valid/ready output.
- Main workload passed Vivado RTL, Vivado post-synthesis functional simulation and Cadence Xcelium: 139 offered/accepted/received, assertion 0, saturation gap exactly one cycle, average latency 18.438 cycles and maximum 44 cycles.
- Added a 192-trial CDC phase sweep covering all 16 sources at 12 request phases from -4.9 ns to +4.9 ns. Vivado RTL, Vivado post-synthesis and Xcelium each delivered 192/192 exactly once with zero errors. The test is labeled digital CDC evidence, not analog metastability proof.
- Vivado sanity synthesis produced 207 LUT and 89 FF, no feedback loops and no unconstrained internal endpoints. The unplaced 10 ns FPGA estimate was WNS -0.813 ns.
- Genus 10 ns mapping produced 478 cells, area 11,605.810, worst data path 3.344 ns, slack +6.202 ns and vectorless power 1.66431 mW.
- Genus 2 ns mapping produced 676 cells, area 15,511.003, worst data path 1.799 ns and zero slack. This is synthesis evidence for a 500 MHz point, not post-layout signoff Fmax.
- VCD power was 1.33562 mW but internal mapping coverage was incomplete, so it remains auxiliary. A queue-flattening experiment improved signal visibility but regressed FPGA mapping from 207 to 347 LUT and was rejected.
- Recorded the broad design comparison in `results/T0_P1_COMPARISON_2026-08-19.md`: P1 improves implementation stability, fairness, burst absorption, backpressure decoupling and throughput at an explicit area/power cost.

### P2 parallel 4x4 hierarchical scheduler optimization

- Held the P1 source interface, CDC, depth-2 queues, elastic output, workload and constraints fixed; changed only the flat 16-way scheduler.
- The first group-then-local serial implementation passed function but failed the 2 ns Genus target with -201 ps slack and area 18,281.895. It was rejected before commit.
- Reworked P2 so all four local 4-way winners are computed in parallel and the global arbiter selects one candidate. RTL main and CDC tests again passed without metric changes.
- Added an explicit 16-source order test. RTL, post-synthesis and Xcelium each produced 16/16 events with zero error in order `0,4,8,12,1,5,9,13,2,6,10,14,3,7,11,15`.
- Final Vivado result: 148 LUT, 95 FF, WNS +1.735 ns and data path 8.114 ns at the 10 ns sanity constraint. P1 used 207 LUT, 89 FF and had WNS -0.813 ns.
- Final Genus 10 ns result: 450 cells, area 11,386.267, data path 3.396 ns, slack +6.132 ns and vectorless power 1.64037 mW.
- Final Genus 2 ns result: 510 cells, area 13,229.093, data path 1.542 ns and zero slack. P2 also reached a 1.8 ns synthesis point with area 14,177.117.
- VCD auxiliary power was 1.70590 mW with only 15.56% driver-net and 0% queue-MDA coverage. It is retained as a possible switching warning, not an absolute power claim.
- Rejected an equal-capacity shared FIFO because explicit 4-bit addresses require at least four times the event-storage bits of implicit per-source counts before pointers and arbitration.

### TSMC 180 nm PDK verification and P2 physical implementation

- Rechecked the official competition notice, OT material and the published 1st Q&A question-list PDF. No written 180 nm requirement or common PVT answer was found; the Q&A document contains participant questions but not organizer answers.
- Read the supplied Liberty header directly. It identifies `SAGE-Modeler TSMC 0.18um`, typical 1.8 V/25°C. The LEF provides `tsm3site` and Metal1-Metal6; the extraction kit uses `t018s6mm.tch` and `t018s6mlv.capTbl`.
- Added a physical-only Genus flow that avoids 52 scan-cell types. The clean netlist contains 458 cells, area 11,506.018 and no SDFF cells.
- Added an MMMC Innovus flow with slow setup and fast hold views, 10 ns clock, 0.2 ns uncertainty, 60% target utilization, signal pin placement, VDD/VSS core ring, CTS, hold optimization and post-route coupled extraction.
- Final floorplan: die 182.160×176.400 µm, core 141.240×136.080 µm. Final design: 476 placed cells, area 11,812.046 µm², density 61.45% and routing overflow 0%.
- Final post-route setup slack was +2.721 ns at slow 1.62 V/125°C. An initial -34 ps fast-corner hold violation on the CDC synchronizer path was fixed with post-CTS hold optimization; final hold slack was +33 ps.
- Generated 504-net coupled SPEF plus DEF, SDF, post-route Verilog and an RC-preserving Innovus database. Innovus route DRC reported zero violations and connectivity reported zero problems including the core power nets.
- Post-route default-activity power was 1.15140032 mW in the slow 1.62 V setup view. It is not compared directly with the previous typical-corner Genus/VCD values.
- Recorded the boundary: this is digital core P&R, not pad/package or foundry GDS/DRC/LVS signoff. Required GDS/CDL, stream-out map, rule decks and standard-cell Verilog models were not found.
- Rendered two reviewable PNGs directly from the final DEF: placement/power-grid view and full Metal1-Metal6 post-route view. The renderer verifies that all 476 components are present before writing images.
- Restored the final RC-preserving Innovus database under Xvfb and used Innovus `gui_dump_picture` directly to export a native 1800×1400 post-route screenshot.

### B0-v1 matched 180 nm physical baseline

- Identified that P2-only Innovus evidence was insufficient for a fair physical comparison. T0 remains physically invalid because of feedback-loop instability, so B0-v1 was selected as the implementable traditional reference.
- Added scan-free B0 Genus, SDC, MMMC and Innovus scripts using the same 180 nm kit, 10 ns clock, 0.2 ns uncertainty, 60% target utilization, VDD/VSS core ring, CTS/hold optimization and post-route coupled extraction as P2.
- B0 Genus produced 94 cells, area 1,573.387 and worst data path 0.940 ns. Innovus completed with setup +6.704 ns, hold +0.103 ns, route DRC 0 and connectivity problems 0.
- B0 post-route used 94 cells, cell area 1,573.387 µm², density 59.87%, default-activity power 0.08285847 mW and 113 SPEF nets.
- Matched comparison showed P2 at 7.51× area and 13.90× default-activity power, while improving peak throughput 4×, average latency 37.8%, maximum latency 95.1% and source-15 hotspot latency 91.8%.

### P3 depth-1 pending-buffer optimization

- Replaced P2's sixteen 2-bit queue counters with sixteen 1-bit pending slots while preserving 2FF CDC, hierarchical round-robin, source acknowledgements and the elastic output.
- Vivado RTL, post-synthesis, Xcelium, 192-phase CDC and 16-source order regressions all passed. Throughput remained 1 event/cycle; average latency improved from 18.438 to 16.517 cycles and maximum latency from 44 to 29 cycles.
- Vivado mapping fell from 148 LUT/95 FF to 70 LUT/79 FF and WNS improved from +1.735 to +2.546 ns.
- Scan-free Genus 10 ns mapping produced 293 cells, area 8,675.251, data path 3.132 ns and vectorless power 1.13497 mW. The 2 ns and 1.8 ns areas were 9,942.610 and 9,999.158.
- Innovus completed at 311 cells, area 8,981.280 µm², density 62.11%, setup +3.131 ns, hold +0.027 ns, default-activity power 0.92491907 mW, DRC 0 and connectivity problems 0.
- P3 reduced P2 post-route cells 34.7%, area 24.0%, power 19.7% and SPEF nets 29.8%, so it replaced P2 as the main design candidate.
- Implemented a functionally equivalent P3-flat experiment with one 4-bit pointer. It passed 139/139 events but used 171 LUT and had a 9.033 ns data path versus hierarchical P3's 70 LUT and 4.016 ns. It was rejected before Cadence P&R.
- Rejected complete pending-bit removal from the equal-function comparison because it prevents early source acknowledgement during receiver stalls and removes the verified 16-event decoupling capacity.
- Reopened the saved P3 RC-preserving Innovus database under Xvfb and exported a native 1800×1400 post-route PNG with `gui_dump_picture`; the image and capture script are now recorded in the P3 evidence manifest.
- Rewrote the public README and competition report around plain-language T0/P3 explanations, corrected the baseline SVG to match the clockless T0 structure, localized the four-phase flow, and added a dedicated P3 architecture SVG.

### T0-PPA physically comparable traditional asynchronous baseline

- Replaced the structural cross-coupled-NOR storage implementation with five characterized TSMC 180 nm transparent latch cells while retaining no global clock, fixed priority, no FIFO, one 4-bit bus and active-high four-phase handshakes.
- Preserved five `DLY4X1` cells on the grant-capture control path and one additional request-launch delay cell. No `cdn_loop_breaker` appears in the Genus or Innovus netlists.
- Vivado and Cadence Xcelium main workloads passed 139/139 events with zero assertions. The 84-trial skew/X-window stress had zero event, unknown or pulse errors; 42 first-winner shifts document fixed-priority rather than FCFS behavior.
- Conformal LEC passed all 21 output and five state compare points with zero nonequivalent, abort or unknown points.
- Post-route conservative bundled-data analysis measured 1.915 ns latest slow address-data arrival versus 2.591 ns earliest fast capture-control arrival, giving +0.676 ns relative margin before the additional latch/request delay.
- Genus mapped 100 cells, area 1,397.088 µm² and vectorless power 0.0451046 mW. Innovus preserved 100 cells and the six delay cells, with 1,397.088 µm² cell area, 59.82% density, 0.03483881 mW slow/default-activity power, 120 SPEF nets, DRC 0 and connectivity 0.
- Recorded the validity boundary: this is a PPA-qualified traditional baseline under a held-request and stable-capture-aperture contract, not a characterized-MUTEX proof for arbitrary near-simultaneous analog edges.

### P4 cut-through and homeostatic exploration

- Identified P3's fixed service bubble: a synchronized request was written to `pending_q` and became eligible only in the following arbitration cycle.
- Implemented P4-C so the newly accepted `pending_d` participates in the same next-state arbitration decision. It retained 2FF CDC, sixteen one-event pending slots, hierarchical round-robin, one 4-bit output lane and 1 event/cycle peak throughput.
- P4-C passed Vivado RTL/post-synthesis main, 192-phase CDC and 16-source order tests, plus Cadence Xcelium 139/139 main, 192/192 CDC and 16/16 order tests. Conformal LEC passed all 100 compare points.
- Against P3, average latency improved 4.70% (16.517 to 15.741 cycles), maximum latency 3.45% (29 to 28) and source-15 hotspot latency 25% (4 to 3).
- P4-C Genus used 308 cells, area 8,568.807 µm², 2.990 ns data path and 1.16579 mW vectorless power. Post-route used 362 cells, area 9,353.837 µm², setup +3.547 ns, hold +0.004 ns, default-activity power 0.96067953 mW, DRC 0 and connectivity 0.
- Explored P4-H homeostatic backpressure steering. It moved the group pointer toward aged backlog during receiver stalls and demonstrated `15 blocker -> 5 aged -> 0 fresh`, but post-route cost rose to 391 cells, 10,039.075 µm² and 1.02219972 mW. It was retained as a QoS research extension rather than the main design.
- Selected P4-C as the new main improved controller because it improves latency and setup margin with only 4.15% post-route area and 3.87% default-power increases over P3.

### P7-GE Gray-epoch arbitration and documentation rewrite

- Replaced P4-C's 10-bit hierarchical round-robin state with a 4-bit Gray epoch and XOR tournament while retaining the 16 source-indexed pending slots, registered output, early ACK and 1 event/cycle peak throughput.
- Added the final robust reset release synchronizer; reset recovery/removal closed at +8.366/+0.340 ns after route.
- Passed broad 139/139, RTL/gate CDC 192/192 each, full-backlog Gray order, 64 random pending masks, worst-position 16 service decisions, Xcelium and 96/96 Conformal equivalence.
- Under the common fixed-demand workload, P4-C and P7-GE kept the same aggregate end-to-end service timing and stall elasticity; output-address bit transitions fell from 174 to 106.
- Genus mapped 236 cells, 7,248.226 µm², 2.508 ns data path and 0.887720 mW vectorless power. Innovus completed at 292 cells, 8,063.194 µm², setup +4.350 ns, hold +0.006 ns and 0.85619239 mW, with DRC/connectivity 0/0.
- Rejected the P7-GE fall-through output as the main design because its -2.380 ns register-to-output slack failed the 10 ns interface constraint despite a one-cycle no-stall latency gain.
- Rewrote README.md and the Korean competition report using the reference submission's problem → intuition → circuit operation → evidence → limitation narrative. Technical terms, PPA conditions, non-signoff boundaries and second-task IP reuse scope remain explicit.

### P8-DG-SCR direct-Gray, shared-tree and reset-partition optimization

- Held P7-GE's external and storage contract fixed: source-local 2FF CDC, pending 16, registered output 1, early ACK, one 4-bit lane, one event/clock peak throughput and at most 16 service decisions for persistent requests excluding receiver-stall time.
- Explored sparse-reset, direct-Gray, shared-valid-tree, two-XOR, strict Gray-ring pointer reuse, full synchronous-core reset and split-reset candidates. Exhaustively checked the XOR tournament and strict ring selectors across 1,048,576 preference/mask combinations each.
- Selected P8-DG-SCR: direct registered Gray state, shared pair/quarter/half/grant OR tree, vector request acceptance, two async-reset release FFs, 36 resetless FFs and 37 synchronous-clear core FFs with ACK/valid output isolation.
- Passed Vivado RTL and post-synthesis broad 139/139, CDC 192/192, exact full-Gray order, 64 random masks, worst-position 16 service decisions and clockless/mid-phase reset tests with zero errors. Cadence Xcelium repeated broad, CDC, fairness and reset tests with zero errors.
- The fixed 101-event contract workload remained identical to P7 at the DUT boundary: events 101, errors 0, saturation span 630 ns, average saturation demand-to-output 354 ns, five pre-release stall ACKs and 106 address toggles.
- Genus FPR 180 nm mapped 232 cells, 6,383.362 µm², 3.130 ns data path, +6.657 ns setup slack and 0.848839 mW vectorless power. RTLStim2Gate VCD power was 0.620896 mW versus P7 0.686263 mW (-9.525%), but gate driver coverage differed 51.21% versus 37.10%, so this remains a directional auxiliary result.
- Conformal mapped all 75 state points as equivalent with nonequivalent/abort/unknown all zero.
- Final Innovus rerun added explicit synchronizer preservation/grouping, a 0.9 ns CDC pair max-delay and the same CLKBUFX20 root driver used by P7. It completed at 313 instances and 7,657.373 µm² with core setup +3.235 ns, CDC max-delay +0.201 ns, hold +0.028 ns, recovery +9.104 ns, removal +0.043 ns, 0.81695915 mW, clock-tree/DRC/connectivity violations 0. Versus P7 this is -5.03% cell area and -4.58% estimated power.
- Restored the RC-preserving Innovus database and exported a native 1800×1400 post-route PNG. Preserved DEF, SDF, SPEF, post-route Verilog, Genus/LEC/Innovus reports and sanitized tool logs.
- Reclassified all 180 nm results as server-provided reference comparisons rather than an organizer-confirmed target. Official-process migration is deferred until the organizer answers; P7 and P8 will be rerun together under that target.
