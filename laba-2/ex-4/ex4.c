#include <stdlib.h>
#include <stdio.h>

//Структура содержащая значение узла стека и ссылку
struct Node_tag{
    int value;
    struct Node_tag *next;
};

//Метод добавления нового узла с перезаписью ссылки вершины
void push(struct Node_tag **head, int value){
    struct Node_tag *in = malloc(sizeof(struct Node_tag));
	if (in == NULL) {
		perror("Невозможно добавить узел(память переполнена)");//Проверка переполнения памяти
    }
    in->next = *head; //Присвоение ссылки старой вершины к новой
    in->value = value;//Значение новой вершины
    *head = in;
}

//Метод извлечения узла из стека с перезаписью ссылки вершины
int pop(struct Node_tag **head){
    if (*head == NULL) { 
    	perror("Невозможно извлеч узел(стек пуст)");//Проверка пустого стека
    }
    struct Node_tag *out = *head;
    *head = (*head)->next; //Присвоение вершины следующему узлу
    int value = out->value;//Значение выходящего узло
    free(out);
    return value;
}

//Метод просмотра верхнего значения
int peek(const struct Node_tag* head){
    if (head == NULL) {
        perror("Невозможно вывести узел(стек пуст)");//Проверка пустого стека
    }
    return head->value;
}

/*void main() {
    struct Node_tag *head = NULL;//Задаем пустой стек
    for (int i = 0; i < 10; i++){//Генератор значений стека
        push(&head, i);
    }
    while (head) {
        printf("peek:%d\n", peek(head));//Проверка вершины
        printf("pop:%d\n", pop(&head));	//Извлекание вершины
    }
}*/
