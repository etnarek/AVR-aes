#ifndef AES_H
#define AES_H

extern void subBytes();
void shiftRow(const int rowNumber);
void mixColumn(const int colomnNumber);
void mixColumns();
void addRoundKey();
void keyExpansion(const int roundNb);
void nextRound(const int roundNb);
void aes(unsigned char plain[16], const unsigned char key[16]);

#endif /*AES_H*/
