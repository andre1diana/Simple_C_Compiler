#ifndef SYM_TABLE_H
#define SYM_TABLE_H


#include <stdio.h>
#include <string.h>

typedef union symbol_value 
{
    int int_val;
    float float_val;
    double double_val;
}symbol_value;

typedef enum symbol_type
{
    TYPE_INT,
    TYPE_FLOAT,
    TYPE_DOUBLE
}symbol_type;

typedef struct symbol_table_entry
{
    char *name;
    symbol_type type;
    symbol_value value;
    int is_temp;
}symbol_table_entry;



void add_symbol(int temp, char *name, symbol_value value, symbol_type type);
symbol_table_entry get_symbol_entry(char *name);
symbol_value get_symbol(char *name);
void update_symbol(char *name, symbol_value value);
void print_symbol_table();
symbol_table_entry serarch_symbol(char *name);
void deleteTempVars();



#endif // SYM_TABLE_H