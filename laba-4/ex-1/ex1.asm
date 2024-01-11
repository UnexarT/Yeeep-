 ; Программа на LC-3 выводящая "Hello, World!" на экран
   .ORIG x3000

   LEA R0, HELLO_STR    ; Загрузка адреса строки "Hello, World!" в R0
   PUTS

   HALT

   HELLO_STR   .STRINGZ "Hello, World!\n"

   .END
