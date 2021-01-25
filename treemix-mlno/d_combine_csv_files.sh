#!/bin/bash

NAMES=( "case_study" \
	"patterson2012_fig5" \
	"haak2015_figS8-1" \
	"mallick2016_figS11_1_simplified" \
        "lipson2020_fig5a" \
        "lipson2020_fig5a_extended" \
        "wu2020_fig7a" \
        "yan2020_fig2" )


for NAME in ${NAMES[@]}; do
    CSV="treemix_model_data_sets_${NAME}.csv"
    if [ ! -e $CSV ]; then
        echo "NAME,MTHD,ORDR,LLIK_TREE,LLIK_NMIG,DIST,TIME" > $CSV
        cat data/model-data-sets/${NAME}/keep* >> $CSV
    fi
done

exit

NAMES=( "case_study" \
        "haak2015_figS8-1" \
        "lipson2020_fig5a" \
        "lipson2020_fig5a_extended" )

NLOCI=( "10" "50" "100" \
        "500" "1000" "1500" \
        "2000" "2500" "3000" )

for NAME in ${NAMES[@]}; do
    CSV="treemix_simulated_data_sets_${NAME}.csv"
    if [ ! -e $CSV ]; then
        echo "TYPE,NAME,LOCI,MTHD,ORDR,LLIK_TREE,LLIK_NMIG,DIST" > $CSV
        for TYPE in "cov" "f2"; do
            for LOCI in ${NLOCI[@]}; do
                cat data/simulated-data-sets/${TYPE}_${NAME}_${LOCI}/keep* >> $CSV 
            done
        done
    fi
done
