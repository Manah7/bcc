#!/usr/bin/env python3

from time import sleep
import sys

print("ITR - Iterpreter")
print("GNU GPL v3 - 2022")
print("Manah <contact@manah.fr>,")
print("Enjmateo <Enjmateo@users.noreply.github.com>")
print("")

if len(sys.argv) == 1:
    prg = "bin/prg.s"
elif len(sys.argv) == 2:
    prg = sys.argv[1]

asm = open(prg, 'r')
ip = -1
ri = -1

memory = [0] * 65536
stack = []

def print_memory():
    print("Memory:")
    for i in range(0, 10):
        print("{:04x}".format(i), ":", memory[i])

def get_line(i):
    asm.seek(0)
    for line in asm:
        if len(line.split()) <= 1:
            continue
        if int(line.split()[0]) == i:
            return line
    print("Seg. fault (this may be normal if we reached the end of the program) -> Exiting")
    exit(0)

def find_main():
    asm.seek(0)
    next = False
    for line in asm:
        if next:
            return int(line.split()[0])
        if line.split()[0] == 'main:':
            next = True
    print("No entry point found -> Exiting")
    exit(-1)

ip = find_main()

while True:
    line = get_line(ip)[:-1]
    print("> ", line)

    if line == '':
        break
    
    tokens = line.split()

    if len(tokens) <= 1:
        ip += 1
        continue

    if tokens[1] == 'AFC':
        memory[int(int(int(tokens[2])/4))] = int(tokens[3])
    elif tokens[1] == 'ADD':
        memory[int(int(tokens[2])/4)] = memory[int(int(tokens[3])/4)] + memory[int(int(tokens[4])/4)]
    elif tokens[1] == 'SOU':
        memory[int(int(tokens[2])/4)] = memory[int(int(tokens[3])/4)] - memory[int(int(tokens[4])/4)]
    elif tokens[1] == 'MUL':
        memory[int(int(tokens[2])/4)] = memory[int(int(tokens[3])/4)] * memory[int(int(tokens[4])/4)]
    elif tokens[1] == 'DIV':
        memory[int(int(tokens[2])/4)] = memory[int(int(tokens[3])/4)] / memory[int(int(tokens[4])/4)]
    elif tokens[1] == 'COP':
        memory[int(int(tokens[2])/4)] = memory[int(int(tokens[3])/4)]
    elif tokens[1] == 'AFC':
        memory[int(int(tokens[2])/4)] = int(tokens[3])
    elif tokens[1] == 'JMP':
        ip = int(tokens[2]) - 1
    elif tokens[1] == 'JMF':
        if memory[int(int(tokens[2])/4)] == 0:
            ip = int(tokens[3]) - 1
    elif tokens[1] == 'INF':
        if memory[int(int(tokens[3])/4)] < memory[int(int(tokens[4])/4)]:
            memory[int(int(tokens[2])/4)] = 1
        else:
           memory[int(int(tokens[2])/4)] = 0
    elif tokens[1] == 'SUP':
        if memory[int(int(tokens[3])/4)] > memory[int(int(tokens[4])/4)]:
            memory[int(int(tokens[2])/4)] = 1
        else:
           memory[int(int(tokens[2])/4)] = 0
    elif tokens[1] == 'EQU':
        if memory[int(int(tokens[3])/4)] == memory[int(int(tokens[4])/4)]:
            memory[int(int(tokens[2])/4)] = 1
        else:
           memory[int(int(tokens[2])/4)] = 0
    elif tokens[1] == 'PRI':
        print(memory[int(int(tokens[2])/4)])
    elif tokens[1] == 'LSL':
        memory[int(int(tokens[2])/4)] = memory[int(int(tokens[3])/4)] << int(tokens[4])
    elif tokens[1] == 'LSR':
        memory[int(int(tokens[2])/4)] = memory[int(int(tokens[3])/4)] >> int(tokens[4])
    elif tokens[1] == 'NOP':
        pass
    elif tokens[1] == 'CAL':
        stack.append(ip)
        ip = int(tokens[2]) - 1
    elif tokens[1] == 'RET':
        ip = stack.pop()
    else :
        print("Unknown instruction: " + tokens[1])
        pass
    
    ip += 1
    sleep(0.1)

print("End of program")
