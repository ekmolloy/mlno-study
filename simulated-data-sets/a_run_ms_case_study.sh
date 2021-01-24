#!/bin/bash

set -e

cd data

# Set fixed model parameters
MU="0.0000000125"
R="0.00000001"
NREPL=3000
NSITE=1000000
PSIZE=10000
THETA=$(echo "4 * $PSIZE * $MU * $NSITE" | bc)
RHO=$(echo "4 * $PSIZE * $R * $NSITE" | bc)

# Set-up model demography     
NPOP=5
SA=20
SB=20
SC=20
SD=20
SE=20
NSAMP=$(echo "$SA + $SB + $SC + $SD + $SE" | bc)

# Admixture weight - Subtract from 1, 
# because going backward in time
w=0.35
ABACK=$(echo "1 - $w" | bc) 

# Time in no. of generations at internal nodes
T_D2A="1000"
T_AB="2500" 
T_ABC="5000"
T_ABCD="7500"
T_ABCDE="7600"

# Convert times for use with ms
T_AB=$(echo "$T_AB / (4 * $PSIZE)" | bc -l)
T_ABC=$(echo "$T_ABC / (4 * $PSIZE)" | bc -l)
T_ABCD=$(echo "$T_ABCD / (4 * $PSIZE)" | bc -l)
T_ABCDE=$(echo "$T_ABCDE / (4 * $PSIZE)" | bc -l)
T_D2A=$(echo "$T_D2A / (4 * $PSIZE)" | bc -l)

# Run ms
# Note:
# -en t i x = subpop i to size x * PSIZE at time t and growth rate to 0
# -es t i p = split subpop i into subpop i and new subpop npop+1, 
# -ej t i j = move all lineages in subpop i to subpop j at time t 
if [ ! -e ms_output_case_study.txt.gz ]; then
    echo "3579 27011 59243" > seedms

    ms $NSAMP $NREPL -T \
        -t $THETA \
        -r $RHO $NSITE \
        -I $NPOP $SA $SB $SC $SD $SE \
        -en 0 1 1 \
        -en 0 2 1 \
        -en 0 3 1 \
        -en 0 4 1 \
        -en 0 5 1 \
        -es $T_D2A 1 $ABACK \
        -ej $T_D2A 6 4 \
        -ej $T_AB 2 1 \
        -ej $T_ABC 3 1 \
        -ej $T_ABCD 4 1 \
        -ej $T_ABCDE 5 1 > ms_output_case_study.txt

    gzip ms_output_case_study.txt
fi
