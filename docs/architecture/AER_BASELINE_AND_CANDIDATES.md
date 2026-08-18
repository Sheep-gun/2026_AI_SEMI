# 전통적 AER와 개선 후보

## 1. AER을 간단히 설명하면

생물학적 뉴런은 주로 spike가 발생한 **시점**으로 정보를 전달한다. AER(Address-Event Representation)은 많은 인공 뉴런이 하나의 빠른 디지털 통신 채널을 공유하도록 만든다. 뉴런 5가 spike를 발생시키면 뉴런 5 전용 장거리 선을 따로 두는 대신 공유 채널로 주소 `5`를 보낸다. 수신기는 주소 5에 해당하는 뉴런 또는 synapse 위치로 이벤트를 복원하거나 routing한다.

이벤트가 없을 때는 event transfer도 없다. 여러 뉴런이 동시에 요청하면 arbiter가 한 source를 선택하고, receiver가 멈추면 handshake의 acknowledge가 늦어져 backpressure가 발생한다.

## 2. 이 프로젝트의 전통적 baseline

AER은 하나의 보편적인 packet이나 회로만을 뜻하지 않는다. 공정한 비교를 위해 이 프로젝트에서 **전통적 AER baseline**이라고 부르는 구조를 다음과 같이 고정한다.

- 16개의 level-held event request
- source 0이 가장 높은 centralized fixed-priority arbitration
- 4비트 단일 공유 주소 버스
- receiver-facing active-high 4-phase request/acknowledge
- source별 FIFO 없음
- source당 outstanding event 최대 1개
- receiver 응답이 source acknowledge까지 직접 전달되는 end-to-end backpressure
- 하나의 clock으로 동작하는 합성 가능한 SystemVerilog controller

이 clock 기반 baseline은 일반적인 standard-cell synthesis flow에서 재현하기 위한 비교 모델이다. hand-crafted delay-insensitive asynchronous AER 구현의 절대 성능을 대표하지 않는다.

![B0-v1 전통적 AER baseline 컨트롤러 구조](aer_baseline_controller_structure.svg)

### 내부 동작

1. 각 source는 `src_req[i]`를 올리고 `src_ack[i]`가 올 때까지 유지한다.
2. fixed-priority encoder가 가장 작은 source index를 선택한다.
3. `grant_q`가 선택 주소를 저장하고 transaction 동안 `aer_addr`를 유지한다.
4. 4-state FSM이 receiver handshake와 선택 source의 release를 순서대로 기다린다.
5. receiver가 주소를 수락한 뒤에만 선택 source의 `src_ack`이 올라간다.

## 3. 4-Phase handshake

![AER 4-phase handshake 시퀀스](aer_4phase_handshake_flow.svg)

Receiver-facing link는 `aer_req=0`, `aer_ack=0`인 idle 상태에서 시작한다.

1. 컨트롤러가 주소를 고정하고 `aer_req ↑`.
2. receiver가 주소를 캡처하고 `aer_ack ↑`.
3. source request가 내려간 뒤 컨트롤러가 `aer_req ↓`.
4. receiver가 `aer_ack ↓`; link는 idle 복귀.

주소는 `aer_req=1`인 동안 안정적으로 유지되어야 한다. 이전 transaction의 `aer_ack`이 0으로 돌아오기 전에는 다음 transaction을 시작할 수 없다.

“4-phase”는 REQ와 ACK의 네 신호 전이를 뜻한다. 네 phase가 모든 AER 회로에서 항상 네 clock cycle이라는 뜻은 아니다. B0-v1에서는 각 전이를 clock 기반 FSM과 synchronous receiver model로 관찰했기 때문에 무정체 event 간격이 4 cycles로 측정되었다.

## 4. AER과 UART의 차이

UART는 일반 byte를 정해진 baud rate로 bit-serial 전송하고 start/stop bit로 frame을 구분한다. 일반적인 UART transaction은 byte가 뉴런 이벤트인지 알지 못하며 event마다 request/acknowledge를 수행하지도 않는다.

AER은 이벤트 중심이다. 이벤트가 발생한 source의 주소를 전송하고, 여러 source가 공유 link를 사용할 때 arbitration이 필요하며, request/acknowledge가 channel ownership과 flow control을 형성한다. 둘 다 주소 값을 운반할 수 있지만 timing model, framing, arbitration과 backpressure 방식이 다르다.

## 5. B0-v1에서 측정할 병목

