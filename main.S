.include "m328pdef.inc"
.include "serial.inc"
.include "matrix.inc"
.include "aes.inc"

.section .data
.type keyyek, @object
.size keyyek, 16
;.global key
keyyek: .byte 0X00, 0X01, 0X02, 0X03, 0X04, 0X05, 0X06, 0X07, 0X08, 0X09, 0X0a, 0X0b, 0X0c, 0X0d, 0X0e, 0X0f

.section .text
.global __do_copy_data
readPlain:
    ldi r20, 0
    readPlainLoop:
        push r20
        call USART_receive
        pop r20
        mov r22, r24
        mov r24, r20
        call setMatrix
        inc r20
        cpi r20, 16
        brlt readPlainLoop
    ret

loop:
    call readPlain

    ldi r24, lo8(keyyek)
    ldi r25, hi8(keyyek)
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
.end
