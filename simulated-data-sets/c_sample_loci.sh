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
    IN="afreq_${NAME}.txt"
    for NL in ${NLOCI[@]}; do
	   OUT="afreq_${NAME}_${NL}.txt"
       head -n1 $IN | cut -d " " -f 3- > $OUT
	   awk -v NLOCI="$NL" '{if ($1<NLOCI) print $0}' $IN | cut -d " " -f 3- >> $OUT
	   gzip $OUT
    done
    gzip $IN
done
