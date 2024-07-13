#include <stdio.h>
#include <stdlib.h>

/*
fibo1:

r0  r1  r2
|---|---|       
0   1   2   3   4   5   6    indeksy
1   1   2   3   5   8   13   wartości
    |---|---|
    r0  r1  r2

Przesunięcie ramki w prawo:

r0 = r1
r1 = r2
r2 = r1 + r0



fibo2:

r0  r1
|---|
0   1   2   3   4   5   6    indeksy
1   1   2   3   5   8   13   wartości
|   |---|
pom r0  r1

Przesunięcie ramki w prawo:

pom = r0
r0  = r1
r1  = pom + r0
*/

int fibo1(int n) {
	int r0 = 1;
	int r1 = 1;
	int r2 = 2;
	
	if (n == 0) return r0;
	if (n == 1) return r1;
	if (n == 2) return r2;
	
	int i;
	for (i = 1; i <= n-2; i++) {
		r0 = r1;
		r1 = r2;
		r2 = r1 + r0;
	}
	
	return r2;
}

/*
- Ile razy należy przesunąć ramkę w prawo, aby wyznaczyć wartość 
  n-tego wyrazu ciągu Fibonacciego w funkcji fibo1 dla n >= 3 ?
  
  Należy przesunąć ramkę w prawo n – 2 razy.
  
  
  
- Dokonaj analizy wywołania fibo1(4).

* fibo1(4) = 
  r0 = 1
  r1 = 1
  r2 = 2
  
  n = 4
  4 == 0   false
  4 == 1   false
  4 == 2   false
  
  i
  i = 1
  1 <= 2   r0 = r1 = 1
           r1 = r2 = 2
           r2 = r1 + r0 = 2 + 1 = 3   i = 2
           
  2 <= 2   r0 = r1 = 2
           r1 = r2 = 3
           r2 = r1 + r0 = 3 + 2 = 5   i = 3
           
  3 <= 2   false
  
  return r2 = 5
  
  
  
- Narysuj graf obliczeń dla fibo1(4).

f(0)    f(1)    f(2)
           \   /  |
            f(3)  |
               \  |
                f(4)
*/

int fibo2(int n) {
	int r0 = 1;
	int r1 = 1;
	
	if (n == 0) return r0;
	if (n == 1) return r1;
	
	int i, pom;
	for (i = 1; i <= n-1; i++) {
		pom = r0;
		r0 = r1;
		r1 = r0 + pom;
	}
	
	return r1;
}

/*
- Ile razy należy przesunąć ramkę w prawo, aby wyznaczyć wartość 
  n-tego wyrazu ciągu Fibonacciego w funkcji fibo2 dla n >= 3 ?
  
  Należy przesunąć ramkę w prawo n – 1 razy.
  
  
  
- Dokonaj analizy wywołania fibo2(4).

* fibo2(4) = 
  r0 = 1
  r1 = 1
  
  n = 4
  4 == 0   false
  4 == 1   false
  
  i, pom
  i = 1
  1 <= 3   pom = r0 = 1
           r0  = r1 = 1
           r1  = r0 + pom = 1 + 1 = 2   i = 2
           
  2 <= 3   pom = r0 = 1
           r0  = r1 = 2
           r1  = r0 + pom = 2 + 1 = 3   i = 3
           
  3 <= 3   pom = r0 = 2
           r0  = r1 = 3
           r1  = r0 + pom = 3 + 2 = 5   i = 4
           
  4 <= 3   false
  
  return r1 = 5
  
  
  
- Narysuj graf obliczeń dla fibo2(4).

f(0)    f(1)
   \   /  |
    f(2)  |
    |  \  |
    |   f(3)
    |  /
    f(4)
*/

int main() {
    printf("fibo.c\n\n");
    
    int n = 4;
    
    printf("fibo1(%d) = %d\n", n, fibo1(n));
    printf("fibo2(%d) = %d\n", n, fibo2(n));
    
    return 0;
}
