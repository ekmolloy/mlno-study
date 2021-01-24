#!/bin/bash


if [ ! -e simulated-parameters.txt ]; then
    NAMES=( "case_study" \
            "haak2015_figS8-1" \
            "lipson2020_fig5a" \
            "lipson2020_fig5a_extended" )

    NLOCI=( "10" "50" "100" \
            "500" "1000" "1500" \
            "2000" "2500" "3000" )

    for TYPE in "cov" "f2"; do
        for NAME in ${NAMES[@]}; do
            for LOCI in ${NLOCI[@]}; do
                echo "$TYPE $NAME $LOCI" >> simulated-parameters.txt
            done
        done
    done
fi
