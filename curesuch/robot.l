%{
 
   #include <stdio.h>
   #include <stdlib.h>
   #include "robot.tab.h"
   #include <math.h>
   extern int yylval;
 
%}

%%
[0-9]+ { yylval = atoi(yytext); return VAL; }
 
right {return RIGHT;} 
left {return LEFT;}
up {return UP;}
down {return DOWN;}
take {return TAKE;}
put {return PUT;}
x_cube_begin {return X_CUBE_BEGIN;}
y_cube_begin {return Y_CUBE_BEGIN;}
x_cube_end {return X_CUBE_END;}
y_cube_end {return Y_CUBE_END;}
map_lenght {return MAP_LENGHT;}
map_hight {return MAP_HIGHT;}
 
exit   { return EXIT; }
\n
[ \t]+ ;
 
%%