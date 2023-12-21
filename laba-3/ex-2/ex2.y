%{
#include <stdio.h>

int yylex(void);
void yyerror(const char *str);

%}


%token INT
%token PLUS
%token MINUS
%token END
%token UNDEF

%%

input: /* пусто */
     | input expr END { printf("= %d\n", $2); }
     | input UNDEF {printf("Недопуcтимое значение\n");}
     ;

expr: term 
    | expr PLUS term { $$ = $1 + $3; }
    | expr MINUS term { $$ = $1 - $3; }
    ;
          
term: INT 
	;

%%

void yyerror(const char *str){
	fprintf(stderr,"Error: %s\n",str);
}


int main(){
	yyparse();
	return 0;
}
