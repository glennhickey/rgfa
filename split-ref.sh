#!/bin/bash

VCF=$1
PREFIX=$2

OUT_NAME=${VCF::-7}.onref.vcf.gz
bcftools view ${VCF} -h | bgzip --threads 2 > $OUT_NAME
bcftools view ${VCF} -H | grep ^${PREFIX} | bgzip --threads 2 >> $OUT_NAME
tabix -fp vcf ${OUT_NAME}

OUT_NAME=${VCF::-7}.offref.vcf.gz
bcftools view ${VCF} -h | bgzip --threads 2 > $OUT_NAME
bcftools view ${VCF} -H | grep -v ^${PREFIX} | bgzip --threads 2 >> $OUT_NAME
tabix -fp vcf ${OUT_NAME}



