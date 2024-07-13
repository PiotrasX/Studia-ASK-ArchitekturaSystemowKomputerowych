         [bits 32]

%ifdef COMMENT
0! = 1
n! = n*(n-1)!
%endif

;        esp -> [ret]  ; ret - adres powrotu do asmloader

n        equ 5

         mov ecx, n  ; ecx = n
         mov eax, 1  ; eax = 1 (akumulator)

         call silnia   ; eax = silnia(ecx, eax) ; fastcall
r_addr:

;        esp -> [ret]

         push eax

;        esp -> [eax][ret]

         call getaddr
format:
         db "silnia = %i", 0xA, 0
getaddr:

;        esp -> [format][eax][ret]

         call [ebx+3*4]  ; printf(format, eax);
         add esp, 2*4    ; esp = esp + 8

;        esp -> [ret]

         push 0          ; esp -> [0][ret]
         call [ebx+0*4]  ; exit(0);

;        eax silnia(ecx, eax)

silnia   cmp ecx, 0   ; ecx - 0                   ; ZF affected
         je done      ; jump to done if ecx == 0  ; jump if ZF = 1
         mul ecx      ; edx:eax = eax*ecx = silnia(n - 1) * n
         dec ecx      ; ecx = ecx - 1 = n - 1
         call silnia  ; eax = silnia(ecx) = silnia(n - 1)

done     ret

; silnia(0) = 1
; silnia(1) = 1
; silnia(n) = n * silnia(n-1)

%ifdef COMMENT
eax = silnia(ecx, eax) = silnia(ecx, akumulator)

* silnia(2, 1) =                * silnia(2, 1) = 2
  ecx = 2                         ecx = 2
  eax = 1                         eax = 1
  eax = eax * ecx = 1 * 2 = 2     eax = eax * ecx = 2
  ecx = ecx - 1 = 2 - 1 = 1       ecx = ecx - 1 = 1
  call silnia(1, 2)               call silnia(1, 2) = 2
  return eax =                    return eax = 2

* silnia(1, 2) =                * silnia(1, 2) = 2
  ecx = 1                         ecx = 1
  eax = 2                         eax = 2
  eax = eax * ecx = 2 * 1 = 2     eax = eax * ecx = 2
  ecx = ecx - 1 = 1 - 1 = 0       ecx = ecx - 1 = 0
  call silnia(0, 2)               call silnia(0, 2) = 2
  return eax =                    return eax = 2

* silnia(0, 2) =                * silnia(0, 2) = 2
  ecx = 0                         ecx = 0
  return eax = 2                  return eax = 2
%endif

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
