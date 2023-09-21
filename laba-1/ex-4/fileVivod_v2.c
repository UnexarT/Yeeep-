#include <stdio.h>

void main(int argc, char *argv[]){
	//Задание буффера для символов
	char ch;
	//Задание указателя файла
	FILE *file;
	//Проверка открытия файла 
	if ((file = fopen(argv[1],"r"))!=NULL){
		//Цикл вывода получаемых из файла символов
		while((ch = fgetc(file))!= EOF){
			printf("%c",ch);
		}
		//Закрытие файла
		fclose(file);
	} else {
		printf("Ошибка окрытия файла!");
	}
}
