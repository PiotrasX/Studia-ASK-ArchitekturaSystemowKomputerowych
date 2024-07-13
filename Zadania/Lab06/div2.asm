         [bits 32]

;        esp -> [ret]  ; ret - adres powrotu do asmloader

%define  ULLONG_MAX 18446744073709551615

%define  UINT_MAX 4294967295

a        equ 4294967296
b        equ 3

;        edx:eax = a  ; signed conversion

;        eax = a % (UINT_MAX + 1)
;        edx = a / (UINT_MAX + 1)

         mov eax, a % (UINT_MAX + 1)
         mov edx, a / (UINT_MAX + 1)

         mov ecx, b  ; ecx = b

;        Dzielenie bez znaku liczby 64-bitowej edx:eax przez argument

;        div arg  ; eax = edx:eax / arg  ; iloraz
                  ; edx = edx:eax % arg  ; reszta

         div ecx  ; eax = edx:eax / ecx  ; iloraz
                  ; edx = edx:eax % ecx  ; reszta

         push edx  ; edx -> stack
         push eax  ; eax -> stack

;        esp -> [eax][edx][ret]

         call getaddr  ; push on the stack the run-time address of format and jump to getaddr
format:
         db "iloraz = %u", 0xA
         db "reszta = %u", 0xA, 0
getaddr:

;        esp -> [format][eax][edx][ret]

         call [ebx+3*4]  ; printf(format, eax, edx);
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
