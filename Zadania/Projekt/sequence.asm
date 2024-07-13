         [bits 32]

seq1     equ __?float64?__(3.0)  ; seq(1)
seq2     equ __?float64?__(4.0)  ; seq(2)
seq3     equ __?float64?__(8.0)  ; seq(3)

half     equ __?float64?__(0.5)  ; 0.5
two      equ __?float64?__(2.0)  ; 2.0

;        esp -> [ret]  ; ret - adres powrotu do asmloader

         call getaddr1  ; push on the stack the runtime address of format1 and jump to getaddr1

format1:
         db 0xA, "n = ", 0

getaddr1:

;        esp -> [format1][ret]

         call [ebx+3*4]  ; printf(format1)

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

         pop ecx  ; ecx <- stack

;        esp -> [ret]

         mov ebp, ebx  ; ebp = ebx

         cmp ecx, 1  ; check if n == 1
         jl less_1   ; jump if ecx < 1

         push ecx  ; ecx -> stack = n
         
;        esp -> [n][ret]

         call getaddr3  ; push on the stack the runtime address of format3 and jump to getaddr3

format3:
         db "seq3(%d) = ", 0

getaddr3:

;        esp -> [format3][n][ret]

         call [ebx+3*4]  ; printf(format3, n)
         add esp, 1*4    ; esp = esp + 4

;        esp -> [n][ret]

         mov ecx, [esp]  ; ecx = *(int*)esp = n   

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

;        esp -> [ ][ ][ ][ ][ ][ ][n][ret]

         call getaddr4  ; push on the stack the runtime address of format4 and jump to getaddr4

format4:
         db "%f", 0xA, 0

length1  equ $-format4

addrs3_t dq two   ; addrs3_t
addrs3_h dq half  ; addrs3_h =  addrs3_t + 8
addrs3_1 dq seq1  ; addrs3_1 =  addrs3_t + 16
addrs3_2 dq seq2  ; addrs3_2 =  addrs3_t + 24
addrs3_3 dq seq3  ; addrs3_3 =  addrs3_t + 32

getaddr4:

;                        +4    +12   +20
;        esp -> [format4][ ][ ][ ][ ][ ][ ][n][ret]

         mov eax, [esp]    ; eax = *(int*)esp = format4
         add eax, length1  ; eax = eax + length1 = format4 + length1 = addrs3_t

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
;        esp -> [format4][ ][ ][ ][ ][ ][ ][n][ret]

         fld qword [eax+16]  ; *(double*)(eax+16) = *(double*)addrs3_1 = seq1 -> st  ; fpu load double

;        st = [st0] = [seq1]

         fstp qword [esp+4]  ; *(double*)(esp+4) <- st = st0 = seq1  ; fpu load and pop double to stack

;        st = [ ]

;                        +4          +12   +20
;        esp -> [format4][seq1][seq1][ ][ ][ ][ ][n][ret]

         fld qword [eax+24]  ; *(double*)(eax+24) = *(double*)addrs3_2 = seq2 -> st  ; fpu load double

;        st = [st0] = [seq2]

         fstp qword [esp+12]  ; *(double*)(esp+12) <- st = st0 = seq2  ; fpu load and pop double to stack

;        st = [ ]

;                        +4          +12         +20
;        esp -> [format4][seq1][seq1][seq2][seq2][ ][ ][n][ret]

         fld qword [eax+32]  ; *(double*)(eax+32) = *(double*)addrs3_3 = seq3 -> st  ; fpu load double

;        st = [st0] = [seq3]

         fstp qword [esp+20]  ; *(double*)(esp+20) <- st = st0 = seq3  ; fpu load and pop double to stack

;        st = [ ]

;                        +4          +12         +20
;        esp -> [format4][seq1][seq1][seq2][seq2][seq3][seq3][n][ret]

seq_loop_seq3:

;        st = [ ]

;                        +4          +12         +20
;        esp -> [format4][seq1][seq1][seq2][seq2][seq3][seq3][n][ret]

         fld qword [esp+12]  ; *(double*)(esp+12) = seq2 -> st  ; fpu load double

