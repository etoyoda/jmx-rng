#!/usr/bin/make -f
test: jmx.rng samples
	cd samples && $(MAKE) validate

jmx.rng: jmx.rnc
	trang jmx.rnc jmx.rng

samples:
	bash getsamp.sh
	bash mkmf.sh

clean: reset
	rm -rf samples

reset:
	rm -f samples/*.ok
