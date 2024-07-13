         [bits 32]

;        esp -> [ret]

         call getaddr  ; push on the stack the run-time address of format and jump to get address
format1:
         db "n = ", 0
getaddr:

;        esp -> [format1][ret]

         call [ebx+3*4]  ; printf(format1);

;        esp -> [n][ret]

         push esp

;        esp -> [addr_n][n][ret]

         call getaddr2
format2:
         db "%lf", 0
getaddr2:

;        esp -> [format2][addr_n][n][ret]

         call [ebx+4*4]  ; scanf(format2, &n);
         add esp, 2*4    ; esp = esp + 8

;        esp -> [n][ret]

         sub esp, 2*4  ; esp = esp + 8

;        esp -> [ ][ ][n][ret] ; esp = esp - 8

         call getaddrr  ; push on the stack the run-time addr of format and jump to get address
format:
         db "length = %d", 0xA, 0
getaddrr:

;                       +4 +8 +12
;        esp -> [format][ ][ ][n][ret]

         finit  ; fpu init
         
;        st = [ ]

         fld1  ; fpu load 1

;        st = [st0] = [1]

         fld qword [esp+12]  ; *(double*)(eax) = *(double*)addr_n = n  ; fpu load double

;        st = [st0, st1] = [n, 1]

         fabs  ; [st0, st1] => [|st0|, st1]

;        st = [st0, st1] = [x, 1]

         fyl2x  ; [st0, st1] => [st0, st1*log2(st0)] => [st1*log2(st0)]

;        st = [st1*log2(st0)] = [y*log2(x)]

         fldlg2  ; fpu load log2(10)
         
;        st = [st0, st1] => [log2(10), y*log2(x)]

         fmul st0, st1  ; [st0, st1] => [st0, st0*st1] => [st0*st1] => [log2(10)*y*log2(x)]

;        st = [st0] = [log2(10)*y*log2(x)]

         fld1  ; fpu load 1

;        st = [st0, st1] = [1, log2(10)*y*log2(x)]

         fadd st0, st1  ;  [st0, st1] => [st0, st0 + st1] => [st0 + st1] => [1 + log2(10)*y*log2(x)]

         fisttp qword [esp+4] ; *(double*)(esp+4) <- st = [1 + log2(10)*y*log2(x)] ; fpu store top elementand pop fpu stack

;        st = [ ]

;                       +4                     +8                       +12
;        esp -> [format][1 + log2(10)*y*log2(x)][1 + log2(10)*y*log2(x)][n][ret]

         call [ebx+3*4]  ; pritnf(format, ...)
         add esp, 2*4    ; esp = esp + 12

;        esp -> []

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
