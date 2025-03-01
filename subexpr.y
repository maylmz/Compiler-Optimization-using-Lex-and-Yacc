%{
	#include <stdio.h>
	#include <iostream>
	#include <string>
	#include <vector>
    #include <cstring>
    #include <cmath> 
	#include <map>
	using namespace std;
	#include "y.tab.h"
	extern FILE *yyin;
	extern int yylex();
	void yyerror(string s);	
	vector<string> vars;
	
	map<string, string> subexpressionTable;
	string new_assignment;
	
%}

%union
{
	int value;
	char * str;
}


%type <str> expression operand
%token <str> IDENTIFIER INTEGER
%token EQUAL ADD SUB MUL DIV POWER SEMICOLON


%%

program:
	statement
	| statement program
	;
	
statement:
	assignment
	;
	
assignment:
	IDENTIFIER EQUAL expression SEMICOLON
	{
		new_assignment += string($1) + "=" + string($3) + ";" + "\n";
		
		subexpressionTable[string($3)] = string($1);

	}
	;
	
	expression:
	operand
	{
		$$ = $1;
	}
	|
	
	operand ADD operand
	{
		string subexpr = string($1) + "+" + string($3);

		if (subexpressionTable.find(subexpr) != subexpressionTable.end()) {
			$$ = strdup(subexpressionTable[subexpr].c_str());
		} 
		else {
			$$ = strdup(subexpr.c_str());	
		}
	}	
	|
	operand SUB operand
	{
		string subexpr = string($1) + "-" + string($3);

		if (subexpressionTable.find(subexpr) != subexpressionTable.end()) {
			$$ = strdup(subexpressionTable[subexpr].c_str());
		} 
		else {
			$$ = strdup(subexpr.c_str());	
		}
	}	
	|
	operand MUL operand
	{
		string subexpr = string($1) + "*" + string($3);

		if (subexpressionTable.find(subexpr) != subexpressionTable.end()) {
			$$ = strdup(subexpressionTable[subexpr].c_str());
		} 
		else {
			$$ = strdup(subexpr.c_str());	
		}
	}	
	|
	operand DIV operand
	{
		string subexpr = string($1) + "/" + string($3);

		if (subexpressionTable.find(subexpr) != subexpressionTable.end()) {
			$$ = strdup(subexpressionTable[subexpr].c_str());
		} 
		else {
			$$ = strdup(subexpr.c_str());	
		}
	}
	|
	operand POWER operand
	{
		string subexpr = string($1) + "^" + string($3);

		if (subexpressionTable.find(subexpr) != subexpressionTable.end()) {
			$$ = strdup(subexpressionTable[subexpr].c_str());
		} 
		else {
			$$ = strdup(subexpr.c_str());	
		}
	}
	;
	
operand:
    IDENTIFIER  {
		$$ = $1;
    }
    | 
    INTEGER {
		$$ = $1;
    }
    ;
%%
void yyerror(string s){
	cerr<<"Error..."<<endl;
}
int yywrap(){
	return 1;
}
int main(int argc, char *argv[])
{
    /* Call the lexer, then quit. */
    yyin=fopen(argv[1],"r");
    yyparse();
    fclose(yyin);
	cout << new_assignment;
    return 0;
}
