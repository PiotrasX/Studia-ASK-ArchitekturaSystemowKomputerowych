         [bits 32]

;        esp -> [ret]  ; ret - adres powrotu do asmloader

x        equ 12  ; x = 0..15

         mov eax, x  ; eax = x
         
         cmp al, 9  ; al - 9                  ; OF SF ZF AF PF CF affected
         jbe _09    ; jump if below or equal  ; jump if CF = 1 or ZF = 1

_AF      add al, 'A' - 10 - '0'  ; al = al + 'A' - 10 - '0'

_09      add al, '0'  ; al = al + '0'

         push eax  ; eax -> stack

;        esp -> [eax][ret]

         push x  ; x -> stack
         
;        esp -> [x][eax][ret]

         call getaddr  ; push on the stack the run-time address of format and jump to getaddr
format:
         db "hexDigit(%d) = %c", 0xA, 0
getaddr:

;        esp -> [format][x][eax][ret]

         call [ebx+3*4]  ; printf(format, x, eax);
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
