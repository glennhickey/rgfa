#!/bin/bash

VCF=$1

# ts/tv
bcftools stats ${VCF} | grep "^TSTV" | head -1 | awk '{print "TSTV\t" $5}'

# counts
bcftools stats ${VCF} | grep "^SN" | grep "number of records" | awk '{print "Total\t" $6}'
bcftools stats ${VCF} | grep "^SN" | grep "number of SNPs" | awk '{print "SNPs\t" $6}'
bcftools stats ${VCF} | grep "^SN" | grep "number of indels" | awk '{print "Indels\t" $6}'


