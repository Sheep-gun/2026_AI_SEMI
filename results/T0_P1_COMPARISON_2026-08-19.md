# T0 대비 P1 개선 비교

## 설계 관점 비교

| 평가축 | T0 전통 baseline | P1 개선본 | 판단 |
|---|---|---|---|
| 입력 방식 | clockless 4-phase | 비동기 4-phase + 2FF CDC | 비동기 source 연결 유지 |
| arbitration | fixed priority | round-robin | starvation 위험 완화 |
| burst storage | 없음 | source별 depth-2 | 짧은 burst 흡수 |
| output | clockless 4-phase | registered valid/ready | ready 시 1 event/cycle |
| receiver stall | 현재 source와 공유 link를 직접 막음 | output slot과 queue가 흡수 | backpressure 격리 |
| implementation stability | feedback loop/발진 관측 | loop 0, fully constrained | P1 우세 |
| analog MUTEX | 없음 | 사용하지 않음 | 대회 library 제약 준수 |

## 측정 결과

| 지표 | T0 | P1 | 주의 |
|---|---:|---:|---|
| main functional events | 139 / 139 | 139 / 139 | 각 구조의 self-checking workload |
| phase/skew trials | 82 / 82 completed | 192 / 192 exactly-once | 시험 목적과 phase set이 다름 |
| Cadence functional stability | finite-delay 발진 | Xcelium pass | P1의 핵심 안정성 개선 |
| Genus cell area | 1,353.845 | 11,605.810 | T0는 loop breaker와 무유효 timing 상태 |
| Genus vectorless power | 31.817 µW | 1.66431 mW | T0는 clock/FF가 없고 정상 동작 timing이 없어 직접 비율 비교 금지 |
| valid synthesis Fmax | 없음 | 500 MHz point 도달 | P1 2 ns, post-layout signoff 아님 |
| no-stall peak | TB delay 기준 4 ns/event | 1 event/cycle | 서로 다른 timing model이라 직접 events/s 비교 금지 |

P1 area는 T0 숫자의 약 8.57배다. 그러나 T0의 작은 수치는 안정적으로 timing closure 가능한 동일 기능 구현의 면적이 아니다. P1은 32-bit queue storage, 32 synchronizer flops, ack state, round-robin pointer와 elastic output에 면적을 사용하고, 그 대가로 일반 ASIC flow에서 검증 가능한 timing, fairness, buffering과 throughput을 얻는다.

동일 synchronous protocol 기준인 기존 `B0-v1`과 비교하면 no-stall steady throughput은 `0.25 event/cycle`에서 `1 event/cycle`로 4배 개선됐다. 이것이 4-phase output return-to-zero를 valid/ready elastic output으로 바꾼 직접 효과다.

## 최종 판단

- `T0`는 전통적 clockless AER의 구조와 약점을 보여주는 baseline으로 보존한다.
- `P1`은 대회 주 설계 후보로 채택한다.
- headline은 “안정성만 개선”이 아니라 **비동기 event 수용 + 공정한 arbitration + burst buffer + backpressure decoupling + 1 event/cycle output + 합성 가능한 PPA**다.
- 다음 최적화는 P1 기능을 유지하면서 hierarchical scheduler와 queue 배치를 조정해 area와 critical path를 줄이는 방향으로 진행한다.

