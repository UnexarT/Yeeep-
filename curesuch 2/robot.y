%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "robot.tab.h"

#define n 2 // the number of columns in a two-dimensional array and cells in a one-dimensional array

int yylex();

char yywrap(){
    return 1;
}

extern int yylineno;
void yyerror(char *str);

extern FILE* yyin;
extern FILE* yyout;

// counts all robot's actions and movements
int counter;

//robot's coordinates
int robot[n];

// cube's coordinates
int numberOfRowsCube;
int numberOfRowsCubeConst;
int *cube;

// reading enviroment file
void readingEnviromentFile(FILE* enviromentFile);

// craete nodes in AST
struct ast{
    int nodetype;
    struct ast *l;
    struct ast *r;
};

struct numval{
    int nodetype;           // type K
    int number;
};

struct flow{
    int nodetype;           // type I or W
    struct ast *cond;       // condition
    struct ast *tl;         // then or do list
    struct ast *el;         // optional else list
};


// build an AST
struct ast *newAst(int nodetype, struct ast *l, struct ast *r);
struct ast *newNum(int i);
struct ast *newFlow(int nodetype, struct ast *cond, struct ast *tl, struct ast *el);

// evaluate an AST
int eval(struct ast *);

// evaluate movements
void evalMovements(int value, int checkDirection);

// evaluate actions
void evalActions(int checkAction, int checkDirection);

// looks to see if there are objects around
int definitionEnvironment(int helperArray[], int checkDirection, int flag);

// to rewrite array
void rewritingArray(int helperArray[], int *array, int sizeArray, int flag);

// delete and free an AST
void treeFree(struct ast *);

%}

%union{
    struct ast *a;
    int i;
}

%token <i> STEPS
%token LEFT RIGHT UP DOWN CUBE TIMES FREE PUT TAKE IF ELSE WHILE

%type <a> body condition elsee statement direction action steps 

%%

commands: // nothing 
| commands body { eval($2); treeFree($2); }
;

body: IF '(' condition ')' '{' body '}' elsee { $$ = newFlow('I', $3, $6, $8); }
| IF '(' condition ')' '{' body '}' { $$ = newFlow('I', $3, $6, NULL); }
| WHILE '(' condition ')' '{' body '}' { $$ = newFlow('W', $3, $6, NULL); }
| statement ';' { $$ = newAst('s', $1, NULL); }
;

elsee: ELSE '{' body '}' { $$ = newAst('e', $3, NULL); }
;

condition: direction FREE { $$ = newAst('F', $1, NULL); }
;

statement: direction steps TIMES { $$ = newAst('T', $1, $2); }
| action CUBE direction { $$ = newAst('a', $1, $3); }
;

direction: UP { $$ = newAst('u', NULL, NULL); }
| DOWN { $$ = newAst('d', NULL, NULL); }
| LEFT { $$ = newAst('l', NULL, NULL); }
| RIGHT { $$ = newAst('r', NULL, NULL); }
;

action: TAKE { $$ = newAst('t', NULL, NULL); }
| PUT { $$ = newAst('P', NULL, NULL); }
;

steps: STEPS { $$ = newNum($1); }
;

%%

void yyerror(char *str){
    fprintf(yyout ,"%d. error: %s in line %d\n", counter, str, yylineno);
    exit(1);
}

int main(){
    char *inputFileName = "input.txt";
    FILE* inputFile = fopen(inputFileName, "r");
    if (inputFile == NULL){
            fprintf(yyout, "%d. file %s doesn't open", counter, inputFileName);
            exit(1);
    }
    

    char *enviromentFileName = "enviroment.txt";
    FILE* enviromentFile = fopen(enviromentFileName, "r");
    if (enviromentFile == NULL){
            fprintf(yyout, "%d. file %s doesn't open", counter, enviromentFileName);
            exit(1);
    }

    char *outputFileName = "output.txt";
    FILE* outputFile = fopen(outputFileName, "w");

    yyin = inputFile;
    yyout = outputFile;
    readingEnviromentFile(enviromentFile);

    // start parsing
    yyparse();

    fclose(yyin);
    fclose(enviromentFile);
    fclose(yyout);
    free(cube);

    return 0;
}


