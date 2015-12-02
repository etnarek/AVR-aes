
.org 0x00
    rjmp main

.section .text
.global readPlain
readPlain:
    ldi r20, 0
    readPlainLoop:
        call USART_receive
        mov r22, r24
        mov r24, r20
        call setMatrix
        inc r20
        cpi r20, 16
        brlt readPlainLoop
    ret

.global print
print:
    ldi r20, 0
    printLoop:
        mov r24, r20
        call getMatrix
        call USART_send
        inc r20
        cpi r20, 16
        brlt printLoop
    ldi r24, 10
    call USART_send
    ret

.global loop
loop:
    call readPlain

    ldi r24, lo8(key)
    ldi r25, hi8(key)
    ldi r22, lo8(roundKey)
    ldi r23, hi8(roundKey)
    call copy

    ldi r24, lo8(roundKey)
    ldi r25, hi8(roundKey)
    call transpose

    ldi r24, lo8(matrix)
    ldi r25, hi8(matrix)
    call transpose

    call aes

    ldi r24, lo8(matrix)
    ldi r25, hi8(matrix)
    call transpose

    call print
    rjmp loop
    ret

.global main
main:
    call USART_init
    ldi r24, 42
    call USART_send
    call loop
    mov r24, 1
    ret

.section .data

;.global key
.type key, @object
key: .byte 0X00, 0X01, 0X02, 0X03, 0X04, 0X05, 0X06, 0X07, 0X08, 0X09, 0X0a, 0X0b, 0X0c, 0X0d, 0X0e, 0X0f
