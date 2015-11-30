#include "aes.h"
#include "matrix.h"
#include "serial.h"

unsigned char plain[16] = {0x00,0x11,0x22,0x33,0x44,0x55,0x66,0x77,0x88,0x99,0xaa,0xbb,0xcc,0xdd,0xee,0xff};
const unsigned char key[16] = {0X00,0X01,0X02,0X03,0X04,0X05,0X06,0X07,0X08,0X09,0X0a,0X0b,0X0c,0X0d,0X0e,0X0f};

void printBackToSerial(const unsigned char matrix[16]){
    for(int i=0; i<16; i++){
        USART_send(matrix[i]);
    }
    USART_send('\n');
}

void readPlain(unsigned char plain[16]){
    for(int i=0; i<16; i++)
        plain[i] = (unsigned char)USART_receive();
}

void loop() {
    while(1){
        readPlain(plain);
        copy(key, roundKey);
        copy(plain, matrix);
        transpose(roundKey);
        transpose(matrix);
        aes();
        transpose(matrix);
        copy(matrix, plain);
        printBackToSerial(plain);
    }
}

int main(void) {
    USART_init();

    USART_send('*');
    loop();
    return 1;
}
