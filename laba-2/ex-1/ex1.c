#include <stdio.h>
#include <stdlib.h>
#include <time.h>
 
int* randomIntArr(int len){
	//Резервируем память для массива чисел
    int* mas = (int*)malloc(len*sizeof(int));
    //Генератор массива псевдослучайных чисел
    for (int i = 0; i < len; i++) {
        int num = rand();
        //Вывод чисел в терминал
        printf("%d\n", num);
        mas[i] = num;
    }
    return mas;
}

int sizeofNum(int num){ //Счетчик цифр в числе
	int numb = num;
	int count = 0;
    while(numb != 0){
    	numb /= 10;
    	count++;
    }
    return count;
}
 
int main () { 
	//Динамическое изменение последовательности 
    //псевдослучайных чисел зависящих от кол-ва секунд
    //прошедших с 01.01.1970
    srand(time(NULL));
	int len = rand()%10;
	int* mas = randomIntArr(len);
    //Проверка на открытие файла для записи    
    FILE *file = fopen("text.txt", "w"); 
    if (file == NULL) {
        perror("Ошибка открытия файла!");
    } else {
        //Считывание данных с массива в обратном порядке
        for(int i = len-1; i >= 0; i--){
            //Счетчик цифр в числе
            int count = sizeofNum(mas[i]);
            //Перевод числа mas[i] в массив символов num_char
            char num_char[count];
            sprintf(num_char, "%d", mas[i]);
            //Посимвольная запись чисел в файл
            for (int j = 0; j < count; j++){
                fputc(num_char[j],file);
            }
			fprintf(file, "\n");
        }
    }
    fclose(file);
    free(mas);
}
