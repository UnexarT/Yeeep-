%{
#include "ex4.tab.h"
%}

%%

[0-9]+(\.[0-9]+)?	{ yylval.d = atof(yytext); return NUM; }
[(){}]	{ return yytext[0]; }
"*"	{ return MUL; }
"/"	{ return DIV; }
"+"	{ return SUM; }
"-"	{ return SUB; }
"\n"	{return yywrap(); }
[ \t]	;
.	{ printf("%s - Неизвестный символ\n", yytext); }
exit(0) { exit(0); }
%%

int yywrap() {
return 0;
}
