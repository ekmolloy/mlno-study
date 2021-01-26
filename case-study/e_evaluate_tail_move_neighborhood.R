#!/usr/bin/env Rscript

source("case_study_graph_topologies.R")
source("../tools/admixturegraph_helper_functions.R")


# Read data file
mydata <- read.table("data/a_true_input_data.csv", sep=",")

# Define tree-based minimum residual (TBMR) graph
tbmr_graph <- get_case_study_tbmr_graph_topology()
tbmr_vec <- canonise_graph(tbmr_graph)

# Define true graph
true_graph <- get_case_study_true_graph_topology()
true_vec <- canonise_graph(true_graph)

# Look at all graphs one tail move away from TBMR graph
neighborhood <- do_all_tail_moves(tbmr_graph)

SSR <- c()
MATCH_TBMR <- c()
MATCH_TRUE <- c()

for (i in 1:length(neighborhood)) {
    mygraph <- neighborhood[[i]]
    myvec <- canonise_graph(mygraph)

    # Compare graphs
    MATCH_TBMR[i] <- FALSE
    if (isTRUE(all.equal(tbmr_vec, myvec))) {
        MATCH_TBMR[i] <- TRUE
    }

    MATCH_TRUE[i] <- FALSE
    if (isTRUE(all.equal(true_vec, myvec))) {
        MATCH_TRUE[i] <- TRUE
    }

    # Fit graph
    myfit <- fit_graph(mydata,
                       mygraph,
                       Z.value=FALSE,
                       parameters=extract_graph_parameters(mygraph),
                       qr_tol=1e-12)
    SSR[i] <- sum_of_squared_errors(myfit)

    # Plot graph
    pdf(paste("data/e_tbmr_tail_move/e_tbmr_tail_move_", i, ".pdf", sep=""))
    plot(mygraph, show_admixture_labels=TRUE)
    dev.off()
}

INDEX <- order(SSR)
SSR <- SSR[INDEX]
MATCH_TBMR <- MATCH_TBMR[INDEX]
MATCH_TRUE <- MATCH_TRUE[INDEX]

write.table(cbind(INDEX, SSR, MATCH_TBMR, MATCH_TRUE),
            file="data/e_tbmr_tail_move.csv", sep=",")


# Checked that pictures look good except

#print("47 ranked -> 42")
#print_graph(neighborhood[[42]])
# PARENT -> CHILD
#[1] "   R -> v1 [  ]"  "   R -> v5 [ w ]"
#[1] "   v1 -> vB [  ]" "   v1 -> v2 [  ]"
#[1] "   v2 -> vA [  ]" "   v2 -> v3 [  ]"
#[1] "   v3 -> v4 [  ]" "   v3 -> v5 [ (1 - w) ]"
#[1] "   v4 -> vC [  ]" "   v4 -> vD [  ]"
#[1] "   v5 -> vE [  ]"
# NOTE: It looks like tree (E,(B,(A,(C,D))));
#       with admixture edge
#       from edge above node (C,D) to terminal edge for E
# Don't think admixture can draw without lines crossing

#print("49 ranked -> 25")
#print_graph(neighborhood[[25]])
# PARENT -> CHILD
#[1] "   R -> v1 [  ]"  "   R -> v4 [  ]"
#[1] "   v1 -> v2 [  ]" "   v1 -> v3 [  ]"
#[1] "   v2 -> vA [  ]" "   v2 -> v5 [ (1 - w) ]"
#[1] "   v3 -> vB [  ]" "   v3 -> vD [  ]"
#[1] "   v4 -> vC [  ]" "   v4 -> v5 [ w ]"
#[1] "   v5 -> vE [  ]"
# NOTE: It looks like tree (((A,E),(B,D)),C);
#       with admixture edge
#       from terminal edge for C to terminal edge for E
# Don't think admixture can draw without lines crossing

