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
ADD
MUL
SOU
DIV
LSL
LSR

INF
SUP
EQU

AFC
COP
NOP

JMP
JMF

PRI
RET
```
Bytecode:
```
-- Convention jeu instruction :
           -- 00000000 -> ADD
           -- 00000001 -> SOU
           -- 00000010 -> MUL
           -- 00000011 -> LSL
           -- 00000100 -> LSR
           -- 00000101 -> INF
           -- 00000110 -> SUP
           -- 00000111 -> EQU
           -- 00001000 -> AFC
           -- 00001001 -> COP
           -- 00001010 -> JMP
           -- 00001011 -> JMF
           -- 00001100 -> PRI
           -- 00001101 -> RET
           -- 11111111 -> NOP
```

## Contact
Manah7 & enjmateo (Github)
