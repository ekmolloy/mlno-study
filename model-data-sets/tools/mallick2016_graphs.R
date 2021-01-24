#!/usr/bin/env Rscript

library("admixturegraph")


get_mallick2016_figS11_1_deni_graph <- function() {
    leaves <- c("Altai",
                "Ami",
                "Australian",
                "Chimp",
                "Dai",
                "Denisovan",
                "Dinka",
                "Kostenki14",
                "Onge",
                "Papuan")

    inner_nodes <- c("R",
                     "archaic1",
                     "archaic2",
                     "Australasia1",
                     "Australasia3",
                     "Australasia4",
                     "Den",
                     "East1",
                     "EastAsian",
                     "modern",
                     "nonAfrican")

    edges <- parent_edges(c(edge("Chimp", "R"),
                            edge("archaic1", "R"),
                            edge("archaic2", "archaic1"),
                            edge("modern", "archaic1"),
                            edge("Den", "archaic2"),
                            edge("Denisovan", "Den"),
                            edge("Altai", "archaic2"),
                            edge("Dinka", "modern"),
                            edge("nonAfrican", "modern"),
                            edge("East1", "nonAfrican"),
                            edge("Kostenki14", "nonAfrican"),
                            edge("EastAsian", "East1"),
                            edge("Australasia1", "East1"),
                            edge("Ami", "EastAsian"),
                            edge("Dai", "EastAsian"),
                            edge("Onge", "Australasia1"),
                            admixture_edge("Australasia3", "Den", "Australasia1", "w_Den_Australasia3"),
                            edge("Australasia4", "Australasia3"),
                            edge("Papuan", "Australasia4"),
                            edge("Australian", "Australasia4")))

    newgraph <- agraph(leaves, inner_nodes, edges)
    #

    # Admixture Weights
    w_Den_Australasia3 <<- 0.03

    # Branch lengths
    edge_R_Chimp <<- 57 / 1000
    edge_R_archaic1 <<- 84 / 1000
    edge_archaic1_archaic2 <<- 39 / 1000
    edge_archaic1_modern <<- 80 / 1000
    edge_archaic2_Den <<- (24 + 25) / 1000
    edge_Den_Denisovan <<- 29 / 1000
    edge_Den_Australasia3 <<- 0
    edge_archaic2_Altai <<- (33 + 41) / 1000
    edge_modern_Dinka <<- 1  / 1000
    edge_modern_nonAfrican <<- (18 + 20) / 1000
    edge_nonAfrican_East1 <<- 7 / 1000
    edge_nonAfrican_Kostenki14 <<- (69 + 71) / 1000
    edge_East1_EastAsian <<- 12 / 1000
    edge_East1_Australasia1 <<- 1 / 1000
    edge_EastAsian_Ami <<- 6 / 1000
    edge_EastAsian_Dai <<- 1 / 1000
    edge_Australasia1_Onge <<- 26 / 1000
    edge_Australasia1_Australasia3 <<- 10 / 1000
    edge_Australasia3_Australasia4 <<- 11 / 1000
    edge_Australasia4_Australian <<- 15 / 1000
    edge_Australasia4_Papuan <<- 12 / 1000

    return(newgraph)
}


get_mallick2016_figS11_1_nean_graph <- function() {
    leaves <- c("Altai",
                "Ami",
                "Australian",
                "Chimp",
                "Dai",
                "Denisovan",
                "Dinka",
                "Kostenki14",
                "Onge",
                "Papuan")

    inner_nodes <- c("R",
                     "archaic1",
                     "archaic2",
                     "Australasia1",
                     "Australasia3",
                     "East1",
                     "EastAsian",
                     "modern",
                     "Nean",
                     "OoA2",
                     "nonAfrican")

    edges <- parent_edges(c(edge("Chimp", "R"),
                            edge("archaic1", "R"),
                            edge("archaic2", "archaic1"),
                            edge("modern", "archaic1"),
                            edge("Denisovan", "archaic2"),
                            edge("Nean", "archaic2"),
                            edge("Altai", "Nean"),
                            edge("Dinka", "modern"),
                            admixture_edge("OoA2", "Nean", "modern", "w_Nean_OoA2"),
                            edge("nonAfrican", "OoA2"),
                            edge("East1", "nonAfrican"),
                            edge("Kostenki14", "nonAfrican"),
                            edge("EastAsian", "East1"),
                            edge("Australasia1", "East1"),
                            edge("Ami", "EastAsian"),
                            edge("Dai", "EastAsian"),
                            edge("Onge", "Australasia1"),
                            edge("Australasia3", "Australasia1"),
                            edge("Papuan", "Australasia3"),
                            edge("Australian", "Australasia3")))

    newgraph <- agraph(leaves, inner_nodes, edges)

    # Admixture Weights
    w_Nean_OoA2 <<- 0.04

    # Branch lengths
    edge_R_Chimp <<- 57 / 1000
    edge_R_archaic1 <<- 84 / 1000
    edge_archaic1_archaic2 <<- 39 / 1000
    edge_archaic1_modern <<- 80 / 1000
    edge_archaic2_Denisovan <<- (24 + 25 + 29) / 1000
    edge_archaic2_Nean <<- 33 / 1000
    edge_Nean_Altai <<- 41 / 1000
    edge_Nean_OoA2 <<- 0
    edge_modern_Dinka <<- 1  / 1000
    edge_modern_OoA2 <<- 18 / 1000
    edge_OoA2_nonAfrican <<- 20 / 1000
    edge_nonAfrican_East1 <<- 7 / 1000
    edge_nonAfrican_Kostenki14 <<- (69 + 71) / 1000
    edge_East1_EastAsian <<- 12 / 1000
    edge_East1_Australasia1 <<- 1 / 1000
    edge_EastAsian_Ami <<- 6 / 1000
    edge_EastAsian_Dai <<- 1 / 1000
    edge_Australasia1_Onge <<- 26 / 1000
    edge_Australasia1_Australasia3 <<- 10 / 1000
    edge_Australasia3_Australian <<- (11 + 15) / 1000
    edge_Australasia3_Papuan <<- (11 + 12) / 1000

    return(newgraph)
}



