%{
#include "ex3.tab.h"
%}

%%
[0-9]+(\.[0-9]+)? { yylval.number = atof(yytext); return NUMB; }
[-+*/(){}] { return yytext[0]; }
\n { return END; }
[ \t] ;
. { return UNDEF; }
exit(0) { exit(0); }
%%

int yywrap(){
	return 0;
}

