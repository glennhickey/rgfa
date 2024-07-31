#!/bin/bash
# Job name:
#SBATCH --job-name=resolve-pangenie
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
#SBATCH --cpus-per-task=32
#
# Number of GPUs, this can be in the format of "--gres=gpu:[1-8]", or "--gres=gpu:A5500:[1-8]" with the type included (optional)
#
# Standard output and error log
#SBATCH --output=pangenie_%j.log
#
# Wall clock limit in hrs:min:sec:
#SBATCH --time=16:00:00
#
## Command(s) to run (example):

set -ex

DECON_VCF=${1}
PG_VCF=${2}
RESOLVED_VCF=${3}

resolve-nested-genotypes ${DECON_VCF} ${PG_VCF} | bgzip > ${RESOLVED_VCF}
tabix -pf vcf ${RESOLVED_VCF}
