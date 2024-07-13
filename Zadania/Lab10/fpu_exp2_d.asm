         [bits 32]

;        esp -> [ret]  ; ret - adres powrotu do asmloader

;        exp = a*b + c*d = 4*5.5 + 6*7.5 = 67

         sub esp, 2*4 ; esp = esp - 8

;        esp -> [ ][ ][ret]

         call getaddr  ; push on the stack the runtime address of format and jump to that address
format:
         db "exp = %f", 0xA, 0
length   equ $-format

addr_a   dq 4.0
addr_b   dq 5.5
addr_c   dq 6.0
addr_d   dq 7.5

getaddr:

;                       +4
;        esp -> [format][ ][ ][ret]

         finit  ; fpu init

         mov eax, [esp]   ; eax = *(int*)esp
         add eax, length  ; eax = eax + length = format

         fld qword [eax]    ; *(double*)eax = *(double*)addr_a = a -> st  ; fpu load double
         fld qword [eax+8]  ; *(double*)eax = *(double*)addr_b = b -> st  ; fpu load double

;        st = [st0, st1] = [b, a]

         fmulp st1  ; [st0, st1] => [st0*st1] => [b*a]

;        st = [st0] = [b*c]

         fstp qword [esp+4]
         
;        st = [ ]

;                       +4
;        esp -> [format][b*c][b*c][ret]

         fld qword [eax+16]  ; *(double*)eax = *(double*)addr_c = c -> st  ; fpu load double
         fld qword [eax+24]  ; *(double*)eax = *(double*)addr_d = d -> st  ; fpu load double
         
;        st = [st0, st1] = [d, c]

         fmulp st1  ; [st0, st1] => [st0*st1] => [d*c]

;        st = [st0] = [d*c]

         fld qword [esp+4]  ; *(double*)(esp+4) = a*b -> st  ; fpu load
         
;        st = [st0, st1] = [b*a, d*c]

         faddp st1  ; [st0, st1] => [st0 + st1] => [b*a + d*c]

;        st = [b*a + d*c]

         fstp qword [esp+4]

;        st = [ ]

;                       +4
;        esp -> [format][b*a + d*c][b*a + d*c][ret]

         call [ebx+3*4]  ; printf(format, b*a + d*c);
         add esp, 3*4    ; esp = esp + 4

;        esp -> [ret]

         push 0          ; esp -> [0][ret] <- to jest na 4 bajtach
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
