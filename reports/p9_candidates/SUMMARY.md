# P9 조합 논리 표현 탐색 요약

P8-DG-SCR의 기능 계약과 순차 상태는 고정하고, 요청 수락·arbiter·pending
consume 논리의 RTL 표현만 바꾼 세 후보를 비교했다. 이 표는 180 nm ASIC
결과가 아니라 Artix-7 Vivado 합성 결과이며, Genus에 올릴 후보를 거르는
용도로만 사용한다.

| 설계 | 표현 | LUT | FF | reg-to-reg data path |
|---|---|---:|---:|---:|
| P8-DG-SCR | vector accept + shared validity tree + dynamic-index clear | 108 | 75 | 5.611 ns |
| P9-OHT | top-down one-hot path 공유 + vector consume | 108 | 75 | **5.230 ns** |
| P9-LR | source loop + independent reductions + dynamic-index clear | 108 | 75 | 5.611 ns |
| P9-OHD | vector accept + independent reductions + one-hot decode/consume | **105** | 75 | 5.605 ns |

P9-OHT는 P8 대비 LUT 증감 없이 data path를 0.381 ns(6.79%) 줄였다.
P9-OHD는 data path가 사실상 동일하면서 LUT를 3개(2.78%) 줄였다. P9-LR은
Vivado에서 P8과 완전히 같은 결과로 매핑되어 ASIC 탐색 우선순위가 낮다.

## 검증

- P8-DG-SCR과 4,007 cycle 내부 상태 lockstep: 세 후보 모두 0 error
- RTL과 post-synthesis 각각 broad: 139/139, 0 error
- RTL과 post-synthesis 각각 frozen-mask fairness: 64 masks, worst 16 grants
- RTL과 post-synthesis 각각 CDC phase sweep: 192/192, 0 error
- RTL과 post-synthesis 각각 clockless reset/restart: 0 error
- RTL과 post-synthesis 각각 contract workload: 101/101, 0 error
- contract address transitions: 106, bit toggles `52,26,16,12`

따라서 다음 180 nm Genus 후보는 면적 지향 P9-OHD와 timing 지향 P9-OHT다.
최종 판단은 Genus cell area/timing/activity-based power와 Innovus post-route
결과로 내려야 한다.
