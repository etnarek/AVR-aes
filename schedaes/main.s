__SP_H__ = 0x3e
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
.section	.text
.global	readPlain
readPlain:
	push r16
	push r17
	push r28
	push r29
	ldi r16,0
	ldi r17,0
    .RPi:
        ldi r28,0
        ldi r29,0
        .RPj:
            call USART_receive
            movw r20,r24
            movw r22,r28
            movw r24,r16
            call setMatrix
            adiw r28,1
            cpi r28,4
            cpc r29,__zero_reg__
            brne .RPj
        subi r16,-1
        sbci r17,-1
        cpi r16,4
        cpc r17,__zero_reg__
        brne .RPi
	pop r29
	pop r28
	pop r17
	pop r16
	ret
.global	loop
loop:
	call readPlain
	call transposeMatrix
	call schedaes
	call transposeMatrix
	call printBackToSerial
	rjmp loop
.global	main
main:
	call initRandom
	call transposeKey
	call genRoundKey
	call transposeKey
	call USART_init
	ldi r24,lo8(42)
	ldi r25,0
	call USART_send
	call loop
