%{
	#include <stdio.h>
	#include "y.tab.h"

	int lineNo = 1;
	int colNo = 1;
%}

%%

"PROGRAM"		{ ECHO; colNo+=7; return TOK_PROGRAM; }
"VAR"			{ ECHO; colNo+=3; return TOK_DECLARE; }
"BEGIN"			{ ECHO; colNo+=5; return TOK_BEGIN; }
"END"			{ ECHO; colNo+=3; return TOK_END; }
[a-z][a-zA-Z0-9]* 	{ ECHO; yylloc.first_line = lineNo; 
			  yylloc.first_column = colNo; 
			  colNo+=strlen(yytext); 
			  yylval.sir = new char[strlen(yytext)+1]; 	
			  strcpy(yylval.sir,yytext);
		          return TOK_NAME;}
";"			{ ECHO; colNo++; return ';'; }		
":"			{ ECHO; colNo++; return ':'; }
"INTEGER"		{ ECHO; colNo+=7; return TOK_TYPE; }
","			{ ECHO; colNo++; return ','; }
":="			{ ECHO; colNo+=2; return TOK_ASSIGN; }
"+"			{ ECHO; colNo++; return '+'; }
"-"			{ ECHO; colNo++; return '-'; }
"*"			{ ECHO; colNo++; return '*'; }
"DIV"			{ ECHO; colNo+=3; return TOK_DIVIDE; }
[1-9][0-9]*|0		{ ECHO; yylloc.first_line = lineNo; 
			  yylloc.first_column = colNo; 
			  colNo+=strlen(yytext); 
			  yylval.sir = new char[strlen(yytext)+1]; 	
			  strcpy(yylval.sir,yytext);
			  return TOK_VALUE; }
"("			{ ECHO; colNo++; return TOK_LEFT; }
")"			{ ECHO; colNo++; return TOK_RIGHT; }
"READ"			{ ECHO; colNo+=4; return TOK_READ; }
"WRITE"			{ ECHO; colNo+=5; return TOK_WRITE; }
"FOR"			{ ECHO; colNo+=3; return TOK_FOR; }
"DO"			{ ECHO; colNo+=2; return TOK_DO; }
"TO"			{ ECHO; colNo+=2; return TOK_TO; }
\n			{ ECHO; lineNo++; colNo=1; }
" "			{ ECHO; colNo++; }
"\."			{ ECHO; colNo++; return '.'; }


%%
