         [bits 32]

;        esp -> [ret]  ; ret - adres powrotu do asmloader

a        equ 4
b        equ 5
c        equ 6

;        exp = a + b*c = 4 + 5*6 = 34

         mov eax, b  ; eax = b
         mov ecx, c  ; ecx = c
         
;        imul arg  ; edx:eax = eax*arg
         
         imul ecx  ; edx:eax = eax*ecx = b*c

         cdq  ; edx:eax = eax  ; signed conversion

         mov ecx, a    ; ecx = a
         adc eax, ecx  ; eax = eax + ecx

         clc         ; CF = 0
         adc edx, 0  ; edx = edx + 0 + CF

         push edx  ; edx -> stack
         push eax  ; eax -> stack

;        esp -> [eax][edx][ret]

         call getaddr  ; push on the stack the run-time address of format and jump to getaddr
format:
         db "a + b*c = %lld", 0xA, 0
getaddr:

;        esp -> [format][eax][edx][ret]

         call [ebx+3*4]  ; printf(format, edx:eax);
         add esp, 3*4    ; esp = esp + 12

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
; To co funkcja zwr�ci jest w EAX.
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