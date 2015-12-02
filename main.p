;.include "m328pdef.inc"

.equ F_CPU, 16000000
.equ BAUDRATE, 9600
.equ BAUD_PRESCALLER, (((F_CPU / (BAUDRATE * 16))) - 1)

.org 0x00
    rjmp main

readPlain:
    ldi r20, 0
    readLoop:
        call USART_receive
        mov r22, r24
        mov r24, r20
        call setMatrix
        inc r20
        cpi r20, 16
        brlt readLoop
    ret

printBackToSerial:
    ldi r22, 0
    writeLoop:
        mov r24, r22
        push r22
        call getMatrix
        call USART_send
        pop r22
        inc r22
        cpi r22, 16
        brlt writeLoop
    mov r24, 10
    call USART_send
    ret


loop:
    ;call readPlain
    call printBackToSerial
    ;ldi r24, 0
    ;ldi r25, 0
    ;ldi r22, 0
    ;ldi r23, 0
    ;subi r24, lo8(-(key))
    ;sbci r25, hi8(-(key))
    ;subi r22, lo8(-(roundKey))
    ;sbci r23, hi8(-(roundKey))
    ;call copy

    ;ldi r24, 0
    ;ldi r25, 0
    ;subi r24, lo8(-(matrix))
    ;sbci r25, hi8(-(matrix))
    ;call transpose
    ;ldi r24, 0
    ;ldi r25, 0
    ;subi r24, lo8(-(roundKey))
    ;sbci r25, hi8(-(roundKey))
    ;call transpose

    ;call aes

    ;ldi r24, 0
    ;ldi r25, 0
    ;subi r24, lo8(-(matrix))
    ;sbci r25, hi8(-(matrix))
    ;call transpose

    ;call printBackToSerial
    rjmp loop
    ret

.global main
main:
    call USART_init
    ldi r24, 42
    call USART_send
    call loop
    ldi r24, 1
    reti

.section data
.type key @object
key: .byte 0X00, 0X01, 0X02, 0X03, 0X04, 0X05, 0X06, 0X07, 0X08, 0X09, 0X0a, 0X0b, 0X0c, 0X0d, 0X0e, 0X0f
