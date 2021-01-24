#!/usr/bin/env Rscript

library("admixturegraph")


get_yan2020_fig2_graph <- function() {
    leaves <- c("Altai",
                "ANE",
                "Dai",
                "Karitiana",
                "Mbuti",
                "Onge")

    inner_nodes <- c("R",
                     "EE",
                     "Human",
                     "OOA",
                     "postAsia",
                     "preANE",
                     "preEE",
                     "WE")

    edges <- parent_edges(c(edge("Altai", "R"),
                            edge("Human", "R"),
                            edge("Mbuti", "Human"),
                            edge("OOA", "Human"),
                            edge("EE", "OOA"),
                            edge("WE", "OOA"),
                            edge("preANE", "WE"),
                            edge("Onge", "EE"),
                            edge("preEE", "EE"),
                            edge("ANE", "preANE"),
                            edge("Dai", "preEE"),
                            admixture_edge("postAsia", "preANE", "preEE", "w_preANE_postAsia"),
                            edge("Karitiana", "postAsia")))
 
    newgraph <- agraph(leaves, inner_nodes, edges)

    # Admixture proportions
    w_preANE_postAsia <<- 0.25

    # Edge lengths in coalescent units
    edge_R_Altai <<- 517 / 1000
    edge_R_Human <<- 0
    edge_Human_Mbuti <<- 36 / 1000
    edge_Human_OOA <<- 155 / 1000
    edge_OOA_EE <<- 20 / 1000
    edge_OOA_WE <<- 0
    edge_WE_preANE <<- 120 / 1000
    edge_EE_Onge <<- 96 / 1000
    edge_EE_preEE <<- 27 / 1000
    edge_preANE_ANE <<- 104 / 1000
    edge_preANE_postAsia <<- 0          # Admixture edge
    edge_preEE_Dai <<- 16 / 1000
    edge_preEE_postAsia <<- 238 / 1000  # Admixture edge
    edge_postAsia_Karitiana <<- 0

    return(newgraph)
}
