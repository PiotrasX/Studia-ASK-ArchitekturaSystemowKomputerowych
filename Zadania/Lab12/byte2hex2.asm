         [bits 32]

;        esp -> [ret]  ; ret - adres powrotu do asmloader

bajt     equ 127  ; x = 0..255

         push bajt  ; bajt -> stack

;        esp -> [bajt][ret]

         call getaddr  ; push on the stack the run-time address of format and jump to getaddr

table    db "0123456789ABCDEF"

format   db "byte2hex2(%d) = "
hex      db 0, 0, 0xA, 0

getaddr:

;        esp -> [table][bajt][ret]

         mov ebp, ebx  ; ebp = ebx
         
         mov ebx, [esp]  ; ebx = *(int*)esp = table
         
         lea edi, [ebx - table + hex + 1]  ; edi = ebx - table + hex + 1 = table - table + hex + 1 = hex + 1

         mov al, bajt  ; al = bajt
         
         mov dl, al  ; dl = al
         
         and al, 00001111b  ; al = al & 00001111b

         xlat  ; al = *(char*)(ebx + al)  ; table lookup translation

         mov [edi], al  ; *(char*)edi = al
         
         dec edi  ; edi--

         mov al, dl  ; al = dl
         
         shr al, 4  ; al = al >> 4 = al / 16
         
         xlat  ; al = *(char*)(ebx + al)  ; table lookup translation

         mov [edi], al  ; *(char*)edi = al

         add dword [esp], format - table  ; *(int*)esp = *(int*)esp + format - table = table + format - table = format

;        esp -> [format][bajt][ret]

         call [ebp+3*4]  ; printf(format, bajt);
         add esp, 2*4    ; esp = esp + 8

;        esp -> [ret]

         push 0          ; esp -> [00 00 00 00][ret]
         call [ebp+0*4]  ; exit(0);

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