;        st = [st0] = [seq2]

         fstp qword [esp+4]  ; *(double*)(esp+4) <- st = st0 = seq2  ; fpu load and pop double to stack

;        st = [ ]

;                        +4          +12         +20
;        esp -> [format4][seq2][seq2][seq2][seq2][seq3][seq3][n][ret]  ; seq1 = seq2

         fld qword [esp+20]  ; *(double*)(esp+20) = seq3 -> st  ; fpu load double

;        st = [st0] = [seq3]

         fstp qword [esp+12]  ; *(double*)(esp+12) <- st = st0 = seq3  ; fpu load and pop double to stack

;        st = [ ]

;                        +4          +12         +20
;        esp -> [format4][seq2][seq2][seq3][seq3][seq3][seq3][n][ret]  ; seq2 = seq3

;                        +4      +12     +20
;        esp -> [format4][s1][s1][s2][s2][seq3][seq3][n][ret]

         fld qword [eax+8]   ; *(double*)(eax+8)  = *(double*)addrs3_h = half -> st  ; fpu load double
         fld qword [esp+12]  ; *(double*)(esp+12) = s2 -> st                         ; fpu load double

;        st = [st0, st1] = [s2, half]

         fmulp st1  ; [st0, st1] => [st0* t1] => [s2*half]

;        st = [st0] = [s2*half]

         fstp qword [esp+20]  ; *(double*)(esp+20) <- st = st0 = s2*half  ; fpu load and pop double to stack

;        st = [ ]

;                        +4      +12     +20
;        esp -> [format4][s1][s1][s2][s2][s2*half][s2*half][n][ret]

         fld qword [eax]    ; *(double*)(eax)   = *(double*)addrs3_t = two -> st  ; fpu load double
         fld qword [esp+4]  ; *(double*)(esp+4) = s1 -> st                        ; fpu load double
         
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
;        esp -> [format4][s1][s1][s2][s2][s2*half + s1*two][s2*half + s1*two][n][ret]

;                        +4          +12         +20
;        esp -> [format4][seq1][seq1][seq2][seq2][seq3][seq3][n][ret]

         loop seq_loop_seq3

         fld qword [esp+20]  ; *(double*)(esp+20) = s2*half + s1*two -> st  ; fpu load double

;        st = [st0] = [s2*half + s1*two]

         jmp save_seq3

ret_1_seq3:

;        st = [ ]

         fld qword [eax+16]  ; *(double*)(eax+16) = *(double*)addrs3_1 = seq1 -> st  ; fpu load double

;        st = [st0] = [seq1]

         jmp save_seq3

ret_2_seq3:

;        st = [ ]

         fld qword [eax+24]  ; *(double*)(eax+24) = *(double*)addrs3_2 = seq2 -> st  ; fpu load double

;        st = [st0] = [seq2]

         jmp save_seq3

ret_3_seq3:

;        st = [ ]

         fld qword [eax+32]  ; *(double*)(eax+32) = *(double*)addrs3_3 = seq3 -> st  ; fpu load double

;        st = [st0] = [seq3]

         jmp save_seq3

save_seq3:

;        st = [st0] = [seq(n)]

         fstp qword [esp+4]  ; *(double*)(esp+4) <- st  ; fpu load and pop double to stack

;        st = [ ]

;        if (n == 1) or (n == 2) or (n == 3)
;        {
;                             +4              +12   +20
;             esp -> [format4][seq(n)][seq(n)][ ][ ][ ][ ][n][ret]
;        }
;        else
;        {
;                             +4              +12                 +20
;             esp -> [format4][seq(n)][seq(n)][seq(n-1)][seq(n-1)][seq(n)][seq(n)][n][ret]
;        }

;                        +4    +12   +20
;        esp -> [format4][X][X][ ][ ][ ][ ][n][ret]

print_seq3:

;                        +4    +12   +20
;        esp -> [format4][X][X][ ][ ][ ][ ][n][ret]

         call [ebx+3*4]  ; printf(format4, ...)
         add esp, 7*4    ; esp = esp + 28

