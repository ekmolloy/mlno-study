#!/usr/bin/env Rscript

library("admixturegraph")

get_case_study_graph <- function() {
    leaves <- c("popA", "popB", "popC", "popD", "popE")

    inner_nodes <- c("R", "v1", "v2", "v3", "v4", "v5")

    edges <- parent_edges(c(edge("v1", "R"),
                            edge("popE", "R"),
                            edge("v2", "v1"),
                            edge("v4", "v1"),
                            edge("v3", "v2"),
                            edge("popC", "v2"),
                            edge("popB", "v3"),
                            edge("popD", "v4"),
                            admixture_edge("v5", "v4", "v3", "w"),
                            edge("popA", "v5")))
 
    newgraph <- agraph(leaves, inner_nodes, edges)

    # Define admixture proportions
    w <<- 0.35

    # Define edge lengths in coalescent units and edge labels
    edge_R_popE <<- 0.38
    edge_R_v1 <<- 0.005
    edge_v1_v2 <<- 0.125
    edge_v2_v3 <<- 0.125
    edge_v2_popC <<- 0.25
    edge_v3_popB <<- 0.125
    edge_v1_v4 <<- 0.325
    edge_v4_popD <<- 0.05
    edge_v3_v5 <<- 0.075
    edge_v5_popA <<- 0.05
    edge_v4_v5 <<- 0.0

    return(newgraph)
}
