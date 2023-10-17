#!/bin/bash

VCF=$1
SDF=$2
MIN_QUAL=$3

# make the pedigree
printf "1 HG001 0 0 1 0\n
2 HG002 HG003 HG004 1 0\n
3 HG003 0 0 1 0\n
4 HG004 0 0 2 0\n
5 HG005 HG006 HG007 1 0\n
6 HG006 0 0 1 0\n
7 HG007 0 0 2 0\n" > ped_tmp_${VCF}.ped

# do some filtering
bcftools view $VCF -i "QUAL>${MIN_QUAL} && FILTER=\"PASS\"" -o mendel_tmp_$(basename ${VCF}) -Oz
tabix -fp vcf mendel_tmp_$(basename ${VCF})

# run rtg
rtg mendelian -i mendel_tmp_$(basename ${VCF}) -t ${SDF} --pedigree ped_tmp_$(basename ${VCF}).ped > ${VCF::-6}.mendel

rm -f mendel_tmp_$(basename ${VCF}) mendel_tmp_$(basename ${VCF}).tbi

# make a phony heterozygous
bcftools view $VCF -i "QUAL>${MIN_QUAL} && FILTER=\"PASS\""  | sed -e 's#0/0#0/1#g' -e 's#1/1#0/1#g' -e 's#2/2#0/2#g' | bgzip --threads 2 > mendel_het_tmp_$(basename ${VCF})
tabix -fp vcf mendel_het_tmp_$(basename ${VCF})

# run rtg
rtg mendelian -i mendel_het_tmp_$(basename ${VCF}) -t ${SDF} --pedigree ped_tmp_$(basename ${VCF}).ped > ${VCF::-6}.mendel.het

rm -f mendel_het_tmp_$(basename ${VCF}) mendel_het_tmp_$(basename ${VCF}).tbi

rm -f ped_tmp_$(basename ${VCF}).ped


