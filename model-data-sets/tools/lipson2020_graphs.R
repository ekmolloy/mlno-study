#!/usr/bin/env Rscript

library("admixturegraph")


get_lipson2020_fig5a_graph <- function() {
    leaves <- c("BakaDG",
                "FrenchDG",
                "HanDG",
                "MixeDG",
                "UlchiDG")

    # Suppressed internal nodes: East2 and West2
    inner_nodes <- c("R",
                     "East0",
                     "East1",
                     "NA1",
                     "pAM1",
                     "West1")

    edges <- parent_edges(c(edge("BakaDG", "R"),
                            edge("NA1", "R"),
                            edge("East0", "NA1"),
                            edge("West1", "NA1"),
                            edge("HanDG", "East0"),
                            edge("East1", "East0"),
                            edge("UlchiDG", "East1"),
                            edge("FrenchDG", "West1"),
                            admixture_edge("pAM1", "West1", "East1", "w_West1_pAM1"),
                            edge("MixeDG", "pAM1")))

    newgraph <- agraph(leaves, inner_nodes, edges)

    # Admixture Weights
    w_West1_pAM1 <<- 0.24

    # Branch lengths
    edge_R_BakaDG <<- 28 / 1000
    edge_R_NA1 <<- 28 / 1000
    edge_NA1_East0 <<- 21 / 1000
    edge_NA1_West1 <<- 11 / 1000
    edge_East0_HanDG <<- 3 / 1000
    edge_East0_East1 <<- 2 / 1000
    edge_East1_UlchiDG <<- 4 / 1000
    edge_East1_pAM1 <<- 14 / 1000
    edge_West1_pAM1 <<- 1 / 1000
    edge_West1_FrenchDG <<- 2 / 1000
    edge_pAM1_MixeDG <<- 25 / 1000

    return(newgraph)
}


get_lipson2020_fig6b_graph <- function() {
    newgraph <- get_lipson2020_fig5a_graph()

    w_West1_pAM1 <<- 0.30

    edge_R_BakaDG <<- 29 / 1000
    edge_R_NA1 <<- 29 / 1000
    edge_NA1_East0 <<- 21 / 1000
    edge_NA1_West1 <<- 8 / 1000
    edge_East0_HanDG <<- 3 / 1000
    edge_East0_East1 <<- 3 / 1000
    edge_East1_UlchiDG <<- 3 / 1000
    edge_East1_pAM1 <<- 13 / 1000
    edge_West1_FrenchDG <<- 5 / 1000
    edge_West1_pAM1 <<- 2 / 1000
    edge_pAM1_MixeDG <<- 27 / 1000

    return(newgraph)
}


get_lipson2020_fig5a_extended_graph <- function() {
    leaves <- c("BakaDG",
                "FrenchDG",
                "HanDG",
                "MixeDG1",
                "MixeDG2",
                "UlchiDG")

    # Suppressed internal nodes: East2 and West2
    inner_nodes <- c("R",
                     "East0",
                     "East1",
                     "MixeDG",
                     "NA1",
                     "pAM1",
                     "West1")

    edges <- parent_edges(c(edge("BakaDG", "R"),
                            edge("NA1", "R"),
                            edge("East0", "NA1"),
                            edge("West1", "NA1"),
                            edge("HanDG", "East0"),
                            edge("East1", "East0"),
                            edge("UlchiDG", "East1"),
                            edge("FrenchDG", "West1"),
                            admixture_edge("pAM1", "West1", "East1", "w_West1_pAM1"),
                            edge("MixeDG", "pAM1"),
                            edge("MixeDG1", "MixeDG"),
                            edge("MixeDG2", "MixeDG")))

    newgraph <- agraph(leaves, inner_nodes, edges)

    # Admixture Weights
    w_West1_pAM1 <<- 0.24

    # Branch lengths
    edge_R_BakaDG <<- 28 / 1000
    edge_R_NA1 <<- 28 / 1000
    edge_NA1_East0 <<- 21 / 1000
    edge_NA1_West1 <<- 11 / 1000
    edge_East0_HanDG <<- 3 / 1000
    edge_East0_East1 <<- 2 / 1000
    edge_East1_UlchiDG <<- 4 / 1000
    edge_East1_pAM1 <<- 14 / 1000
    edge_West1_pAM1 <<- 1 / 1000
    edge_West1_FrenchDG <<- 2 / 1000
    edge_pAM1_MixeDG <<- 25 / 1000
    edge_MixeDG_MixeDG1 <<- 15 / 1000
    edge_MixeDG_MixeDG2 <<- 5 / 1000

    return(newgraph)
}

