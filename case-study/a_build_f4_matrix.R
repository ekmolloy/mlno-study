#!/usr/bin/env Rscript

source("case_study_graph_topologies.R")


mygraph <- get_case_study_true_graph_topology()
leaves <- mygraph$leaves

pdf("data/a_true_graph.pdf")
plot(mygraph, show_admixture_labels=TRUE)
dev.off()

# Define admixture proportions
w <- 0.35

# Define edge lengths in coalescent units and edge labels
edge_R_vE <- 0.38
edge_R_v1 <- 0.005
edge_v1_v2 <- 0.125
edge_v2_v3 <- 0.125
edge_v2_vC <- 0.25
edge_v3_vB <- 0.125
edge_v1_v4 <- 0.325
edge_v4_vD <- 0.05
edge_v3_v5 <- 0.075
edge_v5_vA <- 0.05
edge_v4_v5 <- 0.0

elens <- c(edge_R_v1,
           edge_R_vE,
           edge_v1_v2,
           edge_v1_v4,
           edge_v2_v3,
           edge_v2_vC,
           edge_v3_vB,
           edge_v3_v5,
           edge_v4_vD,
           edge_v4_v5,
           edge_v5_vA)

elabs <- c("edge_R_v1",
           "edge_R_vE",
           "edge_v1_v2",
           "edge_v1_v4",
           "edge_v2_v3",
           "edge_v2_vC",
           "edge_v3_vB",
           "edge_v3_v5",
           "edge_v4_vD",
           "edge_v4_v5",
           "edge_v5_vA")

# Compute f4-statistics (based on basis of f2-statistics)
n <- length(leaves)
W <- c()
X <- c()
Y <- c()
Z <- c()
D <- c()

k <- 1
for (i in 1:(n-1)) {
    for (j in (i+1):n) {
        li <- leaves[i]
        lj <- leaves[j]
        f4expr <- sf4(mygraph, li, lj, li, lj)
        W[k] <- li
        X[k] <- lj
        Y[k] <- li
        Z[k] <- lj
        D[k] <- eval(f4expr)
        k <- k + 1
    }
}

# Write f4-statistics to data matrix
mydata <- data.frame(W, X, Y, Z, D)
write.table(mydata, file="data/a_true_input_data.csv", sep=",")

# Fit numerical parameters to correct admixture graph topology
myfit <- fit_graph(mydata,
                   mygraph,
                   Z.value=FALSE,
                   parameters=extract_graph_parameters(mygraph),
                   qr_tol=1e-12)

# Notes on how to access fit object!
#> myfit[2]$data
#> myfit[6]$best_fit
#> myfit[7]$best_edge_fit
#> myfit[13]$parameters$edges
#> myfit[13]$parameters$admix_prop
#> summary(myfit)

print("NOTE: TreeMix sets c1=c2=0 and admixturegraph sets c2=c3=0, where c1=elen_v5_vA, c2=elen_v4_v5 (v4 is incident to vD), c3=elen_v3_v5 (v3 is adjacent to vB).")

# Compute sum of squared residuals
ssr <- sum_of_squared_errors(myfit)
sprintf("Sum of Squared Residuals (SSR): %.12f", ssr)
#[1] "Sum of Squared Residuals (SSR): 0.000001665628"

# Compute sum of squared errors (true versus estimated branch lengths)
efit <- myfit[7]$best_edge_fit
sse <- 0 
for (i in 1:length(elabs)) {
    diff <- elens[i] - efit[elabs[i]]
    sse <- sse + (diff * diff)
}
sprintf("Sum of Sqaured Error for Edge Lengths (SSE): %.12f", sse)
#[1] "Sum of Sqaured Error for Edge Lengths (SSE): 0.006877352673"
