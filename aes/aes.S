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

.global keyExpansion
keyExpansion:
    mov r20, r24 ; roundNb
    ldi r19, 0
    keyExpansionSubByteLoop:
        mov r24, r19
        inc r24
        lsl r24
        lsl r24
        andi r24, 15
        subi r24, 253 ; add 3
        call getRoundKey
        call subByte
        mov r22, r24

        mov r24, r19
        lsl r24
        lsl r24
        push r24
        call getRoundKey
        eor r22, r24
        pop r24
        call setRoundKey
        inc r19
        cpi r19, 4
        brlt keyExpansionSubByteLoop
    ldi r24, 0
    call getRoundKey
    mov r22, r24
    mov r24, r20
    call getRCON
    eor r22, r24
    ldi r24, 0
    call setRoundKey
    ldi r18, 1
    keyExpansionILoop:
        ldi r19, 0
        keyExpansionJLoop:
            mov r24, r19
            lsl r24
            lsl r24
            add r24, r18
            push r24
            dec r24
            call getRoundKey
            mov r22, r24
            pop r24
            push r24
            call getRoundKey
            eor r22, r24
            pop r24
            call setRoundKey
            inc r19
            cpi r19, 4
            brlt keyExpansionJLoop
        inc r18
        cpi r18, 4
        brlt keyExpansionILoop
    ret

.global nextRound
nextRound:
    push r24
    call subBytes
    call shiftRows
    call mixColumns
    call addRoundKey
    pop r24
    call keyExpansion
    ret

.global aes
aes:
    call addRoundKey
    ldi r24, 0
    call keyExpansion
    ldi r24, 1
    aesLoop:
        push r24
        call nextRound
        pop r24
        inc r24
        cpi r24, 10
        brlt aesLoop
    call subBytes
    call shiftRows
    call addRoundKey
    ret
