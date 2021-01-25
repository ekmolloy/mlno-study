#!/bin/bash

#. /u/local/Modules/default/init/modules.sh
#module load gcc/4.9.3
#module load gsl
#module load boost/1_58_0
#module load python/3.7.0

#NTD1="/u/home/s/sriram/group/ekmolloy/mlno-study/external/ntd/first/first"
NTD1=first
#NTD1="second"

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
    	DEPTH=3
    	OUTG="popE"
	elif [ $NAME == "haak2015_figS8-1" ]; then
		DEPTH=3
    	OUTG="Mbuti"
	elif [ $NAME == "lipson2020_fig5a" ]; then
    	OUTG="BakaDG"
    	DEPTH=3
	elif [ $NAME == "lipson2020_fig5a_extended" ]; then
		DEPTH=3
    	OUTG="BakaDG"
    elif [ $NAME == "wu2020_fig7a" ]; then
    	DEPTH=5
    	OUTG="YRI"
    elif [ $NAME == "yan2020_fig2" ]; then
    	DEPTH=3
    	OUTG="Altai"
    elif [ $NAME == "patterson2012_fig5" ]; then
    	DEPTH=3
    	OUTG="Out"
    elif [ $NAME == "case_study" ]; then
    	DEPTH=3
    	OUTG="popE"
    elif [ $NAME == "mallick2016_figS11_1_simplified" ]; then
    	DEPTH=5
    	OUTG="Chimp"
	fi

	TRUEG="../model-data-sets/data/ntdgraph_${NAME}.txt"
	TRUEM="../model-data-sets/data/ntdmap_${NAME}.txt"

	echo $NAME
	ESTIG="ntdgraph_tmp.txt"
	python tools/miqograph_to_ntd.py \
    	-x $OUTG \
		-l data/model-data-sets/${NAME}_model.log \
		-d $DEPTH \
		-m $TRUEM \
		-o $ESTIG


	$NTD1  $TRUEG $ESTIG #| awk '{print $1}'

	rm $ESTIG
	OUTG=""
    DEPTH=""
done
