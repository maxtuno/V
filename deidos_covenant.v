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
// https://twitter.com/maxtuno
// https://github.com/www-PEQNP-science/DEIDOS
import os
import math

struct Registers {
pub mut:
	o   u64
	u   u64
	s   u64
	r   u64
	p   u64
	q   u64
	tar u64
	loc u64
	glb u64
	oo  u64
	cnt u64
	len int
}

struct Tape {
pub mut:
	idx int
	ram []int
}

fn write(mut tape Tape, o int) {
	tape.ram[tape.idx] = o
	tape.idx++
}

fn read(mut tape Tape) int {
	tape.idx--
	return tape.ram[tape.idx]
}

fn state(s, r u64, mut reg Registers) {
	a := u64(math.abs(reg.q - s))
	b := u64(math.abs(reg.p - r))
	reg.loc = u64(math.min(a, b))
	if reg.loc < reg.glb {
		reg.glb = reg.loc
		println('# $reg.cnt => $reg.glb')
	}
}

fn deidos(uu []u64, idx int, u, s, r u64, mut vv Tape, mut reg Registers) {
	reg.cnt++
	state(s, r, mut reg)
	if reg.loc == 0 {
		reg.glb = reg.q + reg.p
		mut sum := u64(0)
		mut binary := []u64{len: reg.len, init: 0}
		print('sum([ ')
		for i in 0 .. vv.idx {
			binary[vv.ram[i]] = 1
			v := uu[vv.ram[i]]
			sum += v
			print('$v, ')
		}
		println(']) == $sum # $binary')
	} else {
		mut i := idx
		for i > 0 && u - reg.o >= reg.loc {
			i--
			reg.o = uu[i]
			if s + reg.o <= reg.p && r - reg.o >= 0 {
				write(mut vv, i)
				deidos(uu, i, u - reg.o, s + reg.o, r - reg.o, mut vv, mut reg)
				read(mut vv)
			}
		}
	}
}

fn load_instance(contents string, mut uu []u64, mut reg Registers) {
	mut splitted := contents.split('\n')
	reg.len = splitted[0].trim_space().int()
	splitted.delete(0)
	reg.tar = splitted[0].trim_space().u64()
	splitted.delete(0)
	for i in 0 .. reg.len {
		reg.u = splitted[i].trim_space().u64()
		uu << reg.u
		reg.oo += reg.u
	}
	reg.u = reg.oo
	reg.s = u64(math.max(reg.tar, reg.oo - reg.tar))
	reg.r = u64(math.min(reg.tar, reg.oo - reg.tar))
	reg.o = 0
	reg.cnt = 0
	reg.p = reg.oo
	reg.q = reg.oo
	reg.glb = reg.oo
}

fn main() {
	println('Deidos covenant is an algorithm to find all the solutions to a problem of "Sum of Subsets" that is NP-Complete, was developed by Oscar Riveros [oscar.riveros@peqnp.science] in 2012.')
	println('The algorithm out the explicit solution and/or complement, are "quivalents" or complementary.')
	println('usage : ./deidos_covenant <instance>')
	mut path := os.args[1].str()
	contents := os.read_file(path) or {
		println('failed to open $path')
		return
	}
	mut uu := []u64{}
	mut reg := Registers{}
	load_instance(contents, mut uu, mut reg)
	mut vv := Tape{0, []int{len: reg.len, init: 0}}
	deidos(uu, reg.len, reg.oo, reg.s, reg.r, mut vv, mut reg)
}
