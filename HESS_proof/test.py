import sys
import subprocess
import matplotlib.pyplot as plt


if __name__ == '__main__':
    f = sys.argv[1]
    n = int(sys.argv[2])

    hess = []
    states = []
    optimals = []
    for i in range(2 ** n):
        bits = bin(i)[2:]
        bits += (n - len(bits)) * '0'
        states.append(i)
        a, b = subprocess.check_output('./hess_maxsat {} {}'.format(f, bits), shell=True).decode().split('|')
        optimals.append((i, int(''.join(['1' if b else '0' for b in eval(b.replace('true', 'True').replace('false', 'False'))][::-1]), 2)))
        hess.append(float(a))

    plt.plot(states, hess, c='r')
    plt.plot(states, len(states) * [7 / 8], c='k')
    plt.savefig('hess.png')
    plt.close()
