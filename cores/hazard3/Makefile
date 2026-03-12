# Simple recursive Makefile to allow one `make` jobserver to be shared across
# multiple checks directories

.PHONY: all clean base 1port 32ib 32izbk

all: base 1port 32ib 32izbk zcmp zilsd

base:
	$(MAKE) -C checks

1port:
	$(MAKE) -C checks_1port

32ib:
	$(MAKE) -C checks_rv32ib

32izbk:
	$(MAKE) -C checks_rv32izbk

zcmp:
	$(MAKE) -C checks_zcmp

zilsd:
	$(MAKE) -C checks_zilsd

clean:
	./generate.sh