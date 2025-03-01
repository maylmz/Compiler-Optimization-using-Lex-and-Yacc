%{
	#include <stdio.h>
	#include <iostream>
	#include <string>
	#include <vector>
    #include <cstring>
    #include <cmath> 
	using namespace std;
	#include "y.tab.h"
	extern FILE *yyin;
	extern int yylex();
	void yyerror(string s);	
	vector<string> vars;
	
	bool is_const_flag = true;
	
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
		is_const_flag = true;
		new_assignment += string($1) + "=" + string($3) + ";" + "\n";
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
		if (is_const_flag) {
			int left = std::stoi($1);
			int right = std::stoi($3);
			int result = left + right;
        
			$$ = strdup(to_string(result).c_str());
		
		}else {
			string leftOp = $1;
			string rightOp = $3;
			string resultOp = leftOp + "+" + rightOp;

            $$ = strdup(resultOp.c_str());

		}
	}	
	|
	operand SUB operand
	{
		if (is_const_flag) {
			int left = std::stoi($1);
			int right = std::stoi($3);
			int result = left - right;
        
			$$ = strdup(to_string(result).c_str());
		
		}else {
			string leftOp = $1;
			string rightOp = $3;
			string resultOp = leftOp + "-" + rightOp;

			$$ = strdup(resultOp.c_str());

		}
	}	
	|
	operand MUL operand
	{
		if (is_const_flag) {
			int left = std::stoi($1);
			int right = std::stoi($3);
			int result = left * right;
        
			$$ = strdup(to_string(result).c_str());
		
		}else {
			string leftOp = $1;
			string rightOp = $3;
			string resultOp = leftOp + "*" + rightOp;

			$$ = strdup(resultOp.c_str());

		}
	}	
	|
	operand DIV operand
	{
		if (is_const_flag) {
			int left = std::stoi($1);
			int right = std::stoi($3);
			int result = left / right;
        
			$$ = strdup(to_string(result).c_str());
		
		}else {
			string leftOp = $1;
			string rightOp = $3;
			string resultOp = leftOp + "/" + rightOp;

			$$ = strdup(resultOp.c_str());

		}
	}
	|
	operand POWER operand
	{
		if (is_const_flag) {
			int left = std::stoi($1);
			int right = std::stoi($3);
			int result = pow(left, right);
        
			$$ = strdup(to_string(result).c_str());
		
		}else {
			string leftOp = $1;
			string rightOp = $3;
			string resultOp = leftOp + "^" + rightOp;

			$$ = strdup(resultOp.c_str());

		}
	}
	;
	
operand:
    IDENTIFIER  {
    is_const_flag = false;
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
