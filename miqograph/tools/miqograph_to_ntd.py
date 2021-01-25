import argparse
import dendropy
import copy
import gzip
import numpy
import os
import sys


def main(args):
    # Read name map
    hmap = {}
    with open(args.mapfile, 'r') as f:
        for l in f:
            data = l.split()
            index = data[0]
            label = data[1]
            istip = data[2]
            isroot = data[3]
            if istip == "TIP":
                hmap[label] = index
            if isroot == "ROOT":
                rv = int(index)

    # Read label file and assing to leaves
    i2l_map = {}
    with open(args.labelfile, 'r') as f:
        for l in f:
            [label, index, weight] = l.split()
            i2l_map[index] = label

    # Create binary tree of depth d
    last_level = []
    level= []
    index = 1

    tree = dendropy.Tree()
    tree.is_rooted = True  # IMPORTANT!
    root_node = tree.seed_node
    root_node.islabeled = False
    root_node.label = index
    index = index + 1
    level.append(root_node)

    for d in range(args.depth):
        last_level = level
        level = []

        for node in last_level:
            left = dendropy.Node()
            left.islabeled = False
            left.label = str(index)
            index = index + 1
            node.add_child(left)
            level.append(left)

            right = dendropy.Node()
            right.islabeled = False
            right.label = str(index)
            index = index + 1
            node.add_child(right)
            level.append(right)

    for node in level:
        try:
            node.leaf_label = i2l_map[node.label]
            node.label = hmap[node.leaf_label]
            node.islabeled = True
        except KeyError:
            pass

    #print(tree.as_string(schema='newick'))

    # Remove leaves without labels
    postorder = [n for n in tree.postorder_node_iter()]
    for node in postorder:
        if (node.islabeled == False) and (node.is_leaf()):
            parent = node.parent_node
            parent.remove_child(node)

    # Suppress vertices of in-degree 1 and out-degree 1
    tree.suppress_unifurcations()

    # Reroot at outgroup
    for node in tree.leaf_node_iter():
        if node.leaf_label == args.outgroup:
            outgroup_node = node
            break
    #print(tree.as_ascii_plot())
    tree.reroot_at_edge(outgroup_node.edge,
                        update_bipartitions=False)
    #print(tree.as_ascii_plot())
    #print(tree.as_string(schema='newick'))

    # Relabel tree for ntd and save admixture edges
    for node in tree.postorder_node_iter():
        if not node.is_leaf():
            node.label = ""

    found = set([])
    found_again = set([])
    for node in tree.leaf_node_iter():
        if node.label in found:
            found_again.add(node.label)
        else:
            found.add(node.label)

    # Leaves cannot be admixture nodes
    counter = rv + 1
    admixture_map = {}
    for node in tree.leaf_node_iter():
        if node.label in found_again:
            leaf_label = node.label
            node.label = str(counter)
            admixture_map[node.label] = leaf_label
            counter = counter + 1

    preorder = [n for n in tree.preorder_node_iter()]
    found_again = list(found_again)
    num_nodes = len(preorder) + len(found_again)

    for node in preorder[1:]:
        if not node.is_leaf():
            node.label = str(counter)
            counter = counter + 1

    tree.seed_node.label = str(rv)

    #print(tree.as_string(schema='newick'))

    # Write output graph file, including admixture edges
    with open(args.output, 'w') as f:
        f.write(str(num_nodes) + '\n')

        for node in tree.preorder_node_iter():
            f.write(node.label + " ")
            if node.is_leaf():
                try:
                    label = admixture_map[node.label]
                    f.write(" " + label)
                except KeyError:
                    pass
            else:
                for child in node.child_nodes():
                    f.write(" " + child.label)
            f.write("\n")

        for x in found_again:
            f.write(x + "\n")


if __name__ == "__main__":
    parser = argparse.ArgumentParser()

    parser.add_argument("-l", "--labelfile", type=str,
                        help="Leaf label file from miqograph",
                        required=True)
    parser.add_argument("-x", "--outgroup", type=str,
                        help="Name of outgroup",
                        required=True)
    parser.add_argument("-d", "--depth", type=int,
                        help="Depth of binary tree from miqograph",
                        required=True)
    parser.add_argument("-m", "--mapfile", type=str,
                        help="Vertex index map file",
                        required=True)
    parser.add_argument("-o", "--output", type=str,
                        help="Output file",
                        required=True)

    main(parser.parse_args())
