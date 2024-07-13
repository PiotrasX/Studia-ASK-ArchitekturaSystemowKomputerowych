         [bits 32]

;        esp -> [ret]  ; ret - adres powrotu do asmloader

%ifdef COMMENT
0   1   2   3   4   5   6    indeksy

a   b   d
|---|---|
1   1   2   3   5   8   13   wartosci
    |---|---|
    a   b   d

Przesuniecie ramki:

a = b      ; a = 1
b = d      ; b = 2
d = d + a  ; d = 2 + 1 = 3
%endif

         mov ebp, ebx  ; ebp = ebx
         
         mov ebx, 1  ; ebx = 1
         mov edx, 2  ; edx = 2
         
shift:   mov eax, ebx  ; eax = ebx
         mov ebx, edx  ; ebx = edx
         add edx, eax  ; edx = edx + eax

;        a = b = 1
;        b = d = 2
;        d = d + a = 2 + 1 = 3

         push edx  ; edx -> stack
         push ebx  ; ebx -> stack
         push eax  ; eax -> stack

;        esp -> [eax][ebx][edx][ret]

         call getaddr  ; push on the stack the run-time address of format and jump to getaddr
format:
         db "a = %i", 0xA
         db "b = %i", 0xA
         db "d = %i", 0xA, 0
getaddr:

;        esp -> [format][eax][ebx][edx][ret]

         call [ebp+3*4]  ; printf(format, eax, ebx, edx);
         add esp, 4*4    ; esp = esp + 16

;        esp -> [ret]

         push 0          ; esp -> [00 00 00 00][ret]
         call [ebp+0*4]  ; exit(0);

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
