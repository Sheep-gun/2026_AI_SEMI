# Bio-mimic Neuron용 AER 통신 구조 분석 및 P3 개선 설계

## 1. 설계 목표

뉴런은 서로 독립적으로 spike를 발생시키므로 모든 뉴런에 전용 데이터 선을 연결하면 배선 비용이 빠르게 증가한다. Address-Event Representation(AER)은 spike 자체의 값 대신 이벤트가 발생한 뉴런의 주소를 하나의 공유 버스로 전송한다.

본 설계는 16개 asynchronous neuron source와 하나의 4-bit 주소 버스를 기준으로 전통적 clockless AER 컨트롤러 T0를 구성하고, 구조적 문제를 분석한 뒤 동일한 bus 수와 폭을 유지하는 P3 개선 컨트롤러를 설계하는 것을 목표로 한다.

## 2. T0 전통적 clockless AER baseline

### 2.1 구조

T0는 global clock을 사용하지 않는다. source request가 들어오면 fixed-priority encoder가 가장 낮은 번호의 source를 선택하고, structural cross-coupled NOR latch가 선택 주소와 busy 상태를 보존한다.

```text
16 source requests
  → fixed-priority encoder
  → structural grant latch
  → one 4-bit address bus
  → four-phase receiver request/acknowledge
```

source와 receiver는 다음 4-phase 순서로 transaction을 완료한다.

```text
REQ↑ → ACK↑ → REQ↓ → ACK↓
```

source별 FIFO는 없으며 source는 acknowledge가 올 때까지 하나의 request를 유지한다.

### 2.2 baseline 검증

| 검증 | 결과 |
|---|---:|
| Vivado RTL workload | 139 issued / 139 received / error 0 |
| Vivado post-synthesis functional | 139 / 139 / error 0 |
| request-skew sweep | 82/82 completed |
| SDF winner shift | 40/82 |
| Cadence Xcelium finite-delay | FAIL |
| Genus valid STA/Fmax | 산출 불가 |

Vivado의 digital model에서는 event loss가 발생하지 않았다. 그러나 SDF가 반영되면 높은 번호 source가 1~20 ps 먼저 요청해도 낮은 번호 source가 먼저 선택되는 winner shift가 관측됐다.

Cadence Xcelium에서는 gate delay를 반영했을 때 `aer_req`가 high인 transaction 중 주소가 반복적으로 변했다. Genus는 combinational feedback을 처리하기 위해 loop breaker를 삽입했으며 유효한 timing path와 Fmax를 만들지 못했다.

따라서 T0는 AER protocol 설명과 문제점 측정을 위한 baseline이지만, metastability-safe asynchronous ASIC 또는 정상 physical PPA 결과로 주장하지 않는다.

## 3. T0에서 확인한 문제

### Fixed-priority starvation

source 0과 같은 높은 우선순위 요청이 반복되면 source 15가 계속 밀릴 수 있다. 실제 fixed-priority workload에서도 긴 latency tail이 발생했다.

### Burst 저장 부재

source별 event storage가 없어 receiver가 느릴 때 backpressure가 source까지 직접 전달된다.

### Four-phase turnaround

새 transaction을 시작하려면 REQ와 ACK가 모두 0으로 돌아와야 한다. 공유 버스가 비어 있어도 return-to-zero 과정이 전송 간격을 만든다.

### 일반 ASIC flow와의 충돌

MUTEX가 없는 cross-coupled feedback 구조는 zero-delay와 finite-delay simulation 결과가 달랐으며 conventional STA, CTS와 place-and-route flow로 검증할 수 없었다.

## 4. P3 개선 구조

P3는 asynchronous source interface를 유지하고, 복잡한 선택·저장·출력 제어는 하나의 synchronous core에서 수행한다.

```text
async src_req[15:0]
  → source별 2FF synchronizer
  → source별 1-bit pending buffer
  → local 4-way arbiter × 4
  → global 4-way round-robin
  → one-entry elastic valid/ready output
  → one 4-bit address bus
```

### 2FF CDC

각 request는 두 개의 flip-flop을 거쳐 controller clock domain으로 들어온다. 이는 metastability 발생 확률을 낮추고 일반적인 digital synthesis와 timing flow를 사용할 수 있게 한다.

### 1-bit pending buffer

각 source는 최대 한 개의 event를 controller 내부에 보관한다. slot이 차면 event를 버리지 않고 source가 request를 유지하며 기다린다. 하나의 pending bit만 사용하여 register, area와 clock power를 절감했다.

### Hierarchical round-robin

16개 source를 4개 group으로 나누고 각 group의 local winner를 병렬 계산한다. Global arbiter는 valid group을 순환 선택한다. Fixed priority와 달리 지속적으로 요청하는 낮은 번호 source가 버스를 독점하지 않는다.

### Elastic output

출력은 `out_addr`, `out_valid`, `out_ready`를 사용한다. 현재 event가 전송되는 cycle에 다음 event를 output register에 채울 수 있으므로 receiver가 ready일 때 1 event/cycle을 유지한다.

## 5. 검증 방법

두 설계의 기능 검증에는 single event, 16-source simultaneous event, single-source burst, receiver stall, saturation, hotspot, reset-held request와 independent stream을 사용했다.

P3에는 추가로 다음 검증을 수행했다.

- clock edge 기준 -4.9 ns~+4.9 ns request phase sweep 192회
- 16-source hierarchical order 검증
- Vivado RTL 및 post-synthesis functional simulation
- Cadence Xcelium RTL simulation
- Vivado FPGA synthesis sanity
- TSMC 0.18 µm Genus synthesis
- Innovus floorplan, power grid, placement, CTS, routing, RC extraction
- slow setup / fast hold timing, route DRC와 connectivity 검사

