#include <stdio.h>
#include <stdlib.h>
#include <time.h>

//сортировка пузырьком
void mas_sort(float* mas, int len){
	for(int i = 0; i < len-1; i++){
        for(int j = i+1; j < len; j++){
            if(mas[j] < mas[i]){
                float min = mas[j];
                mas[j] = mas[i];
                mas[i] = min;
            }
        }
    }
}

//метод возвращающий массив случацных чисел в окрестности (0;1)
float* randomFloatArr(int len){
	//Динамическое изменение последовательности 
    //псевдослучайных чисел зависящих от кол-ва секунд
    //прошедших с 01.01.1970
    srand(time(NULL));
    float *mas = (float*)malloc(len * sizeof(float)); //Резервирование памяти для массива
    for(int i = 0; i < len; i++){ 
        //Запись в массив случайных чисел от 0 до 1
        mas[i] = (float)rand()/(float)RAND_MAX;
    }
    return mas;
}

void main(){
	printf("Введите размерность массива: ");
    int len;
    scanf("%d", &len);
    float* mas = randomFloatArr(len);
    mas_sort(mas,len);
    //Проверка открытия файла
    FILE *file = fopen("text.txt", "w"); 
    if (file == NULL) {
        perror("Ошибка открытия файла!");
    } else {
        //Перебор значений массива mas
        for(int i = 0; i < len; i++){
        	printf("%f\n", mas[i]);
            float num = mas[i];
            int count1 = 0;//Счетчик символов после запятой
            int count2 = 0;//Счетчик цифр после запятой
            while(num != (int)num){
                num *= 10;
                count1++;
            }
            int num2 =  (int)num;
            while(num2 != 0){
                num2 /= 10;
                count2++;
            }
            //Перевод числа num в массив символов num_char
            char num_char[count2];
            sprintf(num_char, "%d", (int)num);
            //Запись символов начала float
            fputc('0',file);
            fputc('.',file);
            //Запись нулей поле символа "."
            for (int j = 0; j < count1-count2; j++){
                fputc('0',file);
            }
            //Запись чисел в массив
            for (int j = 0; j < count2; j++){
                fputc(num_char[j],file);
            }
			fprintf(file, "\n");
        }
    }
    fclose(file);
    free(mas);
}

