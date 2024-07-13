#include <stdio.h>
#include <stdlib.h>

int main() {
    printf("bytes.c\n\n");
    
    int value;
    printf("Podaj liczbe typu 'int': ");
    scanf("%lu", &value);

    char bytes[4];
    bytes[0] = value & 0xFF;
    bytes[1] = (value >> 8) & 0xFF;
    bytes[2] = (value >> 16) & 0xFF;
    bytes[3] = (value >> 24) & 0xFF;

    printf("\n");
    printf("value = %lu\n\n", value);
    printf("bytes = %03lu %03lu %03lu %03lu\n", bytes[0], bytes[1], bytes[2], bytes[3]);
    
    return 0;
}
