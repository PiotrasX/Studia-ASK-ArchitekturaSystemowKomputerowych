         [bits 32]

%ifdef COMMENT
0   1   2   3   4   5   6    indeksy
1   1   2   3   5   8   13   wartosci

f(0) = 1
f(1) = 1
f(n) = f(n - 1) + f(n - 2)
%endif

;        esp -> [ret]  ; ret - adres powrotu do asmloader

n        equ 5

         mov ecx, n  ; ecx = n

         call fibo   ; eax = fibo(ecx) ; fastcall
r_addr:

;        esp -> [ret]

         push eax

;        esp -> [eax][ret]

         call getaddr
format:
         db "fibo = %i", 0xA, 0
getaddr:

;        esp -> [format][eax][ret]

         call [ebx+3*4]  ; printf(format, eax);
         add esp, 2*4    ; esp = esp + 8

;        esp -> [ret]

         push 0          ; esp -> [0][ret]
         call [ebx+0*4]  ; exit(0);

;        eax fibo(ecx)

fibo     cmp ecx, 0  ; ecx - 0            ; ZF affected
         jne next    ; jump if not equal  ; jump if ZF = 0
         mov eax, 1  ; eax = 1
         ret
         
next     cmp ecx, 1    ; ecx - 1            ; ZF affected
         jne rec       ; jump if not equal  ; jump if ZF = 0
         mov eax, ecx  ; eax = ecx
         ret

rec      dec ecx       ; ecx = ecx - 1 = n - 1
         push ecx      ; ecx -> stack = n - 1
         call fibo     ; eax = fibo(ecx) = fibo(n - 1)
         pop ecx       ; ecx <- stack = n - 1
         dec ecx       ; ecx = ecx - 1 = n - 2
         push eax      ; eax -> stack fibo(n - 1)
         call fibo     ; eax = fibo(ecx) = fibo(n - 2)
         pop ecx       ; ecx -> stack = fibo(n - 1)
         add eax, ecx  ; eax = eax + ecx = fibo(n - 2) + fibo(n - 1)
         ret

%ifdef COMMENT
eax = fibo(ecx)

* fibo(2) =                   * fibo(2) = 2
  ecx = 2                       ecx = 2
  ecx = ecx - 1 = 2 - 1 = 1     ecx = ecx - 1 = 1
  ecx -> stack = 1              ecx -> stack = 1
  eax = fibo(1) =               eax = fibo(1) = 1
  ecx <- stack = 1              ecx <- stack = 1
  ecx = ecx - 1 = 1 - 1 = 0     ecx = ecx - 1 = 0
  eax -> stack =                eax -> stack = 1
  eax = fibo(0) =               eax = fibo(0) = 1
  ecx <- stack =                ecx <- stack = 1
  eax = eax + ecx =             eax = eax + ecx = 1 + 1 = 2
  return eax =                  return eax =

* fibo(1) =                   * fibo(1) = 1
  ecx = 1                       ecx = 1
  eax = ecx = 1                 eax = ecx = 1
  return eax = 1                return eax = 1

* fibo(0) =                   * fibo(0) = 1
  ecx = 0                       ecx = 0
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
