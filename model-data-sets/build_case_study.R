#!/usr/bin/env Rscript

source("tools/admixturegraph_io.R")
source("tools/case_study_graphs.R")

mygraph <- get_case_study_graph()

pdf("case_study_graph_topology.pdf")
plot(mygraph, show_admixture_labels=FALSE)
dev.off()

write_graph_for_ntd(mygraph,
	"data/ntdgraph_case_study.txt",
	"data/ntdmap_case_study.txt")

myfile_f2 <- "data/modelf2mat_case_study.txt"
myfile_f2se <- "data/modelf2se_case_study.txt"
myf2 <- compute_modelf2(mygraph)
write_modelf2_for_treemix(myf2, myfile_f2, myfile_f2se)


myfile_f3 <- "data/modelf3_case_study.csv"
myfile_f3se <- "data/modelf3se_case_study.csv"
myf3 <- compute_modelf3(mygraph, "popE")
write_modelf3_for_miqograph(myf3, myfile_f3, myfile_f3se)
