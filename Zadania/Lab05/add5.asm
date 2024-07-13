         [bits 32]

;        esp -> [ret]  ; ret - adres powrotu do asmloader

%define  UINT_MAX 4294967295

%define  INT_MIN -2147483648
%define  INT_MAX 2147483647

a        equ -2147483648
b        equ -1

;        edi:esi
;        edx:eax +
;        ---------
;        edx:eax

;        cdq  ; edx:eax = eax  ; sign extension ; convert doubleword to quadword

         mov eax, a  ; eax = a
         mov ecx, b  ; ecx = b

         cdq  ; edx:eax = eax ; signed conversion  ; sign extension

         mov esi, eax  ; esi = eax
         mov edi, edx  ; edi = edx

         mov eax, ecx  ; eax = ecx
         
         cdq  ; edx:eax = eax ; signed conversion  ; sign extension
         
         clc           ; CF = 0
         adc eax, esi  ; eax = eax + esi + CF
         adc edx, edi  ; edx = edx + edi + CF

         push edx  ; edx -> stack
         push eax  ; eax -> stack
         
;        esp -> [eax][edx][ret]

         call getaddr  ; push on the stack the runtime address of format and jump to that address
format:
         db "suma = %lld", 0xA, 0
getaddr:

;        esp -> [format][eax][edx][s_l][s_h][ret]

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
