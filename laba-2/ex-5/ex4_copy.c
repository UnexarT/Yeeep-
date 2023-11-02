#include <stdlib.h>
#include <stdio.h>

struct Node_tag{
    int value;
    struct Node_tag *next;
};

void push(struct Node_tag **head, int value){
    struct Node_tag *in = malloc(sizeof(struct Node_tag));
	if (in == NULL) {
		perror("Невозможно добавить узел(память переполнена)");
    }
    in->next = *head; 
    *head = in;
}


int pop(struct Node_tag **head){
    if (*head == NULL) { 
    	perror("Невозможно извлеч узел(стек пуст)");
    }
    struct Node_tag *out = *head;
    *head = (*head)->next; 
    int value = out->value;
    free(out);
    return value;
}

int peek(const struct Node_tag* head){
    if (head == NULL) {
        perror("Невозможно вывести узел(стек пуст)");
    }
    return head->value;
}
