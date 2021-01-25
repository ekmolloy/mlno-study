#!/bin/bash

#. /u/local/Modules/default/init/modules.sh
#module load gcc/4.9.3
#module load gsl
#module load boost/1_58_0
#module load python/3.7.0

#NTD1="/u/home/s/sriram/group/ekmolloy/mlno-study/external/ntd/first/first"
NTD1=first
#NTD1="second"

#"mallick2016_figS11_1_simplified" \
#"patterson2012_fig5" \
#"case_study" \

NAMES=( "haak2015_figS8-1" \
        "lipson2020_fig5a" \
        "lipson2020_fig5a_extended" \
        "wu2020_fig7a" \
        "yan2020_fig2" )

NAMES=( "mallick2016_figS11_1_simplified" )

for NAME in ${NAMES[@]}; do
	if [ $NAME == "case_study" ]; then
    	DEPTH=3
    	OUTG="popE"
	elif [ $NAME == "haak2015_figS8-1" ]; then
		DEPTH=3
    	OUTG="Mbuti"
	elif [ $NAME == "lipson2020_fig5a" ]; then
    	OUTG="BakaDG"
	elif [ $NAME == "lipson2020_fig5a_extended" ]; then
		DEPTH=3
    	OUTG="BakaDG"
    elif [ $NAME == "wu2020_fig7a" ]; then
    	DEPTH=5
    	OUTG="YRI"
    elif [ $NAME == "yan2020_fig2" ]; then
    	DEPTH=3
    	OUTG="Altai"
	fi

	echo $NAME

	TRUEG="../model-data-sets/data/ntdgraph_${NAME}.txt"
	TRUEM="../model-data-sets/data/ntdmap_${NAME}.txt"

	ESTIG="ntdgraph_tmp.txt"
	python tools/miqograph_to_ntd.py \
    	-x $OUTG \
		-l data/model-data-sets/${NAME}_model.log \
		-d $DEPTH \
		-m $TRUEM \
		-o $ESTIG

	$NTD1  $TRUEG $ESTIG #| awk '{print $1}'
done
