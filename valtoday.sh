#!/bin/bash
set -Ceuo pipefail
PATH=/usr/local/bin:/usr/bin:/bin

work=$(cat ${HOME}/.workdir)
: ${work:=/nwp/p3}
addr=$(cat ${HOME}/.mailto)
arch=/nwp/a0
scriptdir=$(dirname $0)

today=$(TZ=JST-9 date +%Y-%m-%d --date="40 hours ago")

ym=$(echo $today | cut -c1-7)
wd=${work}/jmxval-${today}

tgz=${arch}/${ym}/jmx-${today}.tar.gz
rng=${scriptdir}/jmx.rng

barf() {
  echo "$*" >&2
  exit 16
}

test -f $tgz || barf $tgz not found
test -f $rng || barf $rng not found

mkdir $wd
cd $wd
exec 2> validate.log

echo "#--- JMX nightly validation $today ---" >&2

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
    echo "=== ${nfail}: $xml fails ===" >&2
  fi
done

echo "# total messages: $n" >&2
echo "# failed messages: $nfail" >&2

exec 2>&1

mail --subject="JMX nightly validation $today" $addr < validate.log

cd $work
test -d $work/$ym || mkdir $work/$ym
tar -c -C $wd -z -f $work/$ym/jmxval-$today.tgz .
rm -rf $wd

exit 0
