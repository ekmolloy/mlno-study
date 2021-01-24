#!/usr/bin/env Rscript

source("tools/admixturegraph_io.R")
source("tools/lipson2020_graphs.R")

mygraph <- get_lipson2020_fig5a_graph()

pdf("lipson2020_fig5a_graph_topology.pdf")
plot(mygraph, show_admixture_labels=FALSE)
dev.off()

write_graph_for_ntd(mygraph,
	"data/ntdgraph_lipson2020_fig5a.txt",
	"data/ntdmap_lipson2020_fig5a.txt")

myfile_f2 <- "data/modelf2mat_lipson2020_fig5a.txt"
myfile_f2se <- "data/modelf2se_lipson2020_fig5a.txt"
myf2 <- compute_modelf2(mygraph)
write_modelf2_for_treemix(myf2, myfile_f2, myfile_f2se)


myfile_f3 <- "data/modelf3_lipson2020_fig5a.csv"
myfile_f3se <- "data/modelf3se_lipson2020_fig5a.csv"
myf3 <- compute_modelf3(mygraph, "BakaDG")
write_modelf3_for_miqograph(myf3, myfile_f3, myfile_f3se)
