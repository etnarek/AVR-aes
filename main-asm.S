
.org 0x00
    rjmp main

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
