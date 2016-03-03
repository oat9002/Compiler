
D			[0-9]
L			[a-zA-Z_]
H			[a-fA-F0-9]
B			[0-1]
E			[Ee][+-]?{D}+
FS			(f|F|l|L)
IS			(u|U|l|L)*

%option noyywrap

%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "Mhee.tab.h"

int fromHexa();
int fromBinary();
void maximumMunch();
%}

%%
"OR"						{return	OR;}
"AND"						{ return AND; }
"NEG"						{ return NEG; }
"NOT"						{ return NOT;}
"\n" 						{ return '\n'; }
"+"						{ return '+'; }
"-"						{ return '-'; }
"*"						{ return '*'; }
"^"						{ return '^'; }
"/"						{ return '/'; }
"\\"						{ return '\\'; }
"("						{ return '(';}
")"						{ return ')';}


"$r0"						{ return R0;}
"$r1"						{ return R1;}
"$r2"						{ return R2;}
"$r3"						{ return R3;}
"$r4"						{ return R4;}
"$r5"						{ return R5;}
"$r6"						{ return R6;}
"$r7"						{ return R7;}
"$r8"						{ return R8;}
"$r9"						{ return R9;}
"$acc"						{ return ACC;}
"$top"						{ return TOP;}
"$size"						{ return SIZE;}

"LOAD"						{ return LOAD;}
"SHOW"						{ return SHOW;}
"POP"							{ return POP;}
"PUSH"						{ return PUSH;}

">"						{ return '>';}

{B}+"b"					{ yylval = fromBinary(); return(CONSTANT); }
{H}+"h"					{ yylval = fromHexa(); return(CONSTANT); }
{D}+						{ yylval = atoi(yytext); return(CONSTANT); }

[ \t\v\f]		{  }
.			{ /* ignore bad characters */ maximumMunch(); return ERR;}

%%

void maximumMunch(){
	while(input() != '\n');
}

int fromBinary()
{
		int i, j, result = 0;
		for(i = strlen(yytext) - 2;i >= 0;i--) {
			result += (yytext[i] - '0') * pow(2, strlen(yytext) - 2 - i);
		}
		return result;
}

int fromHexa()
{
	int i, j, result = 0;
	for(i = strlen(yytext) - 2;i >= 0;i--) {
		int temp = 0;
		if(yytext[i] == 'A' || yytext[i] == 'a') {
			temp = 10;
		}
		else if(yytext[i] == 'B' || yytext[i] == 'b') {
			temp = 11;
		}
		else if(yytext[i] == 'C' || yytext[i] == 'c') {
			temp = 12;
		}
		else if(yytext[i] == 'D' || yytext[i] == 'd') {
			temp = 13;
		}
		else if(yytext[i] == 'E' || yytext[i] == 'e') {
			temp = 14;
		}
		else if(yytext[i] == 'F' || yytext[i] == 'f') {
			temp = 15;
		}
		else {
			temp = yytext[i] - '0';
		}
		result += temp * pow(16, strlen(yytext) - 2 - i);
	}
	return result;
}
