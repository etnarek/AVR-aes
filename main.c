#include "aes.h"
#include "matrix.h"
#include "serial.h"
#include <stdio.h>
#include <util/delay.h>

unsigned char plain[16] = {0x00,0x11,0x22,0x33,0x44,0x55,0x66,0x77,0x88,0x99,0xaa,0xbb,0xcc,0xdd,0xee,0xff};
unsigned char key[16] = {0X00,0X01,0X02,0X03,0X04,0X05,0X06,0X07,0X08,0X09,0X0a,0X0b,0X0c,0X0d,0X0e,0X0f};

FILE uart_output = FDEV_SETUP_STREAM(USART_send, NULL, _FDEV_SETUP_WRITE);
FILE uart_input = FDEV_SETUP_STREAM(NULL, USART_receive, _FDEV_SETUP_READ);

void printBackToSerial(const unsigned char matrix[16]){
    for(int i=0; i<16; i++){
        //if(matrix[i] < 16)
            //Serial.print("0");
            //USART_send('0');
        //USART_send('A');
        //USART_send('B');
        printf("%02X", matrix[i]);
    }
    //USART_send('\n');
    printf("\n");
}


void setup() {
    //Serial.begin(9600);
}

void loop() {
    //if(Serial.readBytes(matrix, 16)){
        transpose(key);
        transpose(plain);
        aes(plain, key);
        transpose(plain);
        transpose(key);
        printBackToSerial(plain);
        _delay_ms(10000);

        printBackToSerial(plain);
        _delay_ms(10000);
        transpose(plain);
    //}
    // put your main code here, to run repeatedly:

}
void main(void) {
    setup();
    USART_init();
    stdout = &uart_output;
    stdin  = &uart_input;
    while(1){
        loop();
    }
}
