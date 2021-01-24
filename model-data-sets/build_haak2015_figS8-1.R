#!/usr/bin/env Rscript

source("tools/admixturegraph_io.R")
source("tools/haak2015_graphs.R")

mygraph <- get_haak2015_figS8_1_graph()

pdf("haak2015_figS8_1_graph_topology.pdf")
plot(mygraph, show_admixture_labels=FALSE)
dev.off()

write_graph_for_ntd(mygraph,
	"data/ntdgraph_haak2015_figS8-1.txt",
	"data/ntdmap_haak2015_figS8-1.txt")

myfile_f2 <- "data/modelf2mat_haak2015_figS8-1.txt"
myfile_f2se <- "data/modelf2se_haak2015_figS8-1.txt"
myf2 <- compute_modelf2(mygraph)
write_modelf2_for_treemix(myf2, myfile_f2, myfile_f2se)


myfile_f3 <- "data/modelf3_haak2015_figS8-1.csv"
myfile_f3se <- "data/modelf3se_haak2015_figS8-1.csv"
myf3 <- compute_modelf3(mygraph, "Mbuti")
write_modelf3_for_miqograph(myf3, myfile_f3, myfile_f3se)
