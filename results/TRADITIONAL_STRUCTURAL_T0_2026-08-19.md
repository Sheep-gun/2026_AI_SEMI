# T0 전통적 clockless AER baseline 결과

## 판정

`T0`는 global clock 없이 source request, receiver acknowledge와 구조적 latch feedback으로 진행하는 전통적 단일 버스 4-phase AER baseline이다. MUTEX는 사용하지 않았고, available standard-cell library에 characterized MUTEX가 없다는 제약을 숨기지 않았다.

기능 시뮬레이션과 Vivado post-synthesis functional netlist에서는 event accounting을 통과했지만, Cadence Xcelium의 finite gate-delay 모델에서 주소가 transaction 도중 흔들리며 발진했다. Genus도 feedback loop를 끊어야만 mapping을 완료했기 때문에 유효한 Fmax를 만들 수 없었다.

따라서 `T0`는 **전통 구조와 그 한계를 측정하는 baseline**으로는 채택하지만, 안정적인 최종 구현 후보로는 채택하지 않는다.

## 구조

- 16 source, 4-bit address, 단일 공유 output lane
- fixed priority: 낮은 source index가 우선
- source별 FIFO 없음
- 구조적 cross-coupled NOR SR latch와 D latch
- source-side 및 receiver-side active-high 4-phase handshake
- global clock 없음
- MUTEX/C-element 없음

RTL: [`rtl/traditional_async/aer_traditional_structural.sv`](../rtl/traditional_async/aer_traditional_structural.sv)

## 기능 및 race 검증

| 검증 | 결과 |
|---|---:|
| Vivado RTL workload | 139 issued / 139 received / assertion 0 |
| Vivado post-synthesis functional workload | 139 / 139 / assertion 0 |
| RTL request-skew sweep | 82 / 82 completed, error 0 |
| post-synthesis functional skew sweep | 82 / 82 completed, error 0 |
| post-synthesis SDF skew sweep | 82 / 82 completed, loss/glitch/X 0 |
| SDF winner shift | 40 / 82 trials |

SDF winner shift는 source 15 또는 7이 1~20 ps 먼저 요청했는데도 낮은 번호 source 0 또는 3이 먼저 선택된 경우다. 이는 event loss는 아니지만, fixed-priority capture window가 실제 도착 순서를 보존하지 않는다는 뜻이다.

## Vivado 구조 probe

- 70 LUT, 0 FF
- combinational feedback loop 8개
- DRC `LUTLP-1` 6건
- post-synthesis functional simulation은 통과했지만 timing closure 기준은 만들 수 없음

Vivado 결과는 feedback 구조가 보존되었는지 확인하는 probe이며 ASIC PPA가 아니다.

## Cadence 결과

### Xcelium

- zero-delay cross-coupled loop: delta-cycle convergence 정지
- 각 NOR gate에 simulation-only 1 ps delay 적용: transaction 중 `aer_addr`가 0과 5 사이에서 반복 전이
- finite-delay 결과: `FAIL`, 첫 오류는 `aer_req=1` 동안 주소 변경

요약 증거: [`reports/traditional_async/cadence/xcelium_instability_summary.txt`](../reports/traditional_async/cadence/xcelium_instability_summary.txt)

### Genus

| 항목 | 결과 |
|---|---:|
| mapped cells | 108 |
| cell area | 1,353.845 |
| sequential cells | 0 |
| vectorless power | 31.817 µW |
| valid constrained timing/Fmax | 산출 불가 |

Genus는 feedback 처리를 위해 7개의 loop breaker를 삽입했고 timing report는 unconstrained 상태다. 따라서 작은 area와 power 숫자를 P1보다 우수한 정상 동작 PPA로 해석하면 안 된다.

## baseline으로 남기는 문제

1. MUTEX 없는 near-simultaneous request capture 불안정성
2. fixed priority의 starvation 및 도착 순서 비보존
3. FIFO 부재로 burst 흡수 불가
4. receiver stall의 end-to-end 전파
5. 4-phase return-to-zero 전송 간격
6. feedback loop 때문에 일반 synchronous STA/PPA flow에서 유효한 Fmax 산출 불가

