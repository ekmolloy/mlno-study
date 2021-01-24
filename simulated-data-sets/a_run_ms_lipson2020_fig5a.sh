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
NPOP=5
SB=20  # 1 - Baka
SF=20  # 2 - French
SH=20  # 3 - Han
SM=20  # 4 - Mixe
SU=20  # 5 - Ulchi
NSAMP=$(echo "$SB + $SF + $SH + $SM + $SU" | bc)

# Admixture weight - Subtract from 1, 
# because going backward in time
w=0.24
ABACK=$(echo "1 - $w" | bc) 

# Edge lengths in coalescent units i.e. 
#   no. of generations / (2 * effective population size)
ECU_B="0.028"
ECU_F="0.002"
ECU_H="0.003"
ECU_M="0.025"
ECU_U="0.004"
ECU_M2MU="0.014"
ECU_M2FM="0.001"
ECU_MU="0.002"
ECU_FM="0.011"
ECU_HMU="0.021"
ECU_FHMU="0.028"

# Time in no. of generations at internal nodes
T_M=100
T_MU=200
T_FM=200
T_HMU=300
T_FHMU=400
T_BFHMU=500

# Edge lengths in time units i.e. no. of generations
ET_B="$T_BFHMU"
ET_F="$T_FM"
ET_H="$T_HMU"
ET_M="$T_M"
ET_U="$T_MU"
ET_M2MU=$(echo "$T_MU - $T_M" | bc)
ET_M2FM=$(echo "$T_FM - $T_M" | bc)
ET_MU=$(echo "$T_HMU - $T_MU" | bc)
ET_FM=$(echo "$T_FHMU - $T_FM" | bc)
ET_HMU=$(echo "$T_FHMU - $T_HMU" | bc)
ET_FHMU=$(echo "$T_BFHMU - $T_FHMU" | bc)

# 1. ECU = ET / (2 * EP) so EP = ET / (2 * ECU)
# 2. EP = X * PSIZE so X = EP / PSIZE
# Putting 1 and 2 together gives: 
#   X = (ET / (2 * ECU)) / PSIZE
X_B=$(echo "($ET_B / (2 * $ECU_B)) / $PSIZE" | bc -l)
X_F=$(echo "($ET_F / (2 * $ECU_F)) / $PSIZE" | bc -l)
X_H=$(echo "($ET_H / (2 * $ECU_H)) / $PSIZE" | bc -l)
X_M=$(echo "($ET_M / (2 * $ECU_M)) / $PSIZE" | bc -l)
X_U=$(echo "($ET_U / (2 * $ECU_U)) / $PSIZE" | bc -l)
X_M2MU=$(echo "($ET_M2MU / (2 * $ECU_M2MU)) / $PSIZE" | bc -l)
X_M2FM=$(echo "($ET_M2FM / (2 * $ECU_M2FM)) / $PSIZE" | bc -l)
X_MU=$(echo "($ET_MU / (2 * $ECU_MU)) / $PSIZE" | bc -l)
X_FM=$(echo "($ET_FM / (2 * $ECU_FM)) / $PSIZE" | bc -l)
X_HMU=$(echo "($ET_HMU / (2 * $ECU_HMU)) / $PSIZE" | bc -l)
X_FHMU=$(echo "($ET_FHMU / (2 * $ECU_FHMU)) / $PSIZE" | bc -l)

# Convert times to units for ms
T_M=$(echo "$T_M / (4 * $PSIZE)" | bc -l)
T_MU=$(echo "$T_MU / (4 * $PSIZE)" | bc -l)
T_FM=$(echo "$T_FM / (4 * $PSIZE)" | bc -l)
T_HMU=$(echo "$T_HMU / (4 * $PSIZE)" | bc -l)
T_FHMU=$(echo "$T_FHMU / (4 * $PSIZE)" | bc -l)
T_BFHMU=$(echo "$T_BFHMU / (4 * $PSIZE)" | bc -l)

# Run ms
# Note:
# -en t i x = subpop i to size x * PSIZE at time t and growth rate to 0
# -es t i p = split subpop i into subpop i and new subpop npop+1, 
# -ej t i j = move all lineages in subpop i to subpop j at time t
if [ ! -e ms_output_lipson2020_fig5a.txt.gz ]; then
    echo "3579 27011 59243" > seedms

    ms $NSAMP $NREPL -T \
        -t $THETA \
        -r $RHO $NSITE \
        -I $NPOP $SB $SF $SH $SM $SU \
        -en 0 1 $X_B \
        -en 0 2 $X_F \
        -en 0 3 $X_H \
        -en 0 4 $X_M \
        -en 0 5 $X_U \
        -es $T_M 4 $ABACK \
        -en $T_M 4 $X_M2MU \
        -en $T_M 6 $X_M2FM \
        -ej $T_MU 5 4 \
        -en $T_MU 4 $X_MU \
        -ej $T_FM 6 2 \
        -en $T_FM 2 $X_FM \
        -ej $T_HMU 4 3 \
        -en $T_HMU 3 $X_HMU \
        -ej $T_FHMU 3 2 \
        -en $T_FHMU 2 $X_FHMU \
        -ej $T_BFHMU 2 1 \
         > ms_output_lipson2020_fig5a.txt

    gzip ms_output_lipson2020_fig5a.txt
fi
