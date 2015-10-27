#ifndef SERIAL_H
#define SERIAL_H

#define F_CPU 16000000UL
#include <avr/io.h>
#include <util/delay.h>
#include <stdio.h>

#define BAUDRATE 9600
#define BAUD_PRESCALLER (((F_CPU / (BAUDRATE * 16UL))) - 1)

void USART_init(void);
unsigned char USART_receive(FILE *stream);
void USART_send(const unsigned char data, FILE *stream);

#endif /*SERIAL_H*/
