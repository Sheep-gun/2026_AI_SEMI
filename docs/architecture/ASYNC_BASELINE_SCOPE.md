# A0-functional Clockless AER Baseline

Identifier: `A0-functional`  
Date: 2026-08-19  
Purpose: global clock 없이 4-phase AER protocol이 request/acknowledge 변화만으로 진행되는 기능 기준점

Status: **RTL-only functional model; rejected as a post-synthesis implementation baseline**

## 구현 범위

- 16 event sources, 4-bit implicit source address
- receiver 1개와 단일 공유 주소 버스
- source 0이 가장 높은 fixed-priority encoder
- source별 FIFO 없음, outstanding event 최대 1개
- source-side active-high `src_req/src_ack`
- receiver-facing active-high 4-phase `aer_req/aer_ack`
- `clk` port 없음
- state와 grant는 latch로 유지
- 이전 handshake 조건이 변하면 다음 state로 즉시 진행

상태 순서는 다음과 같다.

```text
IDLE
  → WAIT_SINK_ACK
  → WAIT_SOURCE_RELEASE
  → WAIT_SINK_RELEASE
  → IDLE
```

## B0-v1과의 차이

| 항목 | B0-v1 | A0-functional |
|---|---|---|
| 상태 진행 기준 | `posedge clk` | request/acknowledge/state 변화 |
| 상태 저장 | flip-flop | latch |
| receiver model | clock 기반 | 비동기 delay/handshake model |
| Fmax | FPGA sanity constraint로 확인 | global clock이 없어 해당 없음 |
| 동시 요청 물리 안전성 | 동기 입력 계약 | MUTEX 없음, signoff 주장 불가 |

## 확인된 기능

- 단일 event
- 16-source 동시 request의 deterministic fixed-priority 처리
- source burst
- receiver acknowledge delay/backpressure
- no-stall saturation
- fixed-priority hotspot
- reset 중 held request
- 16개 independent stream
- accepted/received scoreboard
- one-hot source acknowledge
- request-high 동안 address 안정성
- receiver acceptance 이후 source acknowledge

## 안전성 경계

이 RTL은 clockless 기능 baseline이지만 완전한 asynchronous ASIC signoff 구현은 아니다.

현재 project library에는 characterized MUTEX와 Muller C-element가 없다. 따라서 거의 동시에 변하는 물리적 source request에 대해 다음을 보장하지 않는다.

- metastability resolution time
- mutual exclusion failure probability/MTBF
- delay-insensitive 또는 quasi-delay-insensitive 동작
- hazard-free post-layout arbitration
- foundry PVT에서의 asynchronous signoff

Combinational fixed-priority encoder는 simulation에서 deterministic한 선택 규칙을 제공하지만 physical MUTEX를 대체하지 않는다.

## Timing 해석

Testbench는 동작 진행을 위해 receiver acknowledge delay와 source response delay를 명시적으로 부여한다. 측정된 ns 값은 이 testbench environment의 기능 지표이며 cell/library/post-layout 성능이 아니다.

Vivado synthesis probe는 42 LUT와 6 latch primitive를 생성했다. 그러나 no-clock endpoint, unconstrained internal endpoint와 latch loop가 존재하므로 LUT/latch 수 외 timing/PPA를 해석하지 않는다.

추가 race/post-synthesis 검증에서 RTL은 84개 ps-skew trial을 통과했지만 합성 netlist는 84개 trial 모두 receiver event를 완료하지 못했다. 일반 synthesis가 latch feedback의 clockless state 의미를 보존하지 못했으므로 현재 A0 RTL은 physical implementation 후보에서 제외한다.

상세 결과: `results/ASYNC_RACE_STRESS_2026-08-19.md`

## 다음 단계 조건

비동기 round-robin이나 self-timed FIFO를 ASIC headline 구조로 진행하려면 다음 중 하나가 먼저 필요하다.

1. Characterized MUTEX/C-element Liberty·LEF 제공.
2. Custom cell schematic/SPICE/MTBF/Liberty/physical abstract 생성.
3. 승인된 asynchronous relative-timing 및 post-layout verification flow.

그 전까지 `A0-functional`은 protocol/control 연구와 waveform 검증 기준으로만 사용한다.
