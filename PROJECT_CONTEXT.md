# PROJECT_CONTEXT

## Project identity

- Team: 최태원의 검
- Competition: 2026 AI 반도체 회로 설계 경진대회
- Current scope: 디지털 1차 설계 수행과제 only
- Submission deadline: 2026-08-28 (KST)
- Workspace/source of truth: `C:\Users\YangGeon\Documents\2026_AI_SEMI`

The continuation handoff named `C:\Users\YangGeon\Documents\2026_ai_semi_aer`, but that path did not exist during the 2026-08-18 repository handoff. The complete Git repository and all required B0-v1 artifacts were present in the workspace above, so no directory was moved or duplicated.

ECG, SNN ECG Classifier, and every previous ECG SoC are explicitly out of scope. No RTL or architecture from those projects may be imported.

## Confirmed competition requirements

The orientation PDF was visually inspected on 2026-08-18, pages 2 and 3.

- Topic: AER communication for a Bio-mimic Neuron.
- Required reasoning: analyze a traditional AER information-transfer system, identify its problems, propose improvements, and present a direction for an improved AER design.
- Digital first-round deliverables: RTL, synthesis, timing optimization, area, power, and achievable operating frequency.
- The PDF schedule shows the first result date changed from 2026-08-13 to 2026-08-28.
- The broader judging emphasis includes PPA, robustness, and a defensible explanation of design philosophy, method, performance, and results.

Source PDF: `C:\Users\YangGeon\Downloads\2026년 반도체설계경진대회 오리엔테이션 (2026-07-23).pdf`

## Current local environment

- The Git repository was initialized without earlier commits; `B0-v1` is the first local versioned snapshot.
- At the start of this work there were no project RTL, testbench, constraint, or report files.
- No local `iverilog`, `verilator`, or `yosys` executable was initially present on `PATH`.
- Vivado Simulator 2020.2 is installed at `C:\Xilinx\Vivado\2020.2\bin` and is used in batch mode through `xvlog`, `xelab`, and `xsim`.
- An attempted workspace-local Icarus installation failed before installing files and was abandoned after the existing Vivado installation was identified.
- Repository hygiene excludes temporary Vivado/Cadence project state, XSIM work products, journals, WDB files, and the abandoned installer. Source, testbench, constraints, scripts, documentation, text logs/reports, the VCD, and the small manifest-bound synthesis checkpoint are retained.
- A pre-commit credential-pattern scan over all Git candidates found no private-key header, known cloud-token prefix, credential assignment, or credential-bearing URL. This is repository hygiene evidence, not proof about ignored local browser/tool state.
- Public remote `https://github.com/Sheep-gun/2026_AI_SEMI.git` and default branch `master` were verified through the GitHub public repository API on 2026-08-19.

## Current Cadence server status

- This public repository does not store the server endpoint, account name, password, or private-key material.
- A secure interactive read-only inventory succeeded on 2026-08-19.
- Genus 23.14, Innovus 23.14 and Xcelium 23.09 are available; Genus successfully checked out `Genus_Synthesis` and read the 470-cell typical library.
- Fast/typical/slow Liberty, active LEF, QRC technology and capacitance-table artifacts were verified.
- No characterized MUTEX, Muller C-element, or asynchronous arbiter cell was found. Delay cells and ordinary latches/gates exist, but they do not by themselves prove metastability-safe or QDI behavior.
- Full evidence and scope boundaries are recorded in `reports/environment/CADENCE_ASYNC_LIBRARY_AUDIT_2026-08-19.md`.
- Custom-cell follow-up found Spectre but no Virtuoso, Liberate, Cadence physical-verification tool, project transistor model, GDS/CDL, or DRC/LVS rule deck. A foundry-qualified custom MUTEX/C-element cannot be completed in the current environment.
- The orientation PDF does not state whether digital custom cells are permitted; organizer confirmation is required. Evidence is recorded in `reports/environment/CADENCE_CUSTOM_CELL_FEASIBILITY_2026-08-19.md`.

