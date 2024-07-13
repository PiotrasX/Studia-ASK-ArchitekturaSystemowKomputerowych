         [bits 32]

extern _printf
extern _scanf
extern _exit

section .data

format1  db 0xA, "n = ", 0
format2  db "%d", 0
format3  db "seq3(%d) = ", 0
format4  db "seq2(%d) = ", 0
format5  db "%f", 0xA, 0
format6  db "Podano nieprawidlowa wartosc!", 0xA
         db "Musisz podac liczbe calkowita wieksza od 0!", 0xA, 0
format7  db "Cykle procesora przy obliczaniu funkcji seq3 = %llu", 0xA, 0
format8  db "Cykle procesora przy obliczaniu funkcji seq2 = %llu", 0xA, 0

seq1     dq 3.0
seq2     dq 4.0
seq3     dq 8.0

half     dq 0.5
two      dq 2.0

section .bss
n        resd 1

section .text

global _main

_main:

;        esp -> [ret]  ; ret - adres powrotu do asmloader

         push dword format1  ; format1 -> stack
         
;        esp -> [format1][ret]

         call _printf  ; printf(format1)

         add esp, 1*4  ; esp = esp + 4

;        esp -> [ret]

         push dword n  ; addr_n -> stack
         
;        esp -> [addr_n][ret]

         push dword format2  ; format2 -> stack
         
;        esp -> [format2][addr_n][ret]

         call _scanf  ; scanf(format2, addr_n)
         
         add esp, 2*4  ; esp = esp + 8
         
;        esp -> [ret]

         cmp eax, 1       ; check if n == 1 (scanf return 1)
         jne not_integer  ; jump if not equal

         mov ecx, [n]  ; ecx = *(int*)addr_n = n

         mov ebp, ebx  ; ebp = ebx

         cmp ecx, 1  ; check if n == 1
         jl less_1   ; jump if ecx < 1

         push ecx  ; ecx -> stack = n
         
;        esp -> [n][ret]

         push dword format3  ; format3 -> stack
         
;        esp -> [format3][n][ret]

         call _printf  ; printf(format3, n)
    
         add esp, 2*4  ; esp = esp + 8

;        esp -> [ret]

         mov ecx, [n]  ; ecx = *(int*)addr_n = n

         rdtsc  ; read time-stamp counter
    
         mov esi, eax  ; esi = eax
         mov edi, edx  ; edi = edx
         
;        start of test code

%ifdef COMMENT

seq(1) = 3
seq(2) = 4
seq(n) = 0.5*seq(n-1) + 2*seq(n-2)   dla n > 2

seq(3) = 0.5*seq(2) + 2*seq(1) = 0.5*4 + 2*3 = 2 + 6 = 8

%endif

         sub esp, 6*4 ; esp = esp - 24  ; three-tooth frame

;        esp -> [ ][ ][ ][ ][ ][ ][ret]

         push dword format5  ; format5 -> stack

;                        +4    +12   +20
;        esp -> [format5][ ][ ][ ][ ][ ][ ][ret]

         finit  ; fpu init

;        st = [ ]

         cmp ecx, 1     ; check if n == 1
         je ret_1_seq3  ; jump if equal

         cmp ecx, 2     ; check if n == 2
         je ret_2_seq3  ; jump if equal
         
         cmp ecx, 3     ; check if n == 3
         je ret_3_seq3  ; jump if equal

         sub ecx, 3  ; ecx = ecx - 3

;        st = [ ]

;                        +4    +12   +20
;        esp -> [format5][ ][ ][ ][ ][ ][ ][ret]

         fld qword [seq1]  ; *(double*)(addr_seq1) = seq1 -> st  ; fpu load double

;        st = [st0] = [seq1]

         fstp qword [esp+4]  ; *(double*)(esp+4) <- st = st0 = seq1  ; fpu load and pop double to stack

;        st = [ ]

;                        +4          +12   +20
;        esp -> [format5][seq1][seq1][ ][ ][ ][ ][ret]

         fld qword [seq2]  ; *(double*)(addr_seq2) = seq2 -> st  ; fpu load double

;        st = [st0] = [seq2]

         fstp qword [esp+12]  ; *(double*)(esp+12) <- st = st0 = seq2  ; fpu load and pop double to stack

;        st = [ ]

