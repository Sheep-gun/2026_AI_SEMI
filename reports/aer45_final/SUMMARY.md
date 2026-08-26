# GPDK45/GSCLIB045 최종 비교 근거

## 조건

- 공정: 서버 제공 Cadence GPDK045 + GSCLIB045 generic 45 nm digital kit
- Setup: slow, 0.9 V, 125°C
- Hold: fast, 1.1 V, 0°C
- Clock: 10 ns
- Clock uncertainty: setup 0.20 ns, hold 0.02 ns
- I/O delay: 1 ns
- CDC pair max delay: 0.8 ns
- Physical density: 60%
- Signal route: Metal1-Metal9
- Power ring: Metal9/Metal10, width 1 µm, VDD/VSS spacing 2 µm
- Power: vectorless와 동일 workload mapped-SAIF를 분리 보고

이 환경은 교육·비교용 generic PDK이며 특정 foundry 제조 sign-off를 뜻하지 않는다.

## 16-source Genus 전체 후보

| 후보 | cells | area (µm²) | vectorless (mW) | VCD (mW) | data path (ns) |
|---|---:|---:|---:|---:|---:|
| P4-C | 287 | 831.402 | 0.035395 | 0.033096 | 2.830 |
| P7-GE | 216 | 688.104 | 0.028773 | 0.023624 | 2.410 |
| P8-DG-SCR | 259 | 680.922 | 0.022610 | 0.015097 | 2.670 |
| **P9-GRR** | 260 | 655.272 | 0.023833 | **0.014789** | 2.210 |
| P9-OHT | 275 | 696.654 | **0.019387** | **0.014515** | **1.588** |
| P10-IPRRA | 316 | 718.200 | 0.026264 | 0.016446 | 2.072 |
| P10-X1 | 261 | **654.246** | 0.023786 | 0.014865 | 2.179 |
| P10-X2 | 275 | 665.190 | 0.026140 | 0.016149 | 2.057 |

P9-GRR, P9-OHT, P10-X1만 Pareto 후보로 P&R에 올렸다. P4/P7/P8/P10-IPRRA/X2는
면적·timing·동일 workload power 중 다른 후보에 지배되어 합성 단계에서 종료했다.

## 최종 clean P&R

| 후보 | instances | area (µm²) | vectorless (mW) | SAIF (mW) | setup | core setup | hold | recovery/removal | DRC/conn |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| **P9-GRR** | **263** | **669.294** | 0.020641 | 0.014382 | +0.472 ns | +6.824 ns | +0.024 ns | +9.386/+0.061 ns | 0/0 |
| P10-X1 | 263 | 669.978 | 0.020642 | 0.014518 | +0.468 ns | +7.061 ns | +0.024 ns | +9.386/+0.061 ns | 0/0 |
| P9-OHT | 278 | 709.308 | **0.019218** | **0.013780** | +0.458 ns | **+7.555 ns** | +0.024 ns | +9.380/+0.061 ns | 0/0 |

- P9-GRR은 최소 면적과 균형 power를 가진 주 설계다.
- P9-OHT는 P9-GRR보다 면적이 5.979% 크지만 vectorless 6.892%, SAIF 4.189%가 낮고
  core timing 여유가 0.731 ns 크다. 고속·저전력 Pareto 대안이다.
- P10-X1은 P9-GRR보다 core timing이 0.237 ns 좋지만, post-route 면적 0.102%와
  SAIF power 0.946%가 높아 주 설계로 승격하지 않았다.

## 64-source 8x8 중재기

두 후보는 265 FF, source별 pending, early ACK, 단일 6-bit registered output,
1 event/clock, 64-decision 공정성 계약을 공유한다.

| 64-source 후보 | cells | Genus area (µm²) | VCD (mW) | data path (ns) |
|---|---:|---:|---:|---:|
| **8x8 grouped strict RR** | **987** | **2,421.018** | **0.048288** | **3.528** |
| IPRRA tree | 1,234 | 2,727.108 | 0.048399 | 4.334 |

IPRRA는 grouped보다 면적 12.643%, data path 22.846%, VCD power 0.230%가 높아
64-input에서도 탈락했다. 36,992 selector case와 통합 RTL에서 두 후보의 선택 결과는
일치했고, 차이는 기능이 아니라 구현 비용이다.

최종 grouped P&R은 1,095 instances, 2,733.264 µm², vectorless 0.101732 mW,
SAIF 0.057842 mW, setup/core/hold +0.380/+5.142/+0.026 ns이며 DRC와 connectivity는 0이다.

## 라이브러리 저전력 실험

- MBFF 단독: 작은 코어에서는 DFF4 셀 비용으로 area/power가 개선되지 않음
- ICG 단독: 2개 ICG가 21 FF를 gating했지만 실제 VCD power가 증가
- MBFF+ICG: Genus VCD는 감소했으나 post-route에서 역전

MBFF+ICG post-route는 302 instances, 823.878 µm², SAIF 0.015625 mW였다.
기본 P9-GRR보다 면적 23.097%, SAIF 8.643%가 높아 탈락했다. LEC는 gated-clock
모델을 적용해 21 outputs와 71 state points 모두 equivalent로 통과했다.

## 전통 baseline

T0-PPA 45 nm port는 GSCLIB045의 TLATX1 5개와 DLY4X1 6개를 사용한다. Post-route는
92 instances, 214.092 µm², vectorless 0.002127 mW, max-delay slack +4.126 ns,
DRC/connectivity 0/0이며 LEC 21 outputs + 5 latch state points를 통과했다. T0는
clockless·fixed-priority·no-pending 구조이므로 P9의 Fmax/elasticity와 직접 동급 비교하지 않는다.

## 근거 위치

- `reports/`: 모든 후보 Genus와 VCD-power 보고서
- `pnr/p9grr_h020v4/`: P9-GRR clean P&R
- `pnr/p9oht_h020v4/`: P9-OHT clean P&R
- `pnr/p10xor1_h020v4/`: P10-X1 clean P&R
- `pnr/aer64grouped_h030v4/`: 64-source grouped clean P&R
- `pnr/t0_paa/`: T0-PPA clean P&R
- `lec/`: RTL-to-mapped equivalence
- `experiments/`: MBFF/ICG 탈락 근거
