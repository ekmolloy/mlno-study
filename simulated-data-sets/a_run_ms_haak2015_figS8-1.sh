#!/bin/bash

set -e

cd data

# Set-up fixed model parameters
MU="0.0000000125"
R="0.00000001"
NREPL=3000
NSITE=1000000
PSIZE=10000
THETA=$(echo "4 * $PSIZE * $MU * $NSITE" | bc)
RHO=$(echo "4 * $PSIZE * $R * $NSITE" | bc)

# Set-up model demography
NPOP=6
SK=20  # 1 - Karitiana - K
SL=20  # 2 - LBK_EN - L
SC=20  # 3 - Loschbour - C
SM=20  # 4 - MA1 - M
SB=20  # 5 - Mbuti - B
SO=20  # 6 - Onge - O
NSAMP=$(echo "$SK + $SL + $SC + $SM + $SB + $SO" | bc)

# Admixture weight - Subtract from 1, 
# because going backward in time
w_K=0.39
ABACK_K=$(echo "1 - $w_K" | bc)
w_L=0.23
ABACK_L=$(echo "1 - $w_L" | bc)

# Edge lengths in coalescent units i.e. 
#   no. of generations / (2 * effective population size)
ECU_B="0.150"
ECU_C="0.083"
ECU_K="0.123"
ECU_L="0.057"
ECU_M="0.387"
ECU_O="0.089"
ECU_K2KM="0.019"
ECU_KM="0.055"
ECU_K2KO="0.045"
ECU_KO="0.021"
ECU_L2CL="0.033"
ECU_CL="0.027"
ECU_CKLM="0.024"
ECU_CKLMO="0.052"
ECU_L2CKLMO2="0.003"
ECU_CKLMO2="0.008"  # So ECU_CKLMO + ECU_B = 0.158

# Time in no. of generations at internal nodes
T_K=1000
T_L=1000
T_CL=2000
T_KM=2000
T_KO=2000
T_CKLM=3000
T_CKLMO=4000
T_CKLMO2=5000
T_BCKLMO=5000

# Edge lengths in time units i.e. no. of generations
ET_K="$T_K"
ET_L="$T_L"
ET_C="$T_CL"
ET_M="$T_KM"
ET_B="$T_BCKLMO"
ET_O="$T_KO"
ET_K2KM=$(echo "$T_KM - $T_K" | bc)
ET_KM=$(echo "$T_CKLM - $T_KM" | bc)
ET_K2KO=$(echo "$T_KO - $T_K" | bc)
ET_KO=$(echo "$T_CKLMO - $T_KO" | bc)
ET_L2CL=$(echo "$T_CL - $T_L" | bc)
ET_CL=$(echo "$T_CKLM - $T_CL" | bc)
ET_CKLM=$(echo "$T_CKLMO - $T_CKLM" | bc)
ET_CKLMO=$(echo "$T_CKLMO2 - $T_CKLMO" | bc)
ET_L2CKLMO2=$(echo "$T_CKLMO2 - $T_L" | bc)
ET_CKLMO2=$(echo "$T_BCKLMO - $T_CKLMO2" | bc)

