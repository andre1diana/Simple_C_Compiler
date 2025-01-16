%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "sym_table.h"

extern char* yytext;
extern int yylex();
extern int yyparse();
extern int line_number;
extern FILE* yyin;

/* Flex buffer functions */
typedef struct yy_buffer_state* YY_BUFFER_STATE;
extern YY_BUFFER_STATE yy_scan_string(const char* str);
extern void yy_delete_buffer(YY_BUFFER_STATE buffer);

void yyerror(const char* s);

#define MAX_LINE_LENGTH 1024
#define PROMPT "> "

/* Function declarations */
void run_interactive_mode();
void execute_file(const char* filename);

//TODO increment inBlock to have a block counter and change in add_symbol function 
int inBlock = 0;

%}

%union {
    char* sval;
    int ival;
    float fval;
    double dval;
}

%token KEYWORD_INT KEYWORD_FLOAT KEYWORD_DOUBLE
%token <ival> CONST_VAL_INTEGER 
%token <fval> CONST_VAL_FLOAT 
%token <dval> CONST_VAL_DOUBLE
%token <sval> IDENTIFIER 
%token SEMICOLON 
%token COMMA
%token OP_ASSIGN
%token OP_ADD
%token OP_SUB
%token OP_MUL
%token OP_DIV
%token CAST_DOUBLE CAST_INT CAST_FLOAT
%token PRINTF SCANF
%token <sval> STRING
%token LPAREN RPAREN
%token LBRACE RBRACE

%type <ival> OPERAND_INT
%type <fval> OPERAND_FLOAT
%type <dval> OPERAND_DOUBLE

%type <ival> OPERATION_INT
%type <fval> OPERATION_FLOAT
%type <dval> OPERATION_DOUBLE

%start START

%%
START:  INSTRUCTIONS

INSTRUCTIONS: 
                | INSTRUCTIONS INSTRUCTION
                ;

INSTRUCTION:    BLOCK {inBlock = 1;}
                | DECLARATION SEMICOLON
                | OPERATION_INT SEMICOLON { printf("Result: %d\n", $1); }
                | OPERATION_FLOAT SEMICOLON { printf("Result: %f\n", $1); }
                | OPERATION_DOUBLE SEMICOLON { printf("Result: %f\n", $1); }
                | ASSIGNATION SEMICOLON
                | PRINTF LPAREN STRING RPAREN SEMICOLON { printf("Printf: %s\n", $3); }
                | PRINTF LPAREN STRING COMMA OPERAND_INT RPAREN SEMICOLON 
                {
                    char buffer[1024];
                    sprintf(buffer, $3, $5);
                    printf("Printf: %s\n", buffer);
                }
                | PRINTF LPAREN STRING COMMA OPERAND_FLOAT RPAREN SEMICOLON 
                {
                    char buffer[1024];
                    sprintf(buffer, $3, $5);
                    printf("Printf: %s\n", buffer);
                }
                | PRINTF LPAREN STRING COMMA OPERAND_DOUBLE RPAREN SEMICOLON 
                {
                    char buffer[1024];
                    sprintf(buffer, $3, $5);
                    printf("Printf: %s\n", buffer);
                }
                | SCANF LPAREN STRING COMMA IDENTIFIER RPAREN SEMICOLON 
                {
                    symbol_table_entry val;
                    val = get_symbol_entry($5);
                    printf("Scanf: ");
                    if(val.type == TYPE_INT) {
                        int temp;
                        scanf("%d", &temp);
                        val.value.int_val = temp;
                        update_symbol($5, val.value);
                    } else if(val.type == TYPE_FLOAT) {
                        float temp;
                        scanf("%f", &temp);
                        val.value.float_val = temp;
                        update_symbol($5, val.value);
                    } else if(val.type == TYPE_DOUBLE) {
                        double temp;
                        scanf("%lf", &temp);
                        val.value.double_val = temp;
                        update_symbol($5, val.value);
                    }
                }
                ;

BLOCK:  LBRACE INSTRUCTIONS  | RBRACE 
        { 
            printf("Exiting block, inBlock = %d\n", inBlock); 
            if (--inBlock == 0) { 
                deleteTempVars(); 
            }
        }
