%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <time.h>
	extern FILE *yyin, *yyout;
 
	void yyerror();
	int yylex(void);
	int map_lenght, map_hight;
	int x_robot, y_robot;										// объявление переменных буфера
	int x_cube_begin, y_cube_begin;
	int x_cube_end, y_cube_end;
	int cube_taken = 0;
	int counter = 0; 
%}
 
/* объявление токенов */
%token VAL RIGHT LEFT UP DOWN EXIT TAKE PUT MAP_HIGHT MAP_LENGHT
%token X_CUBE_BEGIN Y_CUBE_BEGIN X_CUBE_END Y_CUBE_END
%left '+''-'

/* дерево продукций */
%%
commands: /* пусто */
        | commands command
        ;
command: coordinates
  		| movement
  		| action
		| exit
		;
/* команды отвечающие за присвоения координат */
coordinates: MAP_LENGHT VAL {map_lenght = $2; 					// назначение координат длины карты
  				  x_robot = map_lenght/2;     					// отцентровка робота
				  fprintf(yyout,"Начальная координата робота по x = %d\n",x_robot);
				 }
  | MAP_HIGHT VAL {map_hight = $2;  		 					// назначение координат высоты карты
  				 y_robot = map_hight/2;       					// отцентровка робота
				 fprintf(yyout,"Начальная координата робота по y = %d\n",y_robot);
				}
  | X_CUBE_BEGIN VAL {						  					// назначение координат куба
					/* проверка выхода за граници и занятости координаты роботом */
					if (x_robot == $2 || $2 < 0 || $2 > map_lenght){ 
						fprintf(yyout,"Невозможное действие: невозможная координата куба по х\n");
						printf("Ошибка задания данных!");
						exit(0);
					}
					x_cube_begin = $2;
					fprintf(yyout,"Начальная координата куба по х = %d\n",x_cube_begin);
				}
  | Y_CUBE_BEGIN VAL {						  					// назначение координат куба
					/* проверка выхода за граници и занятости координаты роботом */
					if (y_robot == $2 || $2 < 0 || $2 > map_hight){
						fprintf(yyout,"Невозможное действие: невозможная координата куба по y\n");
						printf("Ошибка задания данных!");
						exit(0);
					}
					y_cube_begin = $2;
					fprintf(yyout,"Начальная координата куба по y = %d\n",y_cube_begin);
				}
  | X_CUBE_END VAL {x_cube_end = $2;          					// назначение координат доставки куба
					/* проверка выхода за граници и занятости координаты роботом */
					if (x_robot == $2 || $2 < 0 || $2 > map_lenght){ 
						fprintf(yyout,"\nНевозможное действие: невозможная координата куба по х\n");
						while (x_robot == x_cube_end  || x_cube_end < 0 || x_cube_end  > map_lenght){
							x_cube_end = rand()%map_lenght; 	// присвоение случайного значения при ошибки пользователя
						}
						fprintf(yyout,"Случайная конечная координата куба по x = %d\n",x_cube_end);
					} else {
						fprintf(yyout,"\nКонечная координата куба по х = %d",x_cube_end);
					}
				}
  | Y_CUBE_END VAL {y_cube_end = $2;          					// назначение координат доставки куба
					/* проверка выхода за граници и занятости координаты роботом */
					if (y_robot == $2 || $2 < 0 || $2 > map_hight){
						fprintf(yyout,"\nНевозможное действие: невозможная координата куба по y\n");
						while (y_robot == y_cube_end  || y_cube_end < 0 || y_cube_end  > map_hight){
							y_cube_end = rand()%map_hight; 		// присвоение случайного значения при ошибки пользователя
						}
						fprintf(yyout,"Случайная конечная координата куба по y = %d\n",y_cube_end);
					} else {
						fprintf(yyout,"\nКонечная координата куба по y = %d",y_cube_end);
					}
				}
