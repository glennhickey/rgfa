# rgfa
keep track of some scripts used to evaluate rgfa stuff

## giraffe mapping

v1.47.0-118-gf26bf2db3

```
for i in 1 2 3 4 5 6 7 ; do kmc -k29 -m128 -okff -t111 @/private/home/hickey/dev/work/giab-reads/HG00${i}.novaseq.pcr-free.30x.paths /private/home/hickey/dev/work/giab-reads/HG00${i}.novaseq.pcr-free.30x $TMPDIR ; done
```

```
for i in 1 2 3 4 5 6 7 ; do vg giraffe -Z ../hprc-v1.1-mc-grch38-rgfa-oct3.gbz --haplotype-name ../hprc-v1.1-mc-grch38-rgfa-oct3.hapl -f ~/dev/work/giab-reads/HG00${i}.novaseq.pcr-free.30x.R1.fastq.gz -f ~/dev/work/giab-reads/HG00${i}.novaseq.pcr-free.30x.R2.fastq.gz -N HG00${i} -o gaf -p --kff-name ~/dev/work/giab-reads/HG00${i}.novaseq.pcr-free.30x.kff 2> hprc-v1.1-mc-grch38-rgfa-oct3.HG00${i}.hapl.gaf.gz.log | bgzip > hprc-v1.1-mc-grch38-rgfa-oct3.HG00${i}.hapl.gaf.gz ; done
```

## deepvariant

### rGFA calls

These calls include both rGFA and GRCh38

```
for i in 1 2 3 4 5 6 7 ; do vg surject -x ../hprc-v1.1-mc-grch38-rgfa-oct3.rgfa.gbz hprc-v1.1-mc-grch38-rgfa-oct3.HG00${i}.hapl.gaf.gz -n GRCh38 -n _rGFA_ -i -G -b > hprc-v1.1-mc-grch38-rgfa-oct3.HG00${i}.hapl.rgfa.bam ; done
```

(todo: use graph model)

```
for i in 1 2 3 4 5 6 7 ; do docker run   -v "$(pwd):/input"   -v "$(pwd)/calling:/output"  --user $UID:$GID google/deepvariant:"${BIN_VERSION}"   /opt/deepvariant/bin/run_deepvariant   --model_type=WGS   --ref=/input/hprc-v1.1-mc-grch38-rgfa-oct3.rgfa.fa.gz   --reads=/input/mapping/hprc-v1.1-mc-grch38-rgfa-oct3.HG00${i}.hapl.rgfa.sort.bam   --output_vcf=/output/hprc-v1.1-mc-grch38-rgfa-oct3.HG00${i}.hapl.rgfa.dv.vcf.gz   --num_shards=99     --dry_run=false ; done
```

```
for i in 1 2 3 4 5 6 7 ; do zcat hprc-v1.1-mc-grch38-rgfa-oct3.HG00${i}.hapl.grch38-only.dv.vcf.gz | sed -e "s/FORMAT\tdefault/FORMAT\tHG00${i}/g" | bgzip --threads 2 > hprc-v1.1-mc-grch38-rgfa-oct3.HG00${i}.hapl.grch38-only.dv.fix.vcf.gz ; tabix -fp vcf hprc-v1.1-mc-grch38-rgfa-oct3.HG00${i}.hapl.grch38-only.dv.fix.vcf.gz; done
```

```
bcftools merge hprc-v1.1-mc-grch38-rgfa-oct3.HG00*.hapl.rgfa.dv.fix.vcf.gz -Oz | bcftools +fill-tags | bgzip >  hprc-v1.1-mc-grch38-rgfa-oct3.HG001-7.hapl.rgfa.dv.vcf.gz ; tabix -fp vcf hprc-v1.1-mc-grch38-rgfa-oct3.HG001-7.hapl.rgfa.dv.vcf.gz
```


### linear-only calls

These calls are as above, but do not include rGFA

```
for i in 1 2 3 4 5 6 7 ; do vg surject -x ../hprc-v1.1-mc-grch38-rgfa-oct3.rgfa.gbz hprc-v1.1-mc-grch38-rgfa-oct3.HG00${i}.hapl.gaf.gz -n GRCh38 -i -G -b > hprc-v1.1-mc-grch38-rgfa-oct3.HG00${i}.hapl.grch38-only.bam ; done
```

