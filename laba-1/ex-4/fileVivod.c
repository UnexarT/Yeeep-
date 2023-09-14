#include <stdio.h>

void main(){
	//Задание строк имени файла и буффера для строк из файла
	char filename[50], buffer[256];
	//Задание указателя файла
	FILE *file;
	//Цикл пока файл не откроется 
	while((file =fopen(filename,"r"))==NULL){
		//Задание названия файла с клавиатуры
		printf("Введите название файла: ");
		gets(filename);
		//Проверка открытия файла
		if((file=fopen(filename,"r"))==NULL){
			printf("Ошибка в названии файла!\n\n");
		}
	}
	//Цикл вывода получаемых из файла строк
	while (fgets(buffer,256,file)!=NULL){
		printf("%s", buffer);
	}
	fclose(file);
}
