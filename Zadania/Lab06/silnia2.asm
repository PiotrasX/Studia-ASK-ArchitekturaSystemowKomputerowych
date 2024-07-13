         [bits 32]

;        esp -> [ret]  ; ret - adres powrotu do asmloader

n        equ 7

         mov ecx, n  ; ecx = n
         mov esi, 1  ; esi = 1
         mov edi, 0  ; edi = 0
         mov ebp, 0  ; ebp = 0
         
         jecxz done

petla:
         mov ebp, 0  ; ebp = 0
         mov edx, 0  ; edx = 0

;        mul arg  ; edx:eax = eax*arg

         mov eax, esi  ; eax = esi
         mul ecx       ; edx:eax = eax*ecx
         mov esi, eax  ; esi = eax
         
         add ebp, edx  ; ebp = ebp + edx

         mov edx, 0    ; edx = 0
         mov eax, edi  ; eax = edi
         mul ecx       ; edx:eax = eax*ecx

         mov edi, eax  ; edi = eax
         add edi, ebp  ; edi = edi + ebp

         loop petla

done:
         push edi  ; edx -> stack
         push esi  ; eax -> stack

;        esp -> [esi][edi][ret]

         call getaddr  ; push on the stack the run-time address of format and jump to getaddr
format:
         db "silnia = %llu", 0xA, 0
getaddr:

;        esp -> [format][esi][edi][ret]

         call [ebx+3*4]  ; printf(format, edi:esi);
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
