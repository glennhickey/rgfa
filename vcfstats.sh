#!/bin/bash

VCF=$1
MIN_QUAL=$2

# ts/tv
bcftools view $VCF -i "QUAL>${MIN_QUAL} && FILTER=\"PASS\"" | bcftools stats | grep "^TSTV" | head -1 | awk '{print "TSTV\t" $5}'

# counts
bcftools view $VCF -i "QUAL>${MIN_QUAL} && FILTER=\"PASS\"" | bcftools stats | grep "^SN" | grep "number of records" | awk '{print "Total\t" $6}'
bcftools view $VCF -i "QUAL>${MIN_QUAL} && FILTER=\"PASS\"" | bcftools stats | grep "^SN" | grep "number of SNPs" | awk '{print "SNPs\t" $6}'
bcftools view $VCF -i "QUAL>${MIN_QUAL} && FILTER=\"PASS\"" | bcftools stats | grep "^SN" | grep "number of indels" | awk '{print "Indels\t" $6}'


