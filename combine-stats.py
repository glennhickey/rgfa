#!/bin/python3

import os, sys, collections, math

input_files = sys.argv[1:]

print('\t'.join(['Caller', 'Subset', 'MIN-QUAL', 'Sample', 'SNPs', 'TSTV']))

records = collections.defaultdict(list)

for f in input_files:
    # use some naming conventions to parse fields for our table
    # hprc-v1.1-mc-grch38-rgfa-oct3.pangenie.HG007_genotyping.resolved.snp-only.onref.stats.0.tsv
    fn = os.path.basename(f)
    if 'pangenie' in fn:
        caller = 'PanGenie'
    elif 'deep' in fn or 'dv' in fn:
        caller = 'DV-{}'.format('rgfa' if 'rgfa.dv' in fn else 'linear')
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

    key = (caller, subset, qual)
    val = (sample, tstv, snps)
    records[key].append(val)

def mean(l):
    return round(sum([float(x) for x in l]) / len(l), 2)

def stdev(l):
    m = mean(l)
    var = sum([(float(x) -m)**2 for x in l]) / len(l)
    return round(math.sqrt(var), 2)
    
# add in our averages
for key, val in list(records.items()):
    avg_val = ('Mean', mean([v[1] for v in val]), mean([v[2] for v in val]))
    sd = ('Stdev', stdev([v[1] for v in val]), stdev([v[2] for v in val]))
    records[key] += [avg_val, sd]

# dump to tsv
for key, val in records.items():
    for v in val:
        line_toks = list(key) + list(v)
        print ('\t'.join([str(x) for x in line_toks]))
    
    
        
    
        
