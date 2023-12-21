%{
#include "ex2.tab.h"
%}

%%

[0-9]+ { yylval = atoi(yytext); return INT; }
"+" { return PLUS; }
"-" { return MINUS; }
"\n" { return END; }
[ \t]+ ;
. { return UNDEF; }
"exit(0)" { exit(0); }

%%

int yywrap(){
	return 0;
}