(todo: just use bwa-mem deepvariant and/or best-practices deepvariant)

```
for i in 1 2 3 4 5 6 7 ; do docker run   -v "$(pwd):/input"   -v "$(pwd)/calling:/output"  --user $UID:$GID google/deepvariant:"${BIN_VERSION}"   /opt/deepvariant/bin/run_deepvariant   --model_type=WGS   --ref=/input/hprc-v1.1-mc-grch38-rgfa-oct3.rgfa.fa.gz   --reads=/input/mapping/hprc-v1.1-mc-grch38-rgfa-oct3.HG00${i}.hapl.grch38-only.sort.bam   --output_vcf=/output/hprc-v1.1-mc-grch38-rgfa-oct3.HG00${i}.hapl.grch38-only.dv.vcf.gz   --num_shards=80     --dry_run=false ; done
```

```
for i in 1 2 3 4 5 6 7 ; do zcat hprc-v1.1-mc-grch38-rgfa-oct3.HG00${i}.hapl.grch38-only.dv.vcf.gz | sed -e "s/FORMAT\tdefault/FORMAT\tHG00${i}/g" | bgzip --threads 2 > hprc-v1.1-mc-grch38-rgfa-oct3.HG00${i}.hapl.grch38-only.dv.fix.vcf.gz ; tabix -fp vcf hprc-v1.1-mc-grch38-rgfa-oct3.HG00${i}.hapl.grch38-only.dv.fix.vcf.gz; done
```

```
bcftools merge hprc-v1.1-mc-grch38-rgfa-oct3.HG00*.hapl.grch38-only.dv.fix.vcf.gz | bcftools +fill-tags | bgzip > hprc-v1.1-mc-grch38-rgfa-oct3.HG001-7.hapl.grch38-only.dv.vcf.gz ; tabix -fp vcf hprc-v1.1-mc-grch38-rgfa-oct3.HG001-7.hapl.grch38-only.dv.vcf.gz
```

## vg call

vg f29425d01e546c5025eca6c74f50f4f68dc19990

```
for i in 1 2 3 4 5 6 7; do ../calling/vg pack -x ../hprc-v1.1-mc-grch38-rgfa-oct3.rgfa.gbz -a hprc-v1.1-mc-grch38-rgfa-oct3.HG00${i}.hapl.gaf.gz -o hprc-v1.1-mc-grch38-rgfa-oct3.HG00${i}.hapl.pack -Q 5 ; done
```

```
for i in 1 2 3 4 5 6 7 ; do ./vg.call call ../hprc-v1.1-mc-grch38-rgfa-oct3.rgfa.gbz -r ../hprc-v1.1-mc-grch38-rgfa-oct3.snarls -k ../mapping/hprc-v1.1-mc-grch38-rgfa-oct3.HG00${i}.hapl.pack -s HG00${i} -S GRCh38 -S _rGFA_ -zAa | bgzip > hprc-v1.1-mc-grch38-rgfa-oct3.HG00${i}.hapl.rgfa.call.vcf.gz ; tabix -fp vcf hprc-v1.1-mc-grch38-rgfa-oct3.HG00${i}.hapl.rgfa.call.vcf.gz ; done
```