;

DECLARATION:    KEYWORD_INT IDENTIFIER  
                { 
                    printf("Found int: %s\n", $2);
                    symbol_value val;
                    val.int_val = 0;
                    if ( inBlock == 1 ) {
                        add_symbol(1, $2, val, TYPE_INT);
                    } else {
                        add_symbol(0, $2, val, TYPE_INT);
                    }
                    //add_symbol($2, val, TYPE_INT);
                }
                | KEYWORD_INT IDENTIFIER OP_ASSIGN OPERATION_INT  
                { 
                    printf("Found int: %s = %d\n", $2, $4);
                    symbol_value val;
                    val.int_val = $4;
                    //add_symbol($2, val, TYPE_INT);
                    if ( inBlock == 1 ) {
                        add_symbol(1, $2, val, TYPE_INT);
                    } else {
                        add_symbol(0, $2, val, TYPE_INT);
                    }
                }
                | KEYWORD_FLOAT IDENTIFIER  
                { 
                    printf("Found float: %s\n", $2); 
                    symbol_value val;
                    val.float_val = 0;
                    //add_symbol($2, val, TYPE_FLOAT);
                    if ( inBlock == 1 ) {
                        add_symbol(1, $2, val, TYPE_FLOAT);
                    } else {
                        add_symbol(0, $2, val, TYPE_FLOAT);
                    }
                }
                | KEYWORD_FLOAT IDENTIFIER OP_ASSIGN OPERATION_FLOAT  
                { 
                    printf("Found float: %s = %f\n", $2, $4); 
                    symbol_value val;
                    val.float_val = $4;
                    //add_symbol($2, val, TYPE_FLOAT);
                    if ( inBlock == 1 ) {
                        add_symbol(1, $2, val, TYPE_FLOAT);
                    } else {
                        add_symbol(0, $2, val, TYPE_FLOAT);
                    }
                }
                | KEYWORD_DOUBLE IDENTIFIER  
                { 
                    printf("Found double: %s\n", $2); 
                    symbol_value val;
                    val.double_val = 0;
                    //add_symbol($2, val, TYPE_DOUBLE);
                    if ( inBlock == 1 ) {
                        add_symbol(1, $2, val, TYPE_DOUBLE);
                    } else {
                        add_symbol(0, $2, val, TYPE_DOUBLE);
                    }
                }
                | KEYWORD_DOUBLE IDENTIFIER OP_ASSIGN OPERATION_DOUBLE  
                { 
                    printf("Found double: %s = %f\n", $2, $4); 
                    symbol_value val;
                    val.double_val = $4;
                    //add_symbol($2, val, TYPE_DOUBLE);
                    if ( inBlock == 1 ) {
                        add_symbol(1, $2, val, TYPE_DOUBLE);
                    } else {
                        add_symbol(0, $2, val, TYPE_DOUBLE);
                    }
                }
                ;

OPERATION_INT:  OPERATION_INT OP_ADD OPERATION_INT { $$ = $1 + $3; }
                | OPERATION_INT OP_SUB OPERATION_INT { $$ = $1 - $3; }
                | OPERATION_INT OP_MUL OPERATION_INT { $$ = $1 * $3; }
                | OPERATION_INT OP_DIV OPERATION_INT { 
                    //$$ = $1 / $3; 
                    if($3 == 0) {
                        yyerror("Error: Division by zero\n");
                        $$ = 0;
                    } else {
                        $$ = $1 / $3;
                    }
                }
                | OPERAND_INT { $$ = $1; }
                | OPERAND_FLOAT { $$ = (int)$1; }
                | OPERAND_DOUBLE { $$ = (int)$1; }
                ;
//TODO : bug to cast float to double 
OPERAND_INT:    IDENTIFIER { $$ = get_symbol($1).int_val; }
                | CONST_VAL_INTEGER
                | CAST_INT OPERAND_INT { $$ = $2; }
                | CAST_FLOAT OPERAND_INT { $$ = (float)$2; }
                | CAST_DOUBLE OPERAND_INT { $$ = (double)$2; }
                ;
               
