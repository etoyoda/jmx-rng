#!/usr/bin/make -f
test: jmx.rng samples
	for xml in samples/*.xml; do jing jmx.rng $$xml || break; done

jmx.rng: jmx.rnc
	trang jmx.rnc jmx.rng

samples:
	bash getsamp.sh

clean:
	rm -rf samples
