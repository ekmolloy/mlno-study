import argparse
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
            index = int(data[0])
            label = data[1]
            istip = data[2]
            isroot = data[3]
            if istip == "TIP":
                hmap[label] = int(index)
            if isroot == "ROOT":
                rv = index

    # Read vertex file
    nv = rv + 1
    tm2ntd = {}
    f = gzip.open(args.vertexfile, 'rb')
    for l in f:
        data = l.split()
        index = int(data[0])
        #label = str(data[1],'utf-8')  # Needed on my Mac
        #isroot = str(data[2],'utf-8')
        #istip = str(data[4],'utf-8')
        label = str(data[1])
        isroot = str(data[2])
        istip = str(data[4])
        if isroot == "ROOT":
            tm2ntd[index] = rv
        elif istip == "TIP":
            tmp = hmap[label]
            tm2ntd[index] = tmp
        else:
            tm2ntd[index] = nv
            nv = nv + 1
    f.close()

    # Read edge file
    children = numpy.zeros((nv, nv))
    f = gzip.open(args.edgefile, 'rb')
    for l in f:
        data = l.split()
        i = tm2ntd[int(data[0])]
        j = tm2ntd[int(data[1])]
        children[i, j] = 1
    f.close()

    # Write output graph file
    found = set([])
    with open(args.output, 'w') as f:
        f.write(str(nv) + '\n')
        q = []
        q.append(rv)
        while (len(q) > 0):
            node = q.pop(0)
            f.write(str(node))
            found.add(node)

            cs = numpy.where(children[node,] > 0)[0]
            nc = len(cs)
            if nc > 0:
                for j in range(nc):
                    child = cs[j]
                    f.write(" " + str(child))
                    if (child not in found):
                        found.add(child)
                        q.append(child)

            f.write("\n")


if __name__ == "__main__":
    parser = argparse.ArgumentParser()

    parser.add_argument("-v", "--vertexfile", type=str,
                        help="TreeMix vertices gz file",
                        required=True)
    parser.add_argument("-e", "--edgefile", type=str,
                        help="TreeMix edges gz file",
                        required=True)
    parser.add_argument("-m", "--mapfile", type=str,
                        help="Vertex index map file",
                        required=True)
    parser.add_argument("-o", "--output", type=str,
                        help="Output file",
                        required=True)

    main(parser.parse_args())
