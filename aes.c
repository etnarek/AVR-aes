#include "aes.h"
#include "matrix.h"

//void subBytes(){
//    int i =0;
//    for(i=0; i<16; i++)
//        setMatrix(i, subByte(getMatrix(i)));
//
//}

//void shiftRow(const char rowNumber){
//    unsigned char tmpRow[4];
//    int i =0;
//    for(i=0;i<4;i++)
//        tmpRow[i] = getMatrix(i+ 4*rowNumber);
//
//    for(i=0;i<4;i++)
//        setMatrix(i+4*rowNumber, tmpRow[(i+rowNumber)%4]);
//}

//void shiftRows(){
//    int i =0;
//    for(i=0; i<4; i++)
//        shiftRow(i);
//}

//void mixColumn(const int colomnNumber){
//    int i=0;
//    unsigned char a[4];
//    for(i=0; i<4; i++)
//        a[i] = getMatrix(i*4 + colomnNumber);
//
//    setMatrix(colomnNumber, multBy2(a[0]) ^ multBy3(a[1]) ^ a[2] ^ a[3]);
//    setMatrix(colomnNumber + 4, a[0] ^ multBy2(a[1]) ^ multBy3(a[2]) ^ a[3]);
//    setMatrix(colomnNumber + 8, a[0] ^ a[1] ^ multBy2(a[2]) ^ multBy3(a[3]));
//    setMatrix(colomnNumber + 12, multBy3(a[0]) ^ a[1] ^ a[2] ^ multBy2(a[3]));
//}

//void mixColumns(){
//    int i =0;
//    for(i=0; i<4; i++)
//        mixColumn(i);
//}

//void addRoundKey(){
//    int i =0;
//    for(i=0; i<16; i++)
//        setMatrix(i, getRoundKey(i) ^ getMatrix(i));
//}

void keyExpansion(const int roundNb){
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

void nextRound(const int roundNb){
    subBytes();
    shiftRows();
    mixColumns();
    addRoundKey();
    keyExpansion(roundNb);
}

void aes(unsigned char plain[16], const unsigned char key[16]){
    int i =0;
    copy(key, roundKey);
    copy(plain, matrix);
    transpose(roundKey);
    transpose(matrix);

    addRoundKey();
    keyExpansion(0);
    for(i=1; i<10; i++)
        nextRound(i);
    subBytes();
    shiftRows();
    addRoundKey();

    transpose(matrix);
    copy(matrix, plain);
}
