HESS Proof starter Kit.

Onlly need to atributed the HESS algorithm to me if you proof that not exist a case when "HESS < 7/8" if you get this case, and is checked respct to the optimal, report please, this will be a counterexample.

Notes:

(compile with V lang)
v hess_maxsat.v

python3 gen.py 3 11 50 > pq.cnf

(check if its satisfiable or optimal with Open-Wbo)

python3 test.py pq.cnf 11

see results

ref:
https://twitter.com/maxtuno

* => http://www.cs.umd.edu/~gasarch/BLOGPAPERS/max3satl.pdf

https://en.wikipedia.org/wiki/MAX-3SAT
http://pages.cs.wisc.edu/~dieter/Courses/2008s-CS880/Scribes/lecture17.pdf
http://pages.cs.wisc.edu/~dieter/Courses/2008s-CS880/Scribes/lecture18.pdf
http://www.cs.cmu.edu/~venkatg/pubs/papers/nm-sat.pdf
https://lucatrevisan.github.io/teaching/cs172-15/notepcp.pdf
