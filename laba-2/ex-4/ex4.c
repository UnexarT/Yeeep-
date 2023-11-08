#include <stdlib.h>
#include <stdio.h>

//Структура содержащая значение узла стека и ссылку
struct Node_tag{
    int value;
    struct Node_tag *next;
};

struct Stack{
    struct Node_tag *head;
    int size;
};

//Метод добавления нового узла с перезаписью ссылки вершины
void push(struct Stack *stack, int value, int maxsize){
	if (stack->size >= maxsize) {
		perror("Невозможно добавить узел(память переполнена)");//Проверка переполнения памяти
    } else {
    	struct Node_tag *in = malloc(sizeof(struct Node_tag));
    	in->next = stack->head; //Присвоение ссылки старой вершины к новой
    	in->value = value;//Значение новой вершины
    	stack->head = in;
    	stack->size++;
    }	
}

//Метод создания стека
struct Stack* createStack() {
    struct Stack* newStack = (struct Stack*)malloc(sizeof(struct Stack));
    if (newStack == NULL) {
        perror("Недостаточно оперативной памяти для создания нового стека");
    } else {
    	newStack->head = NULL;
    	newStack->size = 0;
    	return newStack;
    }	
}

//Метод извлечения узла из стека с перезаписью ссылки вершины
int pop(struct Stack *stack){
    if (stack->head == NULL) { 
    	perror("Невозможно извлеч узел(стек пуст)");//Проверка пустого стека
    } else {
    	struct Node_tag *out = stack->head;
    	stack->head = stack->head->next; //Присвоение вершины следующему узлу
    	int value = out->value;//Значение выходящего узла
    	free(out);
    	return value;
    }	
}

//Метод просмотра верхнего значения
int peek(const struct Stack *stack){
    if (stack->head == NULL) {
        perror("Невозможно вывести узел(стек пуст)");//Проверка пустого стека
    }else{
    	return stack->head->value;
    }
}

/*void main() {
	
	int maxsize;
    printf("Введите максимальный размер стека:");
    scanf("%d", &maxsize);
    struct Stack *stack = createStack();//Задаем пустой стек
    for (int i = 0; i < 10; i++){//Генератор значений стека
        push(stack, i, maxsize);
    }
    while (stack->head) {
        printf("peek:%d\n", peek(stack));//Проверка вершины
        printf("pop:%d\n", pop(stack));	//Извлекание вершины
    }
}*/
