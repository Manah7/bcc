#!/usr/bin/env python3
# Generic file provided by the course - TO CHANGE

prg = "bin/prg"

lines = open(prg, "r").readlines()
lines = [x.strip().split() for x in lines]
lines = [[l[0]] + [int(x) for x in l[1:]] for l in lines]

addr_m_to_addr_r = {}
lines_r = []

for i in range(len(lines)):
    addr_m_to_addr_r[i] = len(lines_r)
    ins = lines[i][1:]
    num = lines[i][0]
    if ins[0] == "ADD" or ins[0] == "SUB":
        lines_r.append(["LDR", 1, ins[2]])
        lines_r.append(["LDR", 2, ins[3]])
        lines_r.append([ins[0], 1, 2, 1])
        lines_r.append(["STR", ins[3], 1])
    elif ins[0] == "COP":
        lines_r.append(["LDR", 1, ins[2]])
        lines_r.append(["STR", ins[1], 1])
    elif ins[0] == "JMP":
        lines_r.append([ins[0], ins[1]]) # BAD ADDR
    elif ins[0] == "JMX":
        lines_r.append(["LDR", 1, ins[1]])
        lines_r.append([ins[0], 1, ins[2]]) # BAD ADDR
    print(lines[i])


for i in range(len(lines_r)):
    ins = lines_r[i][1:]
    if ins[0] == "JMP":
        if ins[1] not in addr_m_to_addr_r:
            ins[1] = len(lines_r)
        else:
            ins[1] = addr_m_to_addr_r[ins[1]]
    elif ins[0] == "JMX":
        if ins[2] not in addr_m_to_addr_r:
            ins[2] = len(lines_r)
        else:
            ins[2] = addr_m_to_addr_r[ins[2]]


for i in range(len(lines_r)):
    while len(lines_r[i]) < 4:
        lines_r[i].append(0)

print("")
for x in lines_r:
    print(x)

print("")


op2bin = {}
op2bin["ADD"] = 0
op2bin["SOU"] = 1
op2bin["MUL"] = 2
op2bin["LSL"] = 3
op2bin["LSR"] = 4
op2bin["INF"] = 5
op2bin["SUP"] = 6
op2bin["EQU"] = 7
op2bin["AFC"] = 8
op2bin["COP"] = 9
op2bin["JMP"] = 10
op2bin["JMF"] = 11
op2bin["PRI"] = 12
op2bin["RET"] = 13
op2bin["LDR"] = 14
op2bin["STR"] = 15
op2bin["NOP"] = 255



print("(")
for x in lines_r:
    print("(x\"%02x%02x%02x%02x\")," % (op2bin[x[0]], x[1], x[2], x[3]))
print(", others => x\"00000000\")")