;                        +4          +12         +20
;        esp -> [format5][seq1][seq1][seq2][seq2][ ][ ][ret]

         fld qword [seq3]  ; *(double*)(addr_seq3) = seq3 -> st  ; fpu load double

;        st = [st0] = [seq3]

         fstp qword [esp+20]  ; *(double*)(esp+20) <- st = st0 = seq3  ; fpu load and pop double to stack

;        st = [ ]

;                        +4          +12         +20
;        esp -> [format5][seq1][seq1][seq2][seq2][seq3][seq3][ret]

seq_loop_seq3:

;        st = [ ]

;                        +4          +12         +20
;        esp -> [format5][seq1][seq1][seq2][seq2][seq3][seq3][ret]

         fld qword [esp+12]  ; *(double*)(esp+12) = seq2 -> st  ; fpu load double

;        st = [st0] = [seq2]

         fstp qword [esp+4]  ; *(double*)(esp+4) <- st = st0 = seq2  ; fpu load and pop double to stack

;        st = [ ]

;                        +4          +12         +20
;        esp -> [format5][seq2][seq2][seq2][seq2][seq3][seq3][ret]  ; seq1 = seq2

         fld qword [esp+20]  ; *(double*)(esp+20) = seq3 -> st  ; fpu load double

;        st = [st0] = [seq3]

         fstp qword [esp+12]  ; *(double*)(esp+12) <- st = st0 = seq3  ; fpu load and pop double to stack

;        st = [ ]

;                        +4          +12         +20
;        esp -> [format5][seq2][seq2][seq3][seq3][seq3][seq3][ret]  ; seq2 = seq3

;                        +4      +12     +20
;        esp -> [format5][s1][s1][s2][s2][seq3][seq3][ret]

         fld qword [half]    ; *(double*)(addr_half) = half -> st  ; fpu load double
         fld qword [esp+12]  ; *(double*)(esp+12)    = s2   -> st
    
;        st = [st0, st1] = [s2, half]

         fmulp st1  ; [st0, st1] => [st0*st1] => [s2*half]
    
;        st = [st0] = [s2*half]
         
         fstp qword [esp+20]  ; *(double*)(esp+20) <- st = st0 = s2*half  ; fpu load and pop double to stack

;        st = [ ]

;                        +4      +12     +20
;        esp -> [format5][s1][s1][s2][s2][s2*half][s2*half][ret]

         fld qword [two]    ; *(double*)(addr_two) = two -> st  ; fpu load double
         fld qword [esp+4]  ; *(double*)(esp+4)    = s1  -> st
         
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
;        esp -> [format5][s1][s1][s2][s2][s2*half + s1*two][s2*half + s1*two][ret]

;                        +4          +12         +20
;        esp -> [format5][seq1][seq1][seq2][seq2][seq3][seq3][ret]

         loop seq_loop_seq3
         
         fld qword [esp+20]  ; *(double*)(esp+20) = s2*half + s1*two -> st  ; fpu load double

;        st = [st0] = [s2*half + s1*two]

         jmp save_seq3
         
ret_1_seq3:

;        st = [ ]

         fld qword [seq1]  ; *(double*)(addr_seq1) = seq1 -> st  ; fpu load double

;        st = [st0] = [seq1]

         jmp save_seq3

ret_2_seq3:

;        st = [ ]

         fld qword [seq2]  ; *(double*)(addr_seq2) = seq2 -> st  ; fpu load double

;        st = [st0] = [seq2]

         jmp save_seq3

ret_3_seq3:

;        st = [ ]

         fld qword [seq3]  ; *(double*)(addr_seq3) = seq3 -> st  ; fpu load double

;        st = [st0] = [seq3]

         jmp save_seq3

save_seq3:

;        st = [st0] = [seq(n)]

         fstp qword [esp+4]  ; *(double*)(esp+4) <- st  ; fpu load and pop double to stack

;        st = [ ]

;        if (n == 1) or (n == 2) or (n == 3)
;        {
;                             +4              +12   +20
;             esp -> [format5][seq(n)][seq(n)][ ][ ][ ][ ][ret]
;        }
;        else
;        {
;                             +4              +12                 +20
;             esp -> [format5][seq(n)][seq(n)][seq(n-1)][seq(n-1)][seq(n)][seq(n)][ret]
;        }

