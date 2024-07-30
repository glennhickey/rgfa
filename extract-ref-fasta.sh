#!/bin/bash
set -ex

FULL_GBZ=$1
DECON_VCF=$2
OUT_PATHS=$3
OUT_LIST=${3}.names
TMP_LIST=${OUT_LIST}.tmp

bcftools view -H $DECON_VCF | awk '{print $1}' | sort | uniq > $TMP_LIST

grep GRCh38 $TMP_LIST > $OUT_LIST
grep CHM13 $TMP_LIST >> $OUT_LIST
for i in `grep -v GRCh38 $TMP_LIST | grep -v ^CHM13` ; do printf "${i}#0\n" >> ${OUT_LIST}; done

vg paths -x ${FULL_GBZ} -F -p ${OUT_LIST} > ${OUT_PATHS}

rm -f $TMP_LIST

