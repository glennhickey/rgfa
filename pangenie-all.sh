#!/bin/bash
set -ex

INPUT_VCF=$1
PG_VCF=$2
INPUT_FA=$3

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
sbatch --wait resolve-pangenie.sh ${INPUT_VCF} ${PG_VCF::-4}.pg.HG001_genotyping.vcf.gz ${PG_VCF::-4}.pg.HG001_resolved.vcf.gz &
sbatch --wait resolve-pangenie.sh ${INPUT_VCF} ${PG_VCF::-4}.pg.HG002_genotyping.vcf.gz ${PG_VCF::-4}.pg.HG002_resolved.vcf.gz &
sbatch --wait resolve-pangenie.sh ${INPUT_VCF} ${PG_VCF::-4}.pg.HG003_genotyping.vcf.gz ${PG_VCF::-4}.pg.HG003_resolved.vcf.gz &
sbatch --wait resolve-pangenie.sh ${INPUT_VCF} ${PG_VCF::-4}.pg.HG004_genotyping.vcf.gz ${PG_VCF::-4}.pg.HG004_resolved.vcf.gz &
sbatch --wait resolve-pangenie.sh ${INPUT_VCF} ${PG_VCF::-4}.pg.HG005_genotyping.vcf.gz ${PG_VCF::-4}.pg.HG005_resolved.vcf.gz &
sbatch --wait resolve-pangenie.sh ${INPUT_VCF} ${PG_VCF::-4}.pg.HG006_genotyping.vcf.gz ${PG_VCF::-4}.pg.HG006_resolved.vcf.gz &
sbatch --wait resolve-pangenie.sh ${INPUT_VCF} ${PG_VCF::-4}.pg.HG007_genotyping.vcf.gz ${PG_VCF::-4}.pg.HG007_resolved.vcf.gz &

wait
