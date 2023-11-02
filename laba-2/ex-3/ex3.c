#include <stdio.h>
#include <ctype.h>

#define n 100

struct product{
    double price;
    char name[n];
};

int numb_of_strings(char * filename){
    FILE *file = fopen(filename, "r");
    int count = 0;
    if (file == NULL) {
        perror("Ошибка открытия файла!");
    } else {
        char ch;
        while((ch = fgetc(file))!= EOF){
                if(ch == '\n'){
                    count++;
                }
        }
    }
    fclose(file);
    return count;
}

void sort(struct product items[]){
	int len = numb_of_strings("text.txt");
	struct product tmp;
	for(int i = len - 1; i >= 0; i--){
		for(int j = 0; j < i; j++){
			if(items[j].price > items[j+1].price){
				tmp = items[j];
				items[j] = items[j+1];
				items[j+1] = tmp;
			}
		}
	}
	
}

void main(){
	int num_strings = numb_of_strings("text.txt");
    struct product items[num_strings];
    FILE *file = fopen("text.txt", "r"); 
    if (file == NULL) {
        perror("Ошибка открытия файла!");
    } else {
        for(int i = 0; i < num_strings; i++){
        	fscanf(file, "%100s %lf", items[i].name, & items[i].price);
        }
        fclose(file);
    }
    file = fopen("text1.txt", "w"); 
    sort(items);
    if (file == NULL) {
        perror("Ошибка открытия файла!");
    } else {
    for (int i = 0; i < num_strings; i++) {
            fprintf(file, "%s %.2f\n", items[i].name, items[i].price);
    	}
	}
    fclose(file);
}

