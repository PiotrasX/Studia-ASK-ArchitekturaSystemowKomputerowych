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

/*
0!! = 1
1!! = 1
n!! = n*(n-2)!!
*/

int silniap(int n) {
	if (n == 0) return 1;
	if (n == 1) return 1;
	
	return n * silniap(n - 2);
}

/*
- Dokonaj analizy wywołania silniap(3).

* silniap1(3) = 
  n = 3
  return 3 * silniap2(1) = 3 * 1 = 3
  
* silniap2(1) = 1
  n = 1
  return 1



- Narysuj graf wywołań dla silniap(3).

silniap1(3) -> silniap2(1)
*/
	
int main() {
    printf("silniap.c\n\n");
    
    int n = 3;
    
	printf("silnia(%d) = %d\n", n, silnia(n));
	printf("silnia(%d) = %d", n, silniap(n));
    
    return 0;
}
