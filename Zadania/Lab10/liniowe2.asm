         [bits 32]

;        esp -> [ret]

         call format_1  ; push on the stack the run-time address of format and jump to get address
print_a:
         db "a = ", 0
format_1:

;        esp -> [print_a][ret]

         call [ebx+3*4]  ; printf(print_a);

         push esp

;        esp -> [addr_a][ret]

         call format_a
scanf_a:
         db "%lf", 0
format_a:

;        esp -> [format_a][addr_a][ret]

         call [ebx+4*4]  ; scanf(scanf_a, &n);
         add esp, 1*4    ; esp = esp + 4
         push esp
         
;        esp -> [addr_b][ret]

         call format_2  ; push on the stack the run-time address of format and jump to get address
print_b:
         db "b = ", 0
format_2:

;        esp -> [print_b][addr_b][ret]

         call [ebx+3*4]  ; printf(print_b);
         add esp, 1*4    ; esp = esp + 4

;        esp -> [addr_b][ret]

         call format_b
scanf_b:
         db "%lf", 0
format_b:

;        esp -> [format_b][addr_b][ret]

         call [ebx+4*4]  ; scanf(scanf_b, &n);
         add esp, 2*4    ; esp = esp + 8

;                  +4
;        esp -> [b][a][ret]

         finit  ; fpu init
         
;        st = [ ]

         fld qword [esp]  ; *(double*)eax = *(double*)addr_b = b -> st  ; fpu load floating-point

;        st = [st0] = [b]  ; fpu stack

         fld qword [esp+4]  ; *(double*)eax = *(double*)addr_a = a -> st  ; fpu load floating-point

;        st = [st0, st1] = [a, b]  ; fpu stack

         ftst  ; st0 - 0  ; fpu test st0

         fstsw ax  ; ax = fpu_status_word  ; fpu store status word

         sahf  ; eflags(SF:ZF:0:AF:0:PF:1:CF) = ah

         jz a_zero  ; jump if zero  ; jump if ZF = 1

;        x = -b/a

         sub esp, 1*4  ; esp = esp - 4

;        esp -> [ ][ret]

         call getaddr2
wynik1:
         db "x = %f", 0xA, 0
getaddr2:

;                       +4
;        esp -> [wynik1][ ][ ][ret]

         fdivp st1, st0  ; [st0, st1] => [st0, st1/st0] => [st1/st0] = [b/a]

         fstp qword [esp+4]  ; *(double*)(esp+4) <- st = [-b/a]  ; fpu store top element and pop fpu stack

;        st = [ ]

;                       +4
;        esp -> [wynik1][-b/a][-b/a][ret]

         jmp print

a_zero   call getaddr3

wynik2   db "x nalezy do zbioru pustego", 0xA, 0
wynik3   db "x nalezy do R", 0xA, 0

getaddr3:

;        esp -> [wynik2][ret]

         fcomi st0, st1  ; st0 - st1  ; ZF PF CF affected

         jz b_zero  ; jump if zero  ; jump if ZF = 1
;        x nalezy do zbioru pustego

         jmp print
;        x nalezy do R

b_zero   add dword [esp], wynik3 - wynik2  ; *(int*)esp = wynik3

;        esp -> [wynik3][ret]

print    call [ebx+3*4]  ; printf(...);

         push 0          ; esp -> [0][ret]
         call [ebx+0*4]  ; exit(0)

; asmloader API
;
; ESP wskazuje na prawid³owy stos
; argumenty funkcji wrzucamy na stos
; EBX zawiera wskaŸnik na tablicê API
;
; call [ebx + NR_FUNKCJI*4] ; wywo³anie funkcji API
;
; NR_FUNKCJI:
;
; 0 - exit
; 1 - putchar
; 2 - getchar
; 3 - printf
; 4 - scanf
;
; To co funkcja zwróci, znajduje siê w EAX.
; Po wywo³aniu funkcji œci¹gamy argumenty ze stosu.
;
; https://gynvael.coldwind.pl/?id=387

%ifdef COMMENT

Tablica API

ebx    -> [ ][ ][ ][ ] -> exit
ebx+4  -> [ ][ ][ ][ ] -> putchar
ebx+8  -> [ ][ ][ ][ ] -> getchar
ebx+12 -> [ ][ ][ ][ ] -> printf
ebx+16 -> [ ][ ][ ][ ] -> scanf

%endif
