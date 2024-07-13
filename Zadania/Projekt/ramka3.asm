         [bits 32]

%ifdef COMMENT

seq(1) = 3
seq(2) = 4
seq(n) = 0.5*seq(n-1) + 2*seq(n-2)   dla n > 2

seq(3) = 0.5*seq(2) + 2*seq(1) = 0.5*4 + 2*3 = 2 + 6 = 8

%endif

section .data

section .text
global _main

_main:

;        esp -> [ret]  ; ret - adres powrotu do asmloader

         call getaddr0  ; push on the stack the runtime address of format0 and jump to getaddr0

format0:
         db 0xA, "sequence3.asm", 0

getaddr0:

;        esp -> [format0][ret]

         call [ebx+3*4]  ; printf(format0)
         add esp, 1*4    ; esp = esp + 4

;        esp -> [ret]

         call getaddr1  ; push on the stack the runtime address of format1 and jump to getaddr1

format1:
         db 0xA, "n = ", 0

getaddr1:

;        esp -> [format1][ret]

         call [ebx+3*4]  ; printf(format1)

;        esp -> [format1][ret]

;        esp -> [n][ret]  ; variable 'n', address of format is no longer needed

         push esp  ; esp -> stack
         
;        esp -> [addr_n][n][ret]

         call getaddr2  ; push on the stack the runtime address of format2 and jump to getaddr2

format2:
         db "%d", 0

getaddr2:

;        esp -> [format2][addr_n][n][ret]

         call [ebx+4*4]  ; scanf(format2, addr_n)
         add esp, 2*4    ; esp = esp + 8

;        esp -> [n][ret]

         cmp eax, 1       ; check if n == 1 (scanf return 1)
         jne not_integer  ; jump if not equal

         pop ecx  ; ecx <- stack = n

;        esp -> [ret]

         mov ebp, ebx  ; ebp = ebx

         cmp ecx, 1  ; check if n == 1
         jl less_1   ; jump if ecx < 1

         push ecx  ; ecx -> stack = n
         
;        esp -> [n][ret]

         call getaddr3  ; push on the stack the runtime address of format3 and jump to getaddr3

format3:
         db "seq(%d) = ", 0

getaddr3:

;        esp -> [format3][n][ret]

         call [ebx+3*4]  ; printf(format3, n)
         add esp, 1*4    ; esp = esp + 4

;        esp -> [n][ret]

         pop ecx  ; ecx <- stack = n

;        esp -> [ret]

seq1     equ __?float64?__(3.0)  ; seq(1)
seq2     equ __?float64?__(4.0)  ; seq(2)
seq3     equ __?float64?__(8.0)  ; seq(3)

half     equ __?float64?__(0.5)  ; 0.5
two      equ __?float64?__(2.0)  ; 2.0

         sub esp, 6*4 ; esp = esp - 24  ; three-tooth frame

;        esp -> [ ][ ][ ][ ][ ][ ][ret]

         call getaddr4  ; push on the stack the runtime address of format4 and jump to getaddr4

format4:
         db "%f", 0xA, 0

length   equ $-format4

addr_t   dq two   ; addr_t
addr_h   dq half  ; addr_h =  addr_t + 8
addr_1   dq seq1  ; addr_1 =  addr_t + 16
addr_2   dq seq2  ; addr_2 =  addr_t + 24
addr_3   dq seq3  ; addr_3 =  addr_t + 32

getaddr4:

;                        +4    +12   +20
;        esp -> [format4][ ][ ][ ][ ][ ][ ][ret]

         mov eax, [esp]   ; eax = *(int*)esp = format4
         add eax, length  ; eax = eax + length = format4 + length = addr_t

         finit  ; fpu init

;        st = [ ]

         cmp ecx, 1  ; check if n == 1
         je ret_1    ; jump if equal

         cmp ecx, 2  ; check if n == 2
         je ret_2    ; jump if equal
         
         cmp ecx, 3  ; check if n == 3
         je ret_3    ; jump if equal

         sub ecx, 3  ; ecx = ecx - 3

;        st = [ ]

;                        +4    +12   +20
;        esp -> [format4][ ][ ][ ][ ][ ][ ][ret]

         fld qword [eax+16]  ; *(double*)(eax+16) = *(double*)addr_1 = seq1 -> st  ; fpu load double

;        st = [st0] = [seq1]

         fstp qword [esp+4]  ; *(double*)(esp+4) <- st = st0 = seq1  ; fpu load and pop double to stack

;        st = [ ]

;                        +4          +12   +20
;        esp -> [format4][seq1][seq1][ ][ ][ ][ ][ret]

         fld qword [eax+24]  ; *(double*)(eax+24) = *(double*)addr_2 = seq2 -> st  ; fpu load double

;        st = [st0] = [seq2]

         fstp qword [esp+12]  ; *(double*)(esp+12) <- st = st0 = seq2  ; fpu load and pop double to stack

;        st = [ ]

;                        +4          +12         +20
;        esp -> [format4][seq1][seq1][seq2][seq2][ ][ ][ret]

         fld qword [eax+32]  ; *(double*)(eax+32) = *(double*)addr_3 = seq3 -> st  ; fpu load double

;        st = [st0] = [seq3]

         fstp qword [esp+20]  ; *(double*)(esp+20) <- st = st0 = seq3  ; fpu load and pop double to stack

;        st = [ ]

;                        +4          +12         +20
;        esp -> [format4][seq1][seq1][seq2][seq2][seq3][seq3][ret]

seq_loop:

;        st = [ ]

