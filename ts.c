#include "ts.h"
#include "utils.h"
#include <string.h>

#define TAILLE_TABLEAU 8192
#define TAILLE_SYMBOLE 128
#define TAILLE_INT 4
#define TAILLE_BOOL 1
#define TAILLE_FLOAT 4

typedef struct {
    char name[256];
    int addr;
    enum Type type;
    int prof;
} symbolTable;

symbolTable table[TAILLE_TABLEAU];
int currentProf = 0;
int nextI = 0;
int currAddr = 0 ;

int find(char name[TAILLE_SYMBOLE]){
    int i = 0;
    while(!strncmp(table[i].name, name, strlen(name)) && i != nextI){
        i++;
    }
    if(i==nextI){
        return -1;
    }else{
        return i;
    }
}


// Ajoute un symbole 
int add_ts(char name[TAILLE_SYMBOLE], enum Type typ) {
    
    if(find(name)==-1){
        panic("redeclaration of variable");
    }
    strncpy(table[nextI].name, name, TAILLE_SYMBOLE);
    table[nextI].type = typ;
    table[nextI].prof = currentProf;
    
    switch (typ)
    {
    case tinteger:
        table[nextI].addr = currAddr+=TAILLE_INT;
        break;
    case tvoid:
        panic("A variable can't have void type.");
        break;
    case tfloat:
        table[nextI].addr = currAddr+=TAILLE_FLOAT;
        break;
    
    default:
        break;
    }

    return table[nextI].addr;
}

int get_symbol_addr(char name[]){
    int i = find(name);
    if( i == -1){
        panic("Opération sur variable non déclarée");
    }
    return table[i].addr;
}
enum Type get_symbol_type(char name[]){
    int i = find(name);
    if( i == -1){
        panic("Opération sur variable non déclarée");
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
}