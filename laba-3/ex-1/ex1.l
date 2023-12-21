%{
#include <stdio.h>
%}

%%

[0-9] { printf("%d - Цифра\n", yytext); } 
"-"?[0-9]+ { printf("%d - Целое число\n", yytext); }
"-"?[0-9]+\.[0-9]+ { printf("%d - Число с плавающей точкой\n", yytext); } 
[a-zA-Z] { printf("%d - Буква\n", yytext); } 
[a-zA-Z]+ { printf("%d - Строка\n", yytext); } 
"+" { printf("%d - Плюс\n", yytext); } 
"-" { printf("%d - Минус\n", yytext); } 
"*" { printf("%d - Умножение\n", yytext); } 
"/" { printf("%d - Деление\n", yytext); } 
"(" { printf("%d - Левая скобка\n", yytext); } 
")" { printf("%d - Правая скобка\n", yytext); } 
. { printf("%d - Неизвестный символ\n", yytext); } 
"exit(0)" { exit(0); }

%%

int main() {
	yylex();
	return 0;
}