;        esp -> [n][ret]

;        end of test code

         rdtsc

         sub eax, esi  ; eax = eax - esi       ; CF affected
         sbb edx, edi  ; edx = edx - edi - CF  ; CF affected

         push edx  ; edx -> stack
         push eax  ; eax -> stack

;        esp -> [eax][edx][n][ret]

         call getaddr5  ; push on the stack the runtime address of format5 and jump to getaddr5

format5:
         db "Cykle procesora przy obliczaniu funkcji seq3 = %llu", 0xA, 0

getaddr5:

;        esp -> [format5][eax][edx][n][ret]

         call [ebx+3*4]  ; printf(format5, edx:eax);
         add esp, 3*4    ; esp = esp + 12

;        esp -> [n][ret]

         call getaddr6  ; push on the stack the runtime address of format6 and jump to getaddr6

format6:
         db "seq2(%d) = ", 0

getaddr6:

;        esp -> [format6][n][ret]

         call [ebx+3*4]  ; printf(format6, n)
         add esp, 1*4    ; esp = esp + 4

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

         call getaddr7  ; push on the stack the runtime address of format7 and jump to getaddr7

format7:
         db "%f", 0xA, 0

length2  equ $-format7

addrs2_t dq two   ; addrs2_t
addrs2_h dq half  ; addrs2_h =  addrs2_t + 8
addrs2_1 dq seq1  ; addrs2_1 =  addrs2_t + 16
addrs2_2 dq seq2  ; addrs2_2 =  addrs2_t + 24

getaddr7:

;                        +4    +12
;        esp -> [format7][ ][ ][ ][ ][ret]

         mov eax, [esp]    ; eax = *(int*)esp = format7
         add eax, length2  ; eax = eax + length2 = format7 + lenght2 = addrs2_t
         
;        st = [ ]

         cmp ecx, 1     ; check if n == 1
         je ret_1_seq2  ; jump if equal

         cmp ecx, 2     ; check if n == 2
         je ret_2_seq2  ; jump if equal

         sub ecx, 2  ; ecx = ecx - 2

;        st = [ ]

;                        +4    +12
;        esp -> [format7][ ][ ][ ][ ][ret]

         fld qword [eax+16]  ; *(double*)(eax+16) = *(double*)addrs2_1 = seq1 -> st  ; fpu load double

;        st = [st0] = [seq1]

         fstp qword [esp+4]  ; *(double*)(esp+4) <- st = st0 = seq1  ; fpu load and pop double to stack

;        st = [ ]

;                        +4          +12
;        esp -> [format7][seq1][seq1][ ][ ][ret]

         fld qword [eax+24]  ; *(double*)(eax+24) = *(double*)addrs2_2 = seq2 -> st  ; fpu load double

;        st = [st0] = [seq2]

         fstp qword [esp+12]  ; *(double*)(esp+12) <- st = st0 = seq2  ; fpu load and pop double to stack

;        st = [ ]

;                        +4          +12
;        esp -> [format7][seq1][seq1][seq2][seq2][ret]

seq_loop_seq2:

;        st = [ ]

;                        +4          +12
;        esp -> [format7][seq1][seq1][seq2][seq2][ret]

         fld qword [esp+4]  ; *(double*)(esp+4) = seq1 -> st  ; fpu load double

;        st = [st0] = [seq1]

;                        +4          +12
;        esp -> [format7][seq1][seq1][seq2][seq2][ret]

         fld qword [esp+12]  ; *(double*)(esp+12) = seq2 -> st  ; fpu load double

;        st = [st0, st1] = [seq2, seq1]

         fstp qword [esp+4]  ; *(double*)(esp+4) <- st = st0 = seq2  ; fpu load and pop double to stack

;        st = [st0] = [seq1]

;        st = [st0] = [seq1] = [pom]  ; pom = seq1

;                        +4          +12
;        esp -> [format7][seq2][seq2][seq2][seq2][ret]  ; seq1 = seq2

