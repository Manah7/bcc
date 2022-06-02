#!/usr/bin/env python3

import sys

print("CA - Cross-assembler")
print("GNU GPL v3 - 2022")
print("Manah <contact@manah.fr>,")
print("Enjmateo <Enjmateo@users.noreply.github.com>")
print("")

FILE = False

if len(sys.argv) == 1:
    prg = "bin/prg.s"
elif len(sys.argv) == 2:
    prg = sys.argv[1]
elif len(sys.argv) == 3 and sys.argv[2] == "-f":
    prg = sys.argv[1]
    FILE = True

nb_reg = 8
lines = open(prg, "r").readlines()

lines_r = []
lines_r.append(["NOP", 0, 0, 0])

# TODO :
# - Voir si l'optimisation détruit pas les registre lors des boucles
# - Appel de fonction avec stack (en fin de mémoire ?) 
# - Utiliser r0 as sp

print("[+] Cross-assembling...")

# Contient les correspondances entre les anciennes et nouvelles adresses
addr_r_to_addr_m = {}
current_addr_r = 1

# Pour optimisation
addr_in_register = {}
for i in range(nb_reg):
    addr_in_register[i] = [-1, 0]
#                    r      a  d

def find_addr(addr):
    for i in range(1, nb_reg):
        if addr_in_register[i][0] == int(addr):
            return i
    return -1

def find_oldest():
    for j in range(1, nb_reg):
        pass
        if addr_in_register[j][0] == -1:
            return j
    
    oldest = -1
    date = -1
    for i in range(1, nb_reg):
        if addr_in_register[i][1] > date:
            oldest = i
            date = addr_in_register[i][1]
    unvalid_reg(oldest)
    return oldest

def unvalid_addr(addr):
    for i in range(1, nb_reg):
        if addr_in_register[i][0] == int(addr):
            addr_in_register[i][0] = -1
            addr_in_register[i][1] = 0

def unvalid_reg(reg):
    addr_in_register[reg][0] = -1
    addr_in_register[reg][1] = 0

def date_plus():
    for i in range(1, nb_reg):
        if addr_in_register[i][0] != -1:
            addr_in_register[i][1] += 1

def update_addr(addr, reg):
    addr_in_register[reg][0] = int(addr)
    addr_in_register[reg][1] = 0

def print_reg():
    print("[", end='', flush=True)
    for i in range(1, nb_reg):
        print(str(addr_in_register[i][0]) + ",", end='', flush=True)
    print("]")

# Pour simplifcation du code
def ldr(reg, addr):
    return ["LDR", int(reg), int(addr), 0]

def st(reg, addr):
    return ["STR", int(addr), int(reg), 0]

# Pour gestion d'adresses
def get_new_addr(old_addr):
    for i in range(1, current_addr_r):
        if addr_r_to_addr_m[i] == old_addr:
            return i
    return -1
    

