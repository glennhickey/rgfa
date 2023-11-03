#!/bin/python3

import os, sys

input_files = sys.argv[1:]

print('\t'.join(['Caller', 'Subset', 'MIN-QUAL', 'Sample', 'SNPs', 'TSTV']))

for f in input_files:
    # use some naming conventions to parse fields for our table
    # hprc-v1.1-mc-grch38-rgfa-oct3.pangenie.HG007_genotyping.resolved.snp-only.onref.stats.0.tsv
    fn = os.path.basename(f)
    if 'pangenie' in fn:
        caller = 'PanGenie'
    elif 'deep' in fn or 'dv' in fn:
        caller = 'DeepVariant'
    else:
        caller = 'vg-call'

    toks = fn.replace('_genotyping','').split('.')
    try:
        subset = toks[toks.index('stats')-1]
    except:
        subset = 'N/A'

    try:
        qual = int(toks[toks.index('stats')+1])
    except:
        qual = 0

    sample='N/A'
    for tok in toks:
        if tok.startswith('HG') and tok[2:].isnumeric():
            sample = tok
            break

    stats = {}
    with open(f, 'r') as stat_file:
        for line in stat_file:
            toks = line.strip().split()
            if len(toks) == 2:
                stats[toks[0]] = toks[1]

    tstv = stats['TSTV']
    snps = stats['SNPs']

    out_line = '\t'.join(str(x) for x in [caller, subset, qual, sample, tstv, snps])

    print(out_line)
            
        
    
        
