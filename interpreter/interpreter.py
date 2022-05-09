#!/usr/bin/env python3

# Parse a file line by line
asm = open('bin/prg', 'r')
ip = -1
ri = -1

memory = [0] * 65536

def get_line(i):
    for line in asm:
        if int(line.split()[0]) == i:
            return line
    print("Seg. fault -> Exiting")
    exit(-1)

def find_main():
    for line in asm:
        if line.split()[1] == 'main:':
            return int(line.split()[0])
    print("No entry point found -> Exiting")
    exit(-1)


ip = find_main()
print("Entry point found at: ", ip)

while True:
    line = get_line(ip)
    print("[>] Handling line: ", line)
    if line == '':
        break
    tokens = line.split()

    if tokens[1] == 'AFC':
        memory[int(tokens[2])/4] = int(tokens[3])
    elif tokens[1] == 'ADD':
        memory[int(tokens[2])/4] = memory[int(tokens[3])/4] + memory[int(tokens[4])/4]
    elif tokens[1] == 'SOU':
        memory[int(tokens[2])/4] = memory[int(tokens[3])/4] - memory[int(tokens[4])/4]
    elif tokens[1] == 'MUL':
        memory[int(tokens[2])/4] = memory[int(tokens[3])/4] * memory[int(tokens[4])/4]
    elif tokens[1] == 'DIV':
        memory[int(tokens[2])/4] = memory[int(tokens[3])/4] / memory[int(tokens[4])/4]
    elif tokens[1] == 'COP':
        memory[int(tokens[2])/4] = memory[int(tokens[3])/4]
    elif tokens[1] == 'AFC':
        memory[int(tokens[2])/4] = int(tokens[3])
    elif tokens[1] == 'JMP':
        ip = int(tokens[2])
    elif tokens[1] == 'JMF':
        if memory[int(tokens[2])/4] == 0:
            ip = int(tokens[3])
    elif tokens[1] == 'INF':
        if memory[int(tokens[3])/4] < memory[int(tokens[4])/4]:
            memory[int(tokens[2])/4] = 1
    elif tokens[1] == 'SUP':
        if memory[int(tokens[3])/4] > memory[int(tokens[4])/4]:
            memory[int(tokens[2])/4] = 1
    elif tokens[1] == 'EQU':
        if memory[int(tokens[3])/4] == memory[int(tokens[4])/4]:
            memory[int(tokens[2])/4] = 1
    elif tokens[1] == 'PRI':
        print(memory[int(tokens[2])/4])
    else :
        print("Unknown instruction" + tokens[1])
    
    ip += 1

print("End of program")
