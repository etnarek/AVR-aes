;aes functions

.section .text
.global subBytes
subBytes:
    ldi r20, 0
    subBytesLoop:
        mov r24, r20
        call getMatrix
        call subByte
        mov r22, r24
        mov r24, r20
        call setMatrix
        inc r20
        cpi r20, 16
        brlt subBytesLoop
    ret

.global shiftRow
;r24: rowNumber
shiftRow:
    mov r20, r24
    ldi r21, 0
    mov r19, r24
    lsl r19
    lsl r19 ; r19 = r24*4
    shiftRowPushLoop:
        mov r24, r21
        add r24, r19
        call getMatrix
        push r24
        inc r21
        cpi r21, 4
        brlt shiftRowPushLoop
    ldi r21, 4
    ;subi r19, 0xfc ;add 4
    shiftRowPopLoop:
        dec r21
        pop r22
        mov r24, r19
        mov r18, r21
        sub r18, r20
        andi r18, 3
        add r24, r18
        call setMatrix
        cpi r21, 0
        brne shiftRowPopLoop
    ret

.global shiftRows
shiftRows:
    ldi r24, 0
    shiftRowsLoop:
        push r24
        call shiftRow
        pop r24
        inc r24
        cpi r24, 4
        brlt shiftRowsLoop
    ret
