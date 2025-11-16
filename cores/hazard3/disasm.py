#!/usr/bin/env python3

from Verilog_VCD.Verilog_VCD import parse_vcd
from os import system
from sys import argv
import sys
import os.path

rvfi_valid = None
rvfi_order = None
rvfi_insn = None

# Do what I mean
try_paths = [
    f"checks/{argv[1]}_ch0/engine_0/trace.vcd",
    f"{argv[1]}_ch0/engine_0/trace.vcd",
    f"{argv[1]}/engine_0/trace.vcd",
]
vcdpath = None
for p in try_paths:
    if os.path.exists(p):
        vcdpath = p
        break
if vcdpath is None:
    sys.exit(f"Couldn't find VCD for test name '{argv[1]}'")
print(f"Disassembling '{vcdpath}'")
for netinfo in parse_vcd(vcdpath).values():
    for net in netinfo['nets']:
        # print(net["hier"], net["name"])
        if net["hier"] == "rvfi_testbench.wrapper" and net["name"] == "rvfi_valid":
            rvfi_valid = netinfo['tv']
        if net["hier"] == "rvfi_testbench.wrapper" and net["name"] == "rvfi_order":
            rvfi_order = netinfo['tv']
        if net["hier"] == "rvfi_testbench.wrapper" and net["name"] == "rvfi_insn":
            rvfi_insn = netinfo['tv']

assert len(rvfi_valid) == len(rvfi_order)
assert len(rvfi_valid) == len(rvfi_insn)

prog = list()

for tv_valid, tv_order, tv_insn in zip(rvfi_valid, rvfi_order, rvfi_insn):
    if tv_valid[1] == '1':
        prog.append((int(tv_order[1], 2), int(tv_insn[1], 2)))

with open("disasm.s", "w") as f:
    for tv_order, tv_insn in sorted(prog):
        if tv_insn & 3 != 3 and tv_insn & 0xffff0000 == 0:
            print(".insn 2, 0x%04x # %d" % (tv_insn, tv_order), file=f)
        else:
            print(".insn 4, 0x%08x # %d" % (tv_insn, tv_order), file=f)
    # Allow additional (e.g. non-retired) instructions to be appended:
    for word in argv[2:]:
        if len(word) == 4:
            print(".insn 2, 0x" + word, file=f)
        else:
            print(".insn 4, 0x" + word, file=f)


system("riscv32-unknown-elf-gcc -march=rv32imab_zicsr_zifencei_zca_zcb_zcmp -Wa,-march=rv32imab_zicsr_zifencei_zca_zcb_zcmp_zilsd_zclsd -c disasm.s")
system("riscv32-unknown-elf-objdump -D -j .text -M numeric,no-aliases disasm.o")

