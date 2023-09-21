#include <stdio.h>

int main(){
	//Задаем счетчик символов в файле
	int count = 0;
	//Задаем название рабочего файла и символ буфера
	char filename[] = "text.txt", ch;
	//Задаем указатели на файл для счетчика, чтения и записи
	FILE *countChar, *read, *write;
	//Проверка открытия потока файла для счетчика
	if ((countChar = fopen(filename, "r"))!=NULL){
		//Счетчик кол-ва символов в файле
		while((ch = fgetc(countChar) )!= EOF){
			count++;
		}
		//Закрываем поток для счетчика
		fclose(countChar);
		printf("Файл содержит %d символа(-ов)!\n\n", count);
	} else {
		printf("Ошибка окрытия файла!");
		return 0;
	}
	//Создаем строку размером с кол-во символов в файле
	char chars[count];
	//Проверка открытия потока файла для чтения 
	if ((read = fopen(filename, "r"))!=NULL){
		//Цикл заполнения строки chars сиволами из файла
		for(int i = 0;(ch = fgetc(read) )!= EOF;i++){
			chars[i] = ch;		
		}
		//Закрытие потока для чтения
		fclose(read);
		printf("Информация с файла сохранена!\n\n", count);
	} else {
		printf("Ошибка окрытия файла!");
		return 0;
	}
	//Проверка открытия потока файла для записи
	if ((write = fopen(filename, "w"))!=NULL){
		//Флаг для цикла общения с пользователем	
		char choice = 'y';
		int len; //Длинна вводимой строки
		//Цикл общения с пользователем
		while (choice == 'y' || choice == 'Y'){
			printf("Введите кол-во символов строки записываемой в файл: ");
			scanf("%d", &len);
			char text[len];//Записываемая в файл строка длинной len
			printf("Введите строку для записи в файл: ");
			scanf(" %s", &text);
			//Запись строки text в файл
			fprintf(write, text);
			fprintf(write, "\n");
			printf("Продолжить запись(y/n)? ");
			scanf(" %c", &choice);
			//Проверка на глупость пользователя
			if(choice != 'y' && choice != 'Y' &&
				choice != 'N' && choice != 'n'){
				printf("Неверный литерал!!!\n");
			} 
		}
		//Цикл вывода записанных символов из файла в конец файла
		for(int i = 0; i < count; i++){
			//Посимвольная запись в файл
			fputc(chars[i], write);		
		}
		//Закрытие потока
		fclose(write);
		printf("\nФайл %s успешно дополнен!\n\n", filename);
	} else {
		printf("Ошибка окрытия файла!");
		return 0;
	}
}	
