//************ ex4_copy.c *************
#include <stdlib.h>
#include <stdio.h>

struct Node_tag{
    int value;
    struct Node_tag *next;
};

struct Stack{
    struct Node_tag *head;
    int size;
};

void push(struct Stack *stack, int value, int maxsize){
	if (stack->size >= maxsize) {
		perror("Невозможно добавить узел(память переполнена)");
    } else {
    	struct Node_tag *in = malloc(sizeof(struct Node_tag));
    	in->next = stack->head;
    	in->value = value;
    	stack->head = in;
    	stack->size++;
    }	
}

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

int pop(struct Stack *stack){
    if (stack->head == NULL) { 
    	perror("Невозможно извлеч узел(стек пуст)");
    } else {
    	struct Node_tag *out = stack->head;
    	stack->head = stack->head->next;
    	int value = out->value;
    	free(out);
    	return value;
    }	
}

int peek(const struct Stack *stack){
    if (stack->head == NULL) {
        perror("Невозможно вывести узел(стек пуст)");
    }else{
    	return stack->head->value;
    }
}
