#!/bin/bash

set -e

cd data

# NOTE: Maximum number of SNPs per locus is less than 6500

if [ ${SGE_TASK_ID} -eq 1 ]; then
    NAME="case_study"
    POPS=( "popA" "popB" "popC" "popD" "popE" )
elif [ ${SGE_TASK_ID} -eq 2 ]; then
    NAME="lipson2020_fig5a"
    POPS=( "BakaDG" "FrenchDG" "HanDG" "MixeDG" "UlchiDG" )
elif [ ${SGE_TASK_ID} -eq 3 ]; then
    NAME="lipson2020_fig5a_extended"
    POPS=( "BakaDG" "FrenchDG" "HanDG" "MixeDG1" "UlchiDG" "MixeDG2" )
elif [ ${SGE_TASK_ID} -eq 4 ]; then
    NAME="haak2015_figS8-1"
    POPS=( "Karitiana" "LBK_EN" "Loschbour" "MA1" "Mbuti" "Onge" )
fi

IN="ms_output_${NAME}.txt.gz"
OUT="afreq_${NAME}.txt"
if [ ! -e $OUT ]; then
    python ../tools/ms_to_treemix.py \
        -s 6500 \
        -i $IN \
        -p ${POPS[@]} \
        -o $OUT
fi
