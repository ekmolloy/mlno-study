#!/bin/bash

# RUN ON VEENA

#. /u/local/Modules/default/init/modules.sh
#module load gcc/4.9.3
#module load gsl
#module load boost/1_58_0
#module load python/3.7.0

export LD_LIBRARY_PATH="$HOME/gsl-2.6-local-install/lib:$LD_LIBRARY_PATH"
GNUTIME="/home/ekmolloy/time-1.9-local-install/bin/time"
TREEMIX="$HOME/treemix-mlno/src/treemix"
NTD1="$HOME/ntd/first/first"

NAMES=( "mallick2016_figS11_1_simplified" \
        "case_study" \
        "haak2015_figS8-1" \
        "lipson2020_fig5a_extended" \
        "lipson2020_fig5a" \
        "patterson2012_fig5" \
        "wu2020_fig7a" \
        "yan2020_fig2"  )

NAME=$1

#for NAME in ${NAMES[@]}; do

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
elif [ $NAME == "mallick2016_figS11_1_simplified" ]; then
    NORDER=1000
    OUTG="Chimp"
    NMIG=2
elif [ $NAME == "patterson2012_fig5" ]; then
    NORDER=120
    OUTG="Out"
    NMIG=1
elif [ $NAME == "wu2020_fig7a" ]; then
    NORDER=1000
    OUTG="YRI"
    NMIG=2
elif [ $NAME == "yan2020_fig2" ]; then
    NORDER=720
    OUTG="Altai"
    NMIG=1
fi

NORDER=100

TRUEG="../model-data-sets/data/ntdgraph_${NAME}.txt"
TRUEM="../model-data-sets/data/ntdmap_${NAME}.txt"
IN="../model-data-sets/data/modelf2mat_${NAME}.txt"
OUTDIR="data/model-data-sets/${NAME}"
mkdir -p $OUTDIR

for ORDER in `seq 1 $NORDER`; do
    echo "Working on order $ORDER..."

    POPADDORDER="data/pop-add-orders/${NAME}_popaddorder_${ORDER}.txt"

    for MTHD in "treemix" "treemix-mlno" "treemix-allmigs" "treemix-allmigs-mlno"; do
        BASE="${MTHD}_${NAME}_${ORDER}"

        # Set-up TreeMix options
        OPTS="-seed 12345 -f2 -givenmat -popaddorder $POPADDORDER -root $OUTG -global -m $NMIG"
        if [ ! -z $(echo $MTHD | grep "mlno") ]; then
            OPTS="$OPTS -mlno"
        fi
        if [ ! -z $(echo $MTHD | grep "allmigs") ]; then
            OPTS="$OPTS -allmigs"
        fi

        # Run TreeMix
        OUT="$OUTDIR/$BASE"
        if [ ! -e $OUT.vertices.gz ] || [ ! -e $OUT.edges.gz ]; then
            $GNUTIME -v $TREEMIX -i $IN -o $OUT $OPTS |& tee $OUT.log
        fi

        # Compute triplet distance
        KEEP="$OUTDIR/keep_${BASE}.csv"
        if [ ! -e $KEEP ]; then
            # Save log-likelihood
            LLIK=$(cat $OUT.llik | awk '{print $7}' | tr '\n' ' ' | sed 's/ /,/g')
            TIME=$(grep "wall clock" $OUT.log | awk '{print $8}')

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
                echo "$NAME,$MTHD,$ORDER,${LLIK}${DIST},$TIME" > $KEEP
                rm $ESTIG
            else
                echo "$NAME,$MTHD,$ORDER,${LLIK}NA,$TIME" > $KEEP
            fi
        fi
    done
done
#done