for i in range(len(lines)):
    line = lines[i][:-1].split()

    if ':' in line[0]:
        print("[+] Fonction trouvée, skip.")
        continue

    num = int(line[0])

    if line[1] == "ADD" or line[1] == "SUB" or line[1] == "MUL" or line[1] == "DIV" or line[1] == "LSL" or line[1] == "LSR" or line[1] == "INF" or line[1] == "SUP" or line[1] == "EQU": 
        # On regarde si les registres sont déjà en mémoire
        r1 = find_addr(line[2])
        r2 = find_addr(line[3])

        # Sinon, on prend le plus vieux registre
        if r1 == -1:
            r1 = find_oldest()
            lines_r.append(ldr(r1, line[3]))
            addr_r_to_addr_m[current_addr_r] = num
            current_addr_r += 1

        if r2 == -1:
            r2 = find_oldest()
            lines_r.append(ldr(r2, line[4]))
            addr_r_to_addr_m[current_addr_r] = num
            current_addr_r += 1

        r3 = find_oldest()

        # On mémorise la correspondance reg - valeur
        update_addr(line[3], r1)
        update_addr(line[4], r2)

        # On écrit la commande
        lines_r.append([line[1], r3, r2, r1])
        lines_r.append(st(r3, line[2]))

        addr_r_to_addr_m[current_addr_r] = num
        addr_r_to_addr_m[current_addr_r+1] = num
        current_addr_r += 2

        # On invalide l'address modifiée et màj r3
        unvalid_addr(line[2])
        update_addr(line[2], r3)

    elif line[1] == "COP":
        r1 = find_addr(line[3])
        if r1 == -1:
            r1 = find_oldest()
            lines_r.append(ldr(r1, line[3]))
            addr_r_to_addr_m[current_addr_r] = num
            current_addr_r += 1

        lines_r.append(st(r1, line[2]))
        addr_r_to_addr_m[current_addr_r] = num
        current_addr_r += 1

        unvalid_addr(line[2])
        update_addr(line[2], r1)

    elif line[1] == "AFC":
        r1 = find_oldest()

        lines_r.append([line[1], r1, int(line[3]), 0])
        lines_r.append(st(r1, line[2]))

        addr_r_to_addr_m[current_addr_r] = num
        addr_r_to_addr_m[current_addr_r+1] = num
        current_addr_r += 2

        unvalid_addr(line[2])
        update_addr(line[2], r1)

    elif line[1] == "LDR":
        unvalid_reg(int(line[2]))
        lines_r.append([line[1], int(line[2]), int(line[3]), 0])
        addr_r_to_addr_m[current_addr_r] = num
        current_addr_r += 1
        update_addr(line[3], int(line[2]))

    elif line[1] == "STR":
        unvalid_addr(line[3])
        lines_r.append([line[1], int(line[2]), int(line[3]), 0])
        addr_r_to_addr_m[current_addr_r] = num
        current_addr_r += 1

    elif line[1] == "NOP":
        lines_r.append([line[1], 0, 0, 0])
        addr_r_to_addr_m[current_addr_r] = num
        current_addr_r += 1

    elif line[1] == "JMP":
        lines_r.append([line[1], int(line[2]), 0, 0]) # BAD ADDR -> patché en 2nd passe
        addr_r_to_addr_m[current_addr_r] = num
        current_addr_r += 1

    elif line[1] == "JMF":
        lines_r.append(ldr(1, line[2]))
        lines_r.append([line[1], 1, int(line[3]), 0]) # BAD ADDR -> patché en 2nd passe

        addr_r_to_addr_m[current_addr_r] = num
        addr_r_to_addr_m[current_addr_r+1] = num
        current_addr_r += 2

    elif line[1] == "CAL":
        lines_r.append([line[1], int(line[2]), 0, 0]) # BAD ADDR -> patché en 2nd passe
        addr_r_to_addr_m[current_addr_r] = num
        current_addr_r += 1

    elif line[1] == "RET":
        lines_r.append([line[1], 0, 0, 0])
        addr_r_to_addr_m[current_addr_r] = num
        current_addr_r += 1

    else:
        print("[!] Commande non reconnue : " + line[1])


    
    date_plus()
    print("[+] Traité : " + str(line) + ". R: ", end='', flush=True)
    print_reg()


print("[+] Patching JMP with new addresses...")
for i in range(1, current_addr_r):
    if lines_r[i][0] == "JMP":
        print("[>] Patching " + str(lines_r[i]), end='', flush=True)
        lines_r[i][1] = get_new_addr(int(lines_r[i][1]))
        print(" -> " + str(lines_r[i]))
    elif lines_r[i][0] == "JMF":
        print("[>] Patching " + str(lines_r[i]) + "...", end='', flush=True)
        lines_r[i][2] = get_new_addr(int(lines_r[i][2]))
        print(" -> " + str(lines_r[i]))


print("[+] Nouvelles instructions générées :")
for i in range(1, current_addr_r):
    print("[>]\t" + str(i) + ":\t", end='', flush=True)
    print(lines_r[i])

print("[+] Correspondance des nouvelles adresses :")
for i in range(1, current_addr_r):
    print("[>]\t", end='', flush=True)
    print(str(addr_r_to_addr_m[i]) + " <- " + str(i))
    
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
op2bin["CAL"] = 10 # TODO
op2bin["JMF"] = 11
op2bin["PRI"] = 12
op2bin["RET"] = 13
op2bin["LDR"] = 14
op2bin["STR"] = 15
op2bin["NOP"] = 255


print("[+] Code objet :")
print("\t(")
for x in lines_r:
    print("\t(x\"%02x%02x%02x%02x\")," % (op2bin[x[0]], x[1], x[2], x[3]))
print("\tothers => x\"ff000000\")")

if FILE:
    f = open("bin/prg.vhd", "w")
    f.write("library IEEE;\n")
    f.write("use IEEE.STD_LOGIC_1164.ALL;\n")
    f.write("use IEEE.NUMERIC_STD.all;\n\n")

    f.write("entity instructions_memory is\n")
    f.write("Port ( addr : in STD_LOGIC_VECTOR (7 downto 0);\n")
    f.write("\tOUTPUT : out STD_LOGIC_VECTOR (31 downto 0));\n")
    f.write("end instructions_memory;\n\n")

    f.write("architecture Behavioral of instructions_memory is\n")
    f.write("type memory is array (0 to 255) of STD_LOGIC_VECTOR (31 downto 0);\n")

    for x in lines_r:
        f.write("(x\"%02x%02x%02x%02x\")," % (op2bin[x[0]], x[1], x[2], x[3]))
    f.write("others => x\"ff000000\");\n")

    f.write("begin\n")
    f.write("\tOUTPUT <= mem(to_integer(unsigned(addr)));\n")
    f.write("end Behavioral;\n")

    f.close()

print("[+] Nombre d'instruction : %d" % len(lines_r))
print("[+] Nombre d'adresses : %d" % len(addr_r_to_addr_m))
print("[+] Done.")