;                        +4      +12
;        esp -> [format7][s1][s1][seq2][seq2][ret]

         fld qword [eax+8]  ; *(double*)(eax+8) = *(double*)addrs2_h = half -> st  ; fpu load double
         fld qword [esp+4]  ; *(double*)(esp+4) = s1 -> st                         ; fpu load double

;        st = [st0, st1, st2] = [s1, half, pom]

         fmulp st1  ; [st0, st1, st2] => [st0*st1, st2] => [s1*half, pom]

;        st = [st0, st1] = [s1*half, pom]

         fstp qword [esp+12]  ; *(double*)(esp+12) <- st = st0 = s1*half  ; fpu load and pop double to stack

;        st = [st0] = [pom]

;                        +4      +12
;        esp -> [format7][s1][s1][s1*half][s1*half][ret]

         fld qword [eax]  ; *(double*)(eax) = *(double*)addrs2_t = two -> st  ; fpu load double

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
;        esp -> [format7][s1][s1][s1*half + two*pom][s1*half + two*pom][ret]

;                        +4          +12
;        esp -> [format7][seq1][seq1][seq2][seq2][ret]

         loop seq_loop_seq2

         fld qword [esp+12]  ; *(double*)(esp+12) = s1*half + two*pom -> st  ; fpu load double

;        st = [st0] = [s1*half + two*pom]

         jmp save_seq2

ret_1_seq2:

;        st = [ ]

         fld qword [eax+16]  ; *(double*)(eax+16) = *(double*)addrs2_1 = seq1 -> st  ; fpu load double

;        st = [st0] = [seq1]

         jmp save_seq2

ret_2_seq2:

;        st = [ ]

         fld qword [eax+24]  ; *(double*)(eax+24) = *(double*)addrs2_2 = seq2 -> st  ; fpu load double

;        st = [st0] = [seq2]

         jmp save_seq2

save_seq2:

;        st = [st0] = [seq(n)]

         fstp qword [esp+4]  ; *(double*)(esp+4) <- st  ; fpu load and pop double to stack

;        if (n == 1) or (n == 2)
;        {
;                             +4              +12
;             esp -> [format7][seq(n)][seq(n)][ ][ ][ret]
;        }
;        else
;        {
;                             +4              +12
;             esp -> [format7][seq(n)][seq(n)][seq(n)][seq(n)][ret]
;        }
;
;                        +4    +12
;        esp -> [format7][X][X][ ][ ][ret]

print_seq2:

;                        +4    +12
;        esp -> [format7][X][X][ ][ ][ret]

         call [ebx+3*4]  ; printf(format7, ...)
         add esp, 5*4    ; esp = esp + 20

;        esp -> [ret]

;        end of test code

         rdtsc

         sub eax, esi  ; eax = eax - esi       ; CF affected
         sbb edx, edi  ; edx = edx - edi - CF  ; CF affected

         push edx
         push eax

;        esp -> [eax][edx][ret]

         call getaddr8  ; push on the stack the runtime address of format8 and jump to getaddr8

format8:
         db "Cykle procesora przy obliczaniu funkcji seq2 = %llu", 0xA, 0

getaddr8:

;        esp -> [format8][eax][edx][ret]

         call [ebx+3*4]  ; printf(format8, edx:eax);
         add esp, 3*4    ; esp = esp + 12

;        esp -> [ret]

         jmp exit

not_integer:

;        esp -> [n][ret]
         
         add esp, 1*4    ; esp = esp + 4

;        esp -> [ret]

less_1:

;        esp -> [ret]

         call getaddr9  ; push on the stack the runtime address of format9 and jump to getaddr9

format9:
         db "Podano nieprawidlowa wartosc!", 0xA
         db "Musisz podac liczbe calkowita wieksza od 0!", 0xA, 0

getaddr9:

;        esp -> [format9][ret]

         call [ebx+3*4]  ; printf(format9)
         add esp, 1*4    ; esp = esp + 4

;        esp -> [ret]

exit:

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
