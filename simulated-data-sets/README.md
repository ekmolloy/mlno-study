Simulated Data Sets
===================

We simulated data sets from four demographies:
1. Our case study model
2. Model shown in [Lipson (2020)](https://doi.org/10.1111/1755-0998.13230) Figure 5a
3. An extended version of the model from Lipson (2020) Figure 5a, in which Mixe splits into two populations
4. Model shown in [Haak *et al.* (2015)](https://doi.org/10.1534/genetics.112.145037) Figure S8.1
using with *ms* [(Hudson 2002)](https://doi.org/10.1093/bioinformatics/18.2.337) with the
+ number of loci set to 3000,
+ number of sites per locus set to 1000000,
+ effective population size above the root (i.e. *N0*) set to 10000,
+ sample size for each population set to 20,
+ mutation rate *mu* set to 1.25e-8, and
+ recombination rate *r* set to 1e-8.

Importantly, the published models from Lipson (2020) and Haak *et al.* (2015) were fit from biological data sets using *qpGraph* [(Patterson *et al.,* 2012)](https://doi.org/10.1534/genetics.112.145037), the branch lengths are given in units of genetic drift (i.e. the number of generations on the branch divided by twice the effective population size). To simulate data with *ms*, we assigned timings at the internal nodes and then re-scaled the population size on each of the branch so that it was the correct length in drift units (although ideally the demographic models would be dated).

After running *ms*, the output was then reformatted as allele frequencies so that it could be given to *TreeMix* as input. *TreeMix* v1.13 [(Pickrell and Pritchard, 2012)](https://doi.org/10.1371/journal.pgen.1002967) was used to estimate the sample covariance matrix, the *f2*-statistic matrix, and the standard error for the entries of these matrices for each data sets. For the four models, the block size (`-k` option) for jack knifing was set to 6000, 3000, 3500, and 4000, respectively, because the maximum number SNPs per locus was 
+ 6024 for our case study
+ 2877 for Lipson (2020) Figure 5a
+ 3539 for the extended version of Lipson (2020) Figure 5a, and 
+ 4048 for Haak *et al.* (2015) Figure S8.1. 

Lastly, we repeated this process of estimating matrices with *TreeMix* using SNPs from the first 10, 50, 100, 500, 1000, 1500, 2000, and 2500 loci. This produced a total of 36 data sets (based on 4 model demographies and 9 numbers of loci) on which both *f2*-statistic matrices and sample covariance matrices were estimated.
