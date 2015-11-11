#ifndef AES_H
#define AES_H

extern unsigned char subByte(const unsigned char byte);
extern unsigned char getRCON(const unsigned char byte);
extern unsigned char multBy2(const unsigned char byte);
extern unsigned char multBy3(const unsigned char byte);
extern unsigned char getMatrix(const unsigned char pos);
extern unsigned char setMatrix(const unsigned char pos, const unsigned char val);
extern unsigned char matrix[16];
extern unsigned char roundKey[16];
void subBytes(unsigned char matrix[16]);
void shiftRow(unsigned char matrix[16], const int rowNumber);
void mixColumn(unsigned char matrix[16], const int colomnNumber);
void mixColumns(unsigned char matrix[16]);
void addRoundKey(unsigned char matrix[16], const unsigned char roundKey[16]);
void keyExpansion(unsigned char roundKey[16], const int roundNb);
void nextRound(unsigned char matrix[16], unsigned char roundKey[16], const int roundNb);
void aes(unsigned char matrix[16], const unsigned char key[16]);

#endif /*AES_H*/
