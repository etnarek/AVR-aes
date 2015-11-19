#ifndef MATRIX_H
#define MATRIX_H


extern unsigned char subByte(const unsigned char byte);
extern unsigned char getRCON(const unsigned char byte);
extern unsigned char multBy2(const unsigned char byte);
extern unsigned char multBy3(const unsigned char byte);
extern unsigned char getMatrix(const unsigned char pos);
extern unsigned char setMatrix(const unsigned char pos, const unsigned char val);
extern void transpose(unsigned char matrix[16]);
extern void copy(const unsigned char source[16], unsigned char dest[16]);
extern unsigned char matrix[16];
extern unsigned char roundKey[16];

#endif /*MATRIX_H*/
