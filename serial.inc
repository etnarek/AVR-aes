.section .text

.equ F_CPU, 16000000
.equ BAUDRATE, 9600
.equ BAUD_PRESCALLER, (((F_CPU / (BAUDRATE * 16))) - 1)

.global USART_init
USART_init:
; inisialisasi baudrate
    ldi r24, lo8(BAUD_PRESCALLER)
    sts UBRR0L, r24
    ldi r24, hi8(BAUD_PRESCALLER)
    sts UBRR0H, r24

; set interrupt and receive
    ldi r24, (1<<RXEN0)|(1<<TXEN0)
    sts UCSR0B, r24

; Frame-Format: 8 Bit
    ldi r24, (3<<UCSZ00)
    sts UCSR0C, r24
    ret

.global USART_receive
USART_receive:
    receiveWaitLoop:
        lds r24, UCSR0A
        sbrs r24, RXC0
        rjmp receiveWaitLoop
    lds r24, UDR0
    call USART_send
    ret

.global USART_send
USART_send:
    sendWaitLoop:
        lds r21, UCSR0A
        sbrs r21, UDRE0
        rjmp sendWaitLoop
    sts UDR0, r24
    ret