;                        +4    +12   +20
;        esp -> [format5][X][X][ ][ ][ ][ ][ret]

print_seq3:

;                        +4    +12   +20
;        esp -> [format5][X][X][ ][ ][ ][ ][ret]

         call _printf  ; printf(format5, ...)
         add esp, 7*4  ; esp = esp + 28

;        esp -> [ret]

;        end of test code
    
         rdtsc

         sub eax, esi  ; eax = eax - esi       ; CF affected
         sbb edx, edi  ; edx = edx - edi - CF  ; CF affected

         push edx  ; edx -> stack
         push eax  ; eax -> stack

;        esp -> [eax][edx][ret]

         push dword format7  ; format7 -> stack

;        esp -> [format7][eax][edx][ret]

         call _printf  ; printf(format7, edx:eax)
         add esp, 3*4  ; esp = esp + 12

;        esp -> [ret]

         push dword [n]  ; *(int*)(addr_n) = n -> stack

;        esp -> [n][ret]

         push dword format4  ; format4 -> stack
         
;        esp -> [format4][n][ret]

         call _printf  ; printf(format4, n)
         add esp, 1*4  ; esp = esp + 8

;        esp -> [n][ret]

         pop ecx  ; ecx <- stack = n

;        esp -> [ret]

         rdtsc  ; read time-stamp counter

         mov esi, eax  ; esi = eax
         mov edi, edx  ; edi = edx

;        start of test code

%ifdef COMMENT

seq(1) = 3
seq(2) = 4
seq(n) = 0.5*seq(n-1) + 2*seq(n-2)   dla n > 2

%endif

         sub esp, 4*4 ; esp = esp - 16  ; two-tooth frame

;        esp -> [ ][ ][ ][ ][ret]

         push dword format5  ; format5 -> stack
         
;                        +4    +12
;        esp -> [format5][ ][ ][ ][ ][ret]

         cmp ecx, 1     ; check if n == 1
         je ret_1_seq2  ; jump if equal

         cmp ecx, 2     ; check if n == 2
         je ret_2_seq2  ; jump if equal

         sub ecx, 2  ; ecx = ecx - 2

;        st = [ ]

;                        +4    +12
;        esp -> [format5][ ][ ][ ][ ][ret]

         fld qword [seq1]  ; *(double*)(addr_seq1) = seq1 -> st  ; fpu load double

;        st = [st0] = [seq1]

         fstp qword [esp+4]  ; *(double*)(esp+4) <- st = st0 = seq1  ; fpu load and pop double to stack

;        st = [ ]

;                        +4          +12
;        esp -> [format5][seq1][seq1][ ][ ][ret]

         fld qword [seq2]  ; *(double*)(addr_seq2) = seq2 -> st  ; fpu load double

;        st = [st0] = [seq2]

         fstp qword [esp+12]  ; *(double*)(esp+12) <- st = st0 = seq2  ; fpu load and pop double to stack

;        st = [ ]

;                        +4          +12
;        esp -> [format5][seq1][seq1][seq2][seq2][ret]

seq_loop_seq2:

;        st = [ ]

;                        +4          +12
;        esp -> [format5][seq1][seq1][seq2][seq2][ret]

         fld qword [esp+4]  ; *(double*)(esp+4) = seq1 -> st  ; fpu load double

;        st = [st0] = [seq1]

;                        +4          +12
;        esp -> [format5][seq1][seq1][seq2][seq2][ret]

         fld qword [esp+12]  ; *(double*)(esp+12) = seq2 -> st  ; fpu load double

;        st = [st0, st1] = [seq2, seq1]

         fstp qword [esp+4]  ; *(double*)(esp+4) <- st = st0 = seq2  ; fpu load and pop double to stack

;        st = [st0] = [seq1]

;        st = [st0] = [seq1] = [pom]  ; pom = seq1

;                        +4          +12
;        esp -> [format5][seq2][seq2][seq2][seq2][ret]  ; seq1 = seq2

;                        +4      +12
;        esp -> [format5][s1][s1][seq2][seq2][ret]

         fld qword [half]   ; *(double*)(addr_half) = half -> st  ; fpu load double
         fld qword [esp+4]  ; *(double*)(esp+4)     = s1   -> st

;        st = [st0, st1, st2] = [s1, half, pom]

         fmulp st1  ; [st0, st1, st2] => [st0*st1, st2] => [s1*half, pom]

