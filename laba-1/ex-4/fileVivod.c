#include <stdio.h>

void main(){
	//Задание строк имени файла и буффера для строк
	char filename[50], predl[256];
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
	while (fgets(predl,256,file)!=NULL){
		printf("%s", predl);
	}
	fclose(file);
}
