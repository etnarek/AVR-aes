
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

