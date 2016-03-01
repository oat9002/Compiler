%{
	#include<stdio.h>
	#include<math.h>
	#include<stdlib.h>
	#define YYSTYPE int
	typedef struct {
		int data;
		int next;
	} Stack;
	Stack stack;
	int start=0;
	int r[10];
	int acc;
	int top;
	int size;

%}
/*token*/
%token R0 0 R1 1 R2 2 R3 3 R4 4 R5 5 R6 6 R7 7 R8 8 R9 9
%token ACC 11 TOP 12 SIZE 13
%token LOAD
%token SHOW
%token CONSTANT
%left OR
%left AND
%left '-' '+'
%left '*' '/' '\\'
%right NEG NOT
%right '^'

%%
input :	 | input line
line :	'\n'
	| exp '\n'					{ printf("%d\n",$1); }
	| SHOW reg '\n'			{ printf("%d\n",$2); }
	| LOAD reg '>' reg '\n' 	{
 										if( $2 == TOP || $2 == SIZE){ printf("Can't assign $top or $size to register.");}
										else if( $4 == TOP || $4 == SIZE){ printf("Can't assign register to $top or $size.");}
										else {printf("%d %d\n",$2 ,$4); }}
	| error '\n'			{ yyerrok; }
exp :	  CONSTANT {$$ = $1;}
		| exp OR exp	{$$ = $1 | $3;}
		| exp AND exp	{$$ = $1 & $3;}
		| NOT exp	{$$ = ~$2;}
		| exp '+' exp	{$$ = $1 + $3;}
		| exp '-' exp	{$$ = $1 - $3;}
		| exp '*' exp	{$$ = $1 * $3;}
		| exp '/' exp	{ if($3==0)
		{yyerror("Can't divide by 0.");}
		else $$ = $1 / $3;}
		| exp '\\' exp	{ if($3==0)
		{yyerror("Can't divide by 0."); }
		else
		$$ = $1 % $3;}
		| '-' exp %prec NEG	{$$ = -$2;}
		| exp '^' exp	{$$ = pow($1,$3);}
		| '(' exp ')'	{$$ = $2;}
reg:	R0
	|R1 {$$ = R1; }
	|R2	{$$ = R2; }
	|R3 {$$ = R3; }
	|R4	{$$ = R4; }
	|R5	{$$ = R5; }
	|R6	{$$ = R6; }
	|R7 {$$ = R7; }
	|R8	{$$ = R8; }
	|R9 {$$ = R9; }
	|ACC {$$ = ACC; }
	|TOP {$$ = TOP; }
	|SIZE {$$ = SIZE; }

%%

void yyerror(char const *str) {
	printf("\tError just happened.\n ");
}
int main() {
	yyparse();
	return 0;
}