| 병목 | 발생 메커니즘 | 이 프로젝트의 측정값 |
|---|---|---|
| handshake 왕복 | REQ assert, ACK assert, REQ release, ACK release가 끝나야 다음 event 가능 | zero/variable receiver delay에서 event 간격과 latency |
| 처리율 한계 | 단일 link와 return-to-zero bubble이 모든 event를 직렬화 | events/cycle, sustainable offered load |
| 동시 충돌 | 한 source만 선택되고 나머지는 request 유지 | pending time, arbitration wait |
| starvation | fixed priority가 hotspot source를 반복 선택 | source 0 hotspot에서 low-priority 최대 지연 |
| source 수 확장 | priority encode/mux fan-in과 공유 net load 증가 | N=8/16/32/64 timing·area sweep |
| switching | 공유 address/control net이 event마다 전환 | VCD/SAIF power와 toggles/event |
| CDC 위험 | 비동기 request/acknowledge를 raw clock input으로 사용하면 setup/hold 위반 가능 | 별도 CDC wrapper audit |
| loss/duplicate | protocol 위반, reset 또는 잘못된 state sequencing | accepted-vs-output scoreboard와 assertion |
| backpressure | 하나의 stalled receiver가 공유 transaction을 유지 | blocked-source cycles와 stall 전파 |

이 문제 중 일부는 traffic 또는 구현 방식에 따라 달라진다. 올바른 handshake가 반드시 event를 잃는 것은 아니고, 잘 설계된 asynchronous arbiter가 반드시 clock 기반인 것도 아니다. 따라서 모든 전통적 AER이 같은 결함을 가진다고 일반화하지 않고, 명시한 B0-v1 RTL을 측정한다.

## 6. 개선 후보

### 6.1 Round-robin arbitration

마지막으로 서비스한 source 다음부터 탐색한다. 지속적으로 eligible한 source는 downstream stall이 없을 때 제한된 grant 수 안에 서비스되어 fixed-priority starvation을 제거할 수 있다. B1에서는 다른 구조를 바꾸지 않고 arbiter만 교체한다.

### 6.2 Source-local elastic FIFO

source별 depth-2 queue가 짧은 burst와 동시 충돌을 흡수한다. queue가 가득 찼을 때만 해당 source에 backpressure가 전달된다. 저장 bit와 FIFO control area/power가 증가하므로 B2에서 단독 효과를 측정한다.

### 6.3 Registered valid/ready output

하나의 clock domain 안에서 receiver-facing link를 `valid/ready`로 바꾸면 ready가 계속 높을 때 pipeline fill 이후 매 cycle 한 event를 받을 수 있다. 4-phase return-to-zero bubble 제거 효과를 B3에서 분리한다.

### 6.4 Two-phase toggle CDC adapter

비동기 neuron boundary가 실제로 필요할 때 bundled-data two-phase toggle, control synchronizer와 reset phase alignment를 별도 wrapper로 추가한다. core PPA에 CDC 비용을 숨기지 않고 따로 보고한다.

### 6.5 Hierarchical/pipelined arbitration

source 수가 커지면 flat priority cone을 tree로 나누어 combinational depth와 배선을 줄일 수 있다. pipeline stage가 latency와 verification state를 늘리므로 N-sweep 결과가 필요할 때 적용한다.

### 6.6 Multi-lane·burst/delta encoding

두 개의 banked lane은 traffic이 균형적일 때 최대 두 events/cycle을 제공하지만 address/control I/O가 증가한다. burst/delta encoding은 인접 주소 traffic에서 switching을 줄일 수 있지만 workload 의존적이다. 둘 다 단일-lane headline 비교 이후의 stretch experiment다.

## 7. 최종 제안 구조

```text
src_valid[N]
     │
     ▼
source별 depth-2 queue
     │
     ▼
round-robin select
     │
     ▼
registered address + out_valid/out_ready
```

P1은 같은 4비트 단일 address lane을 유지하면서 buffering, fair arbitration과 elastic output을 결합한다. 개선 주장은 다음 지표로 검증한다.

- throughput과 latency distribution
- maximum intervening grants / arbitration wait
- queue occupancy와 stall ratio
- accepted event loss·duplicate·ordering
- mapped area와 sequential/combinational breakdown
- timing critical path와 Fmax
- 동일 activity window의 dynamic/leakage/total power와 energy/event

기능과 구조는 Vivado에서 먼저 안정화하고, 최종 ASIC PPA는 확인된 동일 Cadence library/PVT/SDC 조건에서 비교한다.
