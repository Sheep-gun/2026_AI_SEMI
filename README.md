# 2026 AI 반도체 회로 설계 경진대회 — AER 디지털 설계

팀 **최태원의 검**의 디지털 1차 설계 수행과제 저장소다. Bio-mimic Neuron을 위한 전통적 AER 통신 구조를 분석하고, 병목을 한 단계씩 개선한 뒤 동일 조건에서 기능·성능·PPA를 비교한다.

- 1차 제출일: **2026년 8월 28일**
- 현재 기준점: **B0-v1 Traditional AER baseline**
- 합성 대상: AER 컨트롤러 RTL
- testbench model: 뉴런 event source와 receiver
- 범위 밖: ECG, SNN ECG Classifier, 이전 ECG SoC의 RTL과 구조

## 1. 지금 무엇을 할 것인가

하나의 완성 구조만 제시하지 않고, 전통적 baseline에서 설계 요소를 하나씩 바꾸어 각 개선의 효과를 분리한다.

| 단계 | 변경점 | 확인할 핵심 효과 |
|---|---|---|
| `B0-v1` | fixed priority + FIFO 없음 + 4-phase link | 전통적 기준점과 병목 측정 |
| `B1` | arbiter만 round-robin으로 교체 | starvation 제거, 최대 arbitration wait와 latency tail |
| `B2` | source별 depth-2 FIFO만 추가 | burst 흡수, source-side backpressure 완화 |
| `B3` | registered elastic `valid/ready` output | 4-phase return-to-zero bubble 제거 |
| `P1` | round-robin + FIFO + elastic output | 단일 lane 개선 구조의 종합 성능과 PPA |

단계별 비교에서 source 수, 주소 폭, 단일 output lane, event traffic, receiver backpressure trace와 검증 기준을 고정한다. B1에서는 FIFO나 receiver protocol을 함께 바꾸지 않는다.

최종 ASIC area·timing·Fmax·power는 동일 standard-cell library/PVT/SDC 조건의 Cadence 결과로 판단한다. Vivado 결과는 RTL의 FPGA 합성 가능성을 확인하는 sanity check일 뿐 ASIC PPA가 아니다.

## 2. 전통적인 AER이란

**AER(Address-Event Representation)**은 뉴런이 spike를 발생시켰을 때 뉴런별 전용 데이터 선을 모두 연결하는 대신, 공유 통신 채널로 **이벤트를 발생시킨 뉴런의 주소**를 전송하는 방식이다.

예를 들어 source 5가 spike를 만들면 데이터 값 전체가 아니라 주소 `5`를 전송한다. 수신기는 주소 5에 대응하는 뉴런 또는 synapse 위치로 이벤트를 전달한다. 이벤트가 없을 때는 별도의 event transfer가 발생하지 않는다.

역사적으로 AER에는 여러 회로와 handshake 변형이 존재한다. 이 프로젝트에서 말하는 **전통적 baseline**은 비교 가능하도록 다음 구조로 명시적으로 한정한다.

- event source 16개, source address 4비트
- receiver 1개와 단일 공유 주소 버스
- source 0이 가장 높은 fixed-priority arbitration
- source별 FIFO 없음, source당 outstanding event 최대 1개
- source-side `src_req/src_ack`
- receiver-facing active-high 4-phase `aer_req/aer_ack`
- receiver 응답이 source acknowledge까지 직접 전달되는 end-to-end backpressure
- 일반적인 standard-cell flow에서 재현할 수 있는 clock 기반 합성 RTL

## 3. B0-v1 baseline 컨트롤러 구조

![B0-v1 전통적 AER baseline 컨트롤러 구조](docs/architecture/aer_baseline_controller_structure.svg)

1. 각 뉴런은 이벤트가 생기면 해당 `src_req[i]`를 올리고 `src_ack[i]`가 올 때까지 요청을 유지한다. 별도 입력 FIFO는 없다.
2. combinational fixed-priority encoder가 요청 중 가장 작은 source index를 선택한다. 따라서 source 0이 최고 우선순위다.
3. 선택 주소는 `grant_q`에 저장되어 한 transaction 동안 `aer_addr`로 유지된다.
4. 4-state FSM이 `aer_req`, `src_ack`, source release와 `aer_ack`의 순서를 제어한다.
5. 수신기가 주소를 받아 `aer_ack`을 올린 뒤에야 선택 source의 `src_ack`이 올라간다. 수신기가 멈추면 공유 link와 모든 대기 source가 영향을 받는다.

실제 RTL은 [`rtl/baseline/aer_traditional.sv`](rtl/baseline/aer_traditional.sv), 동결된 구조 정의는 [`docs/architecture/BASELINE_FREEZE.md`](docs/architecture/BASELINE_FREEZE.md)에 있다.

## 4. 4-Phase handshake 동작

![AER 4-phase handshake 시퀀스](docs/architecture/aer_4phase_handshake_flow.svg)

Receiver-facing AER link는 idle 상태 `aer_req=0`, `aer_ack=0`에서 시작한다.

1. **REQ assert:** 컨트롤러가 `aer_addr`를 고정하고 `aer_req`를 올린다.
2. **ACK assert:** 수신기가 주소를 캡처한 뒤 `aer_ack`을 올린다.
3. **REQ release:** 컨트롤러는 선택 source가 요청을 내린 것을 확인한 뒤 `aer_req`를 내린다.
4. **ACK release:** 수신기가 `aer_ack`을 내리면 link가 idle로 돌아가 다음 이벤트를 시작할 수 있다.

