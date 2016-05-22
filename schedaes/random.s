__SP_H__ = 0x3e
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
.section	.text

.global	initRandom
initRandom:
	ldi r24,lo8(-123)
	sts 122,r24
	ldi r24,lo8(5)
	sts 124,r24
	lds r24,122
	ori r24,lo8(64)
	sts 122,r24
    .WAIT:
        lds r24,122
        sbrs r24,4
        rjmp .WAIT
	lds r24,120
	lds r25,120+1
	sts seed,r24
	ret

.global	random
random:
	mov r22,r24
	lds r19,a
	lds r18,seed
	lds r24,c
	ldi r25,0
	mul r19,r18
	add r24,r0
	adc r25,r1
	clr __zero_reg__
	sts seed,r24
	call __udivmodqi4
	mov r24,r25
	ret


.section .data
.global	c
.type	c, @object
.size	c, 1
c: .byte	77

.global	a
.type	a, @object
.size	a, 1
a: .byte	45

.global	seed
.type	seed, @object
.size	seed, 1
seed:	.byte	42

.global __do_copy_data
