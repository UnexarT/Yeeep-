#include <stdio.h>
#include <string.h>

void main(){
	//Задаем счетчик строк в файле
	int count = 0;
	//Задаем название рабочего файла, строка буфера, массив строк из файла, сообщение в начале файла
	char filename[] = "text.txt", buffer[256], predls[15][256], vvod[50];
	//Задаем указатель на файл
	FILE *file;
	//Открываем файл для чтения
	file = fopen(filename, "r");
	//Проверка открытия файла
	if (file){
		//Считывание файла в массив predls
		while((fgets(buffer,256,file))!=NULL){
			//Присвоение строке predls[count] строку buffer
			strcpy(predls[count],buffer);
			count++;
		}
		//Закрытие файла
		fclose(file);
		printf("Файл %s считан в массив predls", filename);
	} else {
		printf("Ошибка окрытия файла!");
	}
	//Открываем файл для записи	
	file = fopen(filename, "w");
	//Проверка открытия файла
	if (file){
		//Ввод с клавиатуры строки vvod
		printf("Введите строку, для дополнения файла: ");
		gets(vvod);
		//Запись в файл строки vvod
		fprintf(file,"%s",vvod);
		fprintf(file,"\n");
		//Запись в файл информации до редактирования
		for(int i = 0; i < count; i++){
			fprintf(file,"%s",predls[i]);			
		}
		fclose(file);
		printf("Файл %s успешно перезаписан!\n", filename);
	} else {
		printf("Ошибка окрытия файла!");
	}
}
