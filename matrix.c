#include "matrix.h"

void swap(unsigned char *a, unsigned char *b){
    unsigned char tmp = *a;
    *a = *b;
    *b = tmp;
}

/*void transpose(unsigned char matrix[16]){*/
    /*int i,j = 0;*/
    /*for(i=0; i<4; i++){*/
        /*for(j=0; j<i; j++)*/
            /*swap(matrix + i*4 + j, matrix + j*4 +i );*/
    /*}*/
/*}*/

void copy(const unsigned char source[16], unsigned char dest[16]){
    int i = 0;
    for(i=0; i<16; i++)
        dest[i] = source[i];
}
