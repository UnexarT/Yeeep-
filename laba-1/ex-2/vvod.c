#include <stdio.h>

void main(){
	//Создание переменных a,b,c
	int a,b,c;
	printf("Решить уравнение ax+b=c.\nЗадайте коэфициент a: ");
	//Присвоение переменной "a" значения с клавиатуры
	scanf("%d",&a);
	printf("Задайте коэфициент b: ");
	//Присвоение переменной "b" значения с клавиатуры
	scanf("%d",&b);
	printf("Задайте коэфициент c: ");
	//Присвоение переменной "c" значения с клавиатуры
	scanf("%d",&c);
	//Вывод решения уравнения ax+b=c
	printf("Значение аргумента x: %d\n",(c-b)/a);
}
	
