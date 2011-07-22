#!/bin/bash
VERSION=$(grep 'INSTALATEUR_VERSION=' src/instalateur |
          sed s/INSTALATEUR_VERSION=// |
          sed s/\"//g)
PREFIX=instalateur-${VERSION}
TARFILE=${PREFIX}.tar.gz
SRC_FILES=$(git ls-files src/)
OTHER_FILES="Makefile \
	instalateur.yaml \
	instalateur.spec \
	instalateur.changes \
	"
TRANSFORM='s,^,'${PREFIX}/','
tar --transform ${TRANSFORM} -zcvf ${TARFILE} ${SRC_FILES} ${OTHER_FILES}
echo ${VERSION} > VERSION
echo
echo "created " ${TARFILE}
echo
ls -l ${TARFILE}
