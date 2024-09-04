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
bcftools view $VCF -i "strlen(ALT) >= 50 || strlen(REF) >=50" | bcftools stats | grep "^SN" | grep "number of SVs" | awk '{print "SVs\t" $6}' > ${OUT_NAME_4} &
# alleles
num_sites=$(bcftools view -H $VCF | wc -l)
num_commas=$(bcftools view -H $VCF | awk '{print $5}' | grep -o , | wc -l)
# sv alleles
num_sv_sites=$(bcftools view -H $VCF -i "strlen(ALT) >= 50 || strlen(REF) >=50" | wc -l)
num_sv_commas=$(bcftools view -H $VCF -i "strlen(ALT) >= 50 || strlen(REF) >=50" | awk '{print $5}' | grep -o , | wc -l)

wait

OUT_NAME=${VCF::-7}.stats.${MIN_QUAL}.tsv
cat ${OUT_NAME_1} ${OUT_NAME_2} ${OUT_NAME_3} ${OUT_NAME_4} > ${OUT_NAME}
printf "Alleles\t$((num_sites + num_commas))\n" >> ${OUT_NAME}
printf "SV-Alleles\t$((num_sv_sites + num_sv_commas))\n" >> ${OUT_NAME}
rm -f ${OUT_NAME_1} ${OUT_NAME_2} ${OUT_NAME_3} ${OUT_NAME_4}

