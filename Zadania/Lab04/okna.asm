         [bits 32]

;        esp -> [ret]  ; ret - adres powrotu do asmloader

a        equ 5
b        equ 19
c        equ 12
d        equ 24
x        equ 3

         mov eax, a  ; eax = a
         mov ecx, b  ; ecx = b
         mov edx, x  ; edx = x

         push ecx  ; ecx -> stack
         push eax  ; eax -> stack
         push edx  ; edx -> stack

;        esp -> [edx][eax][ecx][ret]

; Sprawdzenie czy x nale¿y do (a, b)
         cmp edx, eax       ; cmp x, a
         jle not_in_range1  ; x <= a
         cmp edx, ecx       ; cmp x, b
         jge not_in_range1  ; x >= b

; x nale¿y do (a, b)
         call getaddr1  ; push on the stack the run-time address of format1 and jump to getaddr1
format1:
         db "%d nalezy do (%d, %d)", 0xA, 0
getaddr1:

;        esp -> [format1][edx][eax][ecx][ret]

         call [ebx+3*4]  ; printf(format1, edx, eax, ecx);
         jmp exit1

; x nie nale¿y do (a, b)
not_in_range1:
         call getaddr2  ; push on the stack the run-time address of format2 and jump to getaddr2
format2:
         db "%d nie nalezy do (%d, %d)", 0xA, 0
getaddr2:

;        esp -> [format2][edx][eax][ecx][ret]

         call [ebx+3*4]  ; printf(format2, edx, eax, ecx);

exit1:
         add esp, 4*4  ; esp = esp + 16

;        esp -> [ret]

         mov esi, c  ; esi = c
         mov edi, d  ; edi = d
         mov edx, x  ; edx = x

         push edi  ; edi -> stack
         push esi  ; esi -> stack
         push edx  ; edx -> stack

;        esp -> [edx][esi][edi][ret]

; Sprawdzenie czy x nale¿y do (c, d)
         cmp edx, esi       ; cmp x, c
         jle not_in_range2  ; x <= c
         cmp edx, edi       ; cmp x, d
         jge not_in_range2  ; x >= d

; x nale¿y do (c, d)
         call getaddr3  ; push on the stack the run-time address of format3 and jump to getaddr3
format3:
         db "%d nalezy do (%d, %d)", 0xA, 0
getaddr3:

;        esp -> [format3][edx][esi][edi][ret]

         call [ebx+3*4]  ; printf(format3, edx, esi, edi);
         jmp exit2

; x nie nale¿y do (c, d)
not_in_range2:
         call getaddr4  ; push on the stack the run-time address of format4 and jump to getaddr4
format4:
         db "%d nie nalezy do (%d, %d)", 0xA, 0
getaddr4:

;        esp -> [format4][edx][esi][edi][ret]

         call [ebx+3*4]  ; printf(format4, edx, esi, edi);

exit2:
         add esp, 4*4  ; esp = esp + 16

;        esp -> [ret]

         push 0          ; esp ->[0][ret]
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
