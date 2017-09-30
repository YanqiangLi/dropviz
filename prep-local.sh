#!/bin/sh
#
# When developing locally, syncronize a subset of the atlas and staged data from a remote host
# for a subset of the data.

REMOTE=dropviz.dizz.org:/mnt/disks/dropseq
REMOTE_STAGED=${REMOTE}/staged
REMOTE_ATLAS=${REMOTE}/atlas_ica
LOCAL=/cygdrive/d/dropviz
LOCAL_STAGED=${LOCAL}/staged
LOCAL_ATLAS=${LOCAL}/atlas_ica

EXPERIMENTS="GRCm38.81.P60Hippocampus GRCm38.81.P60Striatum"

mkdir -p ${LOCAL_STAGED}/expr
mkdir -p ${LOCAL_STAGED}/metacells
mkdir -p ${LOCAL_STAGED}/tsne
mkdir -p ${LOCAL_ATLAS}

rsync -v ${REMOTE_STAGED}/expr/gene.map.RDS ${LOCAL_STAGED}/expr/
rsync -rav ${REMOTE_STAGED}/markers ${LOCAL_STAGED}/
rsync -v ${REMOTE_STAGED}/tsne/\*.Rdata ${LOCAL_STAGED}/tsne

for exp in ${EXPERIMENTS}; do
    mkdir -p ${LOCAL_STAGED}/expr/${exp}
    rsync -v ${REMOTE_STAGED}/expr/${exp}/genes.RDS ${LOCAL_STAGED}/expr/${exp}/
    rsync -rav ${REMOTE_STAGED}/expr/${exp}/gene ${LOCAL_STAGED}/expr/${exp}/
    rsync -rav ${REMOTE_STAGED}/metacells/${exp}\* ${LOCAL_STAGED}/metacells/
    rsync -rav ${REMOTE_STAGED}/tsne/${exp} ${LOCAL_STAGED}/tsne/

    mkdir -p ${LOCAL_ATLAS}/F_${exp}
    rsync -rav ${REMOTE_ATLAS}/F_${exp}/components ${LOCAL_ATLAS}/F_${exp}/
    rsync -rav ${REMOTE_ATLAS}/F_${exp}/curation_sheets ${LOCAL_ATLAS}/F_${exp}/
    rsync -rav ${REMOTE_ATLAS}/F_${exp}/cluster_sheets ${LOCAL_ATLAS}/F_${exp}/
done

# create exp_sets.txt
cat > exp_sets.txt <<EOF
exp.label	exp.title	exp.abbrev	exp.dir
EOF

(for exp in ${EXPERIMENTS}; do
    short=`echo $exp | sed -e 's/GRCm38.81.P60//'`
    abbrev=`echo $short | cut -c1-3 | tr [:lower:] [:upper:]`
    dir=`cygpath -w ${LOCAL_ATLAS}/F_${exp}`
    echo "${exp}	${short}	${abbrev}	${dir}"
done) >> exp_sets.txt

LOCAL_STAGED_W=`cygpath -w ${LOCAL_STAGED}`
cat >> options.R <<EOF
options(dropviz.prep.dir='${LOCAL_STAGED_W}')
options(dropviz.experiments='exp_sets.txt')
EOF

# generate a globals.RDS that only includes EXPERIMENTS
# This probably needs to be run within RStudio
R -e "source('prep-global.R')"
