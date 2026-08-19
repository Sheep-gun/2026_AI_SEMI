# Bio-mimic Neuron을 위한 비동기 AER baseline 및 P3 개선 컨트롤러

이 저장소는 16개 뉴런 source의 spike를 하나의 4-bit 주소 버스로 전달하는 전통적 clockless AER 컨트롤러를 분석하고, 공정성·동시 event 처리·receiver stall·물리 구현 안정성을 개선한 P3 RTL과 TSMC 180 nm 검증 근거를 보존한다.

[통합 기술보고서](reports/AER_COMPETITION_REPORT_KR.md)는 T0 baseline의 구조와 실패 원인, P3 개선 구조, 기능 검증 및 180 nm 물리 설계 결과를 대회 제출 관점에서 정리한 기준 문서다.

> T0와 P3 모두 source 16개, 주소 폭 4-bit, 출력 주소 버스 1개를 사용한다. P3의 처리율 개선은 버스 수나 폭을 늘린 결과가 아니다.

## 핵심 아이디어

전통적 T0는 fixed-priority와 FIFO 없는 4-phase 공유 버스를 사용한다. 구조는 단순하지만 동시 요청에서 낮은 우선순위 source가 계속 밀릴 수 있고, receiver stall이 전체 link로 전파되며, MUTEX가 없는 cross-coupled latch 구조는 일반 standard-cell 물리 설계에서 안정적으로 검증되지 않았다.

P3는 source-facing 4-phase interface를 유지하면서 2FF CDC, source별 1-bit pending buffer, 병렬 4×4 hierarchical round-robin과 elastic `valid/ready` 출력을 결합한다. 이를 통해 하나의 주소 버스에서 ready 상태 기준 1 event/cycle을 전송한다.

## 구현 범위

```text
16 asynchronous neuron sources
  → source request synchronization
  → event capture and arbitration
  → one 4-bit AER address bus
  → receiver / second-stage coordinate mapper
```

- T0 baseline: global clock 없음, structural SR/D latch, fixed priority, FIFO 없음, 4-phase source/receiver handshake
- P3 개선본: 2FF CDC, source별 1-bit pending, hierarchical round-robin, single-lane elastic output
- 검증: Vivado RTL/post-synthesis, Cadence Xcelium, Genus, Innovus
- 공정: Artisan TSMC 0.18 µm, 1.8 V standard cells, Metal1~Metal6

## T0 비동기 baseline

T0는 request와 acknowledge 변화만으로 상태가 진행되는 clockless 구조다. Vivado RTL과 post-synthesis functional simulation에서는 139/139 events를 전달했지만, Cadence Xcelium finite-delay simulation에서 `aer_req=1`인 동안 주소가 반복 전이했다. Genus는 feedback loop를 끊는 loop breaker를 삽입해야 했으며 유효한 STA/Fmax를 산출하지 못했다.

따라서 T0는 전통적 AER의 동작과 한계를 보여주는 baseline으로 보존하지만, 정상적인 ASIC physical PPA 기준점으로 사용하지 않는다.

## P3 개선 컨트롤러

```text
async src_req[15:0]
  → 2FF synchronizer
  → 1-bit pending/source
  → four parallel local 4-way arbiters
  → one global 4-way round-robin arbiter
  → registered valid/ready output
```

- fixed priority를 hierarchical round-robin으로 바꾸어 starvation 위험을 완화했다.
- source별 pending bit가 동시 event와 receiver stall 중 event를 보존한다.
- elastic output은 return-to-zero bubble 없이 1 event/cycle을 유지한다.
- source ID는 2차 과제에서 pixel `(x,y)` 좌표로 decode하여 world-memory mapper의 입력으로 사용할 수 있다.

## 최종 결과

| 항목 | T0 clockless baseline | P3 개선본 | 주장 범위 |
|---|---:|---:|---|
| 출력 bus | 1×4-bit | 1×4-bit | 동일 single lane |
| arbitration | fixed priority | hierarchical round-robin | 구조 비교 |
| RTL event accounting | 139/139 | 139/139 | loss·duplicate 0 |
| Cadence finite-delay 기능 | FAIL | PASS | T0 발진, P3 안정 동작 |
| CDC phase sweep | 해당 없음 | 192/192 | digital exactly-once 검증 |
| no-stall throughput | 유효 physical 수치 없음 | 1 event/cycle | P3 ready 상태 |
| average / maximum latency | 유효 동기 기준 없음 | 16.517 / 29 cycles | P3 workload 결과 |
| FPGA synthesis | feedback 구조 probe | 70 LUT, 79 FF | Vivado 2020.2 |
| 180 nm post-route | 정상 STA 불가 | 311 cells, 8,981.280 µm² | core-only Innovus |
| post-route timing | 유효 Fmax 없음 | setup +3.131 ns, hold +0.027 ns | 10 ns constraint |
| post-route power | 직접 비교 불가 | 0.924919 mW | slow 1.62 V, default activity |
| route DRC / connectivity | 미완료 | 0 / 0 | Innovus routing check |

## 평가 원칙

- T0의 RTL 통과를 metastability-safe asynchronous ASIC 증거로 해석하지 않는다.
- T0는 정상 physical flow를 완료하지 못했으므로 P3와 숫자만으로 area·power 우위를 주장하지 않는다.
- P3 CDC phase simulation은 analog metastability MTBF를 증명하지 않는다.
- vectorless/default-activity power와 실제 traffic VCD power를 구분한다.
- 1 event/cycle은 receiver가 계속 ready이고 pending event가 존재할 때의 peak 값이다.

## 저장소 안내

| 목적 | 경로 |
|---|---|
| 대회 기준 보고서 | [reports/AER_COMPETITION_REPORT_KR.md](reports/AER_COMPETITION_REPORT_KR.md) |
| T0 RTL | [rtl/traditional_async/aer_traditional_structural.sv](rtl/traditional_async/aer_traditional_structural.sv) |
| P3 RTL | [rtl/improved/aer_improved_depth1.sv](rtl/improved/aer_improved_depth1.sv) |
| P3 결과 | [results/P3_DEPTH1_AER_2026-08-19.md](results/P3_DEPTH1_AER_2026-08-19.md) |
| P3 180 nm summary | [reports/improved_depth1/cadence/pnr_180nm/SUMMARY.txt](reports/improved_depth1/cadence/pnr_180nm/SUMMARY.txt) |
| P3 evidence hash | [results/P3_MANIFEST_2026-08-19.md](results/P3_MANIFEST_2026-08-19.md) |
| 재현 스크립트 | [scripts/](scripts/) |

## 중요한 검증 범위 구분

P3는 RTL-to-post-route digital core 구현까지 완료했다. Pad ring, semiconductor package, foundry GDS stream-out, signoff DRC/LVS, fabricated silicon과 post-route gate simulation은 수행하지 않았다. 본 결과는 제조 완료나 tapeout signoff를 의미하지 않는다.
