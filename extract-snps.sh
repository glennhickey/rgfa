#!/bin/bash

VCF=$1

SNP_NAME=${VCF::-7}.snp-only.vcf.gz

# need temp file to fix the header
strip-nested.py $VCF 1 1 | bgzip --threads 4 > ${SNP_NAME}.tmp.gz
tabix -fp vcf ${SNP_NAME}.tmp.gz
bcftools +fill-tags ${SNP_NAME}.tmp.gz | bcftools view -i "STRLEN(REF) < 2 && STRLEN(ALT) < 2 && AC > 0" | bcftools view -i 'FILTER="." || FILTER="PASS"' | bgzip --threads 4 > ${SNP_NAME}
tabix -fp vcf ${SNP_NAME}
rm -f ${SNP_NAME}.tmp.gz ${SNP_NAME}.tmp.gz.tbi

