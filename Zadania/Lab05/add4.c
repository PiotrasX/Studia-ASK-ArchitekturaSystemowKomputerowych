#include <stdio.h>
#include <stdlib.h>

int main() {
    printf("add4.c\n\n");
    
    unsigned int a = 4294967295;
    unsigned int b = 1;
    
    unsigned long long suma = (unsigned long long) a + b;
    
    printf("a = %u\n", a);
    printf("b = %u\n\n", b);
    
    printf("suma = %llu\n", suma);
    
    return 0;
}
