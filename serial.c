#include "serial.h"

void USART_init(void){
    UBRR0H = (uint8_t)(BAUD_PRESCALLER>>8);
    UBRR0L = (uint8_t)(BAUD_PRESCALLER);
    UCSR0B = (1<<RXEN0)|(1<<TXEN0);
    UCSR0C = (3<<UCSZ00);
}

char USART_receive(void){
    while(!(UCSR0A & (1<<RXC0)));
    return UDR0;
}

void USART_send(const char data){
    if (data == '\n')
        USART_send('\r');
    while(!(UCSR0A & (1<<UDRE0)));
    UDR0 = data;

}
