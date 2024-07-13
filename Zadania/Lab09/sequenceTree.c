#include <stdio.h>
#include <stdlib.h>

/*
seq1(4) = 12
seq2(3) = 8
seq3(2) = 4
seq4(1) = 3
seq5(2) = 4
*/

int s(int n) {
	if (n == 1) return 3;
	if (n == 2) return 4;
	
	return 0.5 * s(n - 1) + 2 * s(n - 2);
}

int seq(int n) {
	static int wywolanie;
	
	wywolanie++;
	
	printf("seq%u(%u) = %u\n", wywolanie, n, s(n));
	
	if (n == 1) return 3;
	if (n == 2) return 4;
	
	return 0.5 * seq(n - 1) + 2 * seq(n - 2);
}

int main() {
    printf("sequenceTree.c\n\n");
    
    int n = 4;
    
    seq(4);
    
    return 0;
}
