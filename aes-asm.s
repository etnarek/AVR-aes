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

