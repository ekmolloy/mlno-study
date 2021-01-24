#!/usr/bin/env Rscript

source("tools/admixturegraph_io.R")
source("tools/patterson2012_graphs.R")

mygraph <- get_patterson2012_fig5_graph()

pdf("patterson2012_fig5_graph_topology.pdf")
plot(mygraph, show_admixture_labels=FALSE)
dev.off()

write_graph_for_ntd(mygraph,
	"data/ntdgraph_patterson2012_fig5.txt",
	"data/ntdmap_patterson2012_fig5.txt")

myfile_f2 <- "data/modelf2mat_patterson2012_fig5.txt"
myfile_f2se <- "data/modelf2se_patterson2012_fig5.txt"
myf2 <- compute_modelf2(mygraph)
write_modelf2_for_treemix(myf2, myfile_f2, myfile_f2se)


myfile_f3 <- "data/modelf3_patterson2012_fig5.csv"
myfile_f3se <- "data/modelf3se_patterson2012_fig5.csv"
myf3 <- compute_modelf3(mygraph, "Out")
write_modelf3_for_miqograph(myf3, myfile_f3, myfile_f3se)
