#!/usr/bin/env Rscript

library("admixturegraph")


# Read data file
mydata <- read.table("data/a_true_input_data.csv", sep=",")

# Get leaf labels
leaves <- unique(c(levels(mydata$W),
                   levels(mydata$X),
                   levels(mydata$Y),
                   levels(mydata$Z)))


# Fit each tree and save SSR
mytrees <- all_graphs(leaves, 0)
SSR <- c()
j <- 1
for (i in 1:length(mytrees)) {
    myfit <- fit_graph(mydata,
                       mytrees[[i]],
                       Z.value=FALSE,
                       parameters=extract_graph_parameters(mytrees[[i]]),
                       qr_tol=1e-12)
    SSR[j] <- sum_of_squared_errors(myfit)
    j <- j + 1
}

# Sort trees by residuals and write to table
INDEX <- order(SSR)
SSR <- SSR[INDEX]
write.table(cbind(INDEX, SSR), file="../data/c_allk0.csv", sep=",")

# Plot trees
for (i in 1:length(INDEX)) {
  toplot <- make_an_outgroup(mytrees[[INDEX[i]]],
                             outgroup="vE",
                             all_neutral=FALSE)

  pdf(paste("data/c_allk0/c_allk0_mr", i, ".pdf", sep=""))
  plot(toplot, show_admixture_labels=TRUE)
  dev.off()
}
