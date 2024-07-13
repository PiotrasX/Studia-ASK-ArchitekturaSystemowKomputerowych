         [bits 32]

;        esp -> [ret]  ; ret - adres powrotu do asmloader

;        exp = a + b*c = 4 + 5.5*6 = 37

         sub esp, 2*4 ; esp = esp - 8

;        esp -> [ ][ ][ret]

         call getaddr  ; push on the stack the runtime address of format and jump to that address
format:
         db "exp = %f", 0xA, 0
length   equ $-format

addr_a   dq 4.0
addr_b   dq 5.5
addr_c   dq 6.0

getaddr:

;                       +4
;        esp -> [format][ ][ ][ret]

         finit  ; fpu init

         mov eax, [esp]   ; eax = *(int*)esp
         add eax, length  ; eax = eax + length = format

         fld qword [eax]     ; *(double*)eax = *(double*)addr_a = a -> st  ; fpu load double
         fld qword [eax+8]   ; *(double*)eax = *(double*)addr_b = b -> st  ; fpu load double
         fld qword [eax+16]  ; *(double*)eax = *(double*)addr_c = c -> st  ; fpu load double

;        st = [st0, st1, st2] = [c, b, a]

         fmulp st1  ; [st0, st1, st2] => [st0, st0*st1, st2] => [st0*st1, st2] => [b*c, a]

;        st = [st0, st1] = [b*c, a]

         faddp st1  ; [st0, st1] => [st0, st1 + st0] => [st1 + st0] = [a + b*c]

;        st = [st0] = [a + b*c]

         fstp qword [esp+4]

;        st = [ ]

;                       +4
;        esp -> [format][a + b*c][a + b*c][ret]

         call [ebx+3*4]  ; printf(format, a + b*c);
         add esp, 3*4    ; esp = esp + 4

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