OPERATION_FLOAT:OPERATION_FLOAT OP_ADD OPERATION_FLOAT { $$ = $1 + $3; }
                | OPERATION_FLOAT OP_SUB OPERATION_FLOAT { $$ = $1 - $3; }
                | OPERATION_FLOAT OP_MUL OPERATION_FLOAT { $$ = $1 * $3; }
                | OPERATION_FLOAT OP_DIV OPERATION_FLOAT { $$ = $1 / $3; }
                | OPERAND_INT { $$ = $1; }
                | OPERAND_FLOAT { $$ = (float)$1; }
                | OPERAND_DOUBLE { $$ = (float)$1; }

OPERAND_FLOAT:  IDENTIFIER { $$ = get_symbol($1).float_val; }
                | CONST_VAL_FLOAT
                | CAST_INT OPERAND_FLOAT { $$ = $2; }
                | CAST_FLOAT OPERAND_FLOAT { $$ = (float)$2; }
                | CAST_DOUBLE OPERAND_FLOAT { $$ = (double)$2; }
                ;

OPERATION_DOUBLE:OPERATION_DOUBLE OP_ADD OPERATION_DOUBLE { $$ = $1 + $3; }
                | OPERATION_DOUBLE OP_SUB OPERATION_DOUBLE { $$ = $1 - $3; }
                | OPERATION_DOUBLE OP_MUL OPERATION_DOUBLE { $$ = $1 * $3; }
                | OPERATION_DOUBLE OP_DIV OPERATION_DOUBLE { $$ = $1 / $3; }
                | OPERAND_INT { $$ = $1; }
                | OPERAND_FLOAT { $$ = (double)$1; }
                | OPERAND_DOUBLE { $$ = (double)$1; }

OPERAND_DOUBLE: IDENTIFIER { $$ = get_symbol($1).double_val; }
                | CONST_VAL_DOUBLE
                | CAST_INT OPERAND_DOUBLE { $$ = $2; }
                | CAST_FLOAT OPERAND_DOUBLE { $$ = (float)$2; }
                | CAST_DOUBLE OPERAND_DOUBLE { $$ = (double)$2; }
                ;

ASSIGNATION:     IDENTIFIER OP_ASSIGN OPERATION_INT { symbol_value val; val.int_val = $3; update_symbol($1, val); }
                | IDENTIFIER OP_ASSIGN OPERATION_FLOAT { symbol_value val; val.float_val = $3; update_symbol($1, val); }
                | IDENTIFIER OP_ASSIGN OPERATION_DOUBLE { symbol_value val; val.double_val = $3; update_symbol($1, val); }
                ;
%%

void yyerror(const char* s) {
    //had_error = 1;
    fprintf(stderr, "Error at line %d: %s\n", line_number, s);
}

void run_interactive_mode() {
    char line[MAX_LINE_LENGTH];

    printf(PROMPT);

    while (fgets(line, MAX_LINE_LENGTH, stdin)) {
        if (strncmp(line, "exit", 4) == 0) {
            break;
        }

        //had_error = 0;

        if (strncmp(line, "run ", 4) == 0) {
            char* filename = line + 4;
            filename[strcspn(filename, "\n")] = 0; // Remove newline
            execute_file(filename);
        } else {
            YY_BUFFER_STATE buffer = yy_scan_string(line);
            yyparse();
            yy_delete_buffer(buffer);
        }

        printf(PROMPT);
    }
}

void execute_file(const char* filename) {
    FILE* file = fopen(filename, "r");
    if (!file) {
        printf("Error: Could not open file %s\n", filename);
        return;
    }

    //had_error = 0;

    char line[MAX_LINE_LENGTH];
    while (fgets(line, MAX_LINE_LENGTH, file)) {
        YY_BUFFER_STATE buffer = yy_scan_string(line);
        yyparse();
        yy_delete_buffer(buffer);
    }
    fclose(file);
}

int main(int argc, char** argv) {
    printf("Simple C compiler\n");
    printf("Enter expressions or 'exit' to quit:\n");

    if (argc > 1) {
        execute_file(argv[1]);
    } else {
        run_interactive_mode();
    }
    print_symbol_table();

    return 0;
}

