#!/bin/bash
set -ex

# compute rgfa cover

# input GFA.gz file
INPUT_GFA=$1

# output GBZ file (will include cover as ref path fragments)
OUTPUT_GBZ=$2

# min interval size
MIN_INTERVAL=$3

# ref prefix
REF_PREFIX=$4

MAX_THREADS=32

VG_RGFA=~/dev/vg.rgfa/bin/vg
# there is a bug (feature?) in master that randomly converts W-lines to P-lines that
# seems to throw everything off.  So stick to a release for conversion
VG=/private/groups/cgl/cactus/cactus-bin-v2.8.1/bin/vg
#VG=~/dev/vg/bin/vg

# the above bug also prevents vg.rgfa from reading GFA, hence the extra convert step at beginning
zcat ${INPUT_GFA} | sed -e "s/${REF_PREFIX}#chr/${REF_PREFIX}#0#chr/g" | ${VG} convert - | ${VG_RGFA} paths -x - -f ${MIN_INTERVAL} -Q ${REF_PREFIX} -t ${MAX_THREADS} | ${VG} convert -f - > ${OUTPUT_GBZ}.gfa 
${VG} gbwt -G ${OUTPUT_GBZ}.gfa --gbz-format -g ${OUTPUT_GBZ}
rm -f  ${OUTPUT_GBZ}.gfa