;
/* комманды отвечающие за перемещение робота */
movement: UP VAL      { y_robot += $2; 							// перемещение робота вверх по оси у
		/* проверка выхода за граници и наезда на куб */
  		if(y_robot > map_lenght || (x_robot == x_cube_begin && y_robot == y_cube_begin)){ 
  		   if(y_robot > map_lenght){ 							// сценарий выезда за граници
  		      fprintf(yyout,"\nНевозможное действие: выезд за границу y");
  		      y_robot -= $2; fprintf(yyout,"\nТекущие координаты робота:\nx = %d y = %d\n",x_robot,y_robot);
		   }else{ 												// сценарий наезда на куб
		      fprintf(yyout,"\nНевозможное действие: на пути встречен куб");
  		      y_robot -= $2; fprintf(yyout,"Текущие координаты робота:\nx = %d y = %d\n\n",x_robot,y_robot);
		   }
		}else{
		   counter++;
		   fprintf(yyout,"\nРобот поднялся на %d",$2);
  		   fprintf(yyout,"\nТекущие координаты робота:\nx = %d y = %d\n",x_robot,y_robot);
  		}
  	} 
  | DOWN VAL    { y_robot -= $2;     							// перемещение робота вниз по оси у
		/* проверка выхода за граници и наезда на куб */
        if(y_robot < 0 || (x_robot == x_cube_begin && y_robot == y_cube_begin)){
  		   	if(y_robot < 0){ 									// сценарий выезда за граници
  		         fprintf(yyout,"\nНевозможное действие: выезд за границу y");
  		         y_robot += $2; fprintf(yyout,"\nТекущие координаты робота:\nx = %d y = %d\n",x_robot,y_robot);
		      }else{ 											// сценарий наезда на куб
		         fprintf(yyout,"\nНевозможное действие: на пути встречен куб");
  		         y_robot += $2; fprintf(yyout,"\nТекущие координаты робота:\nx = %d y = %d\n",x_robot,y_robot);
		      }	
		}else{
		   counter++;
		   fprintf(yyout,"\nРобот спустился на %d",$2);
  		   fprintf(yyout,"\nТекущие координаты робота:\nx = %d y = %d\n",x_robot,y_robot); 
  	        }
  	    } 
  | RIGHT VAL   { x_robot += $2;    							// перемещение робота вправо по оси х
		/* проверка выхода за граници и наезда на куб */
		if(x_robot > map_hight || (x_robot == x_cube_begin && y_robot == y_cube_begin)){
		   if(x_robot > map_hight){ 							// сценарий выезда за граници
		      fprintf(yyout,"\nНевозможное действие: выезд за границу x");
  		      x_robot -= $2; fprintf(yyout,"\nТекущие координаты робота:\nx = %d y = %d\n",x_robot,y_robot);
	           }else{ 											// сценарий наезда на куб
		      fprintf(yyout,"\nНевозможное действие: на пути встречен куб");
  		      x_robot -= $2; fprintf(yyout,"\nТекущие координаты робота:\nx = %d y = %d\n",x_robot,y_robot);
		   }	
		}else{
		   counter ++;
		   fprintf(yyout,"\nРобот прошел вправо на %d",$2);
  		   fprintf(yyout,"\nТекущие координаты робота:\nx = %d y = %d\n",x_robot,y_robot);
  		}
	      } 
  | LEFT VAL    { x_robot -= $2; 								// перемещение робота влево по оси х
		/* проверка выхода за граници и наезда на куб */
		if(x_robot < 0 || (x_robot == x_cube_begin && y_robot == y_cube_begin)){
		   if(x_robot < 0 ){ 									// сценарий выезда за граници
		      fprintf(yyout,"\nНевозможное действие: выезд за границу x");
  		      x_robot += $2; fprintf(yyout,"\nТекущие координаты робота:\nx = %d y = %d\n",x_robot,y_robot);
	           }else{ 											// сценарий наезда на куб
		      fprintf(yyout,"\nНевозможное действие: на пути встречен куб");
  		      x_robot += $2; fprintf(yyout,"\nТекущие координаты робота:\nx = %d y = %d\n",x_robot,y_robot);
		   }	
		}else{
		   counter ++;
		   fprintf(yyout,"\nРобот прошел влево на %d",$2);
  		   fprintf(yyout,"\nТекущие координаты робота:\nx = %d y = %d\n",x_robot,y_robot);
  		}  		
	      }