No password or private key is stored in this repository or its logs.

## Frozen first comparison point

The initial comparison is deliberately small enough to finish and explain before the deadline.

- Default source count: 16 event sources.
- Event representation: source/neuron address only; `ADDR_W = ceil(log2(NUM_SOURCES))`.
- Receiver count: one shared downstream receiver/link.
- Clocking for the first PPA comparison: one synchronous design clock.
- Reset: active-low asynchronous assertion; reset release must be synchronized at integration level.
- Same comparison conditions: source count, address width, receiver readiness trace, clock constraints, I/O delays, load, library/PVT, synthesis options, and activity window.
- Global event ordering is arbitration-dependent. Per-source order must be preserved.
- Accepted events may not be lost or duplicated. Backpressure is allowed to delay an event.

### Traditional baseline

- One shared address bus.
- Four-phase request/acknowledge at the receiver-facing link.
- Fixed-priority arbitration (source 0 is highest priority).
- No input FIFO; every source may hold at most one pending request until acknowledged.
- End-to-end backpressure: source acknowledge is withheld until receiver acknowledge.

Two implementations are now preserved:

- `B0-v1`: clocked four-state FSM used for reproducible synchronous PPA comparison.
- `A0-functional`: no global clock; latch state advances from request/acknowledge changes. It is functionally verified but not metastability-safe asynchronous ASIC signoff because the available library lacks characterized MUTEX/C-element cells.
- Follow-up race testing rejected `A0-functional` as an implementation baseline: RTL passed 84 ps-skew/X-window trials, while the Vivado post-synthesis functional netlist completed 0/84 trials and raised 170 assertion failures.

### Implemented P1 architecture

- One shared address bus of the same width as baseline.
- Source-local depth-2 elastic queues.
- Round-robin arbitration with a registered grant pointer.
- Registered synchronous `valid/ready` output, capable of one accepted event per cycle when continuously ready.
- Source-facing 4-phase request/acknowledge boundary and two-flop request synchronizers are included in P1 PPA so the asynchronous input cost is not hidden.
- Two-lane banking and delta/burst compression are stretch experiments, not part of the first frozen comparison.

### Implemented P2 optimization

- P1 interface, CDC, queue depth, output protocol, traffic and constraints remain fixed.
- Four local 4-way round-robin winners are computed in parallel.
- One global 4-way round-robin selects among valid groups.
- P2 is the current main design candidate because it preserves P1 behavior while reducing FPGA LUTs and high-speed ASIC area.
- Equal-capacity shared FIFO is rejected for the standard-cell first-round comparison: implicit per-source counts use 32 storage bits for 32 events, while an explicit 32-entry address FIFO needs at least 128 payload bits plus pointers and admission arbitration.

## Status as of 2026-08-19

