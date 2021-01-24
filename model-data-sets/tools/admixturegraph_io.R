##!/usr/bin/env Rscript

#R
#install.packages("devtools")
#library("devtools")
#install_github("mailund/admixture_graph")
#install_github("wch/qstack")
#install.packages("hash")

library("hash")
library("qstack")
library("admixturegraph")


get_child_nodes <- function(mygraph, mynode) {
    return(mygraph$nodes[mygraph$children[mynode,]])
}


write_graph_for_ntd <- function(mygraph, myfile, myfile_map) {
    #The network N is stored in N.txt. 
    #The first line contains |V| and the remaining |V| 
    #lines contain the adjacency list of N. 
    #Every leaf has a label in {0,1,...,x-1}, 
    #the root of N has the label x and every other 
    #internal node has a label in {λ+1, ..., |V|}.
    mynodes <- mygraph$nodes
    nv <- length(mynodes)
    nl <- length(mygraph$leaves)

    # Write name map
    sink(myfile_map)
    hmap <- hash()
    for (i in 1:nv) {
        index <- i - 1
        label <- mynodes[i]
        hmap[label] <- index
        cat(index)
        cat(" ")
        cat(label)
        if (i <= nl) {
            cat(" TIP ")
        } else {
            cat(" NOT_TIP ")
        }
        if (i == nl+1) {
            cat("ROOT")
        } else {
            cat("NOT_ROOT")
        }
        cat("\n")
    }
    sink()

    # Write graph
    sink(myfile)
    cat(nv)
    cat("\n")    

    found <- c()
    q <- Queue()
    q$add(.list=as.list("R"))

    while (q$size() > 0) {
        node <- q$remove()
        cat(hmap[[node]])
        cat(" ")
        found <- union(found, c(node))

        children <- get_child_nodes(mygraph, node)
        nc = length(children)
        if (nc > 0) {
            for (j in 1:nc) {
                child <- children[j]
                cat(" ")
                cat(hmap[[child]])
                if (!(child %in% found)) {
                    q$add(child)
                    found <- union(found, c(child))
                }
            }
        }

        cat("\n")
    }
    sink()
}


compute_modelf2 <- function(mygraph) {
    # See Lipson, 2020
    # f2(A, B) = f4(A, B; A, B)
    myleaves <- mygraph$leaves
    n <- length(myleaves)

    A <- c()
    B <- c()
    f2 <- c()

    k <- 1
    for (i in 1:(n-1)) {
        for (j in (i+1):n) {
            A[k] <- myleaves[i]
            B[k] <- myleaves[j]
            f4expr <- sf4(mygraph, A[k], B[k], A[k], B[k])
            f2[k] <- eval(f4expr)
            k <- k + 1
        }
    }

    newdata <- data.frame(A, B, f2)

    return(newdata)
}


write_modelf2_for_treemix <- function(mydata, myfile_f2, myfile_f2se) {
    myleaves <- append(as.character(mydata$A), as.character(mydata$B))
    myleaves <- factor(myleaves)
    myleaves <- levels(myleaves)
    n <- length(myleaves)

    # Write f2-statistics
    sink(myfile_f2)
    cat(myleaves[1])
    for (i in 2:n) {
        cat(" ")
        cat(myleaves[i])
    }
    cat("\n")
    for (i in 1:n) {
        cat(myleaves[i])
        for (j in 1:n) {
            cat(" ")
            if (i == j) {
                cat("0")
            } else {
                tmp1 <- mydata[which(mydata$A == myleaves[i]),]
                tmp2 <- tmp1[which(tmp1$B == myleaves[j]), ]
                if (nrow(tmp2) != 1) {
                    tmp1 <- mydata[which(mydata$A == myleaves[j]),]
                    tmp2 <- tmp1[which(tmp1$B == myleaves[i]), ]
                }
                cat(tmp2$f2)
            }
        }
        cat("\n")
    }
    sink()

    # Write small standard error
    sink(myfile_f2se)
    cat(myleaves[1])
    for (i in 2:n) {
        cat(" ")
        cat(myleaves[i])
    }
    cat("\n")
    for (i in 1:n) {
        cat(myleaves[i])
        for (j in 1:n) {
            cat(" ")
            if (i == j) {
                    cat("0")
                } else {
                    cat("0.0001")
            }
        }
        cat("\n")
    }
    sink()
}


