%{
#include <stdio.h>
int yylex(void);
void yyerror(const char *str);
%}

%union {
    double number;
}

%token <number> NUMB
%token END
%token UNDEF

%%

input: /* nothing */
     | input expr END { printf("\n");  }
     | input UNDEF { printf("Недопуcтимое значение\n");  }
     ;

expr: term {}
    | expr '+' term { printf("+ "); }
    | expr '-' term { printf("- "); }
    ;

term: factor 
    | term '*' factor { printf("* "); }
    | term '/' factor { printf("/ "); }
    ;

factor: NUMB { printf("%.2f ", $1); }
      | '(' expr ')' {}
      ;

%%

int main() {
    yyparse();
    return 0;
}

void yyerror(const char *str){
	fprintf(stderr, "Error: %s\n", str);
}
