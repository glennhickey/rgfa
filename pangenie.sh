#!/bin/bash
# Job name:
#SBATCH --job-name=pangenie
#
# Partition - This is the queue it goes in:
#SBATCH --partition=long
#
# Where to send email (optional)
#SBATCH --mail-user=glenn.hickey@gmail.com
#
# Number of nodes you need per job:
#SBATCH --nodes=1
#
# Memory needed for the jobs.  Try very hard to make this accurate.  DEFAULT = 4gb
#SBATCH --mem=256gb
#
# Number of tasks (one for each CPU desired for use case) (example):
#SBATCH --ntasks=1
#
# Processors per task:
# At least eight times the number of GPUs needed for nVidia RTX A5500
#SBATCH --cpus-per-task=96
#
# Number of GPUs, this can be in the format of "--gres=gpu:[1-8]", or "--gres=gpu:A5500:[1-8]" with the type included (optional)
#
# Standard output and error log
#SBATCH --output=pangenie_%j.log
#
# Wall clock limit in hrs:min:sec:
#SBATCH --time=48:00:00
#
## Command(s) to run (example):

set -ex

PG_VCF=${1}
FA=${2}
SAMPLE=${3}

PANGENIE=~/dev/pangenie/build/src/PanGenie

R1=~/dev/work/giab-reads/HG00${SAMPLE}.novaseq.pcr-free.30x.R1.fastq.gz
R1=~/dev/work/giab-reads/HG00${SAMPLE}.novaseq.pcr-free.30x.R2.fastq.gz

mkdir -p /data/tmp/glenn
FQ=/data/tmp/glenn/HG00${SAMPLE}.novaseq.pcr-free.30x.fastq

gzip -dc ${R1} > ${FQ}
gzip -dc ${R2} >> ${FQ}

${PANGENIE} -i ${FQ} -r ${FA} -v ${PG_VCF} -j 96 -t 96 -o /data/tmp/glenn/${PG_VCF::-4}.pg.HG00${SAMPLE} -s HG00${SAMPLE}
bgzip -c /data/tmp/glenn/${PG_VCF::-4}.pg.HG00${SAMPLE} > ${PG_VCF::-4}.pg.HG00${SAMPLE}_genotpying.vcf 
tabix -fp vcf ${PG_VCF::-4}.pg.HG00${SAMPLE}_genotpying.vcf.gz

rm -f $FQ /data/tmp/glenn/${PG_VCF::-4}.pg.HG00${SAMPLE}*
