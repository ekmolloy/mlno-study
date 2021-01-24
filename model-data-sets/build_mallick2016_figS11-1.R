#!/usr/bin/env Rscript

source("tools/admixturegraph_io.R")
source("tools/mallick2016_graphs.R")

mygraph <- get_mallick2016_figS11_1_simplified_graph()

pdf("mallick2016_figS11_1_simplified_graph_topology.pdf")
plot(mygraph, show_admixture_labels=FALSE)
dev.off()

write_graph_for_ntd(mygraph,
	"data/ntdgraph_mallick2016_figS11_1_simplified.txt",
	"data/ntdmap_mallick2016_figS11_1_simplified.txt")

myfile_f2 <- "data/modelf2mat_mallick2016_figS11_1_simplified.txt"
myfile_f2se <- "data/modelf2se_mallick2016_figS11_1_simplified.txt"
myf2 <- compute_modelf2(mygraph)
write_modelf2_for_treemix(myf2, myfile_f2, myfile_f2se)


myfile_f3 <- "data/modelf3_mallick2016_figS11_1_simplified.csv"
myfile_f3se <- "data/modelf3se_mallick2016_figS11_1_simplified.csv"
myf3 <- compute_modelf3(mygraph, "Chimp")
write_modelf3_for_miqograph(myf3, myfile_f3, myfile_f3se)
