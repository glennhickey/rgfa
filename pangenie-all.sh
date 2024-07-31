#!/bin/bash
set -ex

INPUT_GBZ=$1
INPUT_VCF=$2
OUT_NAME=$3


# do the pangenie preprocessing on the VCF
PG_VCF=${INPUT_VCF::-7}_pg.vcf
pangenie-prefilter.sh $INPUT_VCF ${PG_VCF} CHM13

# run pangenie on the 7 giab samples
sbatch pangenie.sh ${PG_VCF} 1
sbatch pangenie.sh ${PG_VCF} 2
sbatch pangenie.sh ${PG_VCF} 3
sbatch pangenie.sh ${PG_VCF} 4
sbatch pangenie.sh ${PG_VCF} 5
sbatch pangenie.sh ${PG_VCF} 6
sbatch pangenie.sh ${PG_VCF} 7

# resolve the genotypes
sbatch resolve-pangenie.sh ${INPUT_VCF} ${PG_VCF::-4}.pg.HG001_genotpying.vcf.gz ${PG_VCF::-4}.pg.HG001_resolved.vcf.gz
sbatch resolve-pangenie.sh ${INPUT_VCF} ${PG_VCF::-4}.pg.HG002_genotpying.vcf.gz ${PG_VCF::-4}.pg.HG001_resolved.vcf.gz
sbatch resolve-pangenie.sh ${INPUT_VCF} ${PG_VCF::-4}.pg.HG003_genotpying.vcf.gz ${PG_VCF::-4}.pg.HG001_resolved.vcf.gz
sbatch resolve-pangenie.sh ${INPUT_VCF} ${PG_VCF::-4}.pg.HG004_genotpying.vcf.gz ${PG_VCF::-4}.pg.HG001_resolved.vcf.gz
sbatch resolve-pangenie.sh ${INPUT_VCF} ${PG_VCF::-4}.pg.HG005_genotpying.vcf.gz ${PG_VCF::-4}.pg.HG001_resolved.vcf.gz
sbatch resolve-pangenie.sh ${INPUT_VCF} ${PG_VCF::-4}.pg.HG006_genotpying.vcf.gz ${PG_VCF::-4}.pg.HG001_resolved.vcf.gz
sbatch resolve-pangenie.sh ${INPUT_VCF} ${PG_VCF::-4}.pg.HG007_genotpying.vcf.gz ${PG_VCF::-4}.pg.HG001_resolved.vcf.gz
