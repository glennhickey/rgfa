#!/bin/bash
set -ex

PG_VCF=$1
INPUT_FA=$2

# run pangenie on the 7 giab samples
sbatch --wait pangenie.sh ${PG_VCF} ${INPUT_FA} 1 &
sbatch --wait pangenie.sh ${PG_VCF} ${INPUT_FA} 2 &
sbatch --wait pangenie.sh ${PG_VCF} ${INPUT_FA} 3 &
sbatch --wait pangenie.sh ${PG_VCF} ${INPUT_FA} 4 &
sbatch --wait pangenie.sh ${PG_VCF} ${INPUT_FA} 5 &
sbatch --wait pangenie.sh ${PG_VCF} ${INPUT_FA} 6 &
sbatch --wait pangenie.sh ${PG_VCF} ${INPUT_FA} 7 &

wait

# resolve the genotypes
sbatch --wait resolve-pangenie.sh ${INPUT_VCF} ${PG_VCF::-4}.HG001_genotpying.vcf.gz ${PG_VCF::-4}.HG001_resolved.vcf.gz &
sbatch --wait resolve-pangenie.sh ${INPUT_VCF} ${PG_VCF::-4}.HG002_genotpying.vcf.gz ${PG_VCF::-4}.HG001_resolved.vcf.gz &
sbatch --wait resolve-pangenie.sh ${INPUT_VCF} ${PG_VCF::-4}.HG003_genotpying.vcf.gz ${PG_VCF::-4}.HG001_resolved.vcf.gz &
sbatch --wait resolve-pangenie.sh ${INPUT_VCF} ${PG_VCF::-4}.HG004_genotpying.vcf.gz ${PG_VCF::-4}.HG001_resolved.vcf.gz &
sbatch --wait resolve-pangenie.sh ${INPUT_VCF} ${PG_VCF::-4}.HG005_genotpying.vcf.gz ${PG_VCF::-4}.HG001_resolved.vcf.gz &
sbatch --wait resolve-pangenie.sh ${INPUT_VCF} ${PG_VCF::-4}.HG006_genotpying.vcf.gz ${PG_VCF::-4}.HG001_resolved.vcf.gz &
sbatch --wait resolve-pangenie.sh ${INPUT_VCF} ${PG_VCF::-4}.HG007_genotpying.vcf.gz ${PG_VCF::-4}.HG001_resolved.vcf.gz &

wait