get_mallick2016_figS11_1_simplified_graph <- function() {
    leaves <- c("Altai",
                "Ami",
                "Australian",
                "Chimp",
                "Dai",
                "Denisovan",
                "Dinka",
                "Kostenki14",
                "Onge",
                "Papuan")

    inner_nodes <- c("R",
                     "archaic1",
                     "archaic2",
                     "Australasia1",
                     "Australasia3",
                     "Australasia4",
                     "Den",
                     "East1",
                     "EastAsian",
                     "modern",
                     "Nean",
                     "OoA2",
                     "nonAfrican")

    edges <- parent_edges(c(edge("Chimp", "R"),
                            edge("archaic1", "R"),
                            edge("archaic2", "archaic1"),
                            edge("modern", "archaic1"),
                            edge("Den", "archaic2"),
                            edge("Denisovan", "Den"),
                            edge("Nean", "archaic2"),
                            edge("Altai", "Nean"),
                            edge("Dinka", "modern"),
                            admixture_edge("OoA2", "Nean", "modern", "w_Nean_OoA2"),
                            edge("nonAfrican", "OoA2"),
                            edge("East1", "nonAfrican"),
                            edge("Kostenki14", "nonAfrican"),
                            edge("EastAsian", "East1"),
                            edge("Australasia1", "East1"),
                            edge("Ami", "EastAsian"),
                            edge("Dai", "EastAsian"),
                            edge("Onge", "Australasia1"),
                            admixture_edge("Australasia3", "Den", "Australasia1", "w_Den_Australasia3"),
                            edge("Australasia4", "Australasia3"),
                            edge("Papuan", "Australasia4"),
                            edge("Australian", "Australasia4")))

    newgraph <- agraph(leaves, inner_nodes, edges)

    # Admixture Weights
    w_Nean_OoA2 <<- 0.04
    w_Den_Australasia3 <<- 0.03

    # Branch lengths
    edge_R_Chimp <<- 57 / 1000
    edge_R_archaic1 <<- 84 / 1000
    edge_archaic1_archaic2 <<- 39 / 1000
    edge_archaic1_modern <<- 80 / 1000
    edge_archaic2_Den <<- (24 + 25) / 1000
    edge_Den_Denisovan <<- 29 / 1000
    edge_Den_Australasia3 <<- 0
    edge_archaic2_Nean <<- 33 / 1000
    edge_Nean_Altai <<- 41 / 1000
    edge_Nean_OoA2 <<- 0
    edge_modern_Dinka <<- 1  / 1000
    edge_modern_OoA2 <<- 18 / 1000
    edge_OoA2_nonAfrican <<- 20 / 1000
    edge_nonAfrican_East1 <<- 7 / 1000
    edge_nonAfrican_Kostenki14 <<- (69 + 71) / 1000
    edge_East1_EastAsian <<- 12 / 1000
    edge_East1_Australasia1 <<- 1 / 1000
    edge_EastAsian_Ami <<- 6 / 1000
    edge_EastAsian_Dai <<- 1 / 1000
    edge_Australasia1_Onge <<- 26 / 1000
    edge_Australasia1_Australasia3 <<- 10 / 1000
    edge_Australasia3_Australasia4 <<- 11 / 1000
    edge_Australasia4_Australian <<- 15 / 1000
    edge_Australasia4_Papuan <<- 12 / 1000

    return(newgraph)
}
