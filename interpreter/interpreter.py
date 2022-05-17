#!/usr/bin/env python3

# Parse a file line by line
from time import sleep


asm = open('bin/prg', 'r')
ip = -1
ri = -1

memory = [0] * 65536

def print_memory():
    print("Memory:")
    for i in range(0, 10):
        print("{:04x}".format(i), ":", memory[i])

def get_line(i):
    asm.seek(0)
    for line in asm:
        if int(line.split()[0]) == i:
            return line
    print("Seg. fault -> Exiting")
    exit(-1)

def find_main():
    asm.seek(0)
    for line in asm:
        if line.split()[1] == 'main:':
            return int(line.split()[0])
    print("No entry point found -> Exiting")
    exit(-1)


ip = find_main()
#print("Entry point found at: ", ip)

while True:
    line = get_line(ip)[:-1]
    #print("> ", line)

    if line == '':
        break
    
    tokens = line.split()

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
    else :
        #print("Unknown instruction: " + tokens[1])
        pass
    
    ip += 1
    #sleep(0.1)

print("End of program")
