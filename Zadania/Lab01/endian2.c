#include <stdio.h>
#include <stdlib.h>

int main() {
    printf("endian2.c\n\n");
    
    int i = 1;
    char *c = (char*)&i;
    if (*c) printf("Is a little-endian architecture.\n");
	else printf("Is a big-endian architecture.\n");
    
    return 0;
}
