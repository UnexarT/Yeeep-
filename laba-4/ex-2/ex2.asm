.ORIG x3000

START   
        LEA R0, INPUTING    
        PUTS
        LEA R1, BUFFER        
        ADD R2, R1, #0        

READ    
        GETC                   
        OUT                    
        ADD R4, R0, #-10       
        BRz PRINT              
        STR R0, R2, #0         
        ADD R2, R2, #1         
        BRnzp READ            

PRINT   
        LEA R0, BUFFER       
        PUTS
        
HALT

INPUTING .STRINGZ "Enter a string: "
BUFFER    .BLKW  #80

.END
