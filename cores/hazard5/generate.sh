#!/bin/bash
set -ex
rm -rf hazard5
# FIXME this is awful but not willing to experiment with loops of submodules right now
cp -R $HDL/hazard5 .
mv hazard5/arith/* hazard5
python3 ../../checks/genchecks.py
