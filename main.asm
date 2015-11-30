;.include "m328pdef.inc"

.equ F_CPU, 16000000
.equ BAUDRATE, 9600
.equ BAUD_PRESCALLER, (((F_CPU / (BAUDRATE * 16))) - 1)

.org 0x00
    rjmp main

readPlain:
    ldi r30, lo8(plain)
    ldi r31, hi8(plain)
    ldi r22, 0
    readLoop:
        call USART_receive
        st Z+, r24
        inc r22
        cpi r22, 16
        brlt readLoop
    ret

printBackToSerial:
    ldi r22, 0
    writeLoop:
        mov r24, r22
        call getMatrix
        call USART_send
        inc r22
        cpi r22, 16
        brlt writeLoop
    ret


loop:
    call readPlain
    ldi r24, 0
    ldi r25, 0
    ldi r22, 0
    ldi r23, 0
    subi r24, lo8(-(key))
    sbci r25, hi8(-(key))
    subi r22, lo8(-(roundKey))
    sbci r23, hi8(-(roundKey))
    call copy
    ldi r24, 0
    ldi r25, 0
    ldi r22, 0
    ldi r23, 0
    subi r24, lo8(-(plain))
    sbci r25, hi8(-(plain))
    subi r22, lo8(-(matrix))
    sbci r23, hi8(-(matrix))
    call copy

    ldi r24, 0
    ldi r25, 0
    subi r24, lo8(-(matrix))
    sbci r25, hi8(-(matrix))
    call transpose
    ldi r24, 0
    ldi r25, 0
    subi r24, lo8(-(roundKey))
    sbci r25, hi8(-(roundKey))
    call transpose

    call aes

    ldi r24, 0
    ldi r25, 0
    subi r24, lo8(-(matrix))
    sbci r25, hi8(-(matrix))
    call transpose

    ldi r24, 0
    ldi r25, 0
    ldi r22, 0
    ldi r23, 0
    subi r24, lo8(-(matrix))
    sbci r25, hi8(-(matrix))
    subi r22, lo8(-(plain))
    sbci r23, hi8(-(plain))
    call copy

    call printBackToSerial
    rjmp loop
    ret

main:
    call USART_init
    ldi r24, 42
    call USART_send
    call loop
    ldi r24, 1
    reti

.section data
.type plain @object
plain: .byte 0x00, 0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77, 0x88, 0x99, 0xaa, 0xbb, 0xcc, 0xdd, 0xee, 0xff
.type key @object
key: .byte 0X00, 0X01, 0X02, 0X03, 0X04, 0X05, 0X06, 0X07, 0X08, 0X09, 0X0a, 0X0b, 0X0c, 0X0d, 0X0e, 0X0f
