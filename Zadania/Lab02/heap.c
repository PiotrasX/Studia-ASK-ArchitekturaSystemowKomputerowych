#include <stdio.h>
#include <stdlib.h>

int main() {
    printf("heap.c\n\n");
    
    void* x = malloc(sizeof(int));
    void* y = malloc(sizeof(int));
    
    printf("x = %p\n", x);
    printf("y = %p\n\n", y);
    
    printf("y - x = %d\n\n", y - x);
    
    *(int*)x = 1;
    *(int*)y = 2;
    
    printf("*x = %d\n", *(int*)x);
    printf("*y = %d\n", *(int*)y);
    
    /*
             [ ][ ][ ][ ]
             [ ][ ][ ][ ]
             [ ][ ][ ][ ]
    009D1478 [2][0][0][0]   *y

             [ ][ ][ ][ ]
             [ ][ ][ ][ ]
             [ ][ ][ ][ ]
    009D1468 [1][0][0][0]   *x
    */
    
    return 0;
}
