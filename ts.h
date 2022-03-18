#ifndef TS_H
#define TS_H

enum Type {tinteger, tboolean, tfloat};

// Ajoute un symbole 
void addTS(char name[256], enum Type typ);

int getSymbolAddr(char name[]);
enum Type getSymbolType(char name[]);

// Incrémente la profondeur actuelle
void profPlus();

// Décremente la profondeur actuelle et dépile les symboles de cette dernière
void profMoins();

#endif