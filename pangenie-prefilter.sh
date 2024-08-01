#!/bin/bash
set -ex

DECON_VCF=${1}
PG_VCF=${2}
FILTER_REF=${3}
AN_THRESH=60

mkdir -p /data/tmp/glenn
bcftools view ${DECON_VCF} -i "AN>${AN_THRESH}" -s ^${FILTER_REF} > /data/tmp/glenn/${PG_VCF}.tmp
vcfbub -i /data/tmp/glenn/${PG_VCF}.tmp -r 100000 -l 0 > ${PG_VCF}
rm -f ${PG_VCF}.tmp

