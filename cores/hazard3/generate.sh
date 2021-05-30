#!/bin/bash
set -ex
TB_ROOT=$PROJ_ROOT/test/formal/riscv-formal/tb

rm -rf hdl
mkdir hdl
cp $(listfiles $TB_ROOT/hazard3_rvfi.f) hdl
for incdir in $(listfiles -f flati $TB_ROOT/hazard3_rvfi.f); do
	cp $incdir/*.vh hdl
done

python3 ../../checks/genchecks.py
