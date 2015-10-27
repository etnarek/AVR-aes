#include "aes.h"
#include "matrix.h"

unsigned char subByte(const unsigned char byte){
    return SBOX[byte];
}

void subBytes(unsigned char matrix[16]){
    int i =0;
    for(i=0; i<16; i++)
        matrix[i] = subByte(matrix[i]);

}

void shiftRow(unsigned char matrix[16], const int rowNumber){
    unsigned char tmpRow[4];
    int i =0;
    for(i=0;i<4;i++)
        tmpRow[i] = matrix[i+ 4*rowNumber];

    for(i=0;i<4;i++)
        matrix[i+4*rowNumber] = tmpRow[(i+rowNumber)%4];
}

void shiftRows(unsigned char matrix[16]){
    int i =0;
    for(i=0; i<4; i++)
        shiftRow(matrix, i);
}

void mixColumn(unsigned char matrix[16], const int colomnNumber){
    //Use lookup table to be sideattack safe?
    unsigned char a[4]; // copy of column
    unsigned char b[4]; // each element of a multiplied by 2
    int i =0;

    for(i=0; i<4; i++){
        unsigned char h;
        a[i] = matrix[i*4 + colomnNumber];
        h = (unsigned char)((signed char)a[i] >> 7);
        b[i] = a[i] << 1;
        b[i] ^= 0x1B & h;
    }
    matrix[colomnNumber] = b[0] ^ a[3] ^ a[2] ^ b[1] ^ a[1]; /* 2 * a0 + a3 + a2 + 3 * a1 */
    matrix[colomnNumber + 4] = b[1] ^ a[0] ^ a[3] ^ b[2] ^ a[2]; /* 2 * a1 + a0 + a3 + 3 * a2 */
    matrix[colomnNumber + 8] = b[2] ^ a[1] ^ a[0] ^ b[3] ^ a[3]; /* 2 * a2 + a1 + a0 + 3 * a3 */
    matrix[colomnNumber + 12] = b[3] ^ a[2] ^ a[1] ^ b[0] ^ a[0]; /* 2 * a3 + a2 + a1 + 3 * a0 */
}

void mixColumns(unsigned char matrix[16]){
    int i =0;
    for(i=0; i<4; i++)
        mixColumn(matrix, i);
}

void addRoundKey(unsigned char matrix[16], const unsigned char roundKey[16]){
    int i =0;
    for(i=0; i<16; i++)
        matrix[i] ^= roundKey[i];
}

void keyExpansion(unsigned char roundKey[16], const int roundNb){
    int i,j =0;
    // RotWord + subByte
    for(i=0; i<4; i++){
        roundKey[i*4] ^= subByte(roundKey[((i+1)*4)%16+3]);
    }
    roundKey[0] ^= RCON[roundNb];
    for(i=1; i<4; i++){
        for(j=0; j<4; j++)
            roundKey[j*4+i] ^= roundKey[j*4+i-1];
    }
}

void nextRound(unsigned char matrix[16], unsigned char roundKey[16], const int roundNb){
    subBytes(matrix);
    shiftRows(matrix);
    mixColumns(matrix);
    addRoundKey(matrix, roundKey);
    keyExpansion(roundKey, roundNb);
}

void aes(unsigned char matrix[16], const unsigned char key[16]){
    int i =0;
    copy(key, roundKey);
    addRoundKey(matrix, roundKey);
    keyExpansion(roundKey,0);
    for(i=1; i<10; i++)
        nextRound(matrix, roundKey, i);
    subBytes(matrix);
    shiftRows(matrix);
    addRoundKey(matrix, roundKey);
}