## 6. P3 기능 결과

| 항목 | 결과 |
|---|---:|
| main workload | 139/139, error 0 |
| CDC phase sweep | 192/192, error 0 |
| hierarchical order | 16/16, error 0 |
| no-stall throughput | 1 event/cycle |
| average latency | 16.517 cycles |
| maximum latency | 29 cycles |
| source-15 hotspot latency | 4 cycles |

P3는 하나의 주소 버스에서 처리율을 높였으며 bus lane이나 address width를 증가시키지 않았다.

## 7. TSMC 180 nm 구현 결과

대회 서버의 Liberty header는 Artisan `TSMC 0.18um`, typical 1.8 V/25°C를 명시한다. Physical flow는 Metal1~Metal6 LEF와 `t018` QRC 자료를 사용했다.

| 항목 | 결과 | 조건 |
|---|---:|---|
| Vivado synthesis | 70 LUT, 79 FF | Artix-7 sanity only |
| Genus 10 ns | 293 cells, area 8,675.251 | typical 1.8 V |
| Genus vectorless power | 1.13497 mW | typical default activity |
| Innovus post-route | 311 cells, 8,981.280 µm² | core-only |
| placement density | 62.11% | target 약 60% |
| setup slack | +3.131 ns | slow 1.62 V, 125°C |
| hold slack | +0.027 ns | fast 1.98 V, 0°C |
| post-route power | 0.924919 mW | slow view, default activity |
| SPEF nets | 354 | coupled RC |
| route DRC / connectivity | 0 / 0 | Innovus check |

Genus와 Innovus power는 실제 동일 event traffic에 대한 energy/event가 아니라 tool의 default/vectorless activity 결과다. 절대적인 실사용 전력으로 해석하지 않는다.

## 8. T0와 P3의 핵심 비교

| 구분 | T0 | P3 |
|---|---|---|
| global clock | 없음 | core clock 사용 |
| source input | asynchronous 4-phase | asynchronous 4-phase + 2FF CDC |
| arbitration | fixed priority | hierarchical round-robin |
| input storage | 없음 | source별 1 pending event |
| receiver output | 4-phase | valid/ready elastic |
| address bus | 1×4-bit | 1×4-bit |
| finite-delay stability | 실패 | 통과 |
| physical implementation | 유효 STA 불가 | 180 nm post-route 완료 |

P3는 T0보다 회로 상태와 clocked register를 더 사용한다. 대신 fairness, event buffering, 1 event/cycle output과 conventional ASIC physical verification을 얻는다. T0가 정상 physical flow를 완료하지 못했으므로 두 구조 사이의 area·power 수치를 직접 나누어 P3의 물리 PPA 개선율로 주장하지 않는다.

## 9. 2차 과제 연계

P3의 `out_addr`는 이벤트가 발생한 source ID다. 4×4 sensor를 가정하면 source ID를 pixel `(x,y)`로 decode할 수 있다.

```text
P3 out_addr
  → source ID to pixel (x,y)
  → sensor direction 반영
  → pixel-to-world coordinate transform
  → N×M world-memory write
```

따라서 P3는 2차 과제의 event collection 및 transport front-end로 재사용할 수 있다. Sensor 크기가 커지면 source 수, address width, group 수와 group 크기를 parameter화해야 한다.

## 10. 결론

T0는 전통적 clockless AER의 단순성과 함께 fixed-priority, buffering 부재, four-phase turnaround 및 물리 구현 불안정성을 보여주었다.

P3는 단일 주소 버스를 유지하면서 asynchronous request를 안전하게 수용하고, event를 한 개씩 보존하며, hierarchical round-robin으로 공정하게 선택하고, ready 상태에서 매 cycle 연속 전송한다. RTL, post-synthesis, Xcelium과 TSMC 180 nm post-route 검증을 모두 통과했으므로 현재 대회 주 설계로 채택한다.

## 11. 한계

- P3 CDC simulation은 analog metastability MTBF를 증명하지 않는다.
- Source별 capacity는 한 event이며 무한 burst를 내부에서 모두 저장할 수 없다.
- 전체 발화 시간순 FCFS가 아니라 round-robin 순서다.
- Pad ring, package, foundry GDS, signoff DRC/LVS와 fabricated silicon은 범위 밖이다.
- Post-route power는 실제 workload 측정값이 아니다.

## 12. 주요 근거

- T0 RTL: [`rtl/traditional_async/aer_traditional_structural.sv`](../rtl/traditional_async/aer_traditional_structural.sv)
- P3 RTL: [`rtl/improved/aer_improved_depth1.sv`](../rtl/improved/aer_improved_depth1.sv)
- T0 결과: [`results/TRADITIONAL_STRUCTURAL_T0_2026-08-19.md`](../results/TRADITIONAL_STRUCTURAL_T0_2026-08-19.md)
- P3 결과: [`results/P3_DEPTH1_AER_2026-08-19.md`](../results/P3_DEPTH1_AER_2026-08-19.md)
- P3 180 nm summary: [`reports/improved_depth1/cadence/pnr_180nm/SUMMARY.txt`](improved_depth1/cadence/pnr_180nm/SUMMARY.txt)
- P3 manifest: [`results/P3_MANIFEST_2026-08-19.md`](../results/P3_MANIFEST_2026-08-19.md)
