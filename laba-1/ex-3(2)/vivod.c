#include <stdio.h>

void main(){
	char *filename = "args.txt"; 
	char arg[256];
	FILE *file = fopen(filename,"r");
	if(file){
		while(fgets(arg,256,file)!=NULL){
			printf("%s", arg);
		}
		fclose(file);
	}	
}	
