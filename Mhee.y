%{
	#include<stdio.h>
	#include<math.h>
	#include<stdlib.h>
	#define YYSTYPE int
	// Stack //
	typedef struct node node;
	struct node{
		int data;
		node* next;
	};
	node* head = NULL;
	node* tail = NULL;
	// Register //
	int r[15];
	void push(int data);
	int pop();
	void count();
	void setTopAndSize();
	int isEmpty();
	int er=0;
%}
/*token*/
%token R0 14 R1 1 R2 2 R3 3 R4 4 R5 5 R6 6 R7 7 R8 8 R9 9
%token ACC 11 TOP 12 SIZE 13
%token LOAD
%token SHOW
%token POP
%token PUSH
%token CONSTANT
%token ERR
%left OR
%left AND
%left '-' '+'
%left '*' '/' '\\'
%right NEG NOT
%right '^'
%%
input :	 | input line
line :	'\n'
	| exp '\n'					{ if(er==0){ printf("%d\n",$1); }
											  else{er=0;} }
	| rexp '\n'					{ if(er==0){ printf("%d\n",$1); }
											  else{er=0;} }
	| SHOW reg '\n'			{ printf("%d\n",r[$2]); }
	| LOAD reg '>' reg '\n' 	{ if( $4 == TOP || $4 == SIZE || $4 == ACC){ printf("Can't assign register to $top or $size or $a.\n");yyerror();}
															else { r[$4] = r[$2]; } }
	| PUSH reg 					{ push(r[$2]); setTopAndSize();}
	| POP reg						{ if($2 != ACC && $2 != TOP && $2 != SIZE) { if(!isEmpty()) { r[$2] = pop(); setTopAndSize(); }
 																																	 else { printf("Stack is Empty.\n"); yyerror();} }
												else { printf("Can't assign number to $acc or $top or $size\n");yyerror();} }
	| SHOW ERR			  	{ printf("SHOW only follow by register");er=1;yyerror();}
	| SHOW error			  { printf("SHOW only follow by register");er=1;yyerror();}
 	| LOAD ERR				  { printf("ERROR!2");er=1;yyerror();}
  	| LOAD error				{ printf("");er=1;yyerror();}
	| PUSH ERR			  	{ printf("Can't PUSH this input"); er=1;yyerror();}
	| PUSH error			  { printf("Can't PUSH this input"); er=1;yyerror();}
	| POP ERR			  		{ printf("Can't POP to this input"); er=1;yyerror();}
  	| POP error			  	{ printf("Can't POP to this input"); er=1;yyerror();}
	| exp ERR 					{ printf("ERROR!");yyerror();}
	| exp error 				{ printf("ERROR!");yyerror();}
	| ERR	   						{ printf("ERROR!");yyerror();}
	| error 						{ yyerror();}
exp :	  CONSTANT  		{ $$ = $1; r[ACC] = $1;}
		| exp OR exp			{ $$ = $1 | $3; r[ACC] = $1 | $3;}
		| exp AND exp			{ $$ = $1 & $3; r[ACC] = $1 & $3;}
		| NOT exp					{ $$ = ~$2; r[ACC] = ~$2;}
		| exp '+' exp			{ $$ = $1 + $3; r[ACC] = $1 + $3;}
		| exp '-' exp			{ $$ = $1 - $3; r[ACC] = $1 - $3;}
		| exp '*' exp			{ $$ = $1 * $3; r[ACC] = $1 * $3;}
		| exp '/' exp			{ if($3 == 0) { printf("Can't divide by 0."); er=1;yyerror();}
												else $$ = $1 / $3; r[ACC] = $1 / $3; }
		| exp '\\' exp		{ if($3 == 0) { printf("Can't mod by 0."); yyerror();er=1;}
												else $$ = $1 % $3; r[ACC] = $1 % $3;}
		| '-' exp 			{ $$ = -$2; r[ACC] = -$2;}
		| exp '^' exp			{ $$ = pow($1,$3); r[ACC] = pow($1,$3);}
		| '(' exp ')'			{ $$ = $2; r[ACC] = $2;}

rexp:		 reg 				{ $$ = r[$1]; r[ACC] = r[$1]; }
		| reg OR reg			{ $$ = r[$1] | r[$3]; r[ACC] = r[$1] | r[$3];}
		| reg AND reg			{ $$ = r[$1] & r[$3]; r[ACC] = r[$1] & r[$3];}
		| NOT reg					{ $$ = ~r[$2]; r[ACC] = ~r[$2];}
		| reg '+' reg			{ $$ = r[$1] + r[$3]; r[ACC] = r[$1] + r[$3];}
		| reg '-' reg			{ $$ = r[$1] - r[$3]; r[ACC] = r[$1] - r[$3];}
		| reg '*' reg			{ $$ = r[$1] * r[$3]; r[ACC] = r[$1] * r[$3];}
		| reg '/' reg			{ if($3 == 0) { printf("Can't divide by 0."); er=1;yyerror();}
												else {$$ = r[$1] / r[$3]; r[ACC] = r[$1] / r[$3];}}
		| reg '\\' reg		{ if($3 == 0) { printf("Can't mod by 0.");er=1; yyerror(); }
												else $$ = r[$1] % r[$3]; r[ACC] = r[$1] % r[$3];}
		| '-' reg 			{ $$ = -r[$2]; r[ACC] = -r[$2];}
		| reg '^' reg			{ $$ = pow(r[$1], r[$3]); r[ACC] = pow(r[$1], r[$3]);}
		| '(' reg ')'			{ $$ = r[$2]; r[ACC] = r[$2];}	

reg:	R0 { $$ = R0; }
	|R1 { $$ = R1; }
	|R2	{ $$ = R2; }
	|R3 { $$ = R3; }
	|R4	{ $$ = R4; }
	|R5	{ $$ = R5; }
	|R6	{ $$ = R6; }
	|R7 { $$ = R7; }
	|R8	{ $$ = R8; }
	|R9 { $$ = R9; }
	|ACC { $$ = ACC; }
	|TOP { $$ = TOP; }
	|SIZE { $$ = SIZE; }
%%
void yyerror() {
	  printf("\n");
}
node* init(int data, node *s) {
	node* temp = (node*)malloc(sizeof(node));
	(*temp).data = data;
	(*temp).next = s;
	return temp;
}
void push(int data) {
	if(head != NULL) {
		node* temp = init(data, head);
		head = temp;
	}
	else {
		node* temp = init(data, NULL);
		head = temp;
		tail = head;
	}
}
int pop() {
	if(head != NULL) {
		node *temp = head;
		head = (*head).next;
		return (*temp).data;
	}
	else {
		return -1;
	}
}
int isEmpty() {
	if(head == NULL) {
		return 1;
	}
	else {
		return 0;
	}
}
void count() {
	node* temp = head;
	int count = 0;
	while(temp != NULL) {
		count++;
		temp = (*temp).next;
	}
	r[SIZE] = count;
}
void setTopAndSize() {
	count();
	if(head != NULL) {
		r[TOP] = (*head).data;
	}
	else {
		r[TOP] = 0;
	}
}
int main() {
	yyparse();
	return 0;
}
