         [bits 32]

extern   _printf
extern   _scanf
extern   _exit

section  .data
format   db "liczba = ", 0
format2  db "%d", 0           
format3  db "modul = %d", 0xA, 0

section  .bss
a:       resb 4

section  .text
global   _main

_main:

;        esp -> [ret]  ; return address

         push format

;        esp -> [format][ret]

         call _printf  ; printf(format);
         add esp, 4    ; esp = esp + 4

;        esp -> [ret]

         push a

;        esp -> [addr_a][ret]

         push format2
         
;        esp -> [format2][addr_a][ret]

         call _scanf   ; scanf(format2, &a);
         add esp, 2*4  ; esp = esp + 8
         
;        esp -> [ret]

         mov eax, dword [a]  ; eax = liczba
         mov edx, eax        ; edx = eax
         
         test eax, eax
         jns nieujemna  ; jump if greater or equal  ; jump if SF == OF or ZF == 1

         neg edx  ; edx = -edx

nieujemna:
         push edx  ; edx -> stack

;        esp -> [edx][ret]

         push format3

;        esp -> [format3][edx][ret]

         call _printf  ; printf(format3, edx);
         add esp, 2*4  ; esp = esp + 8

;        esp -> [ret]

         push 0      ; esp -> [00 00 00 00][ret]
         call _exit  ; exit(0);

%ifdef COMMENT

Kompilacja:

nasm -f win32 modul4.asm -o modul4.obj
ld -m i386pe -o modul4.exe modul4.obj -lmsvcrt

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
