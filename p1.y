%{

#include <stdio.h>
#include <stdlib.h>
#include <math.h>


extern int yylex();
extern int yyparse();
extern FILE* yyin;

void yyerror(const char* s);
%}

%union {
	int ival;
	float fval;
}

//%token <ival> INUMBER
//%token <fval> FNUMBER
%token ADD SUB MUL DIV I V X L C D M DOT EOL
%left ADD SUB
%left MUL DIV
%type <ival> exp
%type <ival> INUMBER ONES TENS HUNDREDS
%type <fval> mixed-exp FNUMBER TENTHS HUNDREDTHS THOUSANDTHS

//exit(0);
%%
calclist:
		| calclist exp EOL {printf ("%d\n",$2);}
		| calclist mixed-exp EOL {printf("%f\n",$2);}

mixed-exp: FNUMBER
		| mixed-exp ADD mixed-exp { $$ = $1+$3; }
		| mixed-exp SUB mixed-exp { $$ = $1-$3; }
		| mixed-exp MUL mixed-exp { $$ = $1*$3; }
		| mixed-exp DIV mixed-exp { $$ = $1/$3; }
		| mixed-exp ADD exp { $$ = $1+$3; }
		| mixed-exp SUB exp { $$ = $1-$3; }
		| mixed-exp MUL exp { $$ = $1*$3; }
		| mixed-exp DIV exp { $$ = $1/$3; }
		| exp ADD mixed-exp { $$ = $1+$3; }
		| exp SUB mixed-exp { $$ = $1-$3; }
		| exp MUL mixed-exp { $$ = $1*$3; }
		| exp DIV mixed-exp { $$ = $1/$3; }

FNUMBER: INUMBER DOT TENTHS {$$ = $1 + ($3/10);}
		|INUMBER DOT HUNDREDTHS TENTHS {$$ = $1 + ($3/10+$4/100);}
		|INUMBER DOT THOUSANDTHS HUNDREDTHS TENTHS {$$ = $1 + ($3/10+$4/100+$5/1000);}

THOUSANDTHS: {$$ = 0;}
		| C {$$ = 1;}
		| C C {$$ = 2;}
		| C C C {$$ = 3;}
		| C D {$$ = 4;}
		| D {$$ = 5;}
		| D C {$$ = 6;}
		| D C C {$$ = 7;}
		| D C C C {$$ = 8;}
		| C M {$$ = 9;}


HUNDREDTHS: {$$ = 0;}
		| X {$$ = 1;}
		| X X {$$ = 2;}
		| X X X {$$ =3;}
		| X L {$$ = 4;}
		| L {$$ = 5;}
		| L X {$$ = 6;}
		| L X X {$$ = 7;}
		| L X X X {$$ = 8;}
		| X C {$$ = 9;}

TENTHS: {$$ = 0;}
		| I {$$ = 1;}
		| I I {$$ = 2;}
		| I I I {$$ = 3;}
		| I V {$$ = 4;}
		| V {$$ = 5;}
		| V I {$$ = 6;}
		| V I I {$$ = 7;}
		| V I I I {$$ = 8;}
		| I X {$$ = 9;}


exp:  exp ADD exp { $$ = $1+$3; }
		| exp SUB exp { $$ = $1-$3; }
		| exp MUL exp { $$ = $1*$3; }
		| exp DIV exp { $$ = $1/$3; }
		| INUMBER
INUMBER: HUNDREDS TENS ONES {$$ =$1 + $2 + $3;}

ONES: {$$ = 0;}
		| I {$$ = 1;}
		| I I {$$ = 2;}
		| I I I {$$ = 3;}
		| I V {$$ = 4;}
		| V {$$ = 5;}
		| V I {$$ = 6;}
		| V I I {$$ = 7;}
		| V I I I {$$ = 8;}
		| I X {$$ = 9;}
TENS: {$$ = 0;}
		| X {$$ = 10;}
		| X X {$$ = 20;}
		| X X X {$$ = 30;}
		| X L {$$ = 40;}
		| L {$$ = 50;}
		| L X {$$ = 60;}
		| L X X {$$ = 70;}
		| L X X X {$$ = 80;}
		| X C {$$ = 90;}
HUNDREDS: {$$ = 0;}
		| C {$$ = 100;}
		| C C {$$ = 200;}
		| C C C {$$ = 300;}

//SOMETHINGELSE: T_TEST { printf("This part is the attribute grammar of your CFG"); }

%%

int main() {
	yyin = stdin;

	do {
		yyparse();
	} while(!feof(yyin));

	return 0;
}

void yyerror(const char* s) {
	fprintf(stderr, "Parse error: %s\n", s);
	exit(1);
}
