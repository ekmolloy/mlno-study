##!/usr/bin/env Rscript

library("admixturegraph")
source("tools/admixturegraph_helper_functions.R")

library("hash")

to_treemix <- function(mygraph, myfile) {
	# Write node file
	hmap <- hash()
	mynodes <- mygraph$nodes
    nv <- length(mynodes)
    sink(paste(myfile, ".vertices", sep=""))
    for (i in 1:nv) {
        index <- i
        mynode <- mynodes[i]

        np <- length(get_parent_nodes(mygraph, mynode))
        children <- get_child_nodes(mygraph, mynode)
        nc = length(children)

        if ((np == 2) && (nc == 1)) {
        	# do nothing
        } else {
            hmap[mynode] <- index
            cat(index)
        	if (nc == 0) {
        		cat(" ")
        		cat(mynode)
        	} else {
        		cat(" NA")
        	}

        	if (np == 0) {
            	cat(" ROOT")
        	} else {
            	cat(" NOT_ROOT")
        	}

        	found_mig <- FALSE
        	if (nc > 0) {
        		for (j in 1:nc) {
        			myedge <- list(parent=mynode, child=children[j])
        			myweight <- get_edge_weight(mygraph, myedge)
    				if (myweight == "w") {
    					found_mig <- TRUE
    				}
    			}
    		}

        	if (found_mig) {
        		cat(" MIG")
        	} else {
        		cat(" NOT_MIG")
        	}

        	if (nc == 0) {
            	cat(" TIP ")
        	} else {
            	cat(" NOT_TIP ")
        	}

        	cat("\n")
        }
    }
    sink()


    # Write edge file
    myedges <- get_edges(mygraph)
    ne <- length(myedges)

    sink(paste(myfile, ".edges", sep=""))
    for (i in 1:ne) {
    	myedge <- myedges[[i]]
    	myweight <- get_edge_weight(mygraph, myedge)
        #print(paste("HANDLING edge", myedge$parent, "->", myedge$child))

    	npp <- length(get_parent_nodes(mygraph, myedge$parent))
    	cc <- get_child_nodes(mygraph, myedge$child)
    	ncc <- length(cc)

    	if (npp == 2) {
    		# Suppress this edge
            #print(paste("    Suppressing edge", myedge$parent, "->", myedge$child))
    	} else {
    		# Parent is migration target
    		if (myweight != "") {
                #print("Re-routing edge")
                #print(myedge)
    			cat(hmap[[myedge$parent]])
    			cat(" ")
    			tmp <- cc[[1]]
    			cat(hmap[[tmp]])  # Reroute!
    			
    			if (myweight == "w") {
                    #print(paste("    Re-routing migration source"))
    				cat(" 0 0.10 MIG 1\n")
    			} else if (myweight != "") {
                    #print(paste("    Re-routing OTHER migration source"))
    				cat(" 1 0.90 NOT_MIG 1\n")
    			}
    	   } else {
                #print(paste("    Processing edge"))
    			cat(hmap[[myedge$parent]])
    			cat(" ")
    			cat(hmap[[myedge$child]])
    			cat(" 1 0 NOT_MIG 1\n")
    		}
    	}
    }
    sink()
}


get_start_graph <- function() {
    leaves <- c("popA", "popB", "popC", "popD", "popE")

    inner_nodes <- c("R", "v1", "v2", "v3", "v4", "v5")

    edges <- parent_edges(c(edge("v1", "R"),
                            edge("v5", "R"),
                            edge("v2", "v1"),
                            edge("popD", "v1"),
                            edge("v3", "v2"),
                            edge("popA", "v2"),
                            edge("popB", "v3"),
                            edge("v4", "v3"),
                            edge("popC", "v4"),
                            admixture_edge("v5", "v4", "R", "w"),
                            edge("popE", "v5")))
 
    newgraph <- agraph(leaves, inner_nodes, edges)

    return(newgraph)
}

get_tail_move_one_graph <- function() {
    leaves <- c("popA", "popB", "popC", "popD", "popE")

    inner_nodes <- c("R", "v1", "v2", "v3", "v4", "v5")

    edges <- parent_edges(c(edge("v1", "R"),
                            edge("v5", "R"),
                            edge("v2", "v1"),
                            edge("popD", "v1"),
                            edge("v3", "v2"),
                            edge("popA", "v2"),
                            edge("popC", "v3"),
                            edge("v4", "v3"),
                            edge("popB", "v4"),
                            admixture_edge("v5", "v4", "R", "w"),
                            edge("popE", "v5")))
 
    newgraph <- agraph(leaves, inner_nodes, edges)

    return(newgraph)
}

get_tail_move_two_graph <- function() {
    leaves <- c("popA", "popB", "popC", "popD", "popE")

    inner_nodes <- c("R", "v1", "v2", "v3", "v4", "v5")

    edges <- parent_edges(c(edge("v1", "R"),
                            edge("v5", "R"),
                            edge("popD", "v1"),
                            edge("v2", "v1"),
                            edge("popC", "v2"),
                            edge("v4", "v2"),
                            edge("popB", "v4"),
                            admixture_edge("v5", "v4", "R", "w"),
                            edge("v3", "v5"),
                            edge("popE", "v3"),
                            edge("popA", "v3")))
 
    newgraph <- agraph(leaves, inner_nodes, edges)

    return(newgraph)
}


get_tail_move_three_graph <- function() {
    leaves <- c("popA", "popB", "popC", "popD", "popE")

    inner_nodes <- c("R", "v1", "v2", "v3", "v4", "v5")

    edges <- parent_edges(c(edge("v1", "R"),
                            edge("v5", "R"),
                            edge("v2", "v1"),
                            edge("popD", "v1"),
                            edge("v3", "v2"),
                            edge("popE", "v2"),
                            edge("popC", "v3"),
                            edge("v4", "v3"),
                            edge("popB", "v4"),
                            admixture_edge("v5", "v4", "R", "w"),
                            edge("popA", "v5")))
 
    newgraph <- agraph(leaves, inner_nodes, edges)

    return(newgraph)
}


get_end_graph <- function() {
    leaves <- c("vA", "vB", "vC", "vD", "vE")

    inner_nodes <- c("R", "v1", "v2", "v3", "v4", "v5")

    edges <- parent_edges(c(edge("v1", "R"),
                            edge("vE", "R"),
                            edge("v2", "v1"),
                            edge("v4", "v1"),
                            edge("v3", "v2"),
                            edge("vC", "v2"),
                            edge("vB", "v3"),
                            edge("vD", "v4"),
                            admixture_edge("v5", "v4", "v3", "w"),
                            edge("vA", "v5")))
 
    newgraph <- agraph(leaves, inner_nodes, edges)

    return(newgraph)
}

#mygraph <- get_start_graph()
#to_treemix(mygraph, "start")

#mygraph <- get_tail_move_one_graph()
#to_treemix(mygraph, "tail_move_one")

#mygraph <- get_tail_move_two_graph()
#to_treemix(mygraph, "tail_move_two")

#mygraph <- get_tail_move_three_graph()
#to_treemix(mygraph, "tail_move_three")


mygraph <- get_end_graph()
to_treemix(mygraph, "end")

# sg = -366944.29
# t1 = -534329.98
# t2 = -395847.1
# t3 = 83
# rt = 83
