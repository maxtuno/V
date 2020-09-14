# coding: utf-8
"""Random k-SAT Generator
This script generates a random k-SAT instance.
Example:
    If you want to create random 3-SAT with 100 variables and 300 clauses, run the following.
        $ python gen_ksat.py 3 100 300
    The result (formula) will be showed in standard output.
Todo:
    * Function to confirm whether the generated instance is SAT or UNSAT
"""

import random
import sys

help_message = '''Usage:
python3 {} k nbvar nbclauses [issat]
k         - The size of each clause.
nbvar     - The number of variables.
nbclauses - The number of variables.
issat     - Optional variable, indicating whether the generated SAT instance will be satisfiable or not.
'''.format(sys.argv[0].split("/")[-1])


def generate_ksat(k, nbvar, nbclauses, issat=True):
    """Generate random k-SAT instance.
    Generate a random k-SAT instance and print it to stdout.
    Args:
        k: The size of each clause.
        nbvar: The number of variables.
        nbclauses: The number of variables.
        issat: Optional variable, indicating whether the generated SAT instance will be satisfiable or not.
    """

    def randbool():
        return random.choice([True, False])

    def randlit(clause, nbvar):
        """Return a randomly generated literal from variables not appeared in the clause.
        """
        while (True):
            v = random.randint(1, nbvar)
            if (v not in clause and -v not in clause):
                break
        return v if randbool() else -v

    # Output problem setting.
    print("c Random {}-SAT Problem with parameter:".format(k))
    print("c is_satisfiable={}, #variables={}, #caluses={}.".format(issat, nbvar, nbclauses))
    print("p cnf {} {}".format(nbvar, nbclauses))

    # At least, this assignment is one of the model(s).
    model = [var if randbool() else -var for var in range(1, nbvar + 1)]

    for i in range(nbclauses):
        clause = list()
        if issat:
            clause.append(random.choice(model))

        for _ in range(k - len(clause)):
            clause.append(randlit(clause, nbvar))

        random.shuffle(clause)
        clause.append(0)
        print(" ".join(map(str, clause)))


class Usage(Exception):
    def __init__(self, msg):
        self.msg = msg


def main(argv=None):
    if argv is None:
        argv = sys.argv

    try:
        if argv[1] == '-h' or argv[1] == '--help':
            print(help_message)
            return 0

        k = int(argv[1])
        nbvar = int(argv[2])
        nbclauses = int(argv[3])
        issat = bool(argv[4]) if len(argv) > 4 else False
        generate_ksat(k, nbvar, nbclauses, issat)

    except err:
        print(sys.argv[0].split("/")[-1] + ": " + str(err.msg), file=sys.stderr)
        print("\t for help use --help", file=sys.stderr)
        return 2

    return 0


if __name__ == '__main__':
    sys.exit(main())