;                        +4          +12         +20
;        esp -> [format4][seq1][seq1][seq2][seq2][seq3][seq3][ret]

         fld qword [esp+12]  ; *(double*)(esp+12) = seq2 -> st  ; fpu load double

;        st = [st0] = [seq2]

         fstp qword [esp+4]  ; *(double*)(esp+4) <- st = st0 = seq2  ; fpu load and pop double to stack

;        st = [ ]

;                        +4          +12         +20
;        esp -> [format4][seq2][seq2][seq2][seq2][seq3][seq3][ret]  ; seq1 = seq2

         fld qword [esp+20]  ; *(double*)(esp+20) = seq3 -> st  ; fpu load double

;        st = [st0] = [seq3]

         fstp qword [esp+12]  ; *(double*)(esp+12) <- st = st0 = seq3  ; fpu load and pop double to stack

;        st = [ ]

;                        +4          +12         +20
;        esp -> [format4][seq2][seq2][seq3][seq3][seq3][seq3][ret]  ; seq2 = seq3

;                        +4      +12     +20
;        esp -> [format4][s1][s1][s2][s2][seq3][seq3][ret]

         fld qword [eax+8]   ; *(double*)(eax+8)  = *(double*)addr_h = half -> st  ; fpu load double
         fld qword [esp+12]  ; *(double*)(esp+12) = s2 -> st                       ; fpu load double

;        st = [st0, st1] = [s2, half]

         fmulp st1  ; [st0, st1] => [st0*st1] => [s2*half]

;        st = [st0] = [s2*half]

         fstp qword [esp+20]  ; *(double*)(esp+20) <- st = st0 = s2*half  ; fpu load and pop double to stack

;        st = [ ]

;                        +4      +12     +20
;        esp -> [format4][s1][s1][s2][s2][s2*half][s2*half][ret]

         fld qword [eax]    ; *(double*)(eax)   = *(double*)addr_t = two -> st  ; fpu load double
         fld qword [esp+4]  ; *(double*)(esp+4) = s1 -> st                      ; fpu load double
         
;        st = [st0, st1] = [s1, two]

         fmulp st1  ; [st0, st1] => [st0*st1] => [s1*two]

;        st = [st0] = [s1*two]

         fld qword [esp+20]  ; *(double*)(esp+20) = s2*half -> st  ; fpu load double
         
;        st = [st0, st1] = [s2*half, s1*two]

         faddp st1  ; [st0, st1] => [st0 + st1] => [s2*half + s1*two]

;        st = [st0] = [s2*half + s1*two]

         fstp qword [esp+20]  ; *(double*)(esp+20) <- st = st0 = s2*half + s1*two  ; fpu load and pop double to stack

;        st = [ ]

;                        +4      +12     +20
;        esp -> [format4][s1][s1][s2][s2][s2*half + s1*two][s2*half + s1*two][ret]

;                        +4          +12         +20
;        esp -> [format4][seq1][seq1][seq2][seq2][seq3][seq3][ret]

         loop seq_loop

         fld qword [esp+20]  ; *(double*)(esp+20) = s2*half + s1*two -> st  ; fpu load double

;        st = [st0] = [s2*half + s1*two]

         jmp save

ret_1:

;        st = [ ]

         fld qword [eax+16]  ; *(double*)(eax+16) = *(double*)addr_1 = seq1 -> st  ; fpu load double

;        st = [st0] = [seq1]

         jmp save

ret_2:

;        st = [ ]

         fld qword [eax+24]  ; *(double*)(eax+24) = *(double*)addr_2 = seq2 -> st  ; fpu load double

;        st = [st0] = [seq2]

         jmp save

ret_3:

;        st = [ ]

         fld qword [eax+32]  ; *(double*)(eax+32) = *(double*)addr_3 = seq3 -> st  ; fpu load double

;        st = [st0] = [seq3]

         jmp save

save:

;        st = [st0] = [seq(n)]

         fstp qword [esp+4]  ; *(double*)(esp+4) <- st  ; fpu load and pop double to stack

;        st = [ ]

;        if (n == 1) or (n == 2) or (n == 3)
;        {
;                             +4              +12   +20
;             esp -> [format4][seq(n)][seq(n)][ ][ ][ ][ ][ret]
;        }
;        else
;        {
;                             +4              +12                 +20
;             esp -> [format4][seq(n)][seq(n)][seq(n-1)][seq(n-1)][seq(n)][seq(n)][ret]
;        }

;                        +4    +12   +20
;        esp -> [format4][X][X][ ][ ][ ][ ][ret]

print:

;                        +4    +12   +20
;        esp -> [format4][X][X][ ][ ][ ][ ][ret]

         call [ebx+3*4]  ; printf(format4, ...)
         add esp, 7*4    ; esp = esp + 28

;        esp -> [ret]

         jmp exit

not_integer:

;        esp -> [n][ret]
         
         add esp, 1*4    ; esp = esp + 4
         
;        esp -> [ret]

less_1:

;        esp -> [ret]

         call getaddr5  ; push on the stack the runtime address of format5 and jump to getaddr5

format5:
         db "Podano nieprawidlowa wartosc!", 0xA
         db "Musisz podac liczbe calkowita wieksza od 0!", 0xA, 0

getaddr5:

;        esp -> [format5][ret]

         call [ebx+3*4]  ; printf(format5)
         add esp, 1*4    ; esp = esp + 4

;        esp -> [ret]

exit:

;        esp -> [ret]

         push 0          ; esp -> [00 00 00 00][ret]
         call [ebx+0*4]  ; exit(0)

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
; To co funkcja zwr�ci jest w EAX.
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