#!/bin/bash

set -e

exit

cd data/pop-add-orders

NAMES=( "case_study" \
        "patterson2012_fig5" \
        "haak2015_figS8-1" \
        "mallick2016_figS11_1_simplified" \
        "lipson2020_fig5a" \
        "lipson2020_fig5a_extended" \
        "wu2020_fig7a" \
        "yan2020_fig2" )

for NAME in ${NAMES[@]}; do
    if [ $NAME == "case_study" ]; then
        POPS=( "popA" "popB" "popC" "popD" "popE" )
    elif [ $NAME == "patterson2012_fig5" ]; then
        POPS=( "Out" "A" "B" "C" "X" )
    elif [ $NAME == "haak2015_figS8-1" ]; then
        POPS=( "Karitiana" "LBK_EN" "Loschbour" "MA1" "Mbuti" "Onge" )
    elif [ $NAME == "mallick2016_figS11_1_simplified" ]; then
        POPS=("Altai" "Ami" "Australian" "Chimp" "Dai" \
              "Denisovan" "Dinka" "Kostenki14" "Onge" "Papuan" )
    elif [ $NAME == "lipson2020_fig5a" ]; then
        POPS=( "BakaDG" "FrenchDG" "HanDG" "MixeDG" "UlchiDG" )
    elif [ $NAME == "lipson2020_fig5a_extended" ]; then
        POPS=( "BakaDG" "FrenchDG" "HanDG" "MixeDG1" "UlchiDG" "MixeDG2" )
    elif [ $NAME == "wu2020_fig7a" ]; then
        POPS=( "ASW" "CEU" "CHB" "GIH" "IBS" \
               "ITU" "JPT" "MXL" "PUR" "YRI" )
    elif [ $NAME == "yan2020_fig2" ]; then
        POPS=( "Altai" "ANE" "Dai" "Karitiana" "Mbuti" "Onge" )
    fi

    python ../../tools/write_pop_add_orders.py \
        -p ${POPS[@]} \
        -o $NAME
done
