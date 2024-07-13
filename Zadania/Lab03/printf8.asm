         [bits 32]

;        esp -> [ret]  ; ret - adres powrotu do asmloader

a        equ -4

         call getaddr  ; push on the stack the run-time address of format and jump to getaddr
data_section:
         dd a  ; [ ][ ][ ][ ]  ; define double word
         db "a = %d", 0xA, 0
getaddr:

;        esp -> [data_section][ret]

         mov eax, [esp]  ; eax = *(int*)esp = data_section
         
         push dword [eax]  ; *(int*)eax = *(int*)data_section = a -> stack

;        esp -> [a][data_section][ret]

         add eax, 4  ; eax = eax + 4 = "a = %d"

         push eax  ; "a = %d" -> stack

;        esp -> ["a = %d"][a][data_section][ret]

         call [ebx+3*4]  ; pritnf("a = %d", a)
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

ebx    -> [ ][ ][ ][ ] -> exit
ebx+4  -> [ ][ ][ ][ ] -> putchar
ebx+8  -> [ ][ ][ ][ ] -> getchar
ebx+12 -> [ ][ ][ ][ ] -> printf
ebx+16 -> [ ][ ][ ][ ] -> scanf

%endif
