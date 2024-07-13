         [bits 64]

%define  UINT_MAX 4294967295

extern   printf
extern   exit

section  .bss

section  .data
format:
         db "suma = %lld", 0xA, 0

a        equ 4294967295
b        equ 1

section  .text

global   main

main:

;        rsp -> [ret]

;        rcx, rsi, rdx, stack

         mov rcx, format  ; rcx = format
         mov rdx, a       ; rdx = a

         add rdx, b  ; rdx = rdx + b

         sub rsp, 4*8  ; rsp = rsp - 32  ; reserve the shadow space

;        rsp -> [shadow][ret]

         call printf  ; printf(format, suma);

         add rsp, 4*8  ; rsp = rsp + 32

;        rsp -> [ret]

         mov rax, 60
         xor edi, edi
         syscall

%ifdef COMMENT

Kompilacja:

nasm -f win64 add6.asm -o add6.obj
gcc -o add6.exe add6.obj -lmsvcrt

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
