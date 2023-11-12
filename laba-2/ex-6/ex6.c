#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>

#define n 100

char infExpr[n]; //инфиксное выражение
int infPos = 0;	   //номер символа инфиксного выражения
char postExpr[n];//постфиксное выражение
int postPos = 0;   //номер символа постфиксного выражения

void factor() { //нетерминал продукции скобок и цифр		
   	if (isdigit(infExpr[infPos])) {
   		postExpr[postPos++] = infExpr[infPos++];
    } else if (infExpr[infPos] == '(') {
       	infPos++;
   	    expr();
        if (infExpr[infPos] == ')') {
 	        infPos++;
        } else {
             perror("Ошибка расположения скобок");
             exit(0);
       	}
    } else {
    	perror("Встреча неожиданного символа");
    	exit(0);
    }
}

void moreTerm() { //нетерминал продукций с операциями '*' и '/'
   if (infExpr[infPos] == '*' || infExpr[infPos] == '/') {
     	char op = infExpr[infPos++];
   	    factor();
        moreTerm();
        postExpr[postPos++] = op;
    }
} 

void term() {  //нетерминал наивысшего приоритета продукций
    factor();  // скобки - наивысший приоритет
    moreTerm();// '*' и '/' - повышенный приоритет
}

void moreExpr() { //нетерминал продукций с операциями '+' и '-'
    if (infExpr[infPos] == '+' || infExpr[infPos] == '-') {
        char op = infExpr[infPos++];
        term();
        moreExpr();
        postExpr[postPos++] = op;
    }
}

void expr() {  //нетерминал формирования выражаения 
    term();	   // наивысший приоритет
    moreExpr();// нижайший приоритет
}

void parse() { //нетерминал перевода в постфиксную запись и вывода
    expr();
    printf("Постфиксное выражение: %s\n", postExpr);
}

int main() {
	printf("Введите инфиксное выражение: ");
	scanf("%s", infExpr);
	parse();
    return 0;
}