- [x] Orientation PDF pages 2-3 inspected.
- [x] Empty/local starting state recorded.
- [x] Secure non-interactive server connection attempted.
- [x] Traditional AER comparison baseline defined.
- [x] Candidate improvement set and recommended architecture recorded.
- [x] Cadence libraries and corners inventoried after secure authentication.
- [x] Traditional baseline simulation completed (Vivado XSIM, 431/431 events, assertion errors 0).
- [x] Traditional baseline frozen as `B0-v1`; Vivado structural synthesis sanity passed.
- [x] All 13 `B0-v1` manifest hashes and byte counts revalidated before and after isolated reproduction.
- [x] Isolated XSIM and Vivado synthesis-sanity reruns reproduced the frozen metrics without overwriting manifest-bound evidence.
- [x] Initial local Git snapshot prepared as `feat: establish B0-v1 traditional AER baseline`.
- [x] Korean public README and architecture guide completed with rendered B0-v1 controller-structure and 4-phase sequence SVGs.
- [x] Current public-facing files omit the Cadence server endpoint and account identifiers; runtime inventory uses local environment values.
- [x] Asynchronous-cell audit completed: no project-accessible characterized MUTEX or Muller C-element found.
- [x] `A0-functional` clockless baseline completed: 139/139 XSIM events, zero assertion failures, Vivado latch-structure probe passed with explicit non-signoff boundary.
- [x] A0 race/post-synthesis stability tested: RTL 84/84 pass; synthesized netlist 84/84 fail. A0 is retained as RTL-only protocol evidence, not a physical baseline.
- [x] Custom MUTEX/C-element feasibility audited: Spectre only; required PDK/layout/DRC/LVS/characterization flow unavailable and contest permission unspecified.
- [x] `T0` structural clockless baseline completed and tested in Vivado and Cadence; finite-delay Xcelium instability and invalid loop-based timing retained as baseline weaknesses.
- [x] `P1` hybrid improved RTL completed: asynchronous 4-phase source boundary, 2FF CDC, depth-2 per-source queues, round-robin and one-entry elastic output.
- [x] P1 main workload passed Vivado RTL, Vivado post-synthesis and Cadence Xcelium with 139/139 events and zero assertions.
- [x] P1 CDC phase sweep passed 192/192 trials in Vivado RTL, Vivado post-synthesis and Cadence Xcelium.
- [x] Cadence P1 synthesis, timing, area, and power completed: 10 ns area 11,605.810, vectorless power 1.66431 mW, 2 ns synthesis point reached with area 15,511.003.
- [x] P2 parallel 4x4 hierarchical scheduler implemented and passed the same 139-event main workload, 192 CDC phases and an explicit 16-source order test in RTL, post-synthesis and Xcelium.
- [x] P2 Vivado sanity improved from 207 to 148 LUT and from WNS -0.813 ns to +1.735 ns while preserving 1 event/cycle.
- [x] P2 Genus 10 ns produced area 11,386.267 and vectorless power 1.64037 mW; the 2 ns area fell to 13,229.093 and a 1.8 ns synthesis point was reached.
- [x] P2 selected as the current main design; equal-capacity shared FIFO rejected as a non-competitive standard-cell storage representation.
- [x] Server Liberty header verified as Artisan `TSMC 0.18um`; LEF provides Metal1-Metal6 and QRC uses the `t018` extraction kit.
- [x] P2 scan-free physical netlist completed and routed in Innovus with a VDD/VSS core ring, CTS, post-CTS hold fixing and post-route coupled RC extraction.
- [x] 180 nm post-route result: 476 cells, area 11,812.046 µm², setup +2.721 ns, hold +0.033 ns, route DRC 0, connectivity problems 0, SPEF 504 nets.
- [ ] Foundry GDS stream-out, signoff DRC/LVS/antenna/metal fill and post-route gate simulation remain blocked by missing standard-cell GDS/CDL, rule decks and cell simulation models.
- [x] B0-v1 was completed through the same scan-free 180 nm Genus/Innovus physical flow: 94 cells, area 1,573.387 µm², setup +6.704 ns, hold +0.103 ns, route DRC/connectivity problems 0.
- [x] Fair physical comparison completed: P2 provides 4× throughput and major latency/fairness gains at 7.51× cell area and 13.90× default-activity power versus B0-v1.
- [x] P3 depth-1 pending-buffer optimization completed: all RTL/post-synthesis/Xcelium regressions passed with 1 event/cycle, average latency 16.517 cycles and maximum latency 29 cycles.
- [x] P3 matched 180 nm P&R completed: 311 cells, area 8,981.280 µm², setup +3.131 ns, hold +0.027 ns, power 0.924919 mW, DRC/connectivity problems 0.
- [x] P3 replaces P2 as the current balanced main design, reducing P2 post-route area 24.0% and power 19.7% while preserving throughput and fairness.

## Evidence labels

- **Confirmed** means observed in the supplied PDF, local files, a live tool run, or a cited primary source.
- **Design decision** means frozen for this project and subject to change only with a logged reason.
- **Assumption** means required to make progress and must be rechecked before final PPA claims.
- **Unverified** means no result may be reported as fact yet.
