         [bits 32]

;        esp -> [ret]  ; ret - adres powrotu do asmloader

a        equ 2
b        equ 5

; Dodanie z zgaszon¹ flag¹ CF
         mov eax, a  ; eax = a
         mov ecx, b  ; ecx = b
         
         clc           ; Zgaszenie flagi CF (CF = 0)
         adc eax, ecx  ; eax = eax + ecx + CF
         
         push eax  ; eax -> stack

;        esp -> [eax][ret]

         call getaddr1  ; push on the stack the runtime address of format1 and jump to that address1
format1:
         db "Suma (CF = 0) = %d", 0xA, 0
getaddr1:

;        esp -> [format1][eax][ret]

         call [ebx+3*4]  ; printf(format1, eax);
         add esp, 2*4    ; esp = esp + 8

;        esp -> [ret]

; Dodanie z ustawion¹ flag¹ CF
         mov eax, a  ; eax = a
         mov ecx, b  ; ecx = b

         stc           ; Ustawienie flagi CF (CF = 1)
         adc eax, ecx  ; eax = eax + ecx + CF
         
         push eax  ; eax -> stack

;        esp -> [eax][ret]

         call getaddr2  ; push on the stack the runtime address of format2 and jump to that address2
format2:
         db "Suma (CF = 1) = %d", 0xA, 0
getaddr2:

;        esp -> [format2][eax][ret]

         call [ebx+3*4]  ; printf(format2, eax);
         add esp, 2*4    ; esp = esp + 8

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
