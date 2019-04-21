Hazard5 Formal Test Configuration
=================================

Currently riscv-formal is pulled in as a submodule of RISCBoy so that the regression scripts can call into it. This would cause some peculiar issues if riscv-formal then itself pulled RISCBoy (containing hazard5) in via submodule, so you should run:

```
git clone --recursive https://github.com/Wren6991/RISCBoy.git riscboy
cd riscboy
. sourceme

# Run all regressions, including riscv-formal:
cd test
./runtests

# OR, just run riscv-formal:
cd test/riscv-formal/cores/hazard5
./generate.sh
make -j$(nproc)
```

This will retrieve the correct sources from the RISCBoy tree and setup the riscv-formal check Makefiles. This is moderately cursed, and will be solved at some point by breaking RISCBoy into submodules via some history-rewriting kung fu, so that riscv-formal can just pull in the processor like normal.

Note you must have Yosys, SymbiYosys and the solver (Boolector) installed on your machine; see [here](http://symbiyosys.readthedocs.io/en/latest/quickstart.html#installing).