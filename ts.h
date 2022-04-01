#ifndef TS_H
#define TS_H

enum Type {
    tvoid = 0, 
    tinteger = 1,
    tfloat = 2
};

// Ajoute un symbole 
int add_ts(char *name_r, enum Type typ);

int get_symbol_addr(char *name_r);
enum Type get_symbol_type(char *name_r);

// Incrémente la profondeur actuelle
void prof_plus();

// Décremente la profondeur actuelle et dépile les symboles de cette dernière
void prof_moins();

int add_ts_wn();

#endif