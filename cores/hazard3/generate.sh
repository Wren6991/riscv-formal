#!/bin/bash
set -ex
# FIXME this is awful but not willing to experiment with loops of submodules right now
rm -rf hdl
cp -R ../../../../../hdl .
mv hdl/arith/* hdl
python3 ../../checks/genchecks.py
