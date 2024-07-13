#include <stdio.h>
#include <stdlib.h>

int main() {
    printf("add5.c\n\n");
    
    int a = -2147483648;
    int b = -1;
    
    long long suma = (long long) a + b;
    
    printf("a = %d\n", a);
    printf("b = %d\n\n", b);
    
    printf("suma = %lld\n", suma);
    
    return 0;
}
