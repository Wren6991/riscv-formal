Hazard3 Formal Test Configuration
=================================

Run:

```bash
git clone --recursive https://github.com/Wren6991/Hazard3.git hazard3
cd hazard3
. sourceme

cd test/riscv-formal/riscv-formal/cores/hazard3
./generate.sh
make -j$(nproc)
```
