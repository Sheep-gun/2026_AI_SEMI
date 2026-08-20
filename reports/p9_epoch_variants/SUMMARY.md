# P9-OHT Gray epoch successor 표현 탐색

P9-OHT의 arbiter, pending consume, CDC, reset, output isolation을 고정하고
Gray epoch successor 표현만 세 형태로 바꿨다. Vivado가 명시적 상태표를
16-flop one-hot FSM으로 자동 재인코딩하지 않도록 epoch 상태에는
`fsm_encoding="none"`을 적용해 모든 후보가 원래 4비트 Gray 상태를
유지하도록 했다.

| 설계 | epoch 표현 | LUT | FF | reg-to-reg data path |
|---|---|---:|---:|---:|
| P9-OHT | parity + toggle mask + XOR | **108** | 75 | 5.230 ns |
| Epoch-case | 명시적 16-state successor | 118 | 75 | **5.094 ns** |
| Epoch-Boolean | 최소화 next-bit 식 | 121 | 75 | 5.102 ns |
| Epoch-grant-toggle | grant 시 한 비트 직접 반전 | 110 | 75 | 5.230 ns |

## 결론: P9-OHT 유지

새로운 Pareto 우위 후보는 없다.

- 명시적 case는 경로를 0.136 ns(2.60%) 줄였지만 LUT가 10개(9.26%) 늘었다.
- Boolean식은 경로를 0.128 ns(2.45%) 줄였지만 LUT가 13개(12.04%) 늘었다.
- grant-toggle은 경로 개선 없이 LUT가 2개(1.85%) 늘었다.
- P9-OHT는 이미 10 ns 목표에서 4.619 ns slack이 있으므로, 0.13 ns 이내의
  추가 timing과 9~12% LUT 증가를 교환할 이유가 없다.

즉 4비트 reflected-Gray successor는 기존 parity/toggle/XOR 표현이 이
합성 조건에서 가장 좋은 면적-속도 균형이다. successor 표현만 바꾸는
탐색 방향은 여기서 소진된 것으로 판단한다.

## 검증

- P9-OHT와 4,007 cycle 내부-state lockstep: 세 후보 모두 0 error
- RTL 및 최종 post-synthesis broad: 139/139, 0 error
- RTL 및 최종 post-synthesis fairness: 64 masks, worst 16 grants
- RTL 및 최종 post-synthesis CDC phase sweep: 192/192, 0 error
- RTL 및 최종 post-synthesis clockless reset/restart: 0 error
- RTL 및 최종 post-synthesis contract workload: 101/101, 0 error
- contract address transitions: 106, bit toggles `52,26,16,12`
