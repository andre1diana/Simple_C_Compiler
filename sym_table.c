

#include "sym_table.h"

symbol_table_entry symbol_table[1000];
int symbol_table_size = 0;

void add_symbol(int temp, char *name, symbol_value value, symbol_type type)
{
    if (symbol_table_size >= 1000) {
        printf("Symbol table overflow\n");
        exit(1);
    }
    if (serarch_symbol(name).name != NULL)
    {
        printf("Error: symbol %s already exists\n", name);
        return;
    }
    symbol_table[symbol_table_size].name = strdup(name);
    symbol_table[symbol_table_size].value = value;
    symbol_table[symbol_table_size].type = type;
    symbol_table[symbol_table_size].is_temp = temp;
    symbol_table_entry val = symbol_table[symbol_table_size];
    printf("Adding symbol: %s, isTemp: %d, type: %d\n", val.name, val.is_temp, val.type);
    symbol_table_size++;
}

symbol_value get_symbol(char *name)
{
    
    for (int i = 0; i < symbol_table_size; i++)
    {
        if (strcmp(symbol_table[i].name, name) == 0)
        {
            return symbol_table[i].value;
        }
    }
    printf("Compilation error: symbol %s not found\n", name);
    symbol_value null_value;
    null_value.int_val = 0;
    return null_value;
}

symbol_table_entry serarch_symbol(char *name)
{
    for (int i = 0; i < symbol_table_size; i++)
    {
        if (strcmp(symbol_table[i].name, name) == 0)
        {
            return symbol_table[i];
        }
    }
    symbol_table_entry null_entry;
    null_entry.name = NULL;
    return null_entry;
}

symbol_table_entry get_symbol_entry(char *name)
{
    for (int i = 0; i < symbol_table_size; i++)
    {
        if (strcmp(symbol_table[i].name, name) == 0)
        {
            return symbol_table[i];
        }
    }
    printf("Compilation error: symbol %s not found\n", name);
    symbol_table_entry null_entry;
    null_entry.name = NULL;
    return null_entry;
}

void update_symbol(char *name, symbol_value value)
{
    for (int i = 0; i < symbol_table_size; i++)
    {
        if (strcmp(symbol_table[i].name, name) == 0)
        {
            symbol_table[i].value = value;
            return;
        }
    }
    printf("Error: symbol %s not found\n", name);
}

void print_symbol_table()
{
    printf("Symbol Table\n");
    for (int i = 0; i < symbol_table_size; i++)
    {
        printf("    %s: ", symbol_table[i].name);
        if (symbol_table[i].type == TYPE_INT)
        {
            printf("%d\n", symbol_table[i].value.int_val);
        }
        else if (symbol_table[i].type == TYPE_FLOAT)
        {
            printf("%f\n", symbol_table[i].value.float_val);
        }
        else if (symbol_table[i].type == TYPE_DOUBLE)
        {
            printf("%lf\n", symbol_table[i].value.double_val);
        }
    }
}

void deleteTempVars()
{
    printf("Am intrat in DeleteTempVars\n");
    for (int i = 0; i < symbol_table_size; i++)
    {
        if (symbol_table[i].is_temp == 1)
        {
            for (int j = i; j < symbol_table_size - 1; j++)
            {
                symbol_table[j] = symbol_table[j + 1];
            }
            symbol_table_size--;
        }
    }
}