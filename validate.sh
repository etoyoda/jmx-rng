#!/bin/bash
set -Ceuo pipefail
set -x

for xml in samples/*.xml
do
  hush=".hush.$(basename $xml .xml)"
  if [ -f "$hush" ]; then
    echo "### SKIP $xml"
    continue
  fi
  echo "### TRY $xml"
  test ! -e validate.log || rm -f validate.log
  if ! jing jmx.rng $xml > validate.log 2>&1
  then
    cat validate.log >&2
    break
  fi
  touch "$hush"
done
