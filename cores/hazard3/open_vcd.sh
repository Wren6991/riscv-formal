#!/bin/bash
set -ex

# Reuse same gtkwave config for all VCDs
rm trace.vcd
ln -s checks/${1}_ch0/engine_0/trace.vcd trace.vcd
gtkwave checks.gtkw &