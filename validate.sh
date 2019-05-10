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
  jing jmx.rng $xml || break
  touch "$hush"
done
