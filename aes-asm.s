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

.global mixColumn
;r24: columnNumber
mixColumn:
    mov r23, r24
    ldi r24, 0
    add r24, r23
    call getMatrix
    mov r18, r24

    ldi r24, 4
    add r24, r23
    call getMatrix
    mov r19, r24

    ldi r24, 8
    add r24, r23
    call getMatrix
    mov r20, r24

    ldi r24, 12
    add r24, r23
    call getMatrix
    mov r21, r24

    ldi r22, 0
    mov r24, r18
    call multBy2
    eor r22, r24
    mov r24, r19
    call multBy3
    eor r22, r24
    eor r22, r20
    eor r22, r21
    ldi r24, 0
    add r24, r23
    call setMatrix

    ldi r22, 0
    mov r24, r19
    call multBy2
    eor r22, r24
    mov r24, r20
    call multBy3
    eor r22, r24
    eor r22, r21
    eor r22, r18
    ldi r24, 4
    add r24, r23
    call setMatrix

    ldi r22, 0
    mov r24, r20
    call multBy2
    eor r22, r24
    mov r24, r21
    call multBy3
    eor r22, r24
    eor r22, r18
    eor r22, r19
    ldi r24, 8
    add r24, r23
    call setMatrix

    ldi r22, 0
    mov r24, r21
    call multBy2
    eor r22, r24
    mov r24, r18
    call multBy3
    eor r22, r24
    eor r22, r19
    eor r22, r20
    ldi r24, 12
    add r24, r23
    call setMatrix
    ret

.global mixColumns
mixColumns:
    ldi r24, 0
    mixColumnsLoop:
        push r24
        call mixColumn
        pop r24
        inc r24
        cpi r24, 4
        brlt mixColumnsLoop
    ret

.global addRoundKey
addRoundKey:
    ldi r24, 0
    addRoundKeyLoop:
        mov r23, r24
        call getMatrix
        mov r22, r24
        mov r24, r23
        call getRoundKey
        eor r22, r24
        mov r24, r23
        call setMatrix
        inc r24
        cpi r24, 16
        brlt addRoundKeyLoop
    ret
