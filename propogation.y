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
	
	map<string, int> constantArr;
	
	bool is_constprop_flag = true;
	
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
		if (is_constprop_flag){
			constantArr[$1] = atoi($3);
		}
		else{
			constantArr.erase($1);
		}
		
		new_assignment += string($1) + "=" + string($3) + ";" + "\n";
	}
	;	
	
	expression:
	operand
	{
		is_constprop_flag = true;
		$$ = $1;
	}
	|
	
	operand ADD operand
	{
			string leftOp = $1;
			string rightOp = $3;
			string resultOp = leftOp + "+" + rightOp;

            $$ = strdup(resultOp.c_str());
	}	
	|
	operand SUB operand
	{
			string leftOp = $1;
			string rightOp = $3;
			string resultOp = leftOp + "-" + rightOp;

			$$ = strdup(resultOp.c_str());

	}	
	|
	operand MUL operand
	{
			string leftOp = $1;
			string rightOp = $3;
			string resultOp = leftOp + "*" + rightOp;

			$$ = strdup(resultOp.c_str());
	}	
	|
	operand DIV operand
	{
			string leftOp = $1;
			string rightOp = $3;
			string resultOp = leftOp + "/" + rightOp;

			$$ = strdup(resultOp.c_str());
	}
	|
	operand POWER operand
	{
			string leftOp = $1;
			string rightOp = $3;
			string resultOp = leftOp + "^" + rightOp;

			$$ = strdup(resultOp.c_str());
	}
	;
	
operand:
    IDENTIFIER  {
		if (constantArr.find($1) != constantArr.end()){
			$$ = strdup(to_string(constantArr[$1]).c_str());
		}
		else{
			$$ = $1;
		}
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
