%option noyywrap

%{
#include <stdio.h>

#define YY_DECL int yylex()

#include "p1.tab.h"
//[0-9]+ {yylval.ival = atoi(yytext); return INUMBER;}
//[0-9]+\.[0-9]+ 	{yylval.fval = atof(yytext); return FNUMBER;}
%}

%%
"+" {return ADD;}
"-" {return SUB;}
"*" {return MUL;}
"/" {return DIV;}
"I" {return I;}
"V" {return V;}
"X" {return X;}
"C" {return C;}
"D" {return D;}
"M" {return M;}
"L" {return L;}
"." {return DOT;}
[ \t] ;
\n {return EOL;}
%%
