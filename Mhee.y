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
%}
/*token*/
%token R0 0 R1 1 R2 2 R3 3 R4 4 R5 5 R6 6 R7 7 R8 8 R9 9
%token ACC 11 TOP 12 SIZE 13
%token LOAD
%token SHOW
%token POP
%token PUSH
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
	| SHOW reg '\n'			{ if($2 != ACC && $2 != TOP && $2 != SIZE) {printf("%d\n",r[$2]);}
 												else { if($2 == ACC) { printf("%d\n", acc); }
															 else if($2 == TOP) { printf("%d\n", top);}
														 	 else if($2 == SIZE) { printf("%d\n", size); }} setTopAndSize();}
	| LOAD reg '>' reg '\n' 	{
 															if( $2 == TOP || $2 == SIZE){ printf("Can't assign $top or $size to register.\n");}
															else if( $4 == TOP || $4 == SIZE){ printf("Can't assign register to $top or $size.\n");}
															else if($2 == ACC && ($4 == TOP || $4 == SIZE)) {printf("Can't assign $acc to $top or $size.\n"); }
									  					else if($4 == ACC){printf("Can't assign reg or $top or $size to $acc.\n");}
															else { r[$4] = r[$2];}}
	| PUSH reg 					{ if($2 != ACC && $2 != TOP && $2 != SIZE) { push(r[$2]); }
 												else { if($2 == ACC) { push( acc); }
											 				 else if($2 == TOP) {push(top); }
														 	 else if($2 == SIZE) {push(size); } } setTopAndSize();}
	| POP reg						{ if($2 != ACC && $2 != TOP && $2 != SIZE) { if(!isEmpty()) { r[$2] = pop(); setTopAndSize(); }
 																																	 else { printf("Stack is Empty.\n"); } }
												else { printf("Can't assign number to $acc or $top or $size\n");} }
	| error '\n'				{ yyerrok; }
exp :	  CONSTANT {$$ = $1; acc = $1;}
		| exp OR exp	{$$ = $1 | $3; acc = $1 | $3;}
		| exp AND exp	{$$ = $1 & $3; acc = $1 & $3;}
		| NOT exp	{$$ = ~$2; acc = ~$2;}
		| exp '+' exp	{$$ = $1 + $3; acc = $1 + $3;}
		| exp '-' exp	{$$ = $1 - $3; acc = $1 - $3;}
		| exp '*' exp	{$$ = $1 * $3; acc = $1 * $3;}
		| exp '/' exp	{ if($3==0) { yyerror("Can't divide by 0."); }
										else $$ = $1 / $3; }
		| exp '\\' exp	{ if($3==0) { yyerror("Can't mod by 0."); }
											else $$ = $1 % $3; acc = $1 % $3;}
		| '-' exp %prec NEG	{$$ = -$2; acc = -$2;}
		| exp '^' exp	{$$ = pow($1,$3); acc = pow($1,$3);}
		| '(' exp ')'	{$$ = $2; acc = $2;}
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

%%

void yyerror(char const *str) {
	printf("\tError just happened.\n ");
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
