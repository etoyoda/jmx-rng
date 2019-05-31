#!/bin/bash
set -Ceuo pipefail
PATH=/bin:/usr/bin:/usr/local/bin

exec > samples/Makefile

xmfiles=""
okfiles=""
for xml in samples/*.xml
do
  bn=$(basename $xml)
  okfile="$(basename $xml .xml).ok"
  xmfiles="${xmfiles} ${bn}"
  okfiles="${okfiles} $okfile"
  printf "${okfile}:\n"
  printf "\tjing ../jmx.rng ${bn} && touch ${okfile}\n"
  printf "\n"
done

printf "validate: ${okfiles}\n"
