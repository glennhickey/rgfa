#!/bin/bash
# Job name:
#SBATCH --job-name=deconstruct_parallel
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
#SBATCH --mem=968gb
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
#SBATCH --output=serial_test_%j.log
#
# Wall clock limit in hrs:min:sec:
#SBATCH --time=16:00:00
#
## Command(s) to run (example):

L=1

for arg ; do echo "${arg} ${arg::-3}.vcf.gz" ; done | parallel -j 32 "vg deconstruct {1}  -n -P GRCh38 | bgzip > {2} ; tabix -fp {2}"
#note the sed bit applies only to v1.1 hprc graphs, which dont have reference haplotypes (something since changed in cactus)
bcftools concat -a *.vcf.gz | sed -e 's/GRCh38/GRCh38#0/g' -e 's/CHM13/CHM13#0/g' | bgzip > out.L${L}.vcf.gz
tabix -fp vcf out.L${L}.vcf.gz


