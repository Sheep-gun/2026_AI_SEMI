# P4-H Homeostatic steering 탐색

P4-H는 P4-C cut-through 위에 receiver stall 동안 오래 기다린 4-source group을 기억하는 aged bit 4개를 추가한다. 출력이 막힌 cycle에는 datapath를 움직일 수 없으므로, 그 시간을 이용해 다음 round-robin group pointer를 aged backlog 방향으로 미리 이동시킨다.

```text
receiver stall
  → group별 backlog age 기록
  → 다음 group pointer를 aged group으로 steering
  → ready 복귀 시 오래 기다린 group부터 재개
```

별도 behavior test에서는 group 1의 source 5를 먼저 기다리게 하고, round-robin pointer가 선호하는 group 0의 source 0을 나중에 넣었다. 출력 순서는 `15(blocker) → 5(aged) → 0(fresh)`였으며 오류는 0이었다.

## 최적화 과정

| 후보 | Vivado LUT / FF | data path | 판단 |
|---|---:|---:|---|
| source별 aged bit 16개 | 149 / 95 | 9.529 ns | 비용 과다, 폐기 |
| group aged priority를 ready path에 직접 삽입 | 96 / 83 | 7.396 ns | timing 부담, 폐기 |
| stall-time pointer steering | 86 / 83 | 4.016 ns | timing 회복, 채택 가능한 연구점 |

ready-cycle의 arbitration path에서는 age 비교를 제거하고, output이 막힌 시간에만 pointer를 steering한 것이 핵심 최적화다.

## 물리 결과와 결정

| 항목 | P4-C | P4-H |
|---|---:|---:|
| post-route cells | 362 | 391 |
| area | 9,353.837 µm² | 10,039.075 µm² |
| setup / hold | +3.547 / +0.004 ns | +3.235 / +0.006 ns |
| default power | 0.960680 mW | 1.022200 mW |
| DRC / connectivity | 0 / 0 | 0 / 0 |

P4-H의 혼잡 복구 순서는 명확하지만 main workload latency는 P4-C와 동일했다. 대회 주 설계에는 더 작은 P4-C를 채택하고, P4-H는 receiver stall이 길거나 QoS가 중요한 2차 연구용 확장으로 보존한다.

## 근거

- RTL: [`rtl/improved/aer_improved_homeostatic.sv`](../rtl/improved/aer_improved_homeostatic.sv)
- behavior test: [`tb/aer_improved_homeostatic_behavior_tb.sv`](../tb/aer_improved_homeostatic_behavior_tb.sv)
- Vivado evidence: [`reports/improved_homeostatic/vivado_sanity/`](../reports/improved_homeostatic/vivado_sanity/)
- Cadence summary: [`reports/improved_homeostatic/cadence/pnr_180nm/SUMMARY.txt`](../reports/improved_homeostatic/cadence/pnr_180nm/SUMMARY.txt)
