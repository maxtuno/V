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

fn hess(mut solver Solver) f64 {
	mut loc := 0
	mut glb := solver.clauses.len
	for {
		o:
		mut ready := true
		for i in 0 .. solver.n {		
			solver.assignment[i] = !solver.assignment[i]
			loc = oracle(mut solver, glb)
			if loc < glb {
				glb = loc
				ready = false
				solver.optimal = solver.assignment.clone()
				if glb == 0 {
					break
				}
				goto o
			} else if loc > glb {
				solver.assignment[i] = !solver.assignment[i]
			}
		}
		if ready {
			break
		}
	}
	return f64(solver.m - glb) / f64(solver.m)
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
}

fn main() {
	mut path := os.args[1].str()
	mut assignment := os.args[2].str().split('')
	contents := os.read_file(path) or {
		println('failed to open $path')
		return
	}
	mut solver := Solver{0, 0, 0, [], [], []}
	load_cnf(contents, mut solver)
	for i in 0 .. solver.n {
		if assignment[i] == '1' {
			solver.assignment[i] = true
		} else {
			solver.assignment[i] = false
		}
	}
	print(hess(mut solver))
	print('|')
	print(solver.optimal)
}
