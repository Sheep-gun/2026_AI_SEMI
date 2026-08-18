# A0-functional Race and Post-synthesis Stability Test

Date: 2026-08-19 KST  
Target: `rtl/async_baseline/aer_traditional_async.sv`  
Purpose: near-simultaneous request stress와 synthesis 이후 handshake 의미 보존 여부 확인

## 결론

`A0-functional`은 RTL zero-delay simulation에서는 race stress를 통과했지만, **Vivado post-synthesis netlist에서는 기능이 보존되지 않았다**. 따라서 현재 RTL을 FPGA 또는 ASIC physical baseline으로 사용할 수 없다.

이 결과는 transistor metastability를 직접 측정한 것은 아니다. 그보다 앞 단계에서 일반 합성이 clockless latch feedback의 RTL 의미를 보존하지 못한다는 deterministic failure를 확인한 것이다.

## RTL digital race sweep

재현 명령:

```powershell
.\scripts\run_async_race.ps1
```

Stimulus:

- source pair `0/15`, `3/7`
- request skew `-20 ps`부터 `+20 ps`까지 1 ps 간격
- 동일시각 요청 포함
- 1 ps `X` window 두 건
- source request는 acknowledge까지 유지
- receiver/source model은 명시적 handshake delay 사용

결과:

| 지표 | 결과 |
|---|---:|
| Trials | 84 |
| Unexpected first grant | 0 |
| Unknown controller output | 0 |
| Short request pulse | 0 |
| Loss/duplicate/deadlock | 0 |
| Marker | `RACE_TEST_PASS digital_model trials=84` |

`X` window에서는 high-priority request가 `X`인 동안 Verilog 조건식이 이를 valid request로 선택하지 않아 다른 source가 먼저 grant됐다. Output에 `X`가 전파되지는 않았다. 이는 RTL simulator의 4-state 조건식 의미이며 analog metastability resolution 증거가 아니다.

## Post-synthesis functional netlist

Vivado가 생성한 42-LUT/6-latch netlist를 동일 testbench로 지연 없이 simulation했다.

| 지표 | 결과 |
|---|---:|
| Trials | 84 |
| Completed receiver events | 0 |
| Unexpected/missing first grant | 84 |
| Output unknown observations | 2 |
| Assertion failures | 170 |
| Marker | `RACE_TEST_FAIL digital_model errors=170 trials=84` |

모든 trial에서 receiver-facing event가 완료되지 않았다. 일부 내부/source-side signal은 변했지만 합성된 latch feedback이 RTL의 state progression을 재현하지 못했다.

Raw evidence: `reports/async_baseline/race_stress/post_synth_functional.log`

## Partial SDF timing attempt

전체 post-synthesis SDF는 Vivado `LDCE` model의 CLR→Q, setup/hold/recovery/removal arc를 매핑하지 못해 annotation에 실패했다.

진단 목적으로 다음을 제거한 partial SDF를 별도로 사용했다.

- `LDCE` cell block 6개
- unsupported `PATHPULSE` statement 87개

나머지 LUT/IO delay annotation은 성공했지만 첫 trial에서 latch state가 `IDLE`에 고정되어 `aer_req`가 발생하지 않았다. Latch delay를 제거한 partial SDF이므로 이것도 signoff timing 결과가 아니다.

## 판정

| 주장 | 판정 |
|---|---|
| RTL에서 clockless 4-phase sequence가 진행됨 | 확인 |
| ps-skew digital simulation에서 loss/glitch 없음 | 확인 |
| 일반 Vivado synthesis가 동작 의미를 보존함 | 실패 |
| Post-synthesis implementation baseline으로 사용 가능 | 불가 |
| Metastability-safe physical arbitration | 미검증 |

`A0-functional`은 교육/프로토콜 실험용 RTL로만 남긴다. 다음 physical baseline은 다음 중 하나여야 한다.

1. Characterized MUTEX/C-element와 승인된 asynchronous flow를 사용한 새 A-series.
2. 비동기 request capture와 synchronizer 뒤에 동기식 arbiter를 둔 H-series.
