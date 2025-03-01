all: subexpr folding propogation

subexpr: lex subexpr_yacc
	g++ lex.yy.c y.tab.c -ll -o subexpr.o

folding: lex folding_yacc
	g++ lex.yy.c y.tab.c -ll -o folding.o

propogation: lex propogation_yacc
	g++ lex.yy.c y.tab.c -ll -o propogation.o

folding_yacc: folding.y
	yacc -d folding.y

subexpr_yacc: subexpr.y
	yacc -d subexpr.y

propogation_yacc: propogation.y
	yacc -d propogation.y

lex: lex.l
	lex lex.l

clean: 
	rm *.c *.h *.o
