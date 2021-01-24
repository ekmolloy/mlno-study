#!/usr/bin/env Rscript

library("admixturegraph")

get_haak2015_figS8_1_graph <- function() {
    # Figure 6b
    leaves <- c("Karitiana",
                "LBK_EN",
                "Loschbour",
                "MA1",
                "Mbuti",
                "Onge")

    inner_nodes <- c("R",
                     "AncientNorthEurasian",
                     "EasternnonAfrican",
                     "nonAfrican",
                     "pKaritiana",
                     "pLBK_EN",
                     "WesternEurasian",
                     "X",
                     "W")

    edges <- parent_edges(c(edge("Mbuti", "R"),
                            edge("nonAfrican", "R"),
                            edge("X", "nonAfrican"),
                            edge("EasternnonAfrican", "X"),
                            edge("W", "X"),
                            edge("AncientNorthEurasian", "W"),
                            edge("WesternEurasian", "W"),
                            edge("Onge", "EasternnonAfrican"),
                            edge("MA1", "AncientNorthEurasian"),
                            edge("Loschbour", "WesternEurasian"),
                            admixture_edge("pKaritiana", "AncientNorthEurasian", "EasternnonAfrican", "w_AncientNorthEurasian_pKaritiana"),
                            admixture_edge("pLBK_EN", "nonAfrican", "WesternEurasian", "w_nonAfrican_pLBK_EN"),
                            edge("Karitiana", "pKaritiana"),
                            edge("LBK_EN", "pLBK_EN")))

    newgraph <- agraph(leaves, inner_nodes, edges)

    # Define admixture proportions
    w_nonAfrican_pLBK_EN <<- 0.23
    w_AncientNorthEurasian_pKaritiana <<- 0.39

    # Define edge lengths in coalescent units and edge labels
    edge_R_Mbuti <<- 0
    edge_R_nonAfrican <<- 158 / 1000
    edge_nonAfrican_pLBK_EN <<- 3 / 1000
    edge_nonAfrican_X <<- 52 / 1000
    edge_X_EasternnonAfrican <<- 21 / 1000
    edge_X_W <<- 24 / 1000
    edge_W_AncientNorthEurasian <<- 55 / 1000
    edge_W_WesternEurasian <<- 27 / 1000
    edge_EasternnonAfrican_Onge <<- 89 / 1000
    edge_EasternnonAfrican_pKaritiana <<- 45 / 1000
    edge_AncientNorthEurasian_MA1 <<- 387 / 1000
    edge_AncientNorthEurasian_pKaritiana <<- 19 / 1000
    edge_WesternEurasian_pLBK_EN <<- 33 / 1000
    edge_WesternEurasian_Loschbour <<- 83 / 1000
    edge_pKaritiana_Karitiana <<- 123 / 1000
    edge_pLBK_EN_LBK_EN <<- 57 / 1000

    return(newgraph)
}


get_haak2015_figS8_1_left_graph <- function() {
    newgraph <- get_haak2015_sfig8_1_graph()
    w_nonAfrican_pLBK_EN <<- 0.0
    return(newgraph)
}


get_haak2015_figS8_1_right_graph <- function() {
    newgraph <- get_haak2015_sfig8_1_graph()
    w_AncientNorthEurasian_pKaritiana <<- 0.0
    return(newgraph)
}
