# Cadence 비동기 설계 Library 점검

점검일: 2026-08-19 KST  
범위: 구성된 Cadence 서버의 project-accessible standard-cell, LEF, QRC, component 자료  
보안: 서버 endpoint, account, password, private key는 이 보고서와 저장소에 기록하지 않음

## 결론

현재 환경은 일반적인 동기식 RTL의 Genus synthesis와 Innovus physical flow에는 사용할 수 있다. 그러나 완전 비동기 AER arbitration에 필요한 **전용 MUTEX cell과 Muller C-element는 project library에서 발견되지 않았다**.

따라서 현재 자료만으로 다음을 주장할 수 없다.

- 동시 비동기 요청을 metastability-safe하게 해결하는 MUTEX가 standard-cell mapping되었다.
- C-element가 characterization된 단일 cell로 timing/power/physical 검증되었다.
- 완전 비동기 arbiter/FIFO가 일반 Genus 자동 합성만으로 signoff 가능하다.

Delay cell과 일반 latch/gate는 있으므로 bundled-data delay 실험이나 수동 C-element 유사 회로 연구는 가능하다. 그러나 이는 전용 비동기 cell library를 대체하지 않으며 별도의 relative-timing, hazard, metastability와 post-layout 검증이 필요하다.

## 확인된 Cadence 도구

| 도구 | 확인 결과 |
|---|---|
| Genus | 23.14-s090_1 |
| Innovus | 23.14-s088_1 |
| Xcelium `xrun` | 23.09-s013 |
| Genus license | `Genus_Synthesis` checkout 성공 |

Genus는 project `typical.lib`을 실제로 읽었고 470개 lib cell을 인식했다.

## Project library와 corner

| Corner | Process | Voltage | Temperature |
|---|---:|---:|---:|
| fast | 1 | 1.98 V | 0 °C |
| typical | 1 | 1.80 V | 25 °C |
| slow | 1 | 1.62 V | 125 °C |

추가로 확인된 자료:

- Liberty: `fast.lib`, `typical.lib`, `slow.lib`
- LEF: 통합 `all.lef`, 활성 macro 488개
- QRC technology: `t018s6mm.tch`와 관련 ICT/layermap
- Capacitance table: `t018s6mlv.capTbl`
- Liberty unit: time 1 ns, voltage 1 V, capacitance 1 pF

## 비동기 관련 cell 점검

### 전용 cell

| 검색 대상 | Liberty/LEF 결과 | 판단 |
|---|---|---|
| MUTEX / mutual exclusion | 0 | 전용 metastability-resolving arbiter cell 없음 |
| Muller C-element | 0 | 전용 completion/state cell 없음 |
| Asynchronous arbiter cell | 0 | 전용 비동기 arbiter 없음 |

`/home/tools`의 파일명 검색에서 나온 `mutex` 항목은 Cadence 소프트웨어 내부 C++/Python mutex와 문서였으며 standard-cell macro가 아니었다.

### 사용할 수 있는 보조 cell

- `DLY1X1`~`DLY4X1`: Liberty와 활성 LEF macro가 모두 존재한다. Bundled-data request delay 구성 후보지만 PVT와 post-route relative timing 검증이 필요하다.
- `TLAT*`, DFF와 일반 AOI/OAI/BUF/INV gate: Liberty/LEF에 존재한다. 일반 latch/control 조합은 가능하다.
- `RSLAT*` 8종: Liberty에는 존재하지만 Genus가 `LBR-525 Missing clock pin` 경고를 냈다. 더 중요하게 LEF의 `RSLAT*` macro 블록은 `#`로 주석 처리되어 현재 physical flow의 활성 macro가 아니다.

일반 latch와 gate로 C-element의 논리 상태식을 흉내 낼 수는 있지만, glitch-free/QDI 동작과 physical characterization이 자동으로 보장되지는 않는다.

## Cadence component 이름 검증

도구 설치 자료에서 다음 이름을 추가 확인했지만 완전 비동기 IP가 아니었다.

- `CW_arbiter_fcfs`: `clk`와 `rst_n` 포트를 사용하는 동기식 FCFS arbiter RTL.
- `CW_asymfifo_*`: `asym`은 asynchronous가 아니라 input/output data width가 다른 **asymmetric FIFO**를 의미한다. 단일 `clk`에서 push/pop한다.

따라서 이 component들을 완전 비동기 round-robin이나 self-timed FIFO 근거로 사용할 수 없다.

## 설계 판단

현재 환경에서 증거 수준별로 가능한 범위는 다음과 같다.

| 설계 | 현재 가능 여부 | 필요한 추가 검증 |
|---|---|---|
| 동기식 FIFO·round-robin·elastic output | 가능 | 일반 Genus/Innovus PPA와 STA |
| 비동기 request/ack boundary adapter | 조건부 가능 | CDC, event loss/duplicate, MTBF, bundled-data constraint |
| Delay-cell 기반 bundled-data handshake | 연구 가능 | fast/typical/slow 및 post-route relative timing |
| 수동 C-element 유사 회로 | 연구 가능, signoff 불충분 | hazard, min/max delay, transistor/physical characterization |
| MUTEX 기반 완전 비동기 16-source arbiter | 현재 library로 근거 부족 | characterized MUTEX Liberty/LEF와 SPICE/MTBF 필요 |

## 필요한 추가 자원

완전 비동기 AER controller를 headline 구현으로 사용하려면 최소한 다음 중 하나가 필요하다.

1. Foundry/교육용 library에서 제공하는 characterized MUTEX와 C-element의 Liberty·LEF·transistor model.
2. 직접 설계한 custom MUTEX/C-element의 schematic, SPICE/PVT/Monte Carlo, Liberty characterization와 physical abstract.
3. 승인된 asynchronous synthesis/STA methodology와 relative-timing constraint 예제.

위 자원이 확보되기 전에는 완전 비동기 RTL을 기능 simulation 수준의 실험으로만 표시하고 ASIC PPA/signoff 결과로 제시하지 않는다.
