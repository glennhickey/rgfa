#!/bin/bash
set -ex

DECON_VCF=${1}
PG_VCF=${2}
FILTER_REF=${3}
AN_THRESH=60

bcftools view ${DECON_VCF} -i "AN>${AN_THRESH}" -s ^${FILTER_REF} > ${PG_VCF}.tmp
vcfbub -i ${PG_VCF}.tmp -r 100000 | bgzip > ${PG_VCF}
tabix -fp vcf ${PG_VCF}
rm -f ${PG_VCF}.tmp

