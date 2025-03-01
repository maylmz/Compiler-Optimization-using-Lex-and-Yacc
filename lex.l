%{
#include <stdio.h>
#include <string.h>
#include "y.tab.h"
int linenum;
%}
%%

[0-9]+	{yylval.str = strdup(yytext); return INTEGER;}
\+	return ADD;
\-  return SUB;
\*  return MUL;
\/  return DIV;
\^  return POWER;
=	return EQUAL;
";" return SEMICOLON;
\n	linenum++;
[a-z]([a-z]|[0-9])*	{yylval.str = strdup(yytext); return IDENTIFIER;}

[ \t]+
%%

