#include "ts.h"
#include <string.h>

#define TAILLE_TABLEAU 8192
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


// Ajoute un symbole 
void addTS(char name[256], enum Type typ) {
    strncpy(table[nextI].name, name, 256);
    table[nextI].type = typ;
    table[nextI].prof = currentProf;
    
    switch (typ)
    {
    case tinteger:
        table[nextI].addr = (currAddr+=TAILLE_INT);
        break;
    case tboolean:
        table[nextI].addr = (currAddr+=TAILLE_BOOL);
        break;
    case tfloat:
        table[nextI].addr = (currAddr+=TAILLE_FLOAT);
        break;
    
    default:
        break;
    }
}

int getSymbolAddr(char name[]){
    int i = 0;
    while(table[i].name != name){
        i++;
    }
    return table[i].addr;
}
enum Type getSymbolType(char name[]){
    int i = 0;
    while(table[i].name != name){
        i++;
    }
    return table[i].type;
}

// Incrémente la profondeur actuelle
void profPlus(){
    currentProf++;
}

// Décremente la profondeur actuelle et dépile les symboles de cette dernière
void profMoins(){
    while(table[nextI-1].prof == currentProf){

        switch(table[nextI-1].type){
            case tinteger:
                currAddr -= TAILLE_INT;
                break;
            case tboolean:
                currAddr -= TAILLE_BOOL;
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