void readingEnviromentFile(FILE* enviromentFile){
    int numberOfRows = 0;
    fseek(enviromentFile, 0, SEEK_SET);
    while (!feof(enviromentFile)){
            if (fgetc(enviromentFile) == '\n'){
                    numberOfRows++;
            }
    }
    numberOfRowsCubeConst = numberOfRows - 2;
    numberOfRowsCube = numberOfRowsCubeConst;
    cube = (int*) malloc(numberOfRowsCube * n * sizeof(int));

    char *bufferName;
    fseek(enviromentFile, 0, SEEK_SET);
    while (!feof(enviromentFile)){
        fscanf(enviromentFile, "%s", bufferName);
        if (strcmp(bufferName, "robot") == 0){
                for (int i = 0; i < n; i++){
                        fscanf(enviromentFile, "%d,", &robot[i]);
                }
        }
        else{
                for (int i = 0; i < numberOfRowsCube; i++){
                        for (int j = 0; j < n; j++){
                                fscanf(enviromentFile, "%d,", (cube + i * n + j));
                        }
                }
        }
    }     
}

struct ast *newAst(int nodetype, struct ast *l, struct ast *r){
    struct ast *a = malloc(sizeof(struct ast));

    if (!a){
        yyerror("out of space");
        exit(0);
    }
    a->nodetype = nodetype;
    a->l = l;
    a->r = r;
    return a;
}

struct ast *newNum(int i){
    struct numval *a = malloc(sizeof(struct numval));

    if (!a){
        yyerror("out of space");
        exit(0);
    }
    a->nodetype = 'K';
    a->number = i;
    return (struct ast *)a;
}

struct ast *newFlow(int nodetype, struct ast *cond, struct ast *tl, struct ast *el){
    struct flow *a = malloc(sizeof(struct flow));

    if(!a) {
        yyerror("out of space");
        exit(0);
    }
    a->nodetype = nodetype;
    a->cond = cond;
    a->tl = tl;
    a->el = el;
    return (struct ast *)a;
}

/* node types
 *  s statement
 *  e elsee
 *  F direction free
 *  T direction step TIMES
 *  a action CUBE
 *  u up
 *  d down
 *  l left
 *  r right
 *  t take cube
 *  P put cube
 *  I IF statement
 *  W WHILE statement
 */ 

int eval(struct ast *a){
    // the value returned by the function
    int value;

    // to check the direction
    int checkDirection;

    // to check the action
    int checkAction;

    int flag = -2;

    int helperArray[n];

    switch(a->nodetype){
        case 'K': value = ((struct numval *)a)->number; break;
        case 's':
            eval(a->l);
            break;
        case 'e':
            eval(a->l);
            break;
        case 'T':
            counter++;
            value = eval(a->r);
            checkDirection = eval(a->l);
            evalMovements(value, checkDirection);
            break;
        case 'a':
            counter++;
            checkAction = eval(a->l);
            checkDirection = eval(a->r);
            evalActions(checkAction, checkDirection);
            break;
        case 't':
            value = 't';
            break;
        case 'P':
            value = 'P';
            break;
        case 'F':
            checkDirection = eval(a->l);
            value = definitionEnvironment(helperArray, checkDirection, flag);
            break;    
        case 'u':
            value = 0;
            break;
        case 'd':          
            value = 1;
            break;                 
        case 'r':
            value = 2;
            break;     
        case 'l':
            value = 3;
            break; 
        case 'I':
            if(eval(((struct flow *)a)->cond) == 0) { // check the condition the true branch
                if(((struct flow *)a)->tl) {
                    eval(((struct flow *)a)->tl);
                } 
                else{
                    value = -1; // a default value
                }
            }
            else { // the false branch
                if(((struct flow *)a)->el) {
                    eval(((struct flow *)a)->el);
                } 
                else {
                    value = -1; // a default value
                }       
            }
            break;
        case 'W':
            value = -1; // a default value

            if(((struct flow *)a)->tl) {
                while(eval(((struct flow *)a)->cond) == 0){
                    eval(((struct flow *)a)->tl); // last value is value
                }
            }
            break;
    }
    return value;
}

