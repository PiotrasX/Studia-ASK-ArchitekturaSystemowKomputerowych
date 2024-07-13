#include <stdio.h>
#include <stdlib.h>

/*
seq(1) = 3
seq(2) = 4
seq(n) = 0.5*seq(n-1) + 2*seq(n-2)  dla  n > 2



seq1:

r0  r1  r2
|---|---|       
1   2   3   4   5   6    indeksy
3   4   x   x   x   x    wartości
    |---|---|
    r0  r1  r2

Przesunięcie ramki w prawo:

r0 = r1
r1 = r2
r2 = 0.5 * r1 + 2 * r0
*/

double seq1(int n) {
    double r0 = 3;
    double r1 = 4;
    double r2 = 0.5 * r1 + 2 * r0;
	
	if (n == 1) return r0;
	if (n == 2) return r1;
	if (n == 3) return r2;
	
	int i;
	for (i = 1; i <= n-3; i++) {
		r0 = r1;
		r1 = r2;
		r2 = 0.5 * r1 + 2 * r0;
	}
	
	return r2;
}

/* 
- Ile razy należy przesunąć ramkę w prawo, aby wyznaczyć wartość 
  n-tego wyrazu ciągu w funkcji seq1 dla n >= 3 ?
  
  Należy przesunąć ramkę w prawo n – 3 razy.
  
  
  
- Dokonaj analizy wywołania seq1(4).

* seq1(4) = 
  r0 = 3
  r1 = 4
  r2 = 0.5 * r1 + 2 * r0 = 0.5 * 4 + 2 * 3 = 2 + 6 = 8
  
  n = 4
  4 == 1   false
  4 == 2   false
  4 == 3   false
  
  i
  i = 1
  1 <= 1   r0 = r1 = 4
           r1 = r2 = 8
           r2 = 0.5 * r1 + 2 * r0 = 0.5 * 8 + 2 * 4 = 4 + 8 = 12   i = 2
           
  2 <= 1   false
  
  return r2 = 12
  
  
  
- Narysuj graf obliczeń dla seq1(4).
                
s(1)    s(2)
   \   /  |
    s(3)  |
       \  |
        s(4)
*/

/*
seq(1) = 3
seq(2) = 4
seq(n) = 0.5*seq(n-1) + 2*seq(n-2)  dla  n > 2



seq2:

r0  r1
|---|      
1   2   3   4   5   6    indeksy
3   4   x   x   x   x    wartości
|   |---|
pom r0  r1

Przesunięcie ramki w prawo:

pom = r0
r0 = r1
r1 = 0.5 * r0 + 2 * pom
*/

double seq2(int n) {
    double r0 = 3;
    double r1 = 4;
	
	if (n == 1) return r0;
	if (n == 2) return r1;
	
	int i, pom;
	for (i = 1; i <= n-2; i++) {
		pom = r0;
		r0 = r1;
		r1 = 0.5 * r0 + 2 * pom;
	}
	
	return r1;
}

/* 
- Ile razy należy przesunąć ramkę w prawo, aby wyznaczyć wartość 
  n-tego wyrazu ciągu w funkcji seq2 dla n >= 3 ?
  
  Należy przesunąć ramkę w prawo n – 2 razy.
  
  
  
- Dokonaj analizy wywołania seq2(4).

* seq2(4) = 
  r0 = 3
  r1 = 4
  
  n = 4
  4 == 1   false
  4 == 2   false
  
  i, pom
  i = 1
  1 <= 2   pom = r0 = 3
           r0  = r1 = 4
           r1  = 0.5 * r0 + 2 * pom = 0.5 * 4 + 2 * 3 = 2 + 6 = 9   i = 2
  
  2 <= 2   pom = r0 = 4
           r0  = r1 = 8
           r1  = 0.5 * r0 + 2 * pom = 0.5 * 8 + 2 * 4 = 4 + 8 = 12   i = 3
         
  2 <= 3   false
  
  return r1 = 12
  
  
  
- Narysuj graf obliczeń dla seq2(4).
                
s(1)    s(2)
   \   /  |
    s(3)  |
       \  |
        s(4)
*/

double seq3(int n) {
	if (n == 1) return 3;
	if (n == 2) return 4;
		
	return 0.5 * seq3(n - 1) + 2 * seq3(n - 2);
}

/* 
- Dokonaj analizy wywołania seq3(4).

* seq3_1(4) = 12
  4 == 1   false
  4 == 2   false
  
  return 0.5 * seq3_2(3) + 2 * seq3_?(2) = 0.5 * 8 + 2 * seq3_5(2) = 4 + 2 * 4 = 4 + 8 = 12

* seq3_2(3) = 8
  3 == 1   false
  3 == 2   false
  
  return 0.5 * seq3_3(2) + 2 * seq3_?(1) = 0.5 * 4 + 2 * seq3_4(1) = 2 + 2 * 3 = 2 + 6 = 8

* seq3_3(2) = 4
  2 == 1   false
  2 == 2   true
  
  return 4 

* seq3_4(1) = 3
  1 == 1   true
  
  return 3 

* seq3_5(2) = 4
  2 == 1   false
  2 == 2   true
  
  return 4
  
  
  
- Narysuj graf obliczeń dla seq3(4).
                
			  __s1(4)_
		 	 /        \
	 	 s2(3)         s5(2)
		/ \
	s3(2)  s4(1)
*/

int main() {
    printf("sequence.c\n\n");
    
    int n = 4;
    
    printf("seq1(%d) = %.1f\n", n, seq1(n));
    printf("seq2(%d) = %.1f\n", n, seq2(n));
    printf("seq3(%d) = %.1f\n", n, seq2(n));
    
    return 0;
}
