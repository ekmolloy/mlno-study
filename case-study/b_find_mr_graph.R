#!/usr/bin/env Rscript

library("admixturegraph")


# Read data file
mydata <- read.table("data/a_true_input_data.csv", sep=",")

# Get leaf labels
leaves <- unique(c(levels(mydata$W),
                   levels(mydata$X),
                   levels(mydata$Y),
                   levels(mydata$Z)))

# Fit each graph with one admixture event and save SSR
mygraphs <- all_graphs(leaves, 1)
SSR <- c()
j <- 1
for (i in 1:length(mygraphs)) {
    myfit <- fit_graph(mydata,
                       mygraphs[[i]],
                       Z.value=FALSE,
                       parameters=extract_graph_parameters(mygraphs[[i]]),
                       qr_tol=1e-12)
    SSR[j] <- sum_of_squared_errors(myfit)
    j <- j + 1
}


# Sort graphs by residuals and write to table
INDEX <- order(SSR)
SSR <- SSR[INDEX]
write.table(cbind(INDEX, SSR), file="data/b_allk1.csv", sep=",")


# Plot graphs with lowest residuals
for (i in 1:5) {
    if ((i == 1) || (i == 3) || (i == 4)) {
        toplot <- make_an_outgroup(mygraphs[[INDEX[i]]],
                                   outgroup="vE",
                                   all_neutral=FALSE)

        pdf(paste("data/b_allk1/b_allk1_mr", i, ".pdf", sep=""))
        plot(toplot, show_admixture_labels=TRUE)
        dev.off()
    } else if ((i == 2) || (i = 5)) {
        toplot <- make_an_outgroup(mygraphs[[INDEX[i]]],
                                   outgroup="vC",
                                   all_neutral=FALSE)

        pdf(paste("data/b_allk1/b_allk1_mr", i, ".pdf", sep=""))
        plot(toplot, show_admixture_labels=TRUE)
        dev.off()
    }
}
