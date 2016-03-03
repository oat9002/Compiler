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
	int r[10];
	int acc;
	int top;
	int size;
	void push(int data);
	int pop();
	void count();
	void setTopAndSize();
	int isEmpty();
	int er=0;
%}
/*token*/
%token R0 0 R1 1 R2 2 R3 3 R4 4 R5 5 R6 6 R7 7 R8 8 R9 9
%token ACC 11 TOP 12 SIZE 13
%token LOAD
%token SHOW
%token POP
%token PUSH
%token CONSTANT
//%token IGNORED
//%token MIXCHAR
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
	| SHOW reg '\n'			{ if($2 != ACC && $2 != TOP && $2 != SIZE) {printf("%d\n",r[$2]);}
 												else { if($2 == ACC) { printf("%d\n", acc); }
															 else if($2 == TOP) { printf("%d\n", top);}
														 	 else if($2 == SIZE) { printf("%d\n", size); }
														 	 else{ printf("Error:SHOW follow by register only." );yyerror();}} setTopAndSize();}
	| LOAD reg '>' reg '\n' 	{
															if( $4 == TOP || $4 == SIZE || $4 == ACC){ printf("Can't assign register to $top or $size or $a.\n");yyerror();}
															else { if($2 == ACC) { r[$4] = acc; }
														 				 else if($2 == TOP) { r[$4] = top; }
																	 	 else if($2 == SIZE) { r[$4] = size; }
																		 else {r[$4] = r[$2];}}}

	| PUSH reg 					{ if($2 != ACC && $2 != TOP && $2 != SIZE) { push(r[$2]); }
 												else { if($2 == ACC) { push(acc); }
											 				 else if($2 == TOP) {push(top); }
														 	 else if($2 == SIZE) {push(size); }
														 	 else { printf("Error:can't push this input." );yyerror();}} setTopAndSize();}
	| POP reg						{ if($2 != ACC && $2 != TOP && $2 != SIZE) { if(!isEmpty()) { r[$2] = pop(); setTopAndSize(); }
 																																	 else { printf("Stack is Empty.\n"); yyerror();} }
												else { printf("Can't assign number to $acc or $top or $size\n");yyerror();} }
	| SHOW error			  {printf("SHOW only follow by register");er=1;yyerror();}
	| LOAD error '>' reg			  {printf("Can't load this input to register.");er=1;yyerror();}
	| LOAD reg '>' error			  {printf("Can't load  register to this input.");er=1;yyerror();}
	| LOAD reg error reg			  {printf("Wrong sympol of LOAD ");er=1;yyerror();}
  | LOAD reg error error			  {printf("Can't load.");er=1;yyerror();}
	| PUSH error			  {printf("Can't PUSH this input"); er=1;yyerror();}
	| POP error			  {printf("Can't POP to this input"); er=1;yyerror();}
	| error '\n'							{printf("ERROR!");yyerror();}
exp :	  CONSTANT  {$$ = $1; acc = $1;}
		| exp OR exp	{$$ = $1 | $3; acc = $1 | $3;}
		| exp AND exp	{$$ = $1 & $3; acc = $1 & $3;}
		| NOT exp	{$$ = ~$2; acc = ~$2;}
		| exp '+' exp	{$$ = $1 + $3; acc = $1 + $3;}
		| exp '-' exp	{$$ = $1 - $3; acc = $1 - $3;}
		| exp '*' exp	{$$ = $1 * $3; acc = $1 * $3;}
		| exp '/' exp	{ if($3==0) { printf("Can't divide by 0."); er=1;yyerror();}
										else $$ = $1 / $3; }
		| exp '\\' exp	{ if($3==0) { printf("Can't mod by 0."); yyerror();er=1;}
											else $$ = $1 % $3; acc = $1 % $3;}
		| '-' exp 	{$$ = -$2; acc = -$2;}
		| exp '^' exp	{$$ = pow($1,$3); acc = pow($1,$3);}
		| '(' exp ')'	{$$ = $2; acc = $2;}
		| reg OR reg	{ if($1 != ACC && $1 != TOP && $1 != SIZE) {$$ = r[$1] | r[$3]; acc = r[$1] | r[$3]; }
										else {if($1 == ACC) {
														if($3 == ACC) {$$ = acc | acc; acc = acc | acc; }
														else if($3 == TOP) {$$ = acc | top; acc = acc | top; }
										}}}
		| reg AND reg	{$$ = $1 & $3; acc = $1 & $3;}
		| NOT reg	{$$ = ~$2; acc = ~$2;}
		| reg '+' reg	{$$ = $1 + $3; acc = $1 + $3;}
		| reg '-' reg	{$$ = $1 - $3; acc = $1 - $3;}
		| reg '*' reg	{$$ = $1 * $3; acc = $1 * $3;}
		| reg '/' reg	{ if($3==0) { printf("Can't divide by 0."); er=1;yyerror();}
										else $$ = $1 / $3; }
		| reg '\\' reg	{ if($3==0) { printf("Can't mod by 0.");er=1; yyerror(); }
											else $$ = $1 % $3; acc = $1 % $3;}
		| '-' reg %prec NEG	{$$ = -$2; acc = -$2;}
		| reg '^' reg	{$$ = pow($1,$3); acc = pow($1,$3);}
		| '(' reg ')'	{$$ = $2; acc = $2;}

		| error OR exp	{printf("ERROR!");yyerror();er=1;}
		| exp OR error	{printf("ERROR!");yyerror();er=1;}
		| error OR error	{printf("ERROR!");yyerror();er=1;}
		| exp error exp	{printf("ERROR!");yyerror();er=1;}
		| error AND exp	{printf("ERROR!");yyerror();er=1;}
		| exp AND error	{printf("ERROR!");yyerror();er=1;}
		| error AND error	{printf("ERROR!");yyerror();er=1;}
		| NOT error	{printf("ERROR!");yyerror();er=1;}
		| error '+' exp	{printf("ERROR!");yyerror();er=1;}
		| exp '+' error	{printf("ERROR!");yyerror();er=1;}
		| error '-' exp	{printf("ERROR!");yyerror();er=1;}
		| exp '-' error	{printf("ERROR!");yyerror();er=1;}
		| error '*' exp	{printf("ERROR!");yyerror();er=1;}
		| exp '*' error	{printf("ERROR!");yyerror();er=1;}
		| error '/' exp	{printf("ERROR!");yyerror();er=1;}
		| exp '/' error	{printf("ERROR!");yyerror();er=1;}
		| error '\\' exp	{printf("ERROR!");yyerror();er=1;}
		| exp '\\' error	{printf("ERROR!");yyerror();er=1;}
		| error '^' exp	{printf("ERROR!");yyerror();er=1;}
		| exp '^' error	{printf("ERROR!");yyerror();er=1;}
		| '(' error ')'	{printf("ERROR!");yyerror();er=1;}
		| '-' error	{printf("ERROR!");yyerror();er=1;}
	//	| error {printf("ERROR!");}
	//	| MIXCHAR	alphabet {printf("Error:wrong input."); er=1;}//ex 1qq,1q 1
reg:	R0
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
//alphabet: |IGNORED alphabet | CONSTANT  | " " alphabet | MIXCHAR alphabet

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
	size = count;
}

void setTopAndSize() {
	count();
	if(head != NULL) {
		top = (*head).data;
	}
	else {
		top = 0;
	}
}

int main() {
	yyparse();
	return 0;
}
