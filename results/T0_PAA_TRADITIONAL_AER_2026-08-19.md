# T0-PPA 전통적 비동기 AER baseline 결과

## 목적

초기 T0는 교차 결합 NOR 게이트를 RTL에 직접 작성해 전통적 clockless AER의 기능을 재현했지만, Genus가 저장소로 인식하지 못한 feedback loop를 끊어야 했고 유한 지연에서 주소가 흔들렸다.

T0-PPA는 AER의 전통적 특성을 유지하면서 P3와 최소한의 물리 비교가 가능하도록 다시 구성했다.

- global clock 없음
- 16 source, 4-bit 공유 주소 bus 1개
- fixed priority, source 0 최고 우선순위
- source별 FIFO/pending buffer 없음
- active-high four-phase return-to-zero handshake
- `TLATRX1` 표준 latch 5개로 grant와 busy 상태 보관
- `DLY4X1` 표준 delay cell 6개로 bundled-data relative timing 확보
- MUTEX 사용하지 않음

## 유효 범위

T0-PPA는 다음 operating contract에서 물리 비교가 가능하다.

1. source는 `src_ack`를 받을 때까지 `src_req`를 유지한다.
2. request set은 delayed grant-capture aperture 동안 안정되어 있어야 한다.
3. receiver는 주소를 capture한 뒤에만 `aer_ack`를 올린다.
4. 임의의 near-simultaneous edge에 대한 transistor-level metastability safety는 주장하지 않는다.

현재 180 nm library에는 characterized MUTEX가 없으므로 마지막 한계는 전통 baseline의 문제로 남긴다. T0-PPA가 물리적으로 비교 가능하다는 뜻은 arbitrary asynchronous arbitration까지 signoff했다는 뜻이 아니다.

## 기능 검증

| 항목 | 결과 |
|---|---:|
| Xcelium offered / received | 139 / 139 |
| assertion error | 0 |
| 평균 latency | 33.935 ns |
| 최대 latency | 302 ns |
| saturation event gap | 5 ns |
| source 15 hotspot latency | 62 ns |

Latency와 event gap은 testbench의 receiver acknowledge/release delay를 포함한다. post-route 최대 event rate나 실제 workload energy를 뜻하지 않는다.

### 경합 스트레스

| 항목 | 결과 |
|---|---:|
| skew/X-window trials | 84 |
| event loss, duplicate, unknown, short pulse | 0 |
| first-winner shift | 42 |

두 요청이 capture aperture 안에서 겹치면 먼저 도착한 요청보다 낮은 source 번호가 먼저 선택됐다. 이는 fixed priority의 예상 동작이며 T0-PPA가 FCFS가 아님을 보여준다. 디지털 시험에서 출력 X는 없었지만 이 결과가 analog metastability MTBF를 증명하지는 않는다.

## 합성 및 등가성

| 항목 | 결과 |
|---|---:|
| Genus mapped cells | 100 |
| Genus cell area | 1,397.088 µm² |
| Genus vectorless power | 0.0451046 mW |
| characterized latches | 5 |
| preserved delay cells | 6 |
| loop breaker | 0 |
| Conformal equivalent compare points | 26 / 26 |
| nonequivalent / abort / unknown | 0 / 0 / 0 |

초기 T0와 달리 latch가 sequential library cell로 인식됐고 `cdn_loop_breaker`가 삽입되지 않았다. Conformal LEC는 RTL의 21개 output과 5개 state key point가 합성 netlist와 모두 등가임을 확인했다.

## 180 nm post-route

| 항목 | 결과 |
|---|---:|
| die | 92.400 × 85.680 µm |
| core | 51.480 × 45.360 µm |
| cells | 100 |
| cell area | 1,397.088 µm² |
| placement density | 59.82% |
| routing overflow | 0.00% |
| default-activity power | 0.03483881 mW |
| extracted SPEF nets | 120 |
| route DRC violations | 0 |
| connectivity problems | 0 |

![T0-PPA TSMC 180 nm Innovus post-route](../docs/architecture/t0_paa_180nm_innovus_postroute.png)

## Bundled-data relative timing

주소가 안정되기 전에 `aer_req`가 올라가면 수신기가 잘못된 주소를 읽을 수 있다. 이를 막기 위해 request launch control에 characterized delay cell을 삽입하고 배치·배선 후 다음 보수적 조건을 확인했다.

| 경로 | 최악 조건 |
|---|---:|
| source request → grant latch D, latest slow | 1.915 ns |
| source request → busy latch D, earliest fast | 2.591 ns |
| conservative relative margin | **+0.676 ns** |
| busy latch Q → `aer_req`, earliest fast | 0.380 ns |

가장 느린 주소 data path보다 가장 빠른 capture control path가 0.676 ns 늦게 도착한다. 이후에도 busy latch와 request delay stage가 있으므로 `aer_req` assertion 전에 grant latch가 닫히는 순서를 보수적으로 만족한다.

## P3와 비교할 때의 해석

T0-PPA는 작고 전력 추정치가 낮지만 fixed priority, 무저장, return-to-zero, receiver backpressure 전체 전파라는 전통적 한계를 그대로 가진다. P3는 더 많은 셀을 사용해 CDC, 16-event decoupling, starvation 방지와 매 clock 1-event 출력을 제공한다.

T0-PPA에는 global clock이 없으므로 Fmax를 만들지 않는다. 외부 receiver 응답 시간을 포함한 전체 handshake cycle time으로 처리율을 평가해야 한다. P3의 `1 event/cycle`과 T0-PPA testbench의 `5 ns gap`은 환경 정의가 달라 직접적인 물리 throughput 비교값이 아니다.

## 근거

- RTL: [`rtl/traditional_async/aer_traditional_latch_paa.sv`](../rtl/traditional_async/aer_traditional_latch_paa.sv)
- Cadence summary: [`reports/traditional_latch_paa/cadence/pnr_180nm/SUMMARY.txt`](../reports/traditional_latch_paa/cadence/pnr_180nm/SUMMARY.txt)
- Genus area: [`reports/traditional_latch_paa/cadence/pnr_180nm/reports/genus_pnr_area.rpt`](../reports/traditional_latch_paa/cadence/pnr_180nm/reports/genus_pnr_area.rpt)
- Conformal LEC: [`reports/traditional_latch_paa/cadence/pnr_180nm/reports/t0_paa_lec.rpt`](../reports/traditional_latch_paa/cadence/pnr_180nm/reports/t0_paa_lec.rpt)
- Post-route timing: [`reports/traditional_latch_paa/cadence/pnr_180nm/reports/postroute_timing.rpt`](../reports/traditional_latch_paa/cadence/pnr_180nm/reports/postroute_timing.rpt)
- Relative timing: [`reports/traditional_latch_paa/cadence/pnr_180nm/reports/bundled_data_address_late_slow.rpt`](../reports/traditional_latch_paa/cadence/pnr_180nm/reports/bundled_data_address_late_slow.rpt), [`bundled_data_request_early_fast.rpt`](../reports/traditional_latch_paa/cadence/pnr_180nm/reports/bundled_data_request_early_fast.rpt)
- Post-route DEF/SDF/SPEF/netlist: [`reports/traditional_latch_paa/cadence/pnr_180nm/outputs/`](../reports/traditional_latch_paa/cadence/pnr_180nm/outputs/)
