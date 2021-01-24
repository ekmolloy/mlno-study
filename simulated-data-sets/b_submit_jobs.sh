#!/bin/bash

qsub -cwd \
     -V \
     -N "b" \
     -l h_data=32G,time=06:00:00,highp \
     -t 1-4 \
     -m a \
     -M ekmolloy \
     -b y "bash b_convert_ms_output_to_treemix_input.sh"
