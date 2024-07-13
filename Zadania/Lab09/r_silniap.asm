         [bits 32]

%ifdef COMMENT
0!! = 1
1!! = 1
n!! = n*(n-2)!!
%endif

;        esp -> [ret]  ; ret - adres powrotu do asmloader

n        equ 8

         mov ecx, n  ; ecx = n

         call silnia   ; eax = silnia(ecx) ; fastcall
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

;        eax silnia(ecx)

silnia   cmp ecx, 1  ; compare ecx with 1      ; ZF affected
         jg rec      ; jump to rec if ecx > 1  ; jump if ZF = 0
         mov eax, 1  ; eax = 1
         ret

rec      push ecx     ; ecx -> stack = n
         sub ecx, 2   ; ecx = ecx - 2 = n - 2
         call silnia  ; eax = silnia(ecx) = silnia(n - 2)
         pop ecx      ; ecx <- stack = n
         mul ecx      ; edx:eax = eax*ecx = silnia(n - 2) * n
         ret

%ifdef COMMENT
eax = silnia(ecx)

* silnia(8) =                 * silnia(8) = 384
  ecx -> stack = 8              ecx -> stack = 8
  ecx = ecx - 2 = 8 - 2 = 6     ecx = ecx - 2 = 6
  eax = silnia(6) =             eax = silnia(6) = 48
  ecx <- stack = 8              ecx <- stack = 8
  eax = eax * ecx =             eax = eax * ecx = 48 * 8 = 384
  return eax =                  return eax = 384

* silnia(6) =                 * silnia(6) = 48
  ecx -> stack = 6              ecx -> stack = 6
  ecx = ecx - 2 = 6 - 2 = 4     ecx = ecx - 2 = 4
  eax = silnia(4) =             eax = silnia(4) = 8
  ecx <- stack = 6              ecx <- stack = 6
  eax = eax * ecx =             eax = eax * ecx = 8 * 6 = 48
  return eax =                  return eax = 48

* silnia(4) =                 * silnia(4) = 8
  ecx -> stack = 4              ecx -> stack = 4
  ecx = ecx - 2 = 4 - 2 = 2     ecx = ecx - 2 = 2
  eax = silnia(2) =             eax = silnia(2) = 2
  ecx <- stack = 4              ecx <- stack = 4
  eax = eax * ecx =             eax = eax * ecx = 2 * 4 = 8
  return eax =                  return eax = 8

* silnia(2) =                 * silnia(2) = 2
  ecx -> stack = 2              ecx -> stack = 2
  ecx = ecx - 2 = 2 - 2 = 0     ecx = ecx - 2 = 0
  eax = silnia(0) =             eax = silnia(0) = 1
  ecx <- stack = 2              ecx <- stack = 2
  eax = eax * ecx =             eax = eax * ecx = 1 * 2 = 2
  return eax =                  return eax = 2

* silnia(0) =                 * silnia(0) = 1
  eax = 1                       eax = 1
  return eax = 1                return eax = 1
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