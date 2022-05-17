#!/usr/bin/env python3

prg = "bin/prg"
lines = open(prg, "r").readlines()

lines_r = []


def ldr(reg, addr):
    return ["LDR", int(reg), int(addr), 0]

def str(reg, addr):
    return ["STR", int(reg), int(addr), 0]


for i in range(len(lines)):
    line = lines[i][:-1].split()

    if ':' in line[0]:
        continue

    if line[1] == "ADD" or line[1] == "SUB" or line[1] == "MUL" or line[1] == "DIV" or line[1] == "LSL" or line[1] == "LSR" or line[1] == "INF" or line[1] == "SUP" or line[1] == "EQU": 
        lines_r.append(ldr(1, line[3]))
        lines_r.append(ldr(2, line[4]))
        lines_r.append([line[1], 1, 2, 1])
        lines_r.append(str(1, line[2]))
    elif line[1] == "COP" or line[1] == "AFC":
        lines_r.append(ldr(1, line[3]))
        lines_r.append(str(line[2], 1))
    elif line[1] == "LDR" or line[1] == "STR":
        lines_r.append([line[1], int(line[2]), int(line[3]), 0])
    elif line[1] == "NOP":
        lines_r.append([line[1], 0, 0, 0])
    elif line[1] == "JMP":
        lines_r.append([line[1], int(line[2]), 0, 0]) # BAD ADDR
    elif line[1] == "JMF":
        lines_r.append(ldr(1, line[2]))
        lines_r.append([line[1], 1, int(line[3]), 0]) # BAD ADDR
    print(line)

for i in range(len(lines_r)):
    print(lines_r[i])

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