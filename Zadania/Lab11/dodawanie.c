#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

/*
Plan programu:
- Pobranie a i b. 
- Określenie większej i mniejszej wartości z a i b.
- Określenie tablicy przeniesień.
- Wypisanie przeniesień.
- Wypisanie większej liczby.
- Wypisanie znaku plus i mniejszej liczby.
- Wypisanie podkreślenia.
- Wypisanie wyniku dodawania.
*/

int main() {
	printf("dodawanie.c\n\n");
	
	int a, b;
	char buffer[256];
	 
	do {
        printf("a = ");
        if (fgets(buffer, sizeof(buffer), stdin) != NULL) {
            if (sscanf(buffer, "%d", &a) != 1 || a < 0) {
                printf("Musisz podac liczbe nieujemna.\n");
            	a = -1;
			}
        }
    } while (a < 0);

    do {
        printf("b = ");
        if (fgets(buffer, sizeof(buffer), stdin) != NULL) {
            if (sscanf(buffer, "%d", &b) != 1 || b < 0) {
                printf("Musisz podac liczbe nieujemna.\n");
            	a = -1;
			}
        }
    } while (b < 0);
	
	int max_ab = a > b ? a : b;
	int min_ab = a < b ? a : b;
	
	max_ab = max_ab >= 0 ? max_ab : 0;
	min_ab = min_ab >= 0 ? min_ab : 0;
	
	int width_max_ab = max_ab > 0 ? log10(max_ab) + 1 : 1;
	int carry[width_max_ab + 1];
	memset(carry, 0, sizeof(carry));
	
	/*
	a = 9237
	b = 1267

	7 + 7     = 14   c = 1
	3 + 6 + 1 = 10   c = 1
	2 + 2 + 1 = 5	 c = 0
	9 + 1 + 0 = 10   c = 1
	*/      
	
	int d = 10;
	int carry_value = 0;
	int i;
	
    for (i = 0; i < width_max_ab; i++) {
        int digit_a = (a / (int)pow(10, i)) % 10;
        int digit_b = (b / (int)pow(10, i)) % 10;
        
		int sum = digit_a + digit_b + carry_value;
		
		if (sum >= 10) {
            carry[i + 1] = 1;
            carry_value = 1;
        } else {
            carry_value = 0;
        }
	}
	
	printf("\n ");
	
	for (i = width_max_ab; i >= 0; i--) printf(carry[i] == 1 ? "1" : " ");
		
	printf("\n  %d\n", max_ab);
	printf("+ %*d\n", width_max_ab, min_ab);
		
	for (i = width_max_ab + 2; i >= 0; i--) printf("-");
		
	printf("\n%*d\n", width_max_ab + 2, max_ab + min_ab);
	
	return 0;
}
