%{
#include <stdio.h>
#include <stdlib.h>
#include "parser.tab.h"

extern int yylex();
extern int yyparse();
int line_number = 1;;
void yyerror(const char *s);
%}

name            [a-zA-Z_][a-zA-Z0-9_]*
int_value       0|[-]?[1-9][0-9]*
float_value     {int_value}(\.{int_value})?f
double_value    {int_value}(\.{int_value})?
string          \"[^\"]*\"
comment         \/\/.*
commentln_start \/\*
commentln_end   \*\/

%x COMMENT

%%
"int"           { return KEYWORD_INT; }
"float"         { return KEYWORD_FLOAT; }
"double"        { return KEYWORD_DOUBLE; }

"printf"        { return PRINTF; }
"scanf"         { return SCANF; }

{int_value}     { yylval.ival = atoi(yytext); return CONST_VAL_INTEGER; }
{float_value}   { yylval.fval = atof(yytext); return CONST_VAL_FLOAT; }
{double_value}  { yylval.dval = atof(yytext); return CONST_VAL_DOUBLE; }

{name}          { yylval.sval = strdup(yytext); return IDENTIFIER; }

";"             { return SEMICOLON; }
","             { return COMMA; }

"="             { return OP_ASSIGN; }
"+"             { return OP_ADD; }
"-"             { return OP_SUB; }
"*"             { return OP_MUL; }
"/"             { return OP_DIV; }

"(double)"      { return CAST_DOUBLE; }
"(float)"       { return CAST_FLOAT; }
"(int)"         { return CAST_INT; }

{string}        { yylval.sval = strdup(yytext); return STRING; }
"("             { return LPAREN; }
")"             { return RPAREN; }
"{"             { return LBRACE; }
"}"             { return RBRACE; }


[ \t]           { /* ignore whitespace */ }
{comment}       { /* ignore comments */ }
{commentln_start} { BEGIN(COMMENT); }
<COMMENT>{commentln_end} { BEGIN(INITIAL); }
<COMMENT>.|\n   { if (yytext[0] == '\n') line_number++; }
[\n]            { line_number++; }

%%