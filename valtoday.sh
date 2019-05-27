#!/bin/bash
set -Ceuo pipefail
PATH=/usr/local/bin:/usr/bin:/bin

work=$(cat ${HOME}/.workdir)
: ${work:=/nwp/p3}
addr=$(cat ${HOME}/.mailto)
public=$(cat ${HOME}/.mailto-pub)
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
echo "# NOTE: failure does not always mean JMA message, rather problem of RNG more likely."

tar xf $tgz

nfail=0
n=0
for xml in ./urn*
do
  let "n++" || :
  ln $xml input.xml
  if jing $rng input.xml >&2
  then
    rm -f $xml
  else
    let "nfail++" || :
    echo "=== ${nfail}: $xml fails ===" >&2
  fi
  rm -f input.xml
done

echo "# total messages: $n" >&2
echo "# failed messages: $nfail" >&2

exec 2>&1

mail --subject="JMX nightly validation $today $n" $addr < validate.log
if [ $n -gt 0 ]; then
  mail --subject="JMX nightly validation $today $n" $public < validate.log
fi

cd $work
test -d $work/$ym || mkdir $work/$ym
tar -c -C $wd -z -f $work/$ym/jmxval-$today.tgz .
rm -rf $wd

exit 0
