         [bits 32]

;        esp -> [ret]  ; ret - adres powrotu do asmloader

a        equ 3
b        equ 4
c        equ 5
d        equ 6

;        exp = a*b + c*d = 3*4 + 5*6 = 12 + 30 = 42

         mov eax, a  ; eax = a
         mov ecx, b  ; ecx = b

;        mul arg  ; edx:eax = eax*arg

         mul ecx  ; edx:eax = eax*ecx = a*b

         mov esi, eax  ; esi = eax

         mov eax, c  ; eax = c
         mov ecx, d  ; ecx = d

         mul ecx  ; edx:eax = eax*ecx = c*d

         mov edi, eax  ; edi = eax

         add esi, edi  ; esi = esi + edi
         
         push esi  ; esi -> stack
         
;        esp -> [esi][ret]

         call getaddr  ; push on the stack the run-time address of format and jump to getaddr
format:
         db "a*b + c*d = %u", 0xA, 0
getaddr:

;        esp -> [format][esi][ret]

         call [ebx+3*4]  ; printf(format, esi);
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
