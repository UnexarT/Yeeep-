%option yylineno
%{
#include <stdio.h>
#include <string.h>
#include "robot.tab.h"
%}


%%

 /* single character ops */
[(){};]	{ return yytext[0]; }

 /* keywords */
"if"    { return IF; }
"else"  { return ELSE; }
"while" { return WHILE; }
"take" { return TAKE; }
"put" { return PUT; }

 /*names*/
[0-9]+    { yylval.i = atoi(yytext); return STEPS; }
"left"    { return LEFT; }
"right"   { return RIGHT; }
"up"      { return UP; }
"down"    { return DOWN; }
"cube"     { return CUBE; }
"times"   { return TIMES; }
"free"    { return FREE; }
[ \t\n]+    ; /* skip whitespaces and EOL*/

%%