write_modelf2_for_admixturegraph <- function(mydata, myfile) {
    n <- nrow(mydata)

    W <- c()
    X <- c()
    Y <- c()
    Z <- c()
    D <- c()

    k <- 1
    for (i in 1:n) {
        W[k] <- as.character(mydata[i, 1])
        X[k] <- as.character(mydata[i, 2])
        Y[k] <- as.character(mydata[i, 1])
        Z[k] <- as.character(mydata[i, 2])
        D[k] <- mydata[i, 3]
        k <- k + 1
    }

    newdata <- data.frame(W, X, Y, Z, D)

    write.table(newdata,
                file=myfile,
                sep=",",
                quote=FALSE,
                row.names=FALSE,
                col.names=TRUE)

    return(newdata)
}


compute_modelf3 <- function(mygraph, myoutgroup) {
    # See Lipson, 2020
    # f3(X; A, B) = f4(X, A; X, B)
    myleaves <- mygraph$leaves
    myleaves <- myleaves[myleaves != myoutgroup]
    n <- length(myleaves)

    Outgroup <- c()
    A <- c()
    B <- c()
    f3 <- c()

    k <- 1
    for (i in 1:n) {
        for (j in i:n) {
            Outgroup[k] <- myoutgroup
            A[k] <- myleaves[i]
            B[k] <- myleaves[j]
            f4expr <- sf4(mygraph, Outgroup[k], A[k], Outgroup[k], B[k])
            f3[k] <- eval(f4expr)
            k <- k + 1
        }
    }

    newdata <- data.frame(Outgroup, A, B, f3)

    return(newdata)
}


write_modelf3_for_miqograph <- function(mydata, myfile_f3, myfilef3_se) {
    mydata$f3 <- mydata$f3 * 1000
    write.table(mydata,
                file=myfile_f3,
                sep=",",
                quote=FALSE,
                row.names=FALSE,
                col.names=TRUE)

    A1 <- c()
    B1 <- c()
    A2 <- c()
    B2 <- c()
    covariance <- c()

    n <- nrow(mydata)
    k <- 1
    for (i in 1:n) {
        for (j in i:n) {
            A1[k] <- as.character(mydata[i, 2])
            B1[k] <- as.character(mydata[i, 3])
            A2[k] <- as.character(mydata[j, 2])
            B2[k] <- as.character(mydata[j, 3])
            if ((A1[k] == A2[k]) && (B1[k] == B2[k])) {
                covariance[k] <- 1
            } else {
                covariance[k] <- 0
            }
            k <- k + 1
        }
    }

    newdata <- data.frame(A1, B1, A2, B2, covariance)
    write.table(newdata,
                file=myfile_f3se,
                sep=",",
                quote=FALSE,
                row.names=FALSE,
                col.names=TRUE)
}


write_modelf3_for_admixturegraph <- function(mydata, myfile) {
    n <- nrow(mydata)

    W <- c()
    X <- c()
    Y <- c()
    Z <- c()
    D <- c()

    k <- 1
    for (i in 1:n) {
        W[k] <- as.character(mydata[i, 1])
        X[k] <- as.character(mydata[i, 2])
        Y[k] <- as.character(mydata[i, 1])
        Z[k] <- as.character(mydata[i, 3])
        D[k] <- mydata[i, 4]
        k <- k + 1
    }

    newdata <- data.frame(W, X, Y, Z, D)

    write.table(newdata,
                file=myfile,
                sep=",",
                quote=FALSE,
                row.names=FALSE,
                col.names=TRUE)

    return(newdata)
}
