#!/bin/bash
set -ex

# Assuming checked out inside of Hazard3 repository
export PROJ_ROOT=$(realpath ../../../../../..)
export HDL=${PROJ_ROOT}/hdl

TB_ROOT=$PROJ_ROOT/test/formal/riscv-formal/tb
LISTFILES=$PROJ_ROOT/scripts/listfiles

export 

rm -rf hdl
mkdir hdl
cp $(${LISTFILES} $TB_ROOT/hazard3_rvfi.f) hdl
for incdir in $(${LISTFILES} -f flati $TB_ROOT/hazard3_rvfi.f); do
	cp $incdir/*.vh hdl
done

python3 ../../checks/genchecks.py checks
python3 ../../checks/genchecks.py checks_1port
python3 ../../checks/genchecks.py checks_rv32ib
python3 ../../checks/genchecks.py checks_rv32izbk
