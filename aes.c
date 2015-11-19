#include "aes.h"
#include "matrix.h"

void subBytes(unsigned char matrix[16]){
    int i =0;
    for(i=0; i<16; i++)
        setMatrix(i, subByte(getMatrix(i)));

}

void shiftRow(unsigned char matrix[16], const int rowNumber){
    unsigned char tmpRow[4];
    int i =0;
    for(i=0;i<4;i++)
        tmpRow[i] = getMatrix(i+ 4*rowNumber);

    for(i=0;i<4;i++)
        setMatrix(i+4*rowNumber, tmpRow[(i+rowNumber)%4]);
}

void shiftRows(unsigned char matrix[16]){
    int i =0;
    for(i=0; i<4; i++)
        shiftRow(matrix, i);
}

void mixColumn(unsigned char matrix[16], const int colomnNumber){
    int i=0;
    unsigned char a[4];
    for(i=0; i<4; i++)
        a[i] = getMatrix(i*4 + colomnNumber);

    setMatrix(colomnNumber, multBy2(a[0]) ^ multBy3(a[1]) ^ a[2] ^ a[3]);
    setMatrix(colomnNumber + 4, a[0] ^ multBy2(a[1]) ^ multBy3(a[2]) ^ a[3]);
    setMatrix(colomnNumber + 8, a[0] ^ a[1] ^ multBy2(a[2]) ^ multBy3(a[3]));
    setMatrix(colomnNumber + 12, multBy3(a[0]) ^ a[1] ^ a[2] ^ multBy2(a[3]));
}

void mixColumns(unsigned char matrix[16]){
    int i =0;
    for(i=0; i<4; i++)
        mixColumn(matrix, i);
}

void addRoundKey(unsigned char matrix[16], const unsigned char roundKey[16]){
    int i =0;
    for(i=0; i<16; i++)
        setMatrix(i, getRoundKey(i) ^ getMatrix(i));
}

void keyExpansion(unsigned char roundKey[16], const int roundNb){
    int i,j =0;
    // RotWord + subByte
    for(i=0; i<4; i++){
        setRoundKey(i*4, subByte(getRoundKey(((i+1)*4)%16+3)) ^ getRoundKey(i*4));
    }
    setRoundKey(0, getRCON(roundNb) ^ getRoundKey(0));
    for(i=1; i<4; i++){
        for(j=0; j<4; j++)
            setRoundKey(j*4+i, getRoundKey(j*4+i-1) ^ getRoundKey(j*4+i));
    }
}

void nextRound(unsigned char matrix[16], unsigned char roundKey[16], const int roundNb){
    subBytes(matrix);
    shiftRows(matrix);
    mixColumns(matrix);
    addRoundKey(matrix, roundKey);
    keyExpansion(roundKey, roundNb);
}

void aes(unsigned char plain[16], const unsigned char key[16]){
    //unsigned char roundKey[16];
    int i =0;
    copy(key, roundKey);
    copy(plain, matrix);
    transpose(roundKey);
    transpose(matrix);

    addRoundKey(matrix, roundKey);
    keyExpansion(roundKey,0);
    for(i=1; i<10; i++)
        nextRound(matrix, roundKey, i);
    subBytes(matrix);
    shiftRows(matrix);
    addRoundKey(matrix, roundKey);

    transpose(matrix);
    copy(matrix, plain);
}
