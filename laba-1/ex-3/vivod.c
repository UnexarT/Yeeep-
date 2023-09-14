#include <stdio.h>

//argc - количество переданных аргументов при вызове программы
//argv - массив переданных аргументов
void main(int argc, char *argv[]){
	//Вывод введенных аргументов через терминал
	for (int i = 0; i < argc; i++){
		printf("%s \n", argv[i]);
	}
}
