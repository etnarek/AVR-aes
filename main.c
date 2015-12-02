#include "aes.h"
#include "matrix.h"
#include "serial.h"

const unsigned char key[16] = {0X00,0X01,0X02,0X03,0X04,0X05,0X06,0X07,0X08,0X09,0X0a,0X0b,0X0c,0X0d,0X0e,0X0f};

extern void print();
//void printBackToSerial(){
//    for(int i=0; i<16; i++){
//        USART_send(getMatrix(i));
//    }
//    USART_send('\n');
//}
//
extern void readPlain();

void loop() {
    while(1){
        readPlain();
        copy(key, roundKey);
        transpose(roundKey);
        transpose(matrix);
        aes();
        transpose(matrix);
        print();
    }
}

int main(void) {
    USART_init();
    USART_send('*');
    loop();
    return 1;
}
