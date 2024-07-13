         [bits 32]

;        esp -> [ret]  ; ret - adres powrotu do asmloader

x        equ __?float64?__(256.0)

         sub esp, 2*4  ; esp = esp - 8
         
;        esp -> [ ][ ][ret]

         call getaddr  ; push on the stack the run-time address of format and jump to getaddr

format   db "log2 = %f", 0xA, 0
length   equ $ - format

addr_y   dq 1.0  ; y  ; define quad word
addr_x   dq x    ; x  ; define quad word

getaddr:

;                       +4 +8
;        esp -> [format][ ][ ][ret]

         finit  ; fpu init
         
;        st = [ ]

         mov eax, [esp]   ; eax = *(int*)esp = format
         add eax, length  ; eax = eax + length = format + length = addr_y
         
         fld qword [eax]  ; *(double*)eax = *(double*)addr_y = 1 -> st  ; fpu load floating-point

;        st = [st0] = [1]

         fld qword [eax+8]  ; *(double*)(eax+8) = *(double*)addr_x = x -> st  ; fpu load floating-point

;        st = [st0, st1] = [x, 1]

         fyl2x  ; [st0, st1] => [st0, st1*log2(st0)] => [st1*log2(st0)] = [log2(x)]

;        st = [st0] = [log2(x)]

         fstp qword [esp+4]  ; *(double*)(esp+4) <- st = log2(x)  ; fpu store top element and pop fpu stack

;        st = [ ]

;                       +4       +8
;        esp -> [format][log2(x)][log2(x)][ret]

         call [ebx+3*4]  ; printf(format, *(double*)(esp+4));
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
