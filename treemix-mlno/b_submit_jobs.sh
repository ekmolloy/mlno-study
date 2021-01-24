#!/bin/bash

qsub -cwd \
     -V \
     -N "b" \
     -l h_data=16G,time=05:00:00 \
     -t 1-72 \
     -m a \
     -M ekmolloy \
     -b y "bash b_run_treemix_on_simulated.sh"
