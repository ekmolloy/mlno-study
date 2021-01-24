import argparse
import gzip
import numpy
import sys


def parse_text(text, skey, ekey):
    """Extract text between start key and end key

    Parameters
    ----------
    text : str
    skey : str
    ekey : str

    Returns
    -------
    Text between start and end keys

    """
    s = text.find(skey)
    if s == -1:
        return "NA"
    else:
        s = s + len(skey)
        e = s + text[s:].find(ekey)
        return text[s:e]


def main(args):
    if args.input[-3:] == '.gz':
        fi = gzip.open(args.input, 'rt')
    else:
        fi = open(args.input, 'r')

    fo = open(args.output, 'w')

    fo.write("locus site " + ' '.join(args.pops) + "\n")

    # Read ms command
    line = fi.readline()
    info = parse_text(line, '-I', '-en').split()
    ninds = [int(i) for i in info[1:]]
    npops = len(ninds)
    total = numpy.sum(ninds)

    # Read seed
    line = fi.readline()

    # Read blank line
    line = fi.readline()

    nloci = 0

    mat = numpy.zeros((args.nsite, npops*2), dtype=numpy.uint64)

    while(True):
        line = fi.readline()

        if line == '':
            break

        if line[:8] == 'segsites':
            sys.stdout.write("Processing locus %d...\n" % nloci)
            sys.stdout.flush()

            # Read number of segregating sites
            nsite = int(line.split()[1])

            # Read positions of segregating sites
            line = fi.readline()

            # Create matrix of allele counts
            for j in range(npops):
                for k in range(ninds[j]):
                    line = fi.readline() #.split()[0]
                    for i in range(nsite):
                        mat[i, 2*j + int(line[i])] += 1

            # Write matrix of allele counts
            for i in range(nsite):
                fo.write("%d %d" % (nloci, i))
                for j in range(npops): 
                    fo.write(" %d,%d" % (mat[i, j*2], mat[i, j*2 + 1]))

                mat[i, :] = 0  # Re-set matrix to 0's!
                fo.write("\n")
            fo.flush()

            nloci += 1

    fi.close()
    fo.close()


if __name__ == "__main__":
    parser = argparse.ArgumentParser()

    parser.add_argument("-s", "--nsite", type=int,
                        help="Maximum number of sites per locus")
    parser.add_argument("-i", "--input", type=str,
                        help="Input: Output from running ms",
                        required=True)
    parser.add_argument("-p", "--pops", type=str, nargs='+',
                        help="List of population names",
                        required=True)
    parser.add_argument("-o", "--output", type=str,
                        help="Output: Input for TreeMix")

    main(parser.parse_args())

