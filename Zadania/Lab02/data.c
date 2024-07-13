#include <stdio.h>
#include <stdlib.h>

int main() {
    printf("data.c\n\n");

	int a = 1;
	int b = 2;
	int c;
	int d;
	int e = 3;
	int f;
	int g;
	int h = 4;
	
	int *p_a = &a;
    int *p_b = &b;
    int *p_c = &c;
    int *p_d = &d;
    int *p_e = &e;
    int *p_f = &f;
    int *p_g = &g;
    int *p_h = &h;
    
    printf("p_a = %p\n", p_a);
    printf("p_b = %p\n", p_b);
    printf("p_c = %p\n", p_c);
    printf("p_d = %p\n", p_d);
    printf("p_e = %p\n", p_e);
    printf("p_f = %p\n", p_f);
    printf("p_g = %p\n", p_g);
    printf("p_h = %p\n", p_h);
    
    /*
    &var1 [ ][ ][ ][ ]   var1
	&var2 [ ][ ][ ][ ]   var2
	&var3 [ ][ ][ ][ ]   var3
	&var4 [ ][ ][ ][ ]   var4
	&var5 [ ][ ][ ][ ]   var5
	&var6 [ ][ ][ ][ ]   var6
	&var7 [ ][ ][ ][ ]   var7
	&var8 [ ][ ][ ][ ]   var8
	
	0064FEAC [1][0][0][0]   a
	0064FEA8 [2][0][0][0]   b
	0064FEA4 [0][0][0][0]   c
	0064FEA0 [0][0][0][0]   d
	0064FE9C [3][0][0][0]   e
	0064FE98 [0][0][0][0]   f
	0064FE94 [0][0][0][0]   g
	0064FE90 [4][0][0][0]   h
    */
    
    return 0;
}
