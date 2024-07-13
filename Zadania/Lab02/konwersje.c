#include <stdio.h>
#include <stdlib.h>

/*
Jaką maksymalną liczbę binarną można zapisać przy 
pomocy typu int?

UINT_MAX = 4294967295
UBIN_MAX = 1111111111



Jaka jest wartość dziesiętna maksymalnej liczby binarnej, 
jaką można zapisać przy pomocy typu int?

           9876543210
UBIN_MAX = 1111111111 = 2^10 - 1 = 1KB - 1 = 1023



Dla jakich wartości parametrów aktualnych powyższe funkcje 
będą działać poprawnie?

Dla wartości od 0 do 1023
*/

/*
11 / 2 = 5 	r0 = 1
5 / 2 = 2 	r1 = 1
2 / 2 = 1 	r2 = 0
1 / 2 = 0	r3 = 1

      3210
11 -> 1011 = 1*10^0 + 1*10^1 + 0*10^2 + 1*10^3 = 1 + 2 + 0 + 8 = 11
*/

int dec2bin(int x) {
    int sum = 0;
    int pow = 1;
    
    while (x > 0) {
        sum = sum + x % 2 * pow;
        x = x / 2;
        pow = pow * 10;
    }
    
    return sum;
}

int bin2dec(int x) {
	int sum = 0;
	int pow = 1;
	
	while (x > 0) {
		sum = sum + x % 10 * pow;
		x = x / 10;
		pow = pow * 2;	
	}

	return sum;
}

void dec2byte(unsigned int x) {
	unsigned char *p = (char*) &x;
	printf("bin2dec(%u) = [%.3u] [%.3u] [%.3u] [%.3u]\n", x, *p, *(p + 1), *(p + 2), *(p + 3));
}

int main() {
    printf("konwersje.c\n\n");
    
    int dec1 = 1023;
    printf("dec2bin(%u) = %u\n\n", dec1, dec2bin(dec1));
    
    int bin1 = 1111111111;
    printf("bin2dec(%u) = %u\n\n", bin1, bin2dec(bin1));
    
    unsigned int dec2 = 1023;
    dec2byte(dec2);
    
    return 0;
}
