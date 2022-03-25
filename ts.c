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
    printf("TABLE SYMBOLES (prof:%d, nextI%d)\n", currentProf, nextI);
    printf("Name\tAddr\tProf\n");
    for (size_t i = 0; i < 10; i++)
    {
        printf("%s\t%d\t%d\n", table[i].name, table[i].addr, table[i].prof);
    }   
}


int find(char name[TAILLE_SYMBOLE]){
    // Debug
    bcc_print("Fonction find, recherche de : ");
    bcc_print(name);
    bcc_print("\n");

    int i = 0;
    while(!strncmp(table[i].name, name, strlen(name)) && i != nextI){
        i++;
    }

    if(i == nextI){
        return -1;
    } else {
        return i;
    }
}

// Ajoute un symbole 
int add_ts(char name[TAILLE_SYMBOLE], enum Type typ) {
    printf("NAME = %s\n", name);
    
    if(find(name) != -1){
        panic("Redeclaration of variable (add_ts)");
    }

    strncpy(&name, &table[nextI].name, strlen(name));
    table[nextI].type = typ;
    table[nextI].prof = currentProf;
    
    switch (typ)
    {
    case tinteger:
        table[nextI].addr = currAddr;
        currAddr+=TAILLE_INT;
        break;
    case tvoid:
        panic("A variable can't have void type.");
        break;
    case tfloat:
        table[nextI].addr = currAddr;
        currAddr+=TAILLE_FLOAT;
        break;
    
    default:
        break;
    }
    nextI++;
    print_ts();
    return table[nextI].addr;
}

int add_ts_wn() {
    strncpy("TMP", &table[nextI].name, 3);
    table[nextI].prof = currentProf;
    table[nextI].addr = currAddr;
    currAddr+=TAILLE_INT;
    nextI++;
    printf("TEMPORAIRE\n");
    print_ts();
    return table[nextI].addr;
}

int get_symbol_addr(char name[TAILLE_SYMBOLE]){
    int i = find(name);
    if( i == -1){
        panic("Opération sur variable non déclarée (symbol addr)");
    }
    return table[i].addr;
}
enum Type get_symbol_type(char name[TAILLE_SYMBOLE]){
    int i = find(name);
    if( i == -1){
        panic("Opération sur variable non déclarée (symbol type)");
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
