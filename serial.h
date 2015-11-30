#ifndef SERIAL_H
#define SERIAL_H

#define F_CPU 16000000UL
#include <avr/io.h>

#define BAUDRATE 9600
#define BAUD_PRESCALLER (((F_CPU / (BAUDRATE * 16UL))) - 1)

void USART_init(void);
char USART_receive();
int USART_send(const char data);

#endif /*SERIAL_H*/
