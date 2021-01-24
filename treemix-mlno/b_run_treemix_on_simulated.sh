#!/bin/bash

. /u/local/Modules/default/init/modules.sh
module load gcc/4.9.3
module load gsl
module load boost/1_58_0
module load python/3.7.0

TREEMIX="/u/home/s/sriram/group/ekmolloy/mlno-study/external/treemix-mlno/src/treemix"
NTD1="/u/home/s/sriram/group/ekmolloy/mlno-study/external/ntd/first/first"
NTD2="/u/home/s/sriram/group/ekmolloy/mlno-study/external/ntd/second/second"

#SGE_TASK_ID=$1

PARAMS=( $(head -n${SGE_TASK_ID} simulated-parameters.txt | tail -n1) )

TYPE=${PARAMS[0]}
NAME=${PARAMS[1]}
LOCI=${PARAMS[2]}

if [ $NAME == "case_study" ]; then
    NORDER=120
    OUTG="popE"
    NMIG=1
elif [ $NAME == "haak2015_figS8-1" ]; then
    NORDER=720
    OUTG="Mbuti"
    NMIG=2
elif [ $NAME == "lipson2020_fig5a" ]; then
    NORDER=120
    OUTG="BakaDG"
    NMIG=1
elif [ $NAME == "lipson2020_fig5a_extended" ]; then
    NORDER=720
    OUTG="BakaDG"
    NMIG=1
fi

TRUEG="../model-data-sets/data/ntdgraph_${NAME}.txt"
TRUEM="../model-data-sets/data/ntdmap_${NAME}.txt"
INDIR="../simulated-data-sets/data"
OUTDIR="data/simulated-data-sets/${TYPE}_${NAME}_${LOCI}"
mkdir -p $OUTDIR

for ORDER in `seq 1 $NORDER`; do
    echo "Working on order $ORDER..."

    IN="$INDIR/${TYPE}mat_${NAME}_${LOCI}.txt"
    SE="$INDIR/${TYPE}semat_${NAME}_${LOCI}.txt"
    POPADDORDER="data/pop-add-orders/${NAME}_popaddorder_${ORDER}.txt"

    for MTHD in "treemix" "treemix-mlno"; do
        BASE="${MTHD}_${TYPE}_${NAME}_${LOCI}_${ORDER}"

        # Run TreeMix
        OPTS="-seed 12345 -global -root $OUTG -m $NMIG"
        if [ $TYPE == "f2" ]; then
            OPTS="-f2 $OPTS"
        fi
        if [ $MTHD == "treemix-mlno" ]; then
            OPTS="$OPTS -mlno"
        fi
        OUT="$OUTDIR/$BASE"
        if [ ! -e $OUT.vertices.gz ] || [ ! -e $OUT.edges.gz ]; then
            $TREEMIX -i $IN \
                     -popaddorder $POPADDORDER \
                     -givenmat $SE \
                     -o $OUT \
                     $OPTS > $OUT.log
	    rm ${OUT}.cov.gz
	    rm ${OUT}.covse.gz 
        fi

        # Compute triplet distance
        KEEP="$OUTDIR/keep_${BASE}.csv"
        if [ ! -e $KEEP ]; then
            # Save log-likelihood
            LLIK=$(cat $OUT.llik | awk '{print $7}' | tr '\n' ' ' | sed 's/ /,/g')

            # Convert graph into the correct format for ntd
            ESTIG="$OUTDIR/ntdgraph_${BASE}.txt"
            python tools/treemix_to_ntd.py \
                    -v $OUT.vertices.gz \
                    -e $OUT.edges.gz \
                    -m $TRUEM \
                    -o $ESTIG

            # Run ntd
            if [ -e $TRUEG ] && [ -e $ESTIG ]; then
                DIST=$($NTD1 $TRUEG $ESTIG | awk '{print $1}')
                echo "$TYPE,$NAME,$LOCI,$MTHD,$ORDER,${LLIK}${DIST}" > $KEEP
                rm $ESTIG
            else
                echo "$TYPE,$NAME,$LOCI,$MTHD,$ORDER,${LLIK}NA" > $KEEP
            fi
        fi
    done
done

sleep 5m
