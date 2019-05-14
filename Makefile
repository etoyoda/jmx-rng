#!/usr/bin/make -f
test: jmx.rng samples
	bash validate.sh

jmx.rng: jmx.rnc
	trang jmx.rnc jmx.rng

samples:
	bash getsamp.sh

clean: reset
	rm -rf samples

reset:
	rm -f .hush.*

reset-kaijou:
	rm -f .hush.11* .hush.12* .hush.13*
