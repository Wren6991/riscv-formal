#!/bin/bash
set -ex

if [[ -f checks/${1}_ch0/engine_0/trace.vcd ]]; then
	VCDNAME=checks/${1}_ch0/engine_0/trace.vcd
elif [[ -f ${1}_ch0/engine_0/trace.vcd ]]; then
	VCDNAME=${1}_ch0/engine_0/trace.vcd
elif [[ -f ${1}/engine_0/trace.vcd ]]; then
	VCDNAME=${1}/engine_0/trace.vcd
else
	echo "Couldn't find .vcd for test name: $1"
	exit
fi

# Reuse same gtkwave config for all VCDs
rm -f trace.vcd
ln -s ${VCDNAME} trace.vcd
gtkwave checks.gtkw &