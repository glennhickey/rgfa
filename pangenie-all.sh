#!/bin/bash
set -ex

INPUT_VCF=$1

# do the pangenie preprocessing on the VCF
PG_VCF=${INPUT_VCF::-7}_pg.vcf

# run pangenie on the 7 giab samples
sbatch --wait pangenie.sh ${PG_VCF} 1 &
sbatch --wait pangenie.sh ${PG_VCF} 2 &
sbatch --wait pangenie.sh ${PG_VCF} 3 &
sbatch --wait pangenie.sh ${PG_VCF} 4 &
sbatch --wait pangenie.sh ${PG_VCF} 5 &
sbatch --wait pangenie.sh ${PG_VCF} 6 &
sbatch --wait pangenie.sh ${PG_VCF} 7 &

wait

# resolve the genotypes
sbatch --wait resolve-pangenie.sh ${INPUT_VCF} ${PG_VCF::-4}.pg.HG001_genotpying.vcf.gz ${PG_VCF::-4}.pg.HG001_resolved.vcf.gz &
sbatch --wait resolve-pangenie.sh ${INPUT_VCF} ${PG_VCF::-4}.pg.HG002_genotpying.vcf.gz ${PG_VCF::-4}.pg.HG001_resolved.vcf.gz &
sbatch --wait resolve-pangenie.sh ${INPUT_VCF} ${PG_VCF::-4}.pg.HG003_genotpying.vcf.gz ${PG_VCF::-4}.pg.HG001_resolved.vcf.gz &
sbatch --wait resolve-pangenie.sh ${INPUT_VCF} ${PG_VCF::-4}.pg.HG004_genotpying.vcf.gz ${PG_VCF::-4}.pg.HG001_resolved.vcf.gz &
sbatch --wait resolve-pangenie.sh ${INPUT_VCF} ${PG_VCF::-4}.pg.HG005_genotpying.vcf.gz ${PG_VCF::-4}.pg.HG001_resolved.vcf.gz &
sbatch --wait resolve-pangenie.sh ${INPUT_VCF} ${PG_VCF::-4}.pg.HG006_genotpying.vcf.gz ${PG_VCF::-4}.pg.HG001_resolved.vcf.gz &
sbatch --wait resolve-pangenie.sh ${INPUT_VCF} ${PG_VCF::-4}.pg.HG007_genotpying.vcf.gz ${PG_VCF::-4}.pg.HG001_resolved.vcf.gz &

wait
