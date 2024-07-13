#include <stdio.h>
#include <stdlib.h>
#include <math.h>

int polinomial(unsigned char *p, int n) {
	unsigned int suma = 0;
	
	int i;
	for (i = 0; i < n; i++) {
		suma = suma + *(p + i) * pow(256, i);
	}
	
	return suma;
}

int horner(unsigned char *p, int n) {
	unsigned int suma = *(p + n - 1);
	
	int i;
	for (i = n - 2; i >= 0; i--) {
    	suma = *(p + i) + 256 * suma;
    }
	
	return suma;
}

int main() {
    printf("number.c\n\n");
    
    char xOneByte[] = {4};
    char xTwoBytes[] = {4, 1};
    char xFourBytes[] = {4, 1, 0, 0};
    
    int nOneByte = sizeof(xOneByte);
    int nTwoBytes = sizeof(xTwoBytes);
    int nFourBytes = sizeof(xFourBytes);
    
    void *pOneByte = &xOneByte;
    void *pTwoBytes = &xTwoBytes;
    void *pFourBytes = &xFourBytes;
    
    printf("number(%p, %d) = %u\n", pOneByte, nOneByte, polinomial(pOneByte, nOneByte));
    printf("number(%p, %d) = %u\n\n", pOneByte, nOneByte, horner(pOneByte, nOneByte));
    printf("number(%p, %d) = %u\n", pTwoBytes, nTwoBytes, polinomial(pTwoBytes, nTwoBytes));
    printf("number(%p, %d) = %u\n\n", pTwoBytes, nTwoBytes, horner(pTwoBytes, nTwoBytes));
    printf("number(%p, %d) = %u\n", pFourBytes, nFourBytes, polinomial(pFourBytes, nFourBytes));
    printf("number(%p, %d) = %u\n", pFourBytes, nFourBytes, horner(pFourBytes, nFourBytes));
    
    return 0;
}
