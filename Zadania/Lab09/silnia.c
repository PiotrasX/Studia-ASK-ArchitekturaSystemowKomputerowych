#include <stdio.h>
#include <stdlib.h>

/*
0! = 1
n! = n*(n-1)!
*/

int silnia(int n) {
	if (n == 0) return 1;
	
	return n * silnia(n - 1);
}

/*
- Dokonaj analizy wywołania silnia(3).

* silnia1(3) = 6
  n = 3
  return 3 * silnia2(2) = 3 * 2 = 6
  
* silnia2(2) = 2
  n = 2
  return 2 * silnia3(1) = 2 * 1 = 2
  
* silnia3(1) = 1
  n = 1
  return 1 * silnia4(0) = 1 * 1 = 1
  
* silnia4(0) = 1
  n = 0
  return 1 
  
  
  
- Narysuj graf wywołań dla silnia(3).

silnia1(3) -> silnia2(2) -> silnia3(1) -> silnia4(0)
*/
	
int main() {
    printf("silnia.c\n\n");
    
    int n = 3;
    
	printf("silnia(%d) = %d", n, silnia(n));
    
    return 0;
}
