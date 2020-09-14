/*
///////////////////////////////////////////////////////////////////////////////
//        Copyright (c) 2012-2020 Oscar Riveros. all rights reserved.        //
//                        oscar.riveros@peqnp.science                        //
//                                                                           //
//   without any restriction, Oscar Riveros reserved rights, patents and     //
//  commercialization of this knowledge or derived directly from this work.  //
///////////////////////////////////////////////////////////////////////////////

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/
// https://twitter.com/maxtuno/status/1304023917787574272
import os
import math

struct Solver {
pub mut:
	n          int
	m          int
	t          int
	assignment []bool
	optimal    []bool
	clauses    [][]int
}

fn literal_to_index(literal int) int {
	return int(math.abs(literal) - 1)
}

fn is_satisfied(clause []int, solver Solver) bool {
	for literal in clause {
		if literal > 0 == solver.assignment[literal_to_index(literal)] {
			return true
		}
	}
	return false
}

fn oracle(mut solver Solver, glb int) int {
	mut unsat := 0
	for clause in solver.clauses {
		if !is_satisfied(clause, solver) {
			unsat++
			if unsat > glb {
				return unsat
			}
		}
	}
	return unsat
}

fn step(i, j int, mut solver Solver) {
	if solver.assignment[i] == solver.assignment[j] {
		solver.assignment[i] = !solver.assignment[j]
	} else {
		aux := solver.assignment[i]
		solver.assignment[i] = !solver.assignment[j]
		solver.assignment[j] = aux
	}
}

fn solve(mut solver Solver) bool {
	mut loc := 0
	mut cur := solver.clauses.len
	for clause in solver.clauses {
		mut glb := solver.clauses.len
		o:
		for i in 0 .. solver.n {
			for j in 0 .. solver.n {
				oo:
				step(i, j, mut solver)
				loc = oracle(mut solver, glb)
				if loc < glb {
					glb = loc
					if glb < cur {
						cur = glb
						println('o $glb')
						solver.optimal = solver.assignment.clone()
						if glb <= solver.t {
							return true
						}
						goto o
					}
					goto oo
				} else if loc > glb {
					goto oo
				}
			}
		}
		for literal in 1 .. solver.n + 1 {
			if !(literal in clause) && !(-literal in clause) {
				solver.assignment[literal_to_index(literal)] = !solver.assignment[literal_to_index(literal)]
			}
		}
	}
	return false
}

fn show_cnf(solver Solver) {
	println('p cnf $solver.n $solver.m')
	for clause in solver.clauses {
		for literal in clause {
			print('$literal ')
		}
		println('0')
	}
}

fn load_cnf(contents string, mut solver Solver) {
	mut clause := []int{}
	mut line_no_space := string{}
	mut splitted := []string{}
	for line in contents.split('\n') {
		line_no_space = line.trim_space()
		if line_no_space.starts_with('c') {
			continue
		} else if line_no_space.starts_with('p') {
			splitted = line_no_space.split(' ')
			solver.n = splitted[2].int()
			solver.m = splitted[3].int()
		} else {
			if line_no_space.ends_with('0') {
				splitted = line_no_space.split(' ')
				clause = []
				for s_lit in splitted.slice(0, splitted.len - 1) {
					clause << s_lit.int()
				}
				solver.clauses << [clause]
			}
		}
	}
	solver.assignment = []bool{len: solver.n, init: false}
	println('c')
	println('c vrs $solver.n')
	println('c cls $solver.m')
	println('c')
}

fn main() {
	println('c O. Riveros Polynomial HESS black-box Algorithm on MaxSAT or incomplete SAT Solver. http://www.peqnp.com')
	println('c The PCP theorem implies that there exists an ε > 0 such that (1-ε)-approximation of MAX-3SAT is NP-hard.')
	println('c usage: ./hess <cnf> [target (default=0)]')
	mut path := os.args[1].str()
	contents := os.read_file(path) or {
		println('failed to open $path')
		return
	}
	mut t := 0
	if os.args.len == 3 {
		t = os.args[2].int()
	}
	mut solver := Solver{0, 0, t, []}
	load_cnf(contents, mut solver)
	if solve(mut solver) {
		print('s SATISFIABLE\nv ')
	} else {
		print('s UNKNOWN\nv ')
	}
	for i in 1 .. solver.n + 1 {
		if solver.optimal[i - 1] {
			print('$i ')
		} else {
			print('-$i ')
		}
	}
	println(0)
}
