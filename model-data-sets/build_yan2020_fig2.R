#!/usr/bin/env Rscript

source("tools/admixturegraph_io.R")
source("tools/yan2020_graphs.R")

mygraph <- get_yan2020_fig2_graph()

pdf("yan2020_fig2_graph_topology.pdf")
plot(mygraph, show_admixture_labels=FALSE)
dev.off()

write_graph_for_ntd(mygraph,
	"data/ntdgraph_yan2020_fig2.txt",
	"data/ntdmap_yan2020_fig2.txt")

myfile_f2 <- "data/modelf2mat_yan2020_fig2.txt"
myfile_f2se <- "data/modelf2se_yan2020_fig2.txt"
myf2 <- compute_modelf2(mygraph)
write_modelf2_for_treemix(myf2, myfile_f2, myfile_f2se)


myfile_f3 <- "data/modelf3_yan2020_fig2.csv"
myfile_f3se <- "data/modelf3se_yan2020_fig2.csv"
myf3 <- compute_modelf3(mygraph, "Altai")
write_modelf3_for_miqograph(myf3, myfile_f3, myfile_f3se)
