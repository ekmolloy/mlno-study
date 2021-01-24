#!/usr/bin/env Rscript

library("admixturegraph")


get_wu2020_fig7a_graph <- function() {
    leaves <- c("ASW",
                "CEU",
                "CHB",
                "GIH",
                "IBS",
                "ITU",
                "JPT",
                "MXL",
                "PUR",
                "YRI")

    inner_nodes <- c("R", "v1", "v2", "v3", "v4",
                     "v5", "v6", "v7", "v8", "v9",
                     "v10", "v11", "v12")

    edges <- parent_edges(c(edge("v1", "R"),
                            edge("v10", "R"),
                            edge("v2", "v1"),
                            edge("v3", "v1"),
                            edge("v4", "v2"),
                            edge("v8", "v2"),
                            edge("v5", "v3"),
                            edge("CEU", "v3"),
                            edge("v6", "v4"),
                            edge("v7", "v4"),
                            edge("v9", "v5"),
                            edge("CHB", "v7"),
                            edge("JPT", "v7"),
                            edge("ITU", "v8"),
                            edge("GIH", "v8"),
                            edge("IBS", "v9"),
                            edge("ASW", "v10"),
                            edge("YRI", "v10"),
                            admixture_edge("v11", "v6", "v5", "w_v6_v11"),
                            admixture_edge("v12", "v9", "v6", "w_v9_v12"),
                            edge("MXL", "v11"),
                            edge("PUR", "v12")))
 
    newgraph <- agraph(leaves, inner_nodes, edges)

    # Admixture proportions
    w_v6_v11 <<- 0.39
    w_v9_v12 <<- 0.40

    # Edge lengths in coalescent units
    edge_R_v1 <<- 0.110
    edge_R_v10 <<- 0.101
    edge_v1_v2 <<- 0.041
    edge_v1_v3 <<- 0.044
    edge_v2_v4 <<- 0.032
    edge_v2_v8 <<- 0.031
    edge_v3_v5 <<- 0.028
    edge_v3_CEU <<- 0.039
    edge_v4_v6 <<- 0.044
    edge_v4_v7 <<- 0.060
    edge_v5_v9 <<- 0.018
    edge_v5_v11 <<- 0.018  # Admixture edge
    edge_v6_v11 <<- 0.003  # Admixture edge
    edge_v6_v12 <<- 0.013  # Admixture edge
    edge_v7_CHB <<- 0.037
    edge_v7_JPT <<- 0.039
    edge_v8_ITU <<- 0.031
    edge_v8_GIH <<- 0.051
    edge_v9_v12 <<- 0.002  # Admixture edge
    edge_v9_IBS <<- 0.030
    edge_v10_ASW <<- 0.039
    edge_v10_YRI <<- 0.083
    edge_v11_MXL <<- 0.019
    edge_v12_PUR <<- 0.016

    return(newgraph)
}


get_wu2020_fig7a_left_graph <- function() {
    newgraph <- get_wu2020_fig7a_graph()
    w_v9_v12 <<- 0.0
    return(newgraph)
}

get_wu2020_fig7a_right_graph <- function() {
    newgraph <- get_wu2020_fig7a_graph()
    w_v6_v11 <<- 0.0
    return(newgraph)
}
