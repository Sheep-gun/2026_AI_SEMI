# P1 개선 AER 결과

## 한 줄 결론

`P1`은 비동기 4-phase source interface를 유지하면서 내부를 **2-flop synchronizer + source별 depth-2 queue + round-robin + 1-entry elastic output**으로 구성한 hybrid AER이다. 안정성만 보강한 것이 아니라 공정성, burst 흡수, receiver stall 격리, peak throughput과 구현 가능한 PPA를 함께 개선한 대회용 구조다.

RTL: [`rtl/improved/aer_improved_hybrid.sv`](../rtl/improved/aer_improved_hybrid.sv)

## 개선 항목

| 기존 T0 문제 | P1 변경 | 기대 효과 |
|---|---|---|
| clockless feedback loop | 비동기 입력을 2-flop synchronizer로 clock domain에 편입 | 일반 STA/합성 flow에서 안정적 구현 |
| fixed priority | round-robin pointer | 지속 traffic에서도 낮은 번호 독점 방지 |
| FIFO 없음 | source별 depth-2 event counter queue | 짧은 burst 흡수, source 조기 acknowledge |
| receiver stall 직접 전파 | queue + registered elastic output | 이미 받아둔 event 보존, source와 receiver 분리 |
| 4-phase output bubble | valid/ready output을 전송 edge에 즉시 refill | ready=1일 때 steady 1 event/cycle |
| 관측 어려움 | queue/handshake assertion과 CDC phase sweep | loss, duplicate, bounded response 검증 |

source-facing request/acknowledge는 여전히 4-phase다. 개선점은 source가 비동기로 event를 올릴 수 있게 두되, 여러 source 중 선택하고 저장하고 출력하는 복잡한 부분을 검증 가능한 synchronous core로 옮긴 것이다.

## 기능 검증

동일 testbench scenario는 single event, 16-source simultaneous request, source burst, receiver stall, no-stall saturation, hotspot fairness, reset-held request와 independent streams를 포함한다.

| 환경 | offered / accepted / received | assertion |
|---|---:|---:|
| Vivado RTL | 139 / 139 / 139 | 0 |
| Vivado post-synthesis functional | 139 / 139 / 139 | 0 |
| Cadence Xcelium | 139 / 139 / 139 | 0 |

핵심 workload 지표:

- no-stall saturation: 64 events, min/max gap 모두 1 cycle
- steady peak throughput: 1 event/cycle
- source-15 hotspot latency: 4 cycles
- suite average latency: 18.438 cycles
- suite maximum latency: 44 cycles

## CDC 위상 sweep

16개 source 각각에 대해 request edge를 clock edge 기준 `-4.9 ns`부터 `+4.9 ns`까지 12개 위상으로 이동했다. 정확히 0 ps는 simulator scheduling 순서를 metastability로 오해하지 않도록 제외했다.

| 환경 | trials | received | error |
|---|---:|---:|---:|
| Vivado RTL | 192 | 192 | 0 |
| Vivado post-synthesis functional | 192 | 192 | 0 |
| Cadence Xcelium | 192 | 192 | 0 |

이 결과는 held request가 sampling edge 앞뒤에서 정확히 한 번 처리되는 디지털 구조를 검증한다. 실제 analog metastability 확률, MTBF 또는 placement에 따른 synchronizer 성능을 증명하는 시험은 아니다.

## Vivado FPGA sanity

- 207 LUT, 89 FF
- combinational loop 0
- unconstrained internal endpoint 0
- 10 ns unplaced sanity constraint: WNS `-0.813 ns`

FPGA 100 MHz constraint는 현재 mapping에서 미달이다. 이 결과는 FPGA 구조 확인용이며 ASIC Genus 결과와 섞지 않는다.

## Cadence Genus PPA

Library/corner: 동일 `typical` standard-cell library, typical operating condition.

| synthesis point | cells | cell area | worst data path | slack | 해석 |
|---|---:|---:|---:|---:|---|
| 10 ns | 478 | 11,605.810 | 3.344 ns | +6.202 ns | 여유 있는 100 MHz 기준점 |
| 2 ns | 676 | 15,511.003 | 1.799 ns | 0 ps | 합성 기준 500 MHz 도달점 |

- 10 ns sequential: 89 cells, area 6,549.682
- 10 ns vectorless power: 1.66431 mW
- 2 ns area 증가는 10 ns 대비 약 33.6%
- 2 ns 결과는 post-layout/signoff Fmax가 아니라 synthesis timing lower-bound evidence다.

139-event RTL VCD 기반 보조 power는 1.33562 mW였지만 driver-net mapping 15.43%, RTL driver-net mapping 63.63%, queue MDA 0%라 공식 비교값으로 쓰지 않는다. 공식 표에는 동일 조건의 vectorless 결과를 사용한다.

Sanitized evidence: [`reports/improved/cadence/final/SUMMARY.txt`](../reports/improved/cadence/final/SUMMARY.txt)

## 남은 개선 여지

- 16-way rotating scan이 FPGA critical path를 길게 만든다. 4×4 hierarchical round-robin 또는 two-stage scheduler를 다음 timing 최적화 후보로 둔다.
- depth-2 queue가 모든 source에 고정되어 area의 큰 부분을 차지한다. trace 기반 hot-source 선택 배치 또는 shared small FIFO를 비교할 수 있다.
- actual PPA signoff에는 place-and-route, extracted parasitic, clock tree, synchronizer placement constraint와 activity coverage 향상이 필요하다.

