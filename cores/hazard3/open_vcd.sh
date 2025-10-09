#!/bin/bash
set -ex

VCDNAME=checks/${1}_ch0/engine_0/trace.vcd
if [[ ! -f ${VCDNAME} ]]; then
	echo "No such file: ${VCDNAME}"
	exit
fi

# Reuse same gtkwave config for all VCDs
rm -f trace.vcd
ln -s ${VCDNAME} trace.vcd
gtkwave checks.gtkw &