;
/* команды действий */
action: TAKE { fprintf(yyout,"\nробот пытается взять куб...");  // взятие куба роботом
  		if(cube_taken == 0){ 									// условие робота без груза
			  /* условие взятия куба на расстоянии одной клетки */
  	          if(((x_robot == x_cube_begin || x_robot == x_cube_begin + 1 
			  || x_robot == x_cube_begin - 1) 
			  && (y_robot == y_cube_begin || y_robot == y_cube_begin + 1 
			  || y_robot == y_cube_begin - 1)) 
			  && (x_robot != x_cube_begin && y_robot != y_cube_begin)) {
  	            fprintf(yyout,"\nКуб взят \n"); 
				/* вывод координат куба за пределы во время взятия роботом */
  	            x_cube_begin += map_lenght; 
  	            y_cube_begin += map_hight;	
  	            cube_taken = 1;									// условие загруженности робота
  	            counter++;
  	          }else{
  	            fprintf(yyout,"\nНевозможно взять куб \n");
		  	  }
  	    }else if(cube_taken == 1){								// условие действия при зашруженном роботе
  	            fprintf(yyout,"\nКуб уже взят!\n");
		}else{
  	            fprintf(yyout,"\nКуб уже доставлен! \n"); 		// условие действия доставленном грузе
		}     
 	      }
  | PUT         { 												// доставить куб роботом
  		fprintf(yyout,"\nробот пытается положить куб...");
  		if(cube_taken == 1){ 									// условие загруженности  
		  /* условие доставки куба на расстоянии одной клетки */
 		  if(((x_robot == x_cube_end || x_robot == x_cube_end + 1 
			  || x_robot == x_cube_end - 1) 
			  && (y_robot == x_cube_end || y_robot == x_cube_end + 1 
			  || y_robot == x_cube_end - 1)) 
			  && (x_robot != x_cube_end && y_robot != x_cube_end)){
  	            fprintf(yyout,"\nКуб доставлен! \n"); 
  	            cube_taken = 2;									// доставить доставки груза
  	            counter++;
  	      }else{
  	            fprintf(yyout,"\nНевозможно положить куб \n");
		  }
  		}else if(cube_taken == 0){								// условие робота без груза
  	        fprintf(yyout,"\nКуб ещё не взят!\n");
		}else{													// доставить доставки груза
  	        fprintf(yyout,"\nКуб уже доставлен! \n");
		}     
  	      }
;
/* команда прекращения программы */
exit: EXIT    { fprintf(yyout,"\nПрограмма выполнена!"); 
				printf("Программа выполнена!\n");
  				return 0; 
			  }
;
%%
 
void main() {
	srand(time(NULL));     										// зависимость псевдослучайных чисел от времени
    yyin = fopen("input.txt", "r");								// входной поток
    yyout = fopen("output.txt", "w");							// выходной поток
	printf("Программа пути робота запущена...\n");
	fprintf(yyout,"РОБОТ НАЧАЛ РАБОТУ\n\n");
	yyparse();													// запуск парсера
	fprintf(yyout,"\n\nКонечные координаты робота:\nх = %d у = %d\n\n", x_robot, y_robot);
    if (cube_taken == 2){										// условие контроля доставки груза
       fprintf(yyout,"Куб доставлен! \n");
    }else{
       fprintf(yyout,"Куб не доставлен! \n");
    }
    fprintf(yyout,"Количество действий: %d\n\n",counter);
}
 
void yyerror(){
  printf("\nВыражение недопустимо\n");
}
