         [bits 32]

extern   _printf
extern   _scanf
extern   _exit

section  .data
format   db "a = ", 0         ; Definicja ³añcucha znaków do wyœwietlenia przez printf
format2  db "%d", 0           ; Format scanf do wczytywania liczby ca³kowitej
format3  db "a = %d", 0xA, 0  ; Format printf do wyœwietlenia liczby ca³kowitej, wraz z now¹ lini¹ na koñcu

section  .text
global   _main

_main:

;        esp -> [ret]  ; return address

         push format  ; *(int*)(esp - 4) = format ; esp = esp - 4

;        esp -> [format][ret]

         call _printf  ; printf(format);
         
;        esp -> [a][ret]

         push esp  ; esp -> stack

;        esp -> [addr_a][a][ret]

         push format2
         
;        esp -> [format2][addr_a][a][ret]

         call _scanf   ; scanf(format2, &a);
         add esp, 2*4  ; esp = esp + 8
         
;        esp -> [a][ret]

         push format3
         
;        esp -> [format3][a][ret]

         call _printf  ; printf(format3, a);
         add esp, 2*4  ; esp = esp + 8

;        esp -> [ret]

         push 0      ; esp -> [00 00 00 00][ret]
         call _exit  ; exit(0);
         
%ifdef COMMENT

Kompilacja:

nasm -f win32 scanf2.asm -o scanf2.obj
ld -m i386pe -o scanf2asm.exe scanf2.obj -lmsvcrt

%endif

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
