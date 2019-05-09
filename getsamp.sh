#!/bin/bash
set -Ceuo pipefail
set -x

XMLSITE=http://xml.kishou.go.jp
TH=tec_material.html

[ -f ${TH} ] || wget -O${TH} ${XMLSITE}/${TH}
SZ=$(ruby -ne 'puts($1) and exit if /(jmaxml_\w+_Samples\.zip)/' ${TH})
echo SZ=${SZ:?}

[ -f ${SZ} ] || wget -O${SZ} ${XMLSITE}/${SZ}
SD=$(/usr/bin/basename ${SZ} .zip)

[ ! -e ${SD} ] || rm -rf ${SD}
[ -d ${SD} ] || unzip ${SZ}

SS=samples
[ ! -e ${SS} ] || rm -rf ${SS}
mv ${SD} ${SS}
rm -rf ${TH} ${SZ}
