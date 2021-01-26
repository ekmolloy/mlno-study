##!/usr/bin/env Rscript

source("case_study_graph_topologies.R")
source("../tools/admixturegraph_helper_functions.R") 


# Change doit parameter to test different rootings
# Skip 1 and 2; Go 3 through 11
# DONE: 3, 4, 5, 6, 7, 8, 9, 10, 11
doit <- 3

# Read data file
mydata <- read.table("data/a_true_input_data.csv", sep=",")

# Tree-based minimum residual (TBMR) graph
tbmr_graph <- get_case_study_tbmr_graph_topology()

# True graph - end graph
egraph <- get_case_study_true_graph_topology()
evec <- canonise_graph(egraph)

# Check how many tail moves it takes to get
# from the TBMR graph to the TRUE graph 
edges <- get_edges(tbmr_graph)
edge <- edges[[doit]]  
elab <- paste(edge$parent, "to", edge$child, sep="")
print(elab)

# Reroot start graph at edge
sgraph <- reroot(tbmr_graph, edge)
svec <- canonise_graph(sgraph)

# Check how many tail moves are required to get
# from the TBMR graph to the true graph
steps <- c("step0", "step1", "step2",
           "step3", "step4", "step5")
nsteps <- length(steps)

graphs <- list(step0=c(), step1=c(), step2=c(),
               step3=c(), step4=c(), step5=c())
moves <- list(step0=c(), step1=c(), step2=c(),
              step3=c(), step4=c(), step5=c())

graphs[["step0"]][[1]] <- sgraph
moves[["step0"]][[1]] <- 0

for (s in 2:nsteps) {
    last <- steps[s-1]
    curr <- steps[s]

    k <- 1
    for (i in 1:length(graphs[[last]])) {
        neighborhood <- do_all_tail_moves(graphs[[last]][[i]])
        for (j in 1:length(neighborhood)) {
            print(paste(curr, "| i = ", i, "| j = ", j, "| k = ", k))

            mygraph <- neighborhood[[j]]
            myvec <- canonise_graph(mygraph)

            graphs[[curr]][[k]] <- mygraph
            moves[[curr]][[k]] <- i

            if (isTRUE(all.equal(myvec, evec))) {
                SSR <- c()
                STEP <- c()
                l <- 1
                for (r in s:1) {
                    m <- steps[r]
                    mygraph <- graphs[[m]][[k]]
                    k <- moves[[m]][[k]]

                    # Plot graph
                    pdf(paste("data/f_true_from_tbmr/f_true_from_tbmr_at_", elab, "_", m, ".pdf", sep=""))
                    plot(mygraph, show_admixture_labels=TRUE)
                    dev.off()

                    # Fit graph
                    myfit <- fit_graph(mydata,
                                       mygraph,
                                       Z.value=FALSE,
                                       parameters=extract_graph_parameters(mygraph),
                                       qr_tol=1e-12)

                    STEP[l] <- m
                    SSR[l] <- sum_of_squared_errors(myfit)
                    l <- l + 1
                }
                write.table(cbind(STEP, SSR),
                            file=paste("data/f_true_from_tbmr/f_true_from_tbmr_at_", elab, ".csv", sep=""),
                            sep=",")
                quit()               
            }
            k <- k + 1
        }
    }
}
