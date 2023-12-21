%{
#include <stdio.h>
#include <stdlib.h>

struct ast {           // структура абстрактного синтаксического дерева
    int nodetype;
    struct ast *left;  // левая часть дерева
    struct ast *right; // правая часть дерева
};

struct numvalue { 	   // структура значений узла
    int nodetype;	   // тип: операция или константа
    double num;		   // числовое значение
};

struct ast *newast(int nodetype, struct ast *left, struct ast *right);
struct ast *newnum(double d);
double exprcheck(struct ast *);
void treefree(struct ast *);

%}

%union { 			   // создание типов данных
    struct ast *a;
    double d;
}

%token <d> NUM
%token SUM SUB MUL DIV END

%type <a> expr term factor

%%

// Правила грамматики Bison/Yacc

// Определение структуры программы

program:
    /* пусто */
    | program expr END { printf("= %f\n", exprcheck($2)); treefree($2); } // Вычисление и вывод результата выражения
    ;

// Правила для выражений, термов и факторов
expr: term
    | expr SUM term { $$ = newast('+', $1, $3); } // Обработка операции сложения
    | expr SUB term { $$ = newast('-', $1, $3); } // Обработка операции вычитания
    ;

term: factor
    | term MUL factor { $$ = newast('*', $1, $3); } // Обработка операции умножения
    | term DIV factor { $$ = newast('/', $1, $3); } // Обработка операции деления
    ;

factor: NUM { $$ = newnum($1); }                // Обработка числового литерала
    | '(' expr ')' { $$ = $2; }              // Обработка выражений в скобках
    ;
%%

// функция создания новой ветки дерева
struct ast *newast(int nodetype, struct ast *left, struct ast *right) {
    struct ast *node = (struct ast *)malloc(sizeof(struct ast));
    // проверка памяти
    if (!node) {
        fprintf(stderr, "Out of memory\n");
        exit(1);
    }
    // присваивание значений новой ветке
    node->nodetype = nodetype;
    node->left = left;
    node->right = right;
    return node;
}

// функция создавния нового числового значения
struct ast *newnum(double d) {
    struct numvalue *node = (struct numvalue *)malloc(sizeof(struct numvalue));
    // проверка памяти
    if (!node) {
        fprintf(stderr, "Память переполнена!\n");
        exit(1);
    }
    // присваивание значений нового числового значения
    node->nodetype = 'Cons';
    node->num = d;
    return (struct ast *)node;
}

// функция подсчета результата значения
double exprcheck(struct ast *node) {
    double result;
    if (!node) {
        fprintf(stderr, "Ошибка оценки узла\n");
        exit(1);
    }
    switch (node->nodetype) {
        case 'Cons':
        result = ((struct numvalue *)node)->num;
        break;
    case '+':
        result = exprcheck(node->left) + exprcheck(node->right);
        break;
    case '-':
        result = exprcheck(node->left) - exprcheck(node->right);
        break;
    case '*':
        result = exprcheck(node->left) * exprcheck(node->right);
        break;
    case '/':
        result = exprcheck(node->left) / exprcheck(node->right);
        break;
    default:
        fprintf(stderr, "Неизвестный тип узла: %d\n", node->nodetype);
        exit(1);
    }
    return result;
}

// освобождение памяти структуры
void treefree(struct ast *node) {
    if (!node) return;
    if (node->nodetype == 'Cons') {
        free((struct numvalue *)node);
    } 
    else {
        treefree(node->left);
        treefree(node->right);
        free(node);
    }
}

int main() {
    yyparse();
    return 0;
}

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}
