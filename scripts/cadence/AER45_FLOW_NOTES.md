# AER GPDK45/GSCLIB045 재현 절차

## PDK 구성

```text
$HOME/aer_2026/pdk45_digital/
  gsclib045/timing/{slow,fast}_vdd1v0_basicCells.lib
  gsclib045/timing/{slow,fast}_vdd1v0_multibitsDFF.lib
  gsclib045/lef/gsclib045_{tech,macro,multibitsDFF}.lef
  gsclib045/qrc/qx/gpdk045.tch
```

기본 구조 비교는 basicCells만 사용한다. MBFF/ICG는 별도 low-power experiment다.

## 공통 조건

```text
setup corner    slow 0.9 V / 125 C
hold corner     fast 1.1 V / 0 C
clock           10 ns
setup/hold uncertainty 0.20 / 0.02 ns
input/output delay     1 / 1 ns
CDC pair max delay     0.8 ns
placement density      60%
signal route           Metal1-Metal9
VDD/VSS ring           Metal9/10, width 1 um, spacing 2 um
```

## Genus

```bash
env AER45_RTL=/abs/design.sv \
    AER45_TOP=top_name \
    AER45_TAG=tag \
    AER45_OUT=/abs/reports/tag \
    AER45_SYNC_FF=34 \
    genus -batch -files scripts/cadence/aer45_genus_sweep.tcl
```

`AER45_SYNC_FF`는 P4-C 32, 16-source robust 후보 34, 64-source 후보 130이다.

## VCD power

```bash
env AER45_RTL=/abs/design.sv \
    AER45_TOP=top_name \
    AER45_TAG=tag \
    AER45_OUT=/abs/reports/tag_vcd \
    AER45_SYNC_FF=34 \
    AER45_VCD=/abs/workload.vcd \
    AER45_VCD_SCOPE=tb/dut \
    genus -batch -files scripts/cadence/aer45_genus_vcd_power.tcl
```

## Innovus

```bash
env AER45_TOP=top_name \
    AER45_TAG=tag \
    AER45_NETLIST=/abs/top_mapped.v \
    AER45_OUT=/abs/pnr/tag \
    AER45_VIEW=/abs/scripts/cadence/aer45_pnr.view \
    AER45_SDC=/abs/scripts/cadence/aer45_pnr.sdc \
    AER45_SYNC_FF=34 \
    AER45_HOLD_TARGET=0.020 \
    AER45_NUM_SOURCES=16 \
    AER45_ADDR_W=4 \
    innovus -no_gui -overwrite -files scripts/cadence/aer45_innovus.tcl
```

64-source grouped는 `SYNC_FF=130`, `NUM_SOURCES=64`, `ADDR_W=6`, hold target
`0.030`을 사용한다.

## Post-route SAIF

```bash
env AER45_TOP=top_name \
    AER45_DB=/abs/db/top_postroute.enc.dat \
    AER45_SAIF=/abs/mapped_activity.saif \
    AER45_REPORT=/abs/postroute_power_saif.rpt \
    innovus -no_gui -overwrite -files scripts/cadence/aer45_postroute_saif_power.tcl
```

## LEC

```bash
env AER45_RTL=/abs/design.sv \
    AER45_NETLIST=/abs/top_mapped.v \
    AER45_TOP=top_name \
    AER45_OUT=/abs/lec/tag \
    AER45_TAG=tag \
    lec -nogui -xl -dofile scripts/cadence/aer45_lec.tcl
```

MBFF netlist는 `AER45_USE_MBFF=1`을 추가한다. ICG 후보는 gated-clock flatten
model을 적용한다.

## 최종 근거

정량표와 sanitized 원시 보고서는 `reports/aer45_final/`, 해석은
`results/AER_45NM_MIGRATION_AND_8X8_IPRRA_2026-08-26.md`에 있다.
