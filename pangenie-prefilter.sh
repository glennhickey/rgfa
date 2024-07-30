#!/bin/bash
set -ex

DECON_VCF=${1}
PG_VCF=${2}
FILTER_REF=${3}
AN_THRESH=60

bcftools view ${i} -i "AN>${AN_THRESH}" -s ^${FILTER_REF} | bgzip > ${PG_VCF}
tabix -fp vcf ${PG_VCF}

