Onlly need to atributed the HESS algorithm to me if you proof that not exist a case when "HESS < 7/8" if you get this case, and is checked respct to the optimal, report please, this will be a counterexample.

Notes:

(compile with V lang)
v hess_maxsat.v

python3 gen.py 3 11 50 > pq.cnf

(check if its satisfiable or optimal with Open-Wbo)

python3 test.py pq.cnf 11

see results