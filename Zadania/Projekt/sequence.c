#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <inttypes.h>

uint64_t rdtsc() {
   uint32_t hi, lo;
   __asm__ __volatile__ ("rdtsc" : "=a"(lo), "=d"(hi));
   return ((uint64_t)lo) | (((uint64_t)hi) << 32);
}

/*
seq(1) = 3
seq(2) = 4
seq(n) = 0.5*seq(n-1) + 2*seq(n-2) dla   n > 2

seq(3) = 0.5*seq(2) + 2*seq(1) = 0.5*4 + 2*3 = 2 + 6 = 8



seq3:

r0  r1  r2
|---|---|       
1   2   3   4   5   6    indeksy
3   4   8   x   x   x    wartości
    |---|---|
    r0  r1  r2



Przesunięcie ramki w prawo:

r0 = r1
r1 = r2
r2 = 0.5*r1 + 2*r0
*/

double seq3(int n) {
    double r0 = 3;
    double r1 = 4;
    double r2 = 0.5*r1 + 2*r0;
	
	if (n == 1) return r0;
	if (n == 2) return r1;
	if (n == 3) return r2;
	
	for (int i = 1; i <= n-3; i++) {
		r0 = r1;
		r1 = r2;
		r2 = 0.5*r1 + 2*r0;
	}
	
	return r2;
}

/*
seq(1) = 3
seq(2) = 4
seq(n) = 0.5*seq(n-1) + 2*seq(n-2) dla   n > 2



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
r1 = 0.5*r0 + 2*pom
*/

double seq2(int n) {
    double r0 = 3;
    double r1 = 4;
	
	if (n == 1) return r0;
	if (n == 2) return r1;
	
	double pom;
	for (int i = 1; i <= n-2; i++) {
		pom = r0;
		r0 = r1;
		r1 = 0.5*r0 + 2*pom;
	}
	
	return r1;
}

int main() {
    int n;
    double r_seq3, r_seq2;
    uint64_t start, end;
    
    printf("\nn = ");
    
    if (scanf("%d", &n) != 1 || n < 1) {
        printf("Podano nieprawidlowa wartosc!\n");
        printf("Musisz podac liczbe calkowita wieksza od 0!\n");
    } else {
        start = rdtsc();
        r_seq3 = seq3(n);
        end = rdtsc();
        printf("seq3(%d) = %.6f\n", n, r_seq3);
        printf("Cykle procesora przy wykonaniu funkcji seq3: %" PRIu64 "\n", end - start);

        start = rdtsc();
        r_seq2 = seq2(n);
        end = rdtsc();
        printf("seq2(%d) = %.6f\n", n, r_seq2);
        printf("Cykle procesora przy wykonaniu funkcji seq2: %" PRIu64 "\n", end - start);
    }
    
    return 0;
}
