#include <stdio.h>
#include <stdlib.h>

int main() {
    printf("mul.c\n\n");
    
    unsigned int a = 2147483647;
    unsigned int b = 2;
    
    unsigned int iloczyn = a * b;
    
    printf("a = %u\n", a);
    printf("b = %u\n\n", b);
    
    printf("iloczyn = %u\n", iloczyn);
    
    return 0;
}
