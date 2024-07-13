#include <stdio.h>
#include <stdlib.h>

int main() {
    printf("size.c\n\n");
    
    printf("sizeof(char) = %lu\n", sizeof(char));
    printf("sizeof(short) = %lu\n", sizeof(short));
    printf("sizeof(int) = %lu\n", sizeof(int));
    printf("sizeof(long) = %lu\n", sizeof(long));
    printf("sizeof(long int) = %lu\n", sizeof(long int));
    printf("sizeof(long long) = %lu\n\n", sizeof(long long));
    
    printf("sizeof(float) = %lu\n", sizeof(float));
    printf("sizeof(double) = %lu\n", sizeof(double));
    printf("sizeof(long double) = %lu\n", sizeof(long double));
    
    return 0;
}
