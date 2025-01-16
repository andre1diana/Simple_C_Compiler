all: lexer.l parser.y sym_table.c
	bison -d parser.y
	flex lexer.l
	gcc lex.yy.c parser.tab.c sym_table.c -o compiler -lfl -w

run: all
	./compiler ex.txt

clean:
	rm -f lex.yy.c parser.tab.c parser.tab.h compiler