#include <stdio.h>
#include <stdlib.h>

int main() {
    printf("bits.c\n\n");
    
    void *p; // Generyczny wskaźnik na voida (p + 1 przeskakuje o 1 bajt)
    
    size_t bytes = sizeof(p);
    
    printf("sizeof(p) = %lu\n\n", bytes);
    
    if (bytes == 4) printf("I am a 32-bit program.\n");
    if (bytes == 8) printf("I am a 64-bit program.\n");
    
    return 0;
}