# 1. ECU = ET / (2 * EP) so EP = ET / (2 * ECU)
# 2. EP = X * PSIZE so X = EP / PSIZE
# Putting 1 and 2 together gives: 
#   X = (ET / (2 * ECU)) / PSIZE
X_K=$(echo "($ET_K / (2 * $ECU_K)) / $PSIZE" | bc -l)
X_L=$(echo "($ET_L / (2 * $ECU_L)) / $PSIZE" | bc -l)
X_C=$(echo "($ET_C / (2 * $ECU_C)) / $PSIZE" | bc -l)
X_M=$(echo "($ET_M / (2 * $ECU_M)) / $PSIZE" | bc -l)
X_B=$(echo "($ET_B / (2 * $ECU_B)) / $PSIZE" | bc -l)
X_O=$(echo "($ET_O / (2 * $ECU_O)) / $PSIZE" | bc -l)
X_K2KM=$(echo "($ET_K2KM / (2 * $ECU_K2KM)) / $PSIZE" | bc -l)
X_KM=$(echo "($ET_KM / (2 * $ECU_KM)) / $PSIZE" | bc -l)
X_K2KO=$(echo "($ET_K2KO / (2 * $ECU_K2KO)) / $PSIZE" | bc -l)
X_KO=$(echo "($ET_KO / (2 * $ECU_KO)) / $PSIZE" | bc -l)
X_L2CL=$(echo "($ET_L2CL / (2 * $ECU_L2CL)) / $PSIZE" | bc -l)
X_CL=$(echo "($ET_CL / (2 * $ECU_CL)) / $PSIZE" | bc -l)
X_CKLM=$(echo "($ET_CKLM / (2 * $ECU_CKLM)) / $PSIZE" | bc -l)
X_CKLMO=$(echo "($ET_CKLMO / (2 * $ECU_CKLMO)) / $PSIZE" | bc -l)
X_L2CKLMO2=$(echo "($ET_L2CKLMO2 / (2 * $ECU_L2CKLMO2)) / $PSIZE" | bc -l)
X_CKLMO2=$(echo "($ET_CKLMO2 / (2 * $ECU_CKLMO2)) / $PSIZE" | bc -l)

# Convert times to units for ms
T_K=$(echo "$T_K / (4 * $PSIZE)" | bc -l)
T_L=$(echo "$T_L / (4 * $PSIZE)" | bc -l)
T_CL=$(echo "$T_CL / (4 * $PSIZE)" | bc -l)
T_KM=$(echo "$T_KM / (4 * $PSIZE)" | bc -l)
T_KO=$(echo "$T_KO / (4 * $PSIZE)" | bc -l)
T_CKLM=$(echo "$T_CKLM / (4 * $PSIZE)" | bc -l)
T_CKLMO=$(echo "$T_CKLMO / (4 * $PSIZE)" | bc -l)
T_CKLMO2=$(echo "$T_CKLMO2 / (4 * $PSIZE)" | bc -l)
T_BCKLMO=$(echo "$T_BCKLMO / (4 * $PSIZE)" | bc -l)

# Run ms
# Note:
# -en t i x = subpop i to size x * PSIZE at time t and growth rate to 0
# -es t i p = split subpop i into subpop i and new subpop npop+1, 
# -ej t i j = move all lineages in subpop i to subpop j at time t
if [ ! -e ms_output_haak2015_figS8-1.txt.gz ]; then
    echo "3579 27011 59243" > seedms

    ms $NSAMP $NREPL -T \
        -t $THETA \
        -r $RHO $NSITE \
        -I $NPOP $SK $SL $SC $SM $SB $SO \
        -en 0 1 $X_K \
        -en 0 2 $X_L \
        -en 0 3 $X_C \
        -en 0 4 $X_M \
        -en 0 5 $X_B \
        -en 0 6 $X_O \
        -es $T_K 1 $ABACK_K \
        -en $T_K 1 $X_K2KO \
        -en $T_K 7 $X_K2KM \
        -es $T_L 2 $ABACK_L \
        -en $T_L 2 $X_L2CL \
        -en $T_L 8 $X_L2CKLMO2 \
        -ej $T_KO 6 1 \
        -en $T_KO 1 $X_KO \
        -ej $T_CL 3 2 \
        -en $T_CL 2 $X_CL \
        -ej $T_KM 7 4 \
        -en $T_KM 4 $X_KM \
        -ej $T_CKLM 4 2 \
        -en $T_CKLM 2 $X_CKLM \
        -ej $T_CKLMO 2 1 \
        -en $T_CKLMO 1 $X_CKLMO \
        -ej $T_CKLMO2 8 1 \
        -en $T_CKLMO2 1 $X_CKLMO2 \
        -ej $T_BCKLMO 5 1 \
        > ms_output_haak2015_figS8-1.txt

    gzip ms_output_haak2015_figS8-1.txt
fi
