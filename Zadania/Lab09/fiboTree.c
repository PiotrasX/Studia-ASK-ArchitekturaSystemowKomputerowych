#include <stdio.h>
#include <stdlib.h>

/*
fibo1(4) = 5
fibo2(3) = 3
fibo3(2) = 2
fibo4(1) = 1
fibo5(0) = 1
fibo6(1) = 1
fibo7(2) = 2
fibo8(1) = 1
fibo9(0) = 1
*/

int f(int n) {
	if (n == 0) return 1;
	if (n == 1) return 1;
	
	return f(n - 1) + f(n - 2);
}

int fibo(int n) {
	static int wywolanie;
	
	wywolanie++;
	
	printf("fibo%u(%u) = %u\n", wywolanie, n, f(n));
	
	if (n == 0) return 1;
	if (n == 1) return 1;
	
	return fibo(n - 1) + fibo(n - 2);
}

int main() {
    printf("fiboTree.c\n\n");
    
    int n = 4;
    
    fibo(4);
    
    return 0;
}