;        st = [st0, st1] = [s1*half, pom]

         fstp qword [esp+12]  ; *(double*)(esp+12) <- st = st0 = s1*half  ; fpu load and pop double to stack

;        st = [st0] = [pom]

;                        +4      +12
;        esp -> [format5][s1][s1][s1*half][s1*half][ret]

         fld qword [two]  ; *(double*)(addr_two) = two -> st  ; fpu load double

;        st = [st0, st1] = [two, pom]

         fmulp st1  ; [st0, st1] => [st0*st1] => [two*pom]

;        st = [st0] = [two*pom]

         fld qword [esp+12]  ; *(double*)(esp+12) = s1*half -> st  ; fpu load double
         
;        st = [st0, st1] = [s1*half, two*pom]

         faddp st1  ; [st0, st1] => [st0 + st1] => [s1*half + two*pom]

;        st = [st0] = [s1*half + two*pom]

         fstp qword [esp+12]  ; *(double*)(esp+12) <- st = st0 = s1*half + two*pom  ; fpu load and pop double to stack

;        st = [ ]

;                        +4      +12
;        esp -> [format5][s1][s1][s1*half + two*pom][s1*half + two*pom][ret]

;                        +4          +12
;        esp -> [format5][seq1][seq1][seq2][seq2][ret]

         loop seq_loop_seq2
         
         fld qword [esp+12]  ; *(double*)(esp+12) = s1*half + two*pom -> st  ; fpu load double

;        st = [st0] = [s1*half + two*pom]

         jmp save_seq2

ret_1_seq2:

;        st = [ ]

         fld qword [seq1]  ; *(double*)(addr_seq1) = seq1 -> st  ; fpu load double

;        st = [st0] = [seq1]

         jmp save_seq2

ret_2_seq2:

;        st = [ ]

         fld qword [seq2]  ; *(double*)(addr_seq2) = seq2 -> st  ; fpu load double

;        st = [st0] = [seq2]

         jmp save_seq2

save_seq2:

;        st = [st0] = [seq(n)]

         fstp qword [esp+4]  ; *(double*)(esp+4) <- st  ; fpu load and pop double to stack

;        if (n == 1) or (n == 2)
;        {
;                             +4              +12
;             esp -> [format5][seq(n)][seq(n)][ ][ ][ret]
;        }
;        else
;        {
;                             +4              +12
;             esp -> [format5][seq(n)][seq(n)][seq(n)][seq(n)][ret]
;        }
;
;                        +4    +12
;        esp -> [format5][X][X][ ][ ][ret]

print_seq2:

;                        +4    +12
;        esp -> [format7][X][X][ ][ ][ret]

         call _printf  ; printf(format7, ...)
         add esp, 5*4  ; esp = esp + 20

;        esp -> [ret]

;        end of test code

         rdtsc

         sub eax, esi  ; eax = eax - esi       ; CF affected
         sbb edx, edi  ; edx = edx - edi - CF  ; CF affected

         push edx  ; edx -> stack
         push eax  ; eax -> stack
         
;        esp -> [eax][edx][ret]

         push dword format8  ; format8 -> stack

;        esp -> [format8][eax][edx][ret]

         call _printf  ; printf(format8, edx:eax)
         add esp, 3*4  ; esp = esp + 12

;        esp -> [ret]

         jmp exit

not_integer:

;        esp -> [n][ret]
         
         add esp, 1*4    ; esp = esp + 4

;        esp -> [ret]

less_1:

;        esp -> [ret]

         push dword format6  ; format6 -> stack
         
;        esp -> [format6][ret]

         call _printf  ; printf(format6)
         add esp, 1*4  ; esp = esp + 4

;        esp -> [ret]

exit:

         push dword 0  ; esp -> [00 00 00 00][ret]
         call [_exit]  ; exit(0)

%ifdef COMMENT

Kompilacja:

nasm sequence-exe.asm -o sequence-exe.o -f win32
ld sequence-exe.o -o sequence-exe.exe c:\windows\system32\msvcrt.dll -m i386pe
sequence-exe.exe

nasm sequence-exe.asm -o sequence-exe.o -f win32
gcc sequence-exe.o -o sequence-exe.exe -m32
sequence-exe.exe

%endif
