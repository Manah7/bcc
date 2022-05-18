# Basic C Compiler
BCC is a basic C compiler.

## TODO-list
* Ajouter un segment mémoire proche à chaque fonction.
* Terminer l'interpreteur.

## Examples
```
$ make
$ ./bcc < example/4example.c 2>/dev/null
main:
1	AFC 4 2 
2	COP 0 4 
3	AFC 8 2 
4	EQU 12 0 8
5	JMF 12 7 0
6	PRI 0 
7	AFC 20 9 
8	COP 16 20
```

## Supported functions
* **Athm**: Addition
* **Athm**: Soustraction
* **Athm**: Multiplication
* **Athm**: Division

* **Athm**: Plus égal
* **Athm**: Moins égal

* **Fctn**: Print
* **Loop**: If

## Instruction set
Supported instructions:
```
ADD c
MUL c
SOU c
DIV c
LSL c
LSR c

INF c
SUP c
EQU c

AFC c
COP c
LDR c
STR c
NOP c

JMP ar
JMF ar
MOV
CALL (ASM only)

PRI
RET
```
Bytecode:
```
-- Convention jeu instruction :
           -- 0   00000000 -> ADD
           -- 1   00000001 -> SOU
           -- 2   00000010 -> MUL
           -- 3   00000011 -> LSL
           -- 4   00000100 -> LSR
           -- 5   00000101 -> INF
           -- 6   00000110 -> SUP
           -- 7   00000111 -> EQU
           -- 8   00001000 -> AFC
           -- 9   00001001 -> COP
           -- 10  00001010 -> JMP
           -- 11  00001011 -> JMF
           -- 12  00001100 -> PRI
           -- 13  00001101 -> RET
           -- 14  00001110 -> LDR
           -- 15  00001111 -> STR
           -- 255 11111111 -> NOP
```
Registers:
```
r0
r1
r2
r3
r4
r5
r6
r7
r8
r9
r10
r11
r12
r13
r14
```

## Contact
Manah7 & enjmateo (Github)
