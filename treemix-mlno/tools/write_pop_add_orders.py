import argparse
from itertools import permutations
import numpy.random
import sys


def main(args):
    orders = list(permutations(args.pops))
    n = len(orders)

    print(args.output + " " + str(n))

    #case_study 120
    #patterson2012_fig5 120
    #haak2015_figS8-1 720
    #mallick2016_figS11_1_simplified 3628800
    #lipson2020_fig5a 120
    #lipson2020_fig5a_extended 720
    #wu2020_fig7a 3628800
    #yan2020_fig2 720

    if n > 1000:
        rinds = numpy.random.randint(0, high=n, size=1000)
    else:
        rinds = [i for i in range(0, n)]

    for i, r in enumerate(rinds):
        order = orders[r]
        with open(args.output + "_popaddorder_" + str(i + 1) + ".txt", 'w') as fo:
            fo.write("\n".join(order))


if __name__ == "__main__":
    parser = argparse.ArgumentParser()

    parser.add_argument("-p", "--pops", type=str, nargs='+',
                        help="List of population names",
                        required=True)
    parser.add_argument("-o", "--output", type=str,
                        help="Output prefix",
                        required=True)

    main(parser.parse_args())

