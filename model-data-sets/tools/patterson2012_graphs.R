#!/usr/bin/env Rscript

library("admixturegraph")


get_patterson2012_fig5_graph <- function() {
    leaves <- c("Out", "A", "B", "C", "X")

    inner_nodes <- c("R", "Q", "AB", "BB", "CC", "XX")

    edges <- parent_edges(c(edge("Out", "R"),
                            edge("Q", "R"),
                            edge("AB", "Q"),
                            edge("CC", "Q"),
                            edge("C", "CC"),
                            edge("A", "AB"),
                            edge("BB", "AB"),
                            admixture_edge("XX", "BB", "CC", "w_BB_XX"),
                            edge("B", "BB"),
                            edge("X", "XX")))

    newgraph <- agraph(leaves, inner_nodes, edges)

    # Admixture proportions
    w_BB_XX <<- 0.30

	# Edge lengths
	edge_R_Out <<- 0
	edge_R_Q <<- 68 / 1000
	edge_Q_AB <<- 11 / 1000
	edge_Q_CC <<- 24 / 1000
	edge_C_CC <<- 12 / 1000
	edge_AB_A <<- 22 / 1000
	edge_AB_BB <<- 11 / 1000
	edge_BB_XX <<- 0
	edge_CC_XX <<- 0
	edge_CC_C <<- 12 / 1000
	edge_BB_B <<- 12 / 1000
	edge_XX_X <<- 6 / 1000

    return(newgraph)
}