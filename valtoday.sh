#!/bin/bash
set -Ceuo pipefail

work=$(cat ${HOME}/.workdir)
: ${work:=/nwp/p3}
arch=/nwp/a0
today=$(TZ=JST-9 date +%Y-%m-%d --date="40 hours ago")

ym=$(echo $today | cut -c1-7)
wd=${work}/jmxval-${today}

tgz=${arch}/${ym}/jmx-${today}.tar.gz
rng=$(pwd)/jmx.rng

barf() {
  echo "$*" >&2
  exit 16
}

test -f $tgz || barf $tgz not found
test -f $rng || barf $rng not found

mkdir $wd
cd $wd
exec 2> validate.log

tar xf $tgz

nfail=0
n=0
for xml in ./urn*
do
  let "n++" || :
  if jing $rng $xml >&2
  then
    rm -f $xml
  else
    let "nfail++" || :
    echo === ${nfail}: $xml fails === >&2
  fi
done

exec 2>&1

echo "#total $n"
echo "#fail $nfail"
echo "#wd $wd"

cat validate.log