전체 source-to-receiver 순서는 다음과 같다.

```text
src_req[i] ↑
  → aer_addr=i, aer_req ↑
  → aer_ack ↑
  → src_ack[i] ↑
  → src_req[i] ↓
  → src_ack[i] ↓, aer_req ↓
  → aer_ack ↓
```

“4-phase”는 네 번의 **신호 전이**를 뜻하며 모든 구현에서 반드시 4 clock cycle이라는 뜻은 아니다. 다만 B0-v1의 clock 기반 FSM과 zero-delay synchronous receiver model에서는 새 이벤트 사이 간격이 실제로 4 cycles로 측정되어, 무정체 steady throughput이 `0.25 event/cycle`이었다.

## 5. 전통적 baseline에서 확인할 문제

- **공정성:** fixed priority 때문에 높은 우선순위 traffic이 계속되면 낮은 우선순위 source가 오래 기다리거나 starvation될 수 있다.
- **처리율:** 한 이벤트가 끝날 때마다 REQ와 ACK를 0으로 복귀시켜야 하므로 새 이벤트 사이에 return-to-zero bubble이 생긴다.
- **burst 대응:** 입력 FIFO가 없어 source가 한 이벤트만 직접 붙잡을 수 있다.
- **backpressure:** 수신기 stall이 현재 transaction을 점유하고 단일 공유 link 전체를 막는다.
- **확장성:** source 수가 커질수록 flat priority encoder와 공유 주소/control net의 fan-in·fan-out이 증가한다.

이 항목은 모든 역사적 AER 회로의 보편적 결함이라는 주장이 아니다. 이 저장소가 명시한 B0-v1 RTL에서 측정하고, 이후 variant와 같은 조건으로 비교할 설계 변수다.

## 6. 동결된 baseline 결과

### Vivado XSIM 기능 검증

| 지표 | B0-v1 결과 |
|---|---:|
| issued / received | `431 / 431` |
| event loss / duplicate / assertion failure | `0 / 0 / 0` |
| no-stall inter-event gap | `4 cycles` |
| no-stall steady throughput | `0.25 event/cycle` |
| suite average latency | `29.658 cycles` |
| worst observed latency | `901 cycles` |
| source-15 hotspot max latency | `49 cycles` |
| pass marker | `TEST_PASS baseline issued=431 received=431` |

검증은 단일 이벤트, 16-source 동시 요청, burst, receiver stall, saturation, fixed-priority hotspot, reset, 16개 independent random stream, scoreboard, procedural assertion과 concurrent SVA를 포함한다.

### Vivado synthesis sanity

- Vivado 2020.2, `xc7a35tcpg236-1`
- 41 LUT, 10 FF
- 10 ns sanity constraint에서 estimated WNS `+1.401 ns`
- combinational loop 0, unconstrained internal endpoint 0
- marker: `BASELINE_SANITY_PASS`

위 수치는 FPGA 구조 합성 확인용이며 대회 최종 ASIC area·power·timing·Fmax로 사용하지 않는다.

## 7. 재현 방법

PowerShell에서 저장소 root를 기준으로 실행한다.

```powershell
.\scripts\run_baseline.ps1
.\scripts\run_vivado_synth_baseline.ps1
```

- 시뮬레이션 결과: `sim/logs/`, `sim/waves/`
- Vivado sanity report: `reports/baseline/vivado_sanity/`
- 결과 요약: [`results/BASELINE_SIMULATION_2026-08-18.md`](results/BASELINE_SIMULATION_2026-08-18.md)
- 동결 hash: [`results/BASELINE_MANIFEST_2026-08-18.md`](results/BASELINE_MANIFEST_2026-08-18.md)

일상적인 재검증은 manifest-bound 원본을 덮어쓰지 않도록 격리 작업공간에서 수행한다. RTL 버그 수정이 필요하면 `B0-v2`와 새 dated manifest를 만든다.

## 8. 저장소 구성

```text
rtl/baseline/       B0-v1 합성 가능 RTL
tb/                 self-checking testbench
scripts/            XSIM·Vivado·Cadence 환경 확인 스크립트
docs/requirements/  고정 비교 조건과 평가 지표
docs/architecture/  AER 설명, baseline freeze, 구조/시퀀스 SVG
docs/references/    참고문헌과 claim map
results/            검증 결과 요약과 manifest
reports/            보존할 핵심 text report와 synthesis checkpoint
```

상세 범위와 확인/미확인 상태는 [`PROJECT_CONTEXT.md`](PROJECT_CONTEXT.md), 설계 선택의 근거는 [`DESIGN_DECISIONS.md`](DESIGN_DECISIONS.md), 실행 이력은 [`WORKLOG.md`](WORKLOG.md)에 기록한다.

## 9. 결과 해석 원칙

- 확인된 측정값, 설계 결정, 가정, 미확인 사항을 구분한다.
- simulation 기능 정확도와 synthesis PPA를 섞지 않는다.
- baseline과 개선 구조는 동일 traffic·backpressure·constraints·library/PVT 조건에서 비교한다.
- vectorless power와 VCD/SAIF 기반 power를 구분하고 activity window와 mapping coverage를 기록한다.
- raw log/report와 요약 표를 함께 보존한다.
