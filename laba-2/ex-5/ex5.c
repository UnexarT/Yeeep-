#include <stdio.h>
#include <ctype.h>
#include "ex4_copy.c"

int calc(int var1, int var2, char operation){ //Калькулятор
    switch (operation) {
    	case '+':
        	return var1 + var2;
        break;
        case '-':
            return var1 - var2;
        break;
        case '*':
            return var1 * var2;
        break;
        case '/':
            return var1 / var2;
        break;
    }
}

int main(){
	struct Node_tag *head = NULL;
	FILE* file = fopen("text.txt", "r");
    if (file == NULL) {
        perror("Ошибка открытия файла!");
    } else {
    	
    	char ch;
    	//Считывание постфиксной записи
    	while ((ch = fgetc(file)) != EOF) {
        	if (isdigit(ch)) {
            	push(&head, ch - '0');
        	} else if (ch == '+' || ch == '-' || ch == '*' || ch == '/') {
        		//Запись в стек результата операции
            	push(&head, calc(pop(&head), pop(&head), ch));
            } 
        }
    }
    fclose(file);
	printf("Ответ: %d\n", peek(head));
}
