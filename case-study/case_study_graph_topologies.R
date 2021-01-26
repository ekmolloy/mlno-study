##!/usr/bin/env Rscript

library("admixturegraph")

get_case_study_true_graph_topology <- function() {
    leaves <- c("vA", "vB", "vC", "vD", "vE")

    inner_nodes <- c("R", "v1", "v2", "v3", "v4", "v5")

    edges <- parent_edges(c(edge("v1", "R"),
                            edge("vE", "R"),
                            edge("v2", "v1"),
                            edge("v4", "v1"),
                            edge("v3", "v2"),
                            edge("vC", "v2"),
                            edge("vB", "v3"),
                            edge("vD", "v4"),
                            admixture_edge("v5", "v4", "v3", "w"),
                            edge("vA", "v5")))
 
    newgraph <- agraph(leaves, inner_nodes, edges)

    return(newgraph)
}

get_case_study_mr_tree_topology <- function() {
    leaves <- c("vA", "vB", "vC", "vD", "vE")

    inner_nodes <- c("R", "v1", "v2", "v3")

    edges <- parent_edges(c(edge("v1", "R"),
                            edge("vE", "R"),
                            edge("v2", "v1"),
                            edge("vD", "v1"),
                            edge("v3", "v2"),
                            edge("vA", "v2"),
                            edge("vB", "v3"),
                            edge("vC", "v3")))

    mytree <- agraph(leaves, inner_nodes, edges)

    return(mytree)
}


get_case_study_tbmr_graph_topology <- function() {
    leaves <- c("vA", "vB", "vC", "vD", "vE")

    inner_nodes <- c("R", "v1", "v2", "v3", "v4", "v5")

    edges <- parent_edges(c(edge("v1", "R"),
                            edge("v4", "R"),
                            edge("v2", "v1"),
                            edge("vB", "v1"),
                            edge("v3", "v2"),
                            edge("vA", "v2"),
                            edge("vD", "v3"),
                            edge("v5", "v3"),
                            admixture_edge("v5", "v4", "v3", "w"),
                            edge("vC", "v4"),
                            edge("vE", "v5")))

    newgraph <- agraph(leaves, inner_nodes, edges)

    return(newgraph)
}

