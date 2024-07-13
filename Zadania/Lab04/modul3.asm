         [bits 32]

;        esp -> [ret]  ; ret - adres powrotu do asmloader

         call getaddr  ; push on the stack the run-time address of format and jump to get address
format:
         db "liczba = ", 0
getaddr:

;        esp -> [format][ret]

         call [ebx+3*4]  ; printf(format);
         
;        esp -> [a][ret]

         push esp

;        esp -> [addr_a][a][ret]

         call getaddr2  ; push on the stack the run-time address of format2 and jump to get address2
format2:
         db "%d", 0
getaddr2:

;        esp -> [format2][addr_a][a][ret]

         call [ebx+4*4]  ; scanf(format2, &a);
         add esp, 2*4    ; esp = esp + 8

;        esp -> [a][ret]

         pop eax  ; eax = a

;        esp -> [ret]

         mov edx, eax  ; edx = eax = a

         test eax, eax
         jns nieujemna  ; jump if greater or equal  ; jump if SF == OF or ZF == 1

         neg edx  ; edx = -edx

nieujemna:
         push edx  ; edx -> stack

;        esp -> [edx][ret]

         call getaddr3  ; push on the stack the run-time address of format3 and jump to getaddr3
format3:
         db "modul = %d", 0xA, 0
getaddr3:

;        esp -> [format3][edx][ret]

         call [ebx+3*4]  ; printf(format3, edx);
         add esp, 2*4    ; esp = esp + 8

;        esp -> [ret]

         push 0          ; esp -> [00 00 00 00][ret]
         call [ebx+0*4]  ; exit(0);

; asmloader API
;
; ESP wskazuje na prawidlowy stos
; argumenty funkcji wrzucamy na stos
; EBX zawiera pointer na tablice API
;
; call [ebx + NR_FUNKCJI*4] ; wywolanie funkcji API
;
; NR_FUNKCJI:
;
; 0 - exit
; 1 - putchar
; 2 - getchar
; 3 - printf
; 4 - scanf
;
; To co funkcja zwróci jest w EAX.
; Po wywolaniu funkcji sciagamy argumenty ze stosu.
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
