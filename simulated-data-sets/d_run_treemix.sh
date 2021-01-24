#!/bin/bash

set -e

cd data

NAMES=( "case_study" \
        "lipson2020_fig5a" \
        "lipson2020_fig5a_extended" \
        "haak2015_figS8-1" )

NLOCI=( "10" \
        "50" \
        "100" \
        "500" \
        "1000" \
        "1500" \
        "2000" \
        "2500" \
        "3000" )

for NAME in ${NAMES[@]}; do
    if [ $NAME == "case_study" ]; then
        BSIZE=6000
    elif [ $NAME == "lipson2020_fig5a" ]; then
        BSIZE=3000
    elif [ $NAME == "lipson2020_fig5a_extended" ]; then
        BSIZE=3500
    elif [ $NAME == "haak2015_figS8-1" ]; then
        BSIZE=4000
    fi

    for NL in ${NLOCI[@]}; do
        IN="afreq_${NAME}_${NL}.txt.gz"

        OUT="treemix_cov_${NAME}_${NL}"
        if [ ! -e covmat_${NAME}_${NL}.txt ]; then
            treemix -i $IN \
                    -k ${BSIZE} \
                    -o $OUT \
                    -seed 12345

            gunzip $OUT.cov.gz
            gunzip $OUT.covse.gz

            mv $OUT.cov covmat_${NAME}_${NL}.txt
            mv $OUT.covse covsemat_${NAME}_${NL}.txt

            rm $OUT.*
        fi

        OUT="treemix_f2_${NAME}_${NL}"
        if [ ! -e f2mat_${NAME}_${NL}.txt ]; then
            treemix -i $IN \
                    -f2 \
                    -k ${BSIZE} \
                    -o $OUT \
                    -seed 12345

            gunzip $OUT.cov.gz
            gunzip $OUT.covse.gz

            mv $OUT.cov f2mat_${NAME}_${NL}.txt
            mv $OUT.covse f2semat_${NAME}_${NL}.txt

            rm $OUT.*
        fi
	done
done
