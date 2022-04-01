#include "ts.h"
#include "utils.h"
#include "operations.h"
#include <string.h>
#include <stdio.h>

#define TAILLE_TABLEAU 8192
#define TAILLE_SYMBOLE 128
#define TAILLE_INT 4
#define TAILLE_BOOL 1
#define TAILLE_FLOAT 4

typedef struct {
    char name[TAILLE_SYMBOLE];
    int addr;
    enum Type type;
    int prof;
} symbolTable;

symbolTable table[TAILLE_TABLEAU];
int currentProf = 0;
int nextI = 0;
int currAddr = 0 ;


void print_ts(){
    return;
    printf("=========== TEMPORAIRE - A ENLEVER ===========\n");
    printf("TABLE SYMBOLES (prof: %d; nextI: %d)\n", currentProf, nextI);
    printf("Name\tAddr\tProf\n");
    for (size_t i = 0; i < 10; i++)
    {
        printf("%s\t%d\t%d\n", table[i].name, table[i].addr, table[i].prof);
    }   
}


int find(char name[TAILLE_SYMBOLE]){
    bcc_print("[+] Fonction find, recherche de : ");
    bcc_print(name);
    bcc_print("\n");

    int i = 0;
    while(strcmp(table[i].name, name) != 0 && i != nextI){
        i++;
    }

    if(i == nextI){
        bcc_print("[-] Non trouvé\n");
        return -1;
    } else {
        bcc_print("[+] Trouvé\n");
        return i;
    }
}

// Ajoute un symbole 
int add_ts(char *name_r, enum Type typ) {
    bcc_print("[+] Entrée fonction add_ts\n");

    char name[TAILLE_SYMBOLE];
    memset(name, 0, TAILLE_SYMBOLE);
    strncpy(name, name_r, strlen(name_r));
    
    if(find(name) != -1){
        panic("Redeclaration of variable (add_ts)");
    }

    memset(table[nextI].name, 0, TAILLE_SYMBOLE);
    strncpy(table[nextI].name, name, strlen(name));

    table[nextI].type = typ;
    table[nextI].prof = currentProf;
    
    switch (typ)
    {
    case tinteger:
        bcc_print("[+] Ajout d'un integer\n");
        table[nextI].addr = currAddr;
        currAddr+=TAILLE_INT;
        break;
    case tvoid:
        panic("A variable can't have void type.\n");
        break;
    case tfloat:
        bcc_print("[+] Ajout d'un float\n");
        table[nextI].addr = currAddr;
        currAddr+=TAILLE_FLOAT;
        break;
    
    default:
        break;
    }
    nextI++;
    print_ts();
    return table[nextI-1].addr;
}

int add_ts_wn() {
    bcc_print("[+] Entrée fonction add_ts_wn\n");

    memset(table[nextI].name, 0, TAILLE_SYMBOLE);
    strcpy(table[nextI].name, "TMP");

    table[nextI].prof = currentProf;
    table[nextI].addr = currAddr;
    currAddr += TAILLE_INT;
    nextI++;

    // Debug
    print_ts();

    return table[nextI-1].addr;
}

int get_symbol_addr(char *name_r){
    bcc_print("[+] Entrée fonction get_symbol_addr :\n");

    char name[TAILLE_SYMBOLE];
    memset(name, 0, TAILLE_SYMBOLE);
    strncpy(name, name_r, strlen(name_r));

    int i = find(name);
    if( i == -1){
        panic("Opération sur variable non déclarée (symbol addr)\n");
    }

    bcc_print("[+] Adresse trouvée : <COMMENT>\n");
    //printf("%d\n", table[i].addr);
    return table[i].addr;
}

enum Type get_symbol_type(char *name_r){
    bcc_print("[+] Entrée fonction get_symbol_type\n");
    
    char name[TAILLE_SYMBOLE];
    memset(name, 0, TAILLE_SYMBOLE);
    strncpy(name, name_r, strlen(name_r));

    int i = find(name);
    if( i == -1){
        panic("Opération sur variable non déclarée (symbol type)\n");
    }
    return table[i].type;
}

// Incrémente la profondeur actuelle
void prof_plus(){
    currentProf++;
}

// Décremente la profondeur actuelle et dépile les symboles de cette dernière
void prof_moins(){
    while(table[nextI-1].prof == currentProf){

        switch(table[nextI-1].type){
            case tinteger:
                currAddr -= TAILLE_INT;
                break;
            case tfloat:
                currAddr -= TAILLE_FLOAT;
                break;
            
            default:
                break;
        }
        nextI--;
    }
    currentProf--;
    print_ts();

}
