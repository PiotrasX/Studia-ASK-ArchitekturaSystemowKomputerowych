#include <stdio.h>
#include <stdlib.h>

int main() {
    printf("endian.c\n\n");
    
    int i = 1;
    char *c = (char*)&i;
    if (*c) printf("Architektura little-endian.\n");
    else printf("Architektura big-endian.\n");

    return 0;
}
