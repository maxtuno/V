# V
My V Lang Codes https://vlang.io

- HESS

O. Riveros Polynomial HESS black-box Algorithm on MaxSAT or incomplete SAT Solver. http://www.peqnp.com

The PCP theorem implies that there exists an ε > 0 such that (1-ε)-approximation of MAX-3SAT is NP-hard.

usage: ./hess <cnf> [target (default=0)]

https://twitter.com/maxtuno/status/1304023917787574272

- DEIDOS COVENANT

Deidos covenant is an algorithm to find all the solutions to a problem of "Sum of Subsets" that is NP-Complete, was developed by Oscar Riveros [oscar.riveros@peqnp.science] in 2012.

The algorithm out the explicit solution and/or complement, are "quivalents" or complementary.

usage : ./deidos_covenant <instance>
  
Format

The file format is: (use the gen_ssp.py to generate random examples)

python3 gen_ssp.py bits size

SIZE
TARGET
N_1
N_2
...
N_SIZE