```
bcftools merge hprc-v1.1-mc-grch38-rgfa-oct3.HG00*.hapl.rgfa.call.vcf.gz | bcftools +fill-tags | bgzip > hprc-v1.1-mc-grch38-rgfa-oct3.HG001-7.hapl.rgfa.call.vcf.gz ; tabix -fp vcf hprc-v1.1-mc-grch38-rgfa-oct3.HG001-7.hapl.rgfa.call.vcf.gz

## pangenie

todo: need to use official filters and scripts etc.

PanGenie 916079f57fe474c47e50de4e7a87538770c66b58

bcftools view ../hprc-v1.1-mc-grch38-rgfa-oct3.vcf.gz -i "AN>60" > ../hprc-v1.1-mc-grch38-rgfa-oct3.vcf

```
for i in 1 2 3 4 5 6 7 ; do gzip -dc ~/dev/work/giab-reads/HG00${i}.novaseq.pcr-free.30x.R1.fastq.gz > HG00${i}.novaseq.pcr-free.30x.fastq ; gzip -dc ~/dev/work/giab-reads/HG00${i}.novaseq.pcr-free.30x.R2.fastq.gz >> HG00${i}.novaseq.pcr-free.30x.fastq ;  ~/dev/pangenie/build/src/PanGenie -i HG00${i}.novaseq.pcr-free.30x.fastq -r ../hg38.fa -v ../hprc-v1.1-mc-grch38-rgfa-oct3.vcf -j 64 -o hprc-v1.1-mc-grch38-rgfa-oct3.pangenie.HG00${i} -s HG00${i} -t 64  ; rm -f HG00${i}.novaseq.pcr-free.30x.fastq ; done
```

note: we need to add back the GRCh38#0# prefixes here to match it up with the .rgfa deconstruct VCF which has them
```
for i in 1 2 3 4 5 6 7 ; do sed -e 's/chr/GRCh38#0#chr/g' hprc-v1.1-mc-grch38-rgfa-oct3.pangenie.HG00${i}_genotyping.vcf | bgzip --threads 8 >  hprc-v1.1-mc-grch38-rgfa-oct3.pangenie.HG00${i}_genotyping.vcf.gz ; tabix -fp vcf hprc-v1.1-mc-grch38-rgfa-oct3.pangenie.HG00${i}_genotyping.vcf.gz ; done
```

Now resolve the genotypes
```
for i in 1 2 3 4 5 6 7; do resolve-nested-genotypes ../hprc-v1.1-mc-grch38-rgfa-oct3.rgfa.vcf.gz hprc-v1.1-mc-grch38-rgfa-oct3.pangenie.HG00${i}_genotyping.vcf.gz | bgzip > hprc-v1.1-mc-grch38-rgfa-oct3.pangenie.HG00${i}_genotyping.resolved.vcf.gz ; tabix -fp vcf  hprc-v1.1-mc-grch38-rgfa-oct3.pangenie.HG00${i}_genotyping.resolved.vcf.gz ; done
```

# Analysis

`rGFA` regions were extracted using debug flags, since there's no easy way to get them out of vg yet (todo).  They live in `rgfa.bed`.  In the below, `rgfa_pad50.bed` is used

```
cat ../rgfa.bed | awk '{print $1 "\t" $2-50 "\t" $2+50}' > ../rgfa_pad50.bed
```

## DeepVariant graphs

```
bcftools view hprc-v1.1-mc-grch38-rgfa-oct3.HG001-7.hapl.grch38-only.dv.vcf.gz -R ../rgfa_pad50.bed -Oz > hprc-v1.1-mc-grch38-rgfa-oct3.HG001-7.hapl.grch38-only-rgfa-pad50.dv.vcf.gz
tabix -fp vcf hprc-v1.1-mc-grch38-rgfa-oct3.HG001-7.hapl.grch38-only-rgfa-pad50.dv.vcf.gz
```


These are the VCFs we want to analyze

- GRCh38-only DeepVariant global
- GRCh38-only DeepVarant subset to rGFA regions
- rGFA DeepVariant on rGFA regions
- rGFA DeepVariant on subset rGFA regions
- vg call snps in rGFA regions. this will need careful use of vcfbub on sample-by-sample
- pangenie snps in rGFA regions. ditto vcfbub
- vcfwave could be very useful to isolate snps
- vg call snps / svs on whole genome / grch38
- pangenie snps / svs on whole genome / grch38


### First idea

Just do 1-base SNPs.  This gets rid of the nesting issue by default.  Let's us measure TSTV and drives the mendelian.  




To do vcfbub, we want: 



We want an rGFA / GRCh38 / GRCh38-in-rGFA regions version of each VCF
- DeepVarant X 2
- Call
- PanGenie

For each, we want mendel and vcf stats

To get calls for Call and PanGenie, we need to flatten them.  This means, for each 


TODO:

- use * instead of . for second allele of nested haplo calls.