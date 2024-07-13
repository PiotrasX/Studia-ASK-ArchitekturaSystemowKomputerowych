         [bits 32]

;        esp -> [ret]  ; ret - adres powrotu do asmloader

a        equ -7
         
         mov eax, a  ; eax = a

         xor eax, ~0  ; eax = eax ^ ~0
         inc eax      ; eax++
         
         push eax  ; eax -> stack

;        esp -> [eax][ret]

         mov eax, a  ; eax =  a

         not eax  ; eax = ~eax
         inc eax  ; eax++

         push eax  ; eax -> stack
         
;        esp -> [eax][eax][ret]

         mov eax, a  ; eax = a

         neg eax  ; eax = ~eax

         push eax  ; eax -> stack

;        esp -> [eax][eax][eax][ret]

         call getaddr  ; push on the stack the runtime address of format and jump to that getaddr
format:
         db "-a = %d", 0xA
         db "-a = %d", 0xA
         db "-a = %d", 0xA, 0
getaddr:

;        esp -> [format][eax][eax][eax][ret]

         call [ebx+3*4]  ; printf(format, eax, eax, eax);
         add esp, 4*4    ; esp = esp + 16
         
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

ebx    -> [ ][ ][ ][ ] -> exit
ebx+4  -> [ ][ ][ ][ ] -> putchar
ebx+8  -> [ ][ ][ ][ ] -> getchar
ebx+12 -> [ ][ ][ ][ ] -> printf
ebx+16 -> [ ][ ][ ][ ] -> scanf

%endif
