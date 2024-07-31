First, do the deconsruction on each chrommosome from the hprc v1.1 grch38 graph. the .vg files are softlinked into the current directory

```
sbatch ~/dev/rgfa/parallel-deconstruct.sh chr*.vg
```

Then, do the pangenie preparation.  This means filtering the VCF and making a corresponding FASTA file

```
~/dev/rgfa/pangenie-prefilter.sh hprc-v1.1-mc-grch38.L1.vcf.gz hprc-v1.1-mc-grch38.L1.pg.vcf CHM13#0

~/dev/rgfa/extract-ref-fasta.sh ~/dev/work/hprc-v1.1-jul4/hprc-v1.1-mc-grch38/hprc-v1.1-mc-grch38.full.gbz hprc-v1.1-mc-grch38.L1.pg.vcf hprc-v1.1-mc-grch38.L1.pg.ref.fa
```

Then, do the pangenie genotyping

```
sbatch pangenie-all.sh  ~/dev/work/hprc-v1.1hprc-v1.1-mc-grch38.L1.pg.vcf
```

