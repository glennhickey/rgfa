#!/bin/bash

VCF=$1

SNP_NAME=${VCF::-7}.snp-only.vcf.gz

strip-nested.py $VCF 1 | bcftools +fill-tags | bcftools view -i "STRLEN(REF) < 2 && STRLEN(ALT) < 2 && AC > 1" | bcftools view -i 'FILTER="." || FILTER="PASS"' | bgzip > ${SNP_NAME}
tabix -fp vcf ${SNP_NAME}





														       }
