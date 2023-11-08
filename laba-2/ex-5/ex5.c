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

int fileSize(char *filename){
	FILE *file = fopen(filename, "r");
    int count = 0;
    if (file == NULL) {
        perror("Ошибка открытия файла!");
    } else {
        char ch;
        while((ch = fgetc(file))!= EOF){
        	count++;
        }
    }
    fclose(file);
    return count;
}

int main(){
	struct Stack *stack = createStack();
	FILE* file = fopen("text.txt", "r");
    if (file == NULL) {
        perror("Ошибка открытия файла!");
    } else {
    	int maxsize = fileSize("text.txt");
    	char ch;
    	//Считывание постфиксной записи
    	while ((ch = fgetc(file)) != EOF) {
        	if (isdigit(ch)) {
            	push(stack, ch - '0', maxsize);
        	} else if (ch == '+' || ch == '-' || ch == '*' || ch == '/') {
        		//Запись в стек результата операции
            	push(stack, calc(pop(stack), pop(stack), ch), maxsize);
            } 
        }
    }
    fclose(file);
	printf("Ответ: %d\n", peek(stack));
}