void evalMovements(int value, int checkDirection){
    // to correctly indicate the position when displaying an error
    int tempRobot[2];
    for(int i = 0; i < n; i++){
        tempRobot[i] = robot[i];
    }
    int helperArray[n];
    int flag = - 1;

    for(int i = 0; i < value; i++){
         switch(definitionEnvironment(helperArray, checkDirection, flag)){
            case 1: // there are cube around the robot
                if(checkDirection == 0){ // up
                    fprintf(yyout, "%d. error: robot can't go to position (%d,%d) because of cube in position (%d, %d)\n", counter, tempRobot[0], tempRobot[1] + value, helperArray[0], helperArray[1]);
                    exit(1);
                }
                if(checkDirection == 1){ // down
                    fprintf(yyout, "%d. error: robot can't go to position (%d,%d) because of cube in position (%d, %d)\n", counter, tempRobot[0], tempRobot[1] - value, helperArray[0], helperArray[1]);
                    exit(1);
                }
                if(checkDirection == 2){ // right
                    fprintf(yyout, "%d. error: robot can't go to position (%d,%d) because of cube in position (%d, %d)\n", counter, tempRobot[0] + value, tempRobot[1], helperArray[0], helperArray[1]);
                    exit(1);
                }
                if(checkDirection == 3){ // left
                    fprintf(yyout, "%d. error: robot can't go to position (%d,%d) because of cube in position (%d, %d)\n", counter, tempRobot[0] - value, tempRobot[1], helperArray[0], helperArray[1]);
                    exit(1);
                }
                break;
            case 0: // there are not cube around the robot
                if(checkDirection == 0){ // up
                    robot[1] += 1;
                }
                if(checkDirection == 1){ // down
                    robot[1] -= 1;
                }
                if(checkDirection == 2){ // right
                    robot[0] += 1;
                }
                if(checkDirection == 3){ // left
                    robot[0] -= 1;
                }
                break;
        }
    }
    fprintf(yyout, "%d. Robot moved into position (%d,%d)\n", counter, robot[0], robot[1]);
}

void evalActions(int checkAction, int checkDirection){
    // row to delete or add from definitionEnvironment
    int helperArray[n];

    // to indicate case 't' or 'P'
    int flag;

    switch(checkAction){
        case 't': // take cube, in fact, a row is being deleted from the array
            flag = 0;
            if(definitionEnvironment(helperArray, checkDirection, flag) == 0){
                fprintf(yyout, "%d, error: you're trying to take a cube that doesn't exist in (%d,%d)\n", counter, helperArray[0], helperArray[1]);
                exit(1);
            } 

            rewritingArray(helperArray, cube, numberOfRowsCube, flag);
            fprintf(yyout, "%d. Robot take a cube in (%d,%d)\n", counter, helperArray[0], helperArray[1]);
            break;
        case 'P': // put cube, a new coordinate of the cube in the cube array
            flag = 1;
            if(definitionEnvironment(helperArray, checkDirection, flag) == 1){
                fprintf(yyout, "%d. error: there is already a cube in (%d,%d)\n", counter, helperArray[0], helperArray[1]);
                exit(1);
            }
            rewritingArray(helperArray, cube, numberOfRowsCube, flag);
            fprintf(yyout, "%d. Robot put a cube in (%d,%d)\n", counter, helperArray[0], helperArray[1]);
            break;
    }
}

