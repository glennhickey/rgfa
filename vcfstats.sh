#!/bin/bash

VCF=$1
MIN_QUAL=$2

OUT_NAME_1=${VCF::-7}.vcfstats.${MIN_QUAL}.tmp.1
OUT_NAME_2=${VCF::-7}.vcfstats.${MIN_QUAL}.tmp.2
OUT_NAME_3=${VCF::-7}.vcfstats.${MIN_QUAL}.tmp.3
OUT_NAME_4=${VCF::-7}.vcfstats.${MIN_QUAL}.tmp.4

# ts/tv
bcftools view $VCF -i "QUAL>${MIN_QUAL} && FILTER=\"PASS\"" | bcftools stats | grep "^TSTV" | head -1 | awk '{print "TSTV\t" $5}' > ${OUT_NAME_1} &

# counts
bcftools view $VCF -i "QUAL>${MIN_QUAL} && FILTER=\"PASS\"" | bcftools stats | grep "^SN" | grep "number of records" | awk '{print "Total\t" $6}' > ${OUT_NAME_2} &
bcftools view $VCF -i "QUAL>${MIN_QUAL} && FILTER=\"PASS\"" | bcftools stats | grep "^SN" | grep "number of SNPs" | awk '{print "SNPs\t" $6}' > ${OUT_NAME_3} &
bcftools view $VCF -i "QUAL>${MIN_QUAL} && FILTER=\"PASS\"" | bcftools stats | grep "^SN" | grep "number of indels" | awk '{print "Indels\t" $6}' > ${OUT_NAME_4} &

wait

OUT_NAME=${VCF::-7}.stats.${MIN_QUAL}.tsv
cat ${OUT_NAME_1} ${OUT_NAME_2} ${OUT_NAME_3} ${OUT_NAME_4} > ${OUT_NAME}
rm -f ${OUT_NAME_1} ${OUT_NAME_2} ${OUT_NAME_3} ${OUT_NAME_4}

