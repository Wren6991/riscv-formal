# Simple recursive Makefile to allow one `make` jobserver to be shared across
# multiple checks directories

.PHONY: all clean base 32ib 32izbk

all: base 32ib 32izbk

base:
	$(MAKE) -C checks

32ib:
	$(MAKE) -C checks_rv32ib

32izbk:
	$(MAKE) -C checks_32izbk

clean:
	./generate.sh