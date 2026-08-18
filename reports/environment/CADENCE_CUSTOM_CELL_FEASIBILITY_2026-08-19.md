# Cadence Custom MUTEX/C-element 제작 가능성 점검

점검일: 2026-08-19 KST  
범위: 구성된 Cadence 서버의 custom-IC tool, transistor model, PDK, physical verification 및 characterization 자료  
보안: 서버 endpoint, account와 credential은 기록하지 않음

## 결론

현재 서버에는 **Spectre simulator는 있지만 custom-cell 제작을 완결할 tool/PDK 묶음은 없다**.

따라서 transistor-level MUTEX/C-element의 개념 netlist와 generic simulation을 연구하는 것은 가능하지만, 다음을 모두 갖춘 ASIC custom cell을 현재 환경에서 제작·검증할 수는 없다.

- Foundry transistor model 기반 PVT/Monte Carlo
- Schematic-driven layout
- DRC/LVS-clean custom layout
- Parasitic extraction과 post-layout SPICE
- Liberty timing/power characterization
- 활성 LEF와 GDS/CDL deliverable

## Custom-IC/characterization 도구

| 도구 | 확인 결과 | 해석 |
|---|---|---|
| Spectre | 설치됨, 23.1.0.275.isr2 | Transistor-level netlist simulation 가능 |
| Virtuoso | 실행 파일 없음 | Schematic/layout custom-cell flow 없음 |
| Liberate | 실행 파일 없음 | 자동 Liberty characterization 없음 |
| Cadence PVS | 없음 | `/usr/sbin/pvs`는 Linux LVM 명령으로 Cadence 제품이 아님 |
| Assura | 없음 | DRC/LVS flow 없음 |
| Pegasus | 없음 | DRC/LVS flow 없음 |
| Calibre | 없음 | DRC/LVS flow 없음 |
| Quantus/QRC | 설치됨 | Digital extraction 도구는 있으나 PDK/rule deck이 별도로 필요 |

## PDK와 physical 자료

Project home과 공용 tool 경로를 읽기 전용으로 검색한 결과:

- Project용 Spectre transistor model (`.scs`, `.spice`) 없음
- Project용 GDS/GDSII 없음
- CDL 없음
- DRC/LVS rule deck 없음
- Virtuoso technology library/technology file 없음
- Project PDK directory 없음

공용 tool 경로에서 발견된 `.scs`와 `.tf`는 Cadence 설치의 `examples`, `samples`, `doc` 하위 자료였다. Xcelium AMS sample의 `gpdk.scs`도 교육/제품 예제이며 현재 AER project의 foundry-qualified PDK 근거가 아니다.

기존 `FPR` 자료에는 standard-cell Liberty/LEF/QRC/capacitance table이 있지만 transistor model, standard-cell GDS/CDL과 custom layout rule deck은 없다.

## 현재 가능한 MUTEX 연구

Spectre를 직접 사용해 다음 수준의 연구는 가능하다.

1. Cross-coupled 2-input MUTEX transistor netlist 작성.
2. Generic/sample MOS model을 사용한 동작 원리 확인.
3. Request skew sweep와 nominal resolution-time 관찰.

하지만 generic/sample model 결과로 다음을 주장할 수 없다.

- 실제 target process의 metastability MTBF
- 실제 PVT/variation robustness
- Layout symmetry와 parasitic을 포함한 arbitration safety
- Foundry-clean area/power/timing
- Genus/Innovus signoff 가능한 custom macro

## 대회 문서 확인

Orientation PDF의 관련 페이지를 다시 확인한 결과:

- Digital 1차 제출 항목: RTL, synthesis, timing 최적화, area, power, 동작 frequency.
- Analog 1차 제출 항목: 회로, testbench, layout, RC-extracted 결과.
- Digital 주제: 전통적 AER 분석, 문제점과 개선 방향, 개선된 AER 설계.
- Custom cell 사용을 명시적으로 허용하거나 금지하는 문구는 없음.

따라서 custom MUTEX/C-element를 digital 제출에 포함할 수 있는지는 문서만으로 확인되지 않는다. 주최 측 또는 담당자에게 다음을 확인해야 한다.

1. Digital 1차에서 custom transistor-level cell과 layout을 사용할 수 있는가.
2. 제공된 standard-cell library 밖의 Liberty/LEF/GDS를 추가해도 되는가.
3. Custom cell PPA를 어떤 corner와 방법으로 평가해야 하는가.
4. Frequency 제출 항목을 완전 비동기 handshake cycle/events/s로 대체할 수 있는가.

## 프로젝트 판단

현재 환경에서는 `A0-functional`을 clockless protocol/control 기준으로 유지할 수 있다. 그러나 custom MUTEX/C-element 기반 완전 비동기 ASIC을 다음 단계로 진행하려면 최소한 아래 자료가 추가로 필요하다.

- 승인된 transistor PDK/model
- Schematic/layout editor
- DRC/LVS/PEX rule deck과 실행 도구
- Liberty characterization 방법
- 대회 custom-cell 허용 확인

위 항목이 확보되기 전에는 custom MUTEX를 ASIC 구현 완료나 PPA 결과로 표시하지 않는다.
