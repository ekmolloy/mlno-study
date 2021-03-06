#!/usr/bin/env Rscript

source("tools/admixturegraph_io.R")
source("tools/wu2020_graphs.R")

mygraph <- get_wu2020_fig7a_graph()

pdf("wu2020_fig7a_graph_topology.pdf")
plot(mygraph, show_admixture_labels=FALSE)
dev.off()

write_graph_for_ntd(mygraph,
	"data/ntdgraph_wu2020_fig7a.txt",
	"data/ntdmap_wu2020_fig7a.txt")

myfile_f2 <- "data/modelf2mat_wu2020_fig7a.txt"
myfile_f2se <- "data/modelf2se_wu2020_fig7a.txt"
myf2 <- compute_modelf2(mygraph)
write_modelf2_for_treemix(myf2, myfile_f2, myfile_f2se)


myfile_f3 <- "data/modelf3_wu2020_fig7a.csv"
myfile_f3se <- "data/modelf3se_wu2020_fig7a.csv"
myf3 <- compute_modelf3(mygraph, "YRI")
write_modelf3_for_miqograph(myf3, myfile_f3, myfile_f3se)
