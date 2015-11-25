#ifndef AES_H
#define AES_H

extern void subBytes();
extern void shiftRow(const int rowNumber);
extern void shiftRows();
extern void mixColumn(const char colomnNumber);
extern void mixColumns();
extern void addRoundKey();
extern void keyExpansion(const int roundNb);
extern void nextRound(const int roundNb);
void aes();

#endif /*AES_H*/