int definitionEnvironment(int helperArray[], int checkDirection, int flag){
    for(int k = 0; k < numberOfRowsCube; k++){
        int xCube = *(cube + k * n + 0);
        int yCube = *(cube + k * n + 1);
        switch(checkDirection){
            case 0: // up
                if (robot[0] == xCube & robot[1] + 1 == yCube){
                    helperArray[0] = xCube;
                    helperArray[1] = yCube;
                    return 1;
                }
                else{
                    helperArray[0] = robot[0];
                    helperArray[1] = robot[1] + 1;
                }
                break;
            case 1: // down
                if(robot[0] == xCube & robot[1] - 1 == yCube){
                    helperArray[0] = xCube;
                    helperArray[1] = yCube;
                    return 1;
                }
                else{
                    helperArray[0] = robot[0];
                    helperArray[1] = robot[1] - 1;
                }
                break;
            case 2: // right
                if(robot[0] + 1 == xCube & robot[1] == yCube){
                    helperArray[0] = xCube;
                    helperArray[1] = yCube;
                    return 1;
                }
                else{
                    helperArray[0] = robot[0] + 1;
                    helperArray[1] = robot[1];
                }
                break;
            case 3: // left
                if(robot[0] - 1 == xCube & robot[1] == yCube ){
                    helperArray[0] = xCube;
                    helperArray[1] = yCube;
                    return 1;
                }
                else{
                    helperArray[0] = robot[0] - 1;
                    helperArray[1] = robot[1];
                }
                break;
        }
    }
    return 0;
}

void rewritingArray(int helperArray[], int *array, int sizeArray, int flag){
    // array's coordinates
    int xArray;
    int yArray;
    // new array's coordinates
    int *tempArray = NULL;
    tempArray = (int*) realloc(tempArray, sizeArray * n * sizeof(int));

    int j = 0; // so that the numbering starts from 0 for new cube's coordinates

    if(flag == 0){
        if (numberOfRowsCube = numberOfRowsCubeConst){
            for(int i = 0; i < sizeArray; i++){
                // cube's coordinates
                xArray = *(array + i*n + 0);
                yArray = *(array + i*n + 1);
                if (helperArray[0] != xArray | helperArray[1] != yArray){
                    *(tempArray + j*n + 0) = xArray;
                    *(tempArray + j*n + 1) = yArray;
                    j++;
                }
            }
            free(cube);
            numberOfRowsCube -= 1;
            cube = tempArray; 
        } else {
            fprintf(yyout, "%d. error: robot already has a cube\n", counter);
            exit(1);
        }

    }
    if(flag == 1){
        if (numberOfRowsCube != numberOfRowsCubeConst){
            numberOfRowsCube += 1;
            cube = (int*) realloc(cube, numberOfRowsCube * n * sizeof(int));
            *(cube + (numberOfRowsCube - 1) * n + 0) = helperArray[0];
            *(cube + (numberOfRowsCube - 1) * n + 1) = helperArray[1];
        } else {
            fprintf(yyout, "%d. error: robot does not have a cube\n", counter);
            exit(1);
        }
    }
}

void treeFree(struct ast *a){
    switch(a->nodetype){
        // two subtrees
        case 'T':
        case 'a':
            treeFree(a->r);

        // one subtree
        case 's':
        case 'e':
        case 'F':
            treeFree(a->l);

        // no subtree 
        case 'K':
        case 'u':
        case 'd':
        case 'l':
        case 'r':
        case 'P':
        case 't':
        break;

        case 'I':
        case 'W':
            free( ((struct flow *)a)->cond);
            if( ((struct flow *)a)->tl) free( ((struct flow *)a)->tl);
            if( ((struct flow *)a)->el) free( ((struct flow *)a)->el);
            break;

        default: fprintf(yyout, "%d. internal error: free bad node %c\n", counter, a->nodetype);
    }
}
