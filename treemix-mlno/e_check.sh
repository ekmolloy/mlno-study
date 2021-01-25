NAMES=( "case_study" \
	"patterson2012_fig5" \
	"haak2015_figS8-1" \
	"mallick2016_figS11_1_simplified" \
        "lipson2020_fig5a" \
        "lipson2020_fig5a_extended" \
        "wu2020_fig7a" \
        "yan2020_fig2" )

for NAME in ${NAMES[@]}; do
    echo $NAME
    echo "treemix"
    sed 's/,/ /g' treemix_model_data_sets_${NAME}.csv | \
         grep "treemix " | awk '{print $6}' | sort -n | tail -n1

    #sed 's/,/ /g' treemix_model_data_sets_${NAME}.csv | \
    #     grep "treemix " | awk '{print $6}' | sort -n | head -n1
#

    sed 's/,/ /g' treemix_model_data_sets_${NAME}.csv | \
         grep "treemix " | awk '{print $7}'  | sort
    exit

    echo "treemix-mlno"
    sed 's/,/ /g' treemix_model_data_sets_${NAME}.csv | \
         grep "treemix-mlno" | awk '{print $6}' | sort -n | tail -n1
    #sed 's/,/ /g' treemix_model_data_sets_${NAME}.csv | \
    #     grep "treemix-mlno" | awk '{print $6}' | sort -n | head -n1
done
