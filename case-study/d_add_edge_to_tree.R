#!/usr/bin/env Rscript

source("case_study_graph_topologies.R")
source("../tools/admixturegraph_helper_functions.R")


# Read data file
mydata <- read.table("data/a_true_input_data.csv", sep=",")

# Define leaf and internal node labels
mytree <- get_case_study_mr_tree_topology()

# Add admixture node between all pairs of edges
edges <- get_edges(mytree)
nedge <- length(edges)

graphs <- c()
SSR <- c()
l <- 1

for (i in 1:(nedge-1)) {
    ei <- edges[[i]]
    for (j in (i+1):nedge) {
        ej <- edges[[j]]
        if (ei$parent != ej$parent) {
            for (k in 1:2) {
                if (k == 1) {
                    mygraph <- add_admixture_edge_1_to_2(mytree, ei, ej)
                } else {
                    mygraph <- add_admixture_edge_1_to_2(mytree, ej, ei)
                }
                myfit <- fit_graph(mydata,
                               mygraph,
                               Z.value=FALSE,
                               parameters=extract_graph_parameters(mygraph),
                               qr_tol=1e-12)
                SSR[l] <- sum_of_squared_errors(myfit)
                graphs[[l]] <- mygraph
                l <- l + 1
            }
        }
    }
}

INDEX <- order(SSR)  # Sort graphs by residuals
SSR <- SSR[INDEX]
write.table(cbind(INDEX, SSR), file="data/d_k0tok1.csv", sep=",")

# Plot graphs
for (i in 1:length(INDEX)) {
  pdf(paste("data/d_k0tok1/d_k0tok1_mr", i, ".pdf", sep=""))
  plot(graphs[[INDEX[i]]], show_admixture_labels=TRUE)
  dev.off()
}

