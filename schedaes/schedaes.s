__SP_H__ = 0x3e
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1

.section	.text

.global	genRoundKey
genRoundKey:
	push r14
	push r15
	push r16
	push r17
	push r28
	push r29
	ldi r29,0
    .LOOPgen1I:
        ldi r28,0
        .LOOPgen1J:
            mov r22,r28
            mov r24,r29
            call getKey
            mov r18,r24
            ldi r20,0
            mov r22,r28
            mov r24,r29
            call setRoundKey
            subi r28,lo8(-(1))
            cpi r28,lo8(4)
            brne .LOOPgen1J
        subi r29,lo8(-(1))
        cpi r29,lo8(4)
        brne .LOOPgen1I
	ldi r28,lo8(1)
    .LOOPgen2K:
        ldi r16,0
        ldi r17,0
        clr r15
        dec r15
        add r15,r28
        .LOOPgen2I1:
            subi r16,-1
            sbci r17,-1
            mov r20,r15
            ldi r22,lo8(3)
            mov r24,r16
            andi r24,lo8(3)
            call getRoundKey
            call getSBOX
            mov r29,r24
            clr r14
            dec r14
            add r14,r16
            mov r20,r15
            ldi r22,0
            mov r24,r14
            call getRoundKey
            mov r18,r29
            eor r18,r24
            mov r20,r28
            ldi r22,0
            mov r24,r14
            call setRoundKey
            cpi r16,4
            cpc r17,__zero_reg__
            brne .LOOPgen2I1
        mov r20,r28
        ldi r22,0
        ldi r24,0
        call getRoundKey
        mov r29,r24
        mov r24,r15
        call getRCON
        mov r18,r29
        eor r18,r24
        mov r20,r28
        ldi r22,0
        ldi r24,0
        call setRoundKey
        ldi r17,0
        .LOOPgen2I2:
            ldi r29,0
            ldi r16,lo8(1)
            add r16,r17
            .LOOPgen2J:
                mov r20,r28
                mov r22,r17
                mov r24,r29
                call getRoundKey
                mov r14,r24
                mov r20,r15
                mov r22,r16
                mov r24,r29
                call getRoundKey
                mov r18,r14
                eor r18,r24
                mov r20,r28
                mov r22,r16
                mov r24,r29
                call setRoundKey
                subi r29,lo8(-(1))
                cpi r29,lo8(4)
                brne .LOOPgen2J
            mov r17,r16
            cpi r16,lo8(3)
            brne .LOOPgen2I2
        subi r28,lo8(-(1))
        cpi r28,lo8(11)
        breq .+2
        rjmp .LOOPgen2K
	pop r29
	pop r28
	pop r17
	pop r16
	pop r15
	pop r14
	ret

.global	addRoundKey
addRoundKey:
	push r15
	push r16
	push r17
	push r28
	push r29
	mov r17,r24
	mov r15,r22
	mov r16,r20
	mov r28,r22
	ldi r29,0
	mov r22,r20
	call getSR_state
	cpse r24,__zero_reg__
        rjmp .LaddRoundSRkDONE1
        mov r24,r17
        ldi r25,0
        rjmp .LaddRoundSRkDONE1end
    .LaddRoundSRkDONE1:
        ldi r24,0
        ldi r25,0
    .LaddRoundSRkDONE1end:
	movw r18,r28
	sub r18,r24
	sbc r19,r25
	movw r24,r18
	ldi r22,lo8(4)
	ldi r23,0
	call __divmodhi4
	mov r28,r24
	andi r28,lo8(3)
	mov r22,r16
	mov r24,r17
	call getSR_state
	cpse r24,__zero_reg__
        rjmp .LaddRoundSRkDONE2
        ldi r29,0
        ldi r22,lo8(-1)
        add r22,r16
        mov r24,r17
        call getSR_state
        cpse r24,__zero_reg__
            rjmp .LaddRoundSRk_1DONE
            mov r24,r17
            ldi r25,0
            rjmp .LaddRoundSRk_1DONEend
        .LaddRoundSRk_1DONE:
            ldi r24,0
            ldi r25,0
        .LaddRoundSRk_1DONEend:
        movw r18,r28
        sub r18,r24
        sbc r19,r25
        movw r24,r18
        ldi r22,lo8(4)
        ldi r23,0
        call __divmodhi4
        mov r28,r24
    .LaddRoundSRkDONE2:
	mov r22,r15
	mov r24,r17
	call getMatrix
	mov r29,r24
	mov r22,r28
	andi r22,lo8(3)
	mov r20,r16
	mov r24,r17
	call getRoundKey
	mov r20,r29
	eor r20,r24
	mov r22,r15
	mov r24,r17
	pop r29
	pop r28
	pop r17
	pop r16
	pop r15
	jmp setMatrix

.global	subByte
subByte:
	push r28
	push r29
	mov r28,r24
	mov r29,r22
	call getMatrix
	call getSBOX
	mov r20,r24
	mov r22,r29
	mov r24,r28
	pop r29
	pop r28
	jmp setMatrix

.global	shiftRow
shiftRow:
	push r10
	push r11
	push r12
	push r13
	push r15
	push r16
	push r17
	push r28
	push r29
	rcall .
	rcall .
	in r28,__SP_L__
	in r29,__SP_H__
	mov r15,r24
	movw r24,r28
	adiw r24,1
	movw r10,r24
	ldi r17,0
	movw r12,r24
    .LOOPsetTMP:
        mov r22,r17
        mov r24,r15
        call getMatrix
        movw r30,r10
        st Z+,r24
        movw r10,r30
        subi r17,lo8(-(1))
        cpi r17,lo8(4)
        brne .LOOPsetTMP
	ldi r16,0
	ldi r17,0
	mov r10,r15
	mov r11,__zero_reg__
    .LOOPgetTMP:
        movw r30,r16
        add r30,r10
        adc r31,r11
        andi r30,3
        clr r31
        add r30,r12
        adc r31,r13
        ld r20,Z
        mov r22,r16
        mov r24,r15
        call setMatrix
        subi r16,-1
        sbci r17,-1
        cpi r16,4
        cpc r17,__zero_reg__
        brne .LOOPgetTMP
	pop __tmp_reg__
	pop __tmp_reg__
	pop __tmp_reg__
	pop __tmp_reg__
	pop r29
	pop r28
	pop r17
	pop r16
	pop r15
	pop r13
	pop r12
	pop r11
	pop r10
	ret

.global	mixColumn
mixColumn:
	push r6
	push r7
	push r8
	push r9
	push r10
	push r11
	push r12
	push r13
	push r14
	push r15
	push r16
	push r17
	push r28
	push r29
	rcall .
	rcall .
	in r28,__SP_L__
	in r29,__SP_H__
	mov r12,r24
	mov r13,r22
	movw r24,r28
	adiw r24,1
	movw r8,r24
	mov r10,__zero_reg__
	mov r11,__zero_reg__
	mov r14,r12
	mov r15,__zero_reg__
	clr r6
	dec r6
	add r6,r22
    .LOOPmcsetTMP:
        mov r7,r10
        mov r22,r13
        mov r24,r10
        call getSR_state
        cpse r24,__zero_reg__
            rjmp .LmcSRkDONE1
            movw r16,r10
            rjmp .LmcSRkDONE1end
        .LmcSRkDONE1:
            ldi r16,0
            ldi r17,0
        .LmcSRkDONE1end:
        add r16,r14
        adc r17,r15
        andi r16,3
        clr r17
        mov r22,r13
        mov r24,r7
        call getSR_state
        tst r24
            breq .LmcSRkNOTDONE2
            mov r22,r16
            rjmp .LmcSRkDONE2
        .LmcSRkNOTDONE2:
            mov r22,r6
            mov r24,r7
            call getSR_state
            cpse r24,__zero_reg__
                rjmp .LmcSRk_1DONE2
                movw r22,r10
                rjmp .LmcSRk_1DONE2end
            .LmcSRk_1DONE2:
                ldi r22,0
                ldi r23,0
            .LmcSRk_1DONE2end:
            add r16,r22
            adc r17,r23
            mov r22,r16
            andi r22,lo8(3)
        .LmcSRkDONE2:
        mov r24,r7
        call getMatrix
        movw r30,r8
        st Z+,r24
        movw r8,r30
        ldi r31,-1
        sub r10,r31
        sbc r11,r31
        ldi r24,4
        cp r10,r24
        cpc r11,__zero_reg__
        brne .LOOPmcsetTMP
	ldd r7,Y+1
	mov r24,r7
	call mul2
	mov r17,r24
	ldd r8,Y+2
	mov r24,r8
	call mul3
	ldd r11,Y+3
	ldd r9,Y+4
	mov r20,r11
	eor r20,r9
	eor r17,r20
	mov r20,r17
	eor r20,r24
	mov r22,r12
	ldi r24,0
	call setMatrix
	mov r24,r8
	call mul2
	mov r12,r24
	mov r17,r7
	eor r17,r9
	mov r24,r11
	call mul3
	eor r12,r17
	eor r12,r24
	mov r22,r13
	ldi r24,lo8(1)
	call getSR_state
	ldi r16,lo8(1)
	ldi r17,0
	tst r24
        breq .LmcSRkDONE3
        ldi r16,0
        ldi r17,0
    .LmcSRkDONE3:
	add r16,r14
	adc r17,r15
	clr r10
	dec r10
	add r10,r13
	mov r22,r10
	ldi r24,lo8(1)
	call getSR_state
	ldi r22,lo8(1)
	ldi r23,0
	tst r24
        breq .LmcSRk_1DONE3
        ldi r22,0
        ldi r23,0
    .LmcSRk_1DONE3:
	add r22,r16
	adc r23,r17
	andi r22,3
	clr r23
	mov r20,r12
	ldi r24,lo8(1)
	call setMatrix
	mov r24,r11
	call mul2
	mov r17,r7
	eor r17,r8
	eor r17,r24
	mov r24,r9
	call mul3
	mov r12,r17
	eor r12,r24
	mov r22,r13
	ldi r24,lo8(2)
	call getSR_state
	cpse r24,__zero_reg__
        rjmp .LmcSRkDONE4
        ldi r16,lo8(2)
        ldi r17,0
        rjmp .LmcSRkDONE4end
    .LmcSRkDONE4:
        ldi r16,0
        ldi r17,0
    .LmcSRkDONE4end:
	add r16,r14
	adc r17,r15
	mov r22,r10
	ldi r24,lo8(2)
	call getSR_state
	cpse r24,__zero_reg__
        rjmp .LmcSRk_1DONE4
        ldi r22,lo8(2)
        ldi r23,0
        rjmp .LmcSRk_1DONE4end
    .LmcSRk_1DONE4:
        ldi r22,0
        ldi r23,0
    .LmcSRk_1DONE4end:
	add r22,r16
	adc r23,r17
	andi r22,3
	clr r23
	mov r20,r12
	ldi r24,lo8(2)
	call setMatrix
	mov r24,r7
	call mul3
	mov r17,r8
	eor r17,r11
	eor r17,r24
	mov r24,r9
	call mul2
	eor r17,r24
	mov r22,r13
	ldi r24,lo8(3)
	call getSR_state
	cpse r24,__zero_reg__
        rjmp .LmcSRkDONE5
        ldi r22,lo8(3)
        ldi r23,0
        rjmp .LmcSRkDONE5end
    .LmcSRkDONE5:
        ldi r22,0
        ldi r23,0
    .LmcSRkDONE5end:
	add r14,r22
	adc r15,r23
	mov r22,r10
	ldi r24,lo8(3)
	call getSR_state
	cpse r24,__zero_reg__
        rjmp .LmcSRk_1DONE5
        ldi r22,lo8(3)
        ldi r23,0
        rjmp .LmcSRk_1DONE5end
    .LmcSRk_1DONE5:
        ldi r22,0
        ldi r23,0
    .LmcSRk_1DONE5end:
	add r14,r22
	adc r15,r23
	movw r22,r14
	andi r22,3
	clr r23
	mov r20,r17
	ldi r24,lo8(3)
	pop __tmp_reg__
	pop __tmp_reg__
	pop __tmp_reg__
	pop __tmp_reg__
	pop r29
	pop r28
	pop r17
	pop r16
	pop r15
	pop r14
	pop r13
	pop r12
	pop r11
	pop r10
	pop r9
	pop r8
	pop r7
	pop r6
	jmp setMatrix

.global	perform
perform:
	mov r25,r24
	mov r24,r22
	mov r19,r20
	mov r20,r18
	cpi r25,lo8(1)
        breq .LperfSB
        brlo .LperfARK
        cpi r25,lo8(2)
        breq .LperfSR
        cpi r25,lo8(3)
        breq .LperfMC
	ret
    .LperfARK:
        mov r22,r19
        jmp addRoundKey
    .LperfSB:
        mov r22,r19
        jmp subByte
    .LperfSR:
        mov r22,r18
        jmp shiftRow
    .LperfMC:
        mov r22,r18
        mov r24,r19
        jmp mixColumn

.global	removeFromTheta
removeFromTheta:
    .LOOPremTheta:
        mov r18,r24
        ldi r19,0
        lds r25,theta_size
        mov r20,r25
        ldi r21,0
        subi r20,1
        sbc r21,__zero_reg__
        cp r18,r20
        cpc r19,r21
        brge .LOOPremThetaEnd
        movw r26,r18
        lsl r26
        rol r27
        lsl r26
        rol r27
        subi r26,lo8(-(theta))
        sbci r27,hi8(-(theta))
        lsl r18
        rol r19
        lsl r18
        rol r19
        movw r30,r18
        subi r30,lo8(-(theta+4))
        sbci r31,hi8(-(theta+4))
        ld r20,Z
        ldd r21,Z+1
        ldd r22,Z+2
        ldd r23,Z+3
        st X+,r20
        st X+,r21
        st X+,r22
        st X,r23
        sbiw r26,3
        subi r24,lo8(-(1))
        rjmp .LOOPremTheta
    .LOOPremThetaEnd:
	subi r25,lo8(-(-1))
	sts theta_size,r25
	ret

.global	addToTheta
addToTheta:
	push r14
	push r15
	push r16
	push r17
	push r28
	push r29
	mov r15,r24
	mov r28,r22
	mov r14,r20
	mov r29,r18
	ldi r18,lo8(1)
	cp r24,r18
	brne .+2
        rjmp .LaddSB
        cp r24,r18
        brlo .LaddARK
        ldi r19,lo8(2)
        cp r24,r19
        brne .+2
        rjmp .LaddSR
        ldi r24,lo8(3)
        cpse r15,r24
        rjmp .Ldefault
        .LaddMC:
        mov r22,r29
        mov r24,r20
        call getMC_state
        rjmp .LendCheckAdd
    .LaddARK:
        mov r16,r20
        ldi r17,0
        mov r22,r29
        mov r24,r28
        call getSR_state
        cpse r24,__zero_reg__
            rjmp .LaddTsrkDONE1
            mov r24,r28
            ldi r25,0
            rjmp .LaddTsrkDONE1end
        .LaddTsrkDONE1:
            ldi r24,0
            ldi r25,0
        .LaddTsrkDONE1end:
        movw r18,r16
        sub r18,r24
        sbc r19,r25
        movw r24,r18
        ldi r22,lo8(4)
        ldi r23,0
        call __divmodhi4
        movw r16,r24
        mov r22,r29
        mov r24,r28
        call getSR_state
        cpse r24,__zero_reg__
            rjmp .LaddTsrkDONE2
            clr r17
            ldi r22,lo8(-1)
            add r22,r29
            mov r24,r28
            call getSR_state
            cpse r24,__zero_reg__
                rjmp .LaddTsrk_1DONE2
                mov r24,r28
                ldi r25,0
                rjmp .LaddTsrk_1DONE2end
            .LaddTsrk_1DONE2:
                ldi r24,0
                ldi r25,0
            .LaddTsrk_1DONE2end:
            movw r18,r16
            sub r18,r24
            sbc r19,r25
            movw r24,r18
            ldi r22,lo8(4)
            ldi r23,0
            call __divmodhi4
            mov r16,r24
        .LaddTsrkDONE2:
        mov r22,r16
        andi r22,lo8(3)
        mov r20,r29
        mov r24,r28
        call getARK_state
        rjmp .LendCheckAdd
    .LaddSB:
        mov r16,r20
        ldi r17,0
        mov r22,r29
        mov r24,r28
        call getSR_state
        cpse r24,__zero_reg__
            rjmp .LaddTsrkDONE3
            mov r24,r28
            ldi r25,0
            rjmp .LaddTsrkDONE3end
        .LaddTsrkDONE3:
            ldi r24,0
            ldi r25,0
        .LaddTsrkDONE3end:
        movw r18,r16
        sub r18,r24
        sbc r19,r25
        movw r24,r18
        ldi r22,lo8(4)
        ldi r23,0
        call __divmodhi4
        movw r16,r24
        mov r22,r29
        mov r24,r28
        call getSR_state
        cpse r24,__zero_reg__
            rjmp .LaddTsrkDONE4
            clr r17
            ldi r22,lo8(-1)
            add r22,r29
            mov r24,r28
            call getSR_state
            cpse r24,__zero_reg__
                rjmp .LaddTsrk_1DONE4
                mov r24,r28
                ldi r25,0
                rjmp .LaddTsrk_1DONE4end
            .LaddTsrk_1DONE4:
                ldi r24,0
                ldi r25,0
            .LaddTsrk_1DONE4end:
            movw r18,r16
            sub r18,r24
            sbc r19,r25
            movw r24,r18
            ldi r22,lo8(4)
            ldi r23,0
            call __divmodhi4
            mov r16,r24
        .LaddTsrkDONE4:
        mov r22,r16
        andi r22,lo8(3)
        mov r20,r29
        mov r24,r28
        call getSB_state
        rjmp .LendCheckAdd
    .LaddSR:
        mov r22,r29
        mov r24,r28
        call getSR_state
.LendCheckAdd:
	cpse r24,__zero_reg__
	rjmp .LdontAdd
    .Ldefault:
        lds r24,theta_size
        ldi r19,lo8(4)
        mul r24,r19
        movw r30,r0
        clr __zero_reg__
        subi r30,lo8(-(theta))
        sbci r31,hi8(-(theta))
        st Z,r15
        std Z+1,r29
        std Z+2,r28
        std Z+3,r14
        subi r24,lo8(-(1))
        sts theta_size,r24
    .LdontAdd:
	pop r29
	pop r28
	pop r17
	pop r16
	pop r15
	pop r14
	ret

.global	arkUpdate
arkUpdate:
	push r15
	push r16
	push r17
	push r28
	push r29
	mov r29,r24
	mov r28,r22
	mov r15,r20
	mov r16,r20
	ldi r17,0
	mov r22,r24
	mov r24,r28
	call getSR_state
	cpse r24,__zero_reg__
        rjmp .LarkuSRkDONE1
        mov r24,r28
        ldi r25,0
        rjmp .LarkuSRkDONE1end
    .LarkuSRkDONE1:
        ldi r24,0
        ldi r25,0
    .LarkuSRkDONE1end:
	movw r18,r16
	sub r18,r24
	sbc r19,r25
	movw r24,r18
	ldi r22,lo8(4)
	ldi r23,0
	call __divmodhi4
	mov r16,r24
	andi r16,lo8(3)
	mov r22,r29
	mov r24,r28
	call getSR_state
	cpse r24,__zero_reg__
        rjmp .LarkuSRkDONE2
        ldi r17,0
        ldi r22,lo8(-1)
        add r22,r29
        mov r24,r28
        call getSR_state
        cpse r24,__zero_reg__
            rjmp .LarkuSRk_1DONE2
            mov r24,r28
            ldi r25,0
            rjmp .LarkuSRk_1DONE2end
        .LarkuSRk_1DONE2:
            ldi r24,0
            ldi r25,0
        .LarkuSRk_1DONE2end:
        movw r18,r16
        sub r18,r24
        sbc r19,r25
        movw r24,r18
        ldi r22,lo8(4)
        ldi r23,0
        call __divmodhi4
        mov r16,r24
    .LarkuSRkDONE2:
	mov r22,r16
	andi r22,lo8(3)
	ldi r18,lo8(1)
	mov r20,r29
	mov r24,r28
	call setARK_state
	cpi r29,lo8(10)
        brsh .LarkuDontAddSR
        ldi r17,lo8(1)
        add r17,r29
        mov r18,r17
        mov r20,r15
        mov r22,r28
        ldi r24,lo8(1)
        call addToTheta
        mov r20,r29
        ldi r22,0
        mov r24,r28
        call getARK_state
        tst r24
        breq .LarkuDontAddSR
        mov r20,r29
        ldi r22,lo8(1)
        mov r24,r28
        call getARK_state
        tst r24
        breq .LarkuDontAddSR
        mov r20,r29
        ldi r22,lo8(2)
        mov r24,r28
        call getARK_state
        tst r24
        breq .LarkuDontAddSR
        mov r20,r29
        ldi r22,lo8(3)
        mov r24,r28
        call getARK_state
        tst r24
        breq .LarkuDontAddSR
        mov r22,r29
        mov r24,r28
        call getSR_state
        tst r24
        breq .LarkuDontAddSR
        mov r18,r17
        mov r20,r15
        mov r22,r28
        ldi r24,lo8(2)
        pop r29
        pop r28
        pop r17
        pop r16
        pop r15
        jmp addToTheta
    .LarkuDontAddSR:
	pop r29
	pop r28
	pop r17
	pop r16
	pop r15
	ret

.global	sbUpdate
sbUpdate:
	push r15
	push r16
	push r17
	push r28
	push r29
	mov r28,r24
	mov r29,r22
	mov r15,r20
	mov r16,r20
	ldi r17,0
	mov r22,r24
	mov r24,r29
	call getSR_state
	cpse r24,__zero_reg__
        rjmp .LsbuSRkDONE1
        mov r24,r29
        ldi r25,0
        rjmp .LsbuSRkDONE1end
    .LsbuSRkDONE1:
        ldi r24,0
        ldi r25,0
    .LsbuSRkDONE1end:
	movw r18,r16
	sub r18,r24
	sbc r19,r25
	movw r24,r18
	ldi r22,lo8(4)
	ldi r23,0
	call __divmodhi4
	mov r16,r24
	andi r16,lo8(3)
	mov r22,r28
	mov r24,r29
	call getSR_state
	cpse r24,__zero_reg__
        rjmp .LsbuSRkDONE2
        ldi r17,0
        ldi r22,lo8(-1)
        add r22,r28
        mov r24,r29
        call getSR_state
        cpse r24,__zero_reg__
            rjmp .LsbuSRk_1DONE2
            mov r24,r29
            ldi r25,0
            rjmp .LsbuSRk_1DONE2end
        .LsbuSRk_1DONE2:
            ldi r24,0
            ldi r25,0
        .LsbuSRk_1DONE2end:
        movw r18,r16
        sub r18,r24
        sbc r19,r25
        movw r24,r18
        ldi r22,lo8(4)
        ldi r23,0
        call __divmodhi4
        mov r16,r24
    .LsbuSRkDONE2:
	andi r16,lo8(3)
	ldi r18,lo8(1)
	mov r20,r28
	mov r22,r16
	mov r24,r29
	call setSB_state
	cpi r28,lo8(10)
            brlo .LsbuLT9
            mov r18,r28
            mov r20,r15
            mov r22,r29
            ldi r24,0
            rjmp .Lsbugreaterthan9
        .LsbuLT9:
        mov r22,r28
        ldi r24,0
        call getSR_state
        cpse r24,__zero_reg__
        rjmp .LsbuSR0kDOne
    .LsbuSB0DONE:
        ldi r22,lo8(-1)
        add r22,r28
        ldi r24,0
        call getSR_state
        tst r24
        brne .+2
        rjmp .LsbuDontAddMC
        rjmp .Lsbu0ok
    .LsbuSR0kDOne:
        mov r20,r28
        mov r22,r16
        ldi r24,0
        call getSB_state
        tst r24
        breq .LsbuSB0DONE
    .LsbuSB0DONE2:
        mov r22,r28
        ldi r24,lo8(1)
        call getSR_state
        cpse r24,__zero_reg__
        rjmp .LsbuSR1kDOne
        rjmp .LsbuSR1kNotDOne
    .Lsbu0ok:
        mov r20,r28
        mov r22,r16
        ldi r24,0
        call getSB_state
        cpse r24,__zero_reg__
        rjmp .LsbuSB0DONE2
        rjmp .LsbuDontAddMC
    .LsbuSR1kDOne:
        mov r20,r28
        mov r22,r16
        ldi r24,lo8(1)
        call getSB_state
        cpse r24,__zero_reg__
        rjmp .LsbuSB1DONE
    .LsbuSR1kNotDOne:
        ldi r22,lo8(-1)
        add r22,r28
        ldi r24,lo8(1)
        call getSR_state
        tst r24
        brne .+2
        rjmp .LsbuDontAddMC
        mov r20,r28
        mov r22,r16
        ldi r24,lo8(1)
        call getSB_state
        tst r24
        brne .+2
        rjmp .LsbuDontAddMC
    .LsbuSB1DONE:
        mov r22,r28
        ldi r24,lo8(2)
        call getSR_state
        tst r24
        breq .LsbuSR2kNotDone
        mov r20,r28
        mov r22,r16
        ldi r24,lo8(2)
        call getSB_state
        cpse r24,__zero_reg__
        rjmp .LsbuSB2DONE
    .LsbuSR2kNotDone:
        ldi r22,lo8(-1)
        add r22,r28
        ldi r24,lo8(2)
        call getSR_state
        tst r24
        breq .LsbuDontAddMC
        mov r20,r28
        mov r22,r16
        ldi r24,lo8(2)
        call getSB_state
        tst r24
        breq .LsbuDontAddMC
    .LsbuSB2DONE:
        mov r22,r28
        ldi r24,lo8(3)
        call getSR_state
        tst r24
        breq .LsbuSR3kNotDone
        mov r20,r28
        mov r22,r16
        ldi r24,lo8(3)
        call getSB_state
        cpse r24,__zero_reg__
        rjmp .LsbuSB3DONE
    .LsbuSR3kNotDone:
        ldi r22,lo8(-1)
        add r22,r28
        ldi r24,lo8(3)
        call getSR_state
        tst r24
        breq .LsbuDontAddMC
        mov r20,r28
        mov r22,r16
        ldi r24,lo8(3)
        call getSB_state
        tst r24
        breq .LsbuDontAddMC
    .LsbuSB3DONE:
        mov r18,r28
        mov r20,r16
        mov r22,r29
        ldi r24,lo8(3)
    .Lsbugreaterthan9:
        pop r29
        pop r28
        pop r17
        pop r16
        pop r15
        jmp addToTheta
    .LsbuDontAddMC:
	pop r29
	pop r28
	pop r17
	pop r16
	pop r15
	ret

.global	srUpdate
srUpdate:
	push r16
	push r17
	push r28
	push r29
	mov r28,r24
	mov r16,r22
	ldi r20,lo8(1)
	mov r22,r24
	mov r24,r16
	call setSR_state
	lds r18,theta_size
	ldi r30,lo8(theta+3)
	ldi r31,hi8(theta+3)
	ldi r25,0
    .LOOPshiftTheta:
        cp r25,r18
        breq .LendLOOPshiftTheta
        movw r26,r30
        sbiw r26,3
        ld r24,X
        cpi r24,lo8(2)
        brsh .LdontShift
        adiw r26,2
        ld r24,X
        cpse r16,r24
        rjmp .LdontShift
        sbiw r26,1
        ld r24,X
        cp r24,r28
        brlo .LdontShift
        ld r24,Z
        sub r24,r16
        andi r24,lo8(3)
        st Z,r24
    .LdontShift:
        subi r25,lo8(-(1))
        adiw r30,4
        rjmp .LOOPshiftTheta
    .LendLOOPshiftTheta:
	cpi r28,lo8(9)
        brlo .Llt9
    .LOOPsruJ:
        mov r20,r28
        ldi r22,0
        mov r24,r16
        call getARK_state
        tst r24
        brne .+2
        rjmp .Lendsru
        rjmp .LaddNextSR
        .Llt9:
        ldi r17,0
        ldi r29,lo8(1)
        add r29,r28
    .LOOPsru:
        mov r22,r29
        ldi r24,0
        call getSR_state
        cpse r24,__zero_reg__
        rjmp .LsruSR0k1DONE
    .LsruSB0NotDone:
        mov r22,r28
        ldi r24,0
        call getSR_state
        tst r24
        brne .+2
        rjmp .LsruNotOk
        rjmp .LsruSR0kDONE
    .LsruSR0k1DONE:
        mov r20,r29
        mov r22,r17
        ldi r24,0
        call getSB_state
        tst r24
        breq .LsruSB0NotDone
    .LsruSB0DONE:
        mov r22,r29
        ldi r24,lo8(1)
        call getSR_state
        cpse r24,__zero_reg__
        rjmp .LsruSR1k1DONE
        rjmp .LsruSR1k1NotDONE
    .LsruSR0kDONE:
        mov r20,r29
        mov r22,r17
        ldi r24,0
        call getSB_state
        cpse r24,__zero_reg__
        rjmp .LsruSB0DONE
        rjmp .LsruNotOk
    .LsruSR1k1DONE:
        mov r20,r29
        mov r22,r17
        ldi r24,lo8(1)
        call getSB_state
        cpse r24,__zero_reg__
        rjmp .LsruSB1DONE
    .LsruSR1k1NotDONE:
        mov r22,r28
        ldi r24,lo8(1)
        call getSR_state
        tst r24
        brne .+2
        rjmp .LsruNotOk
        mov r20,r29
        mov r22,r17
        ldi r24,lo8(1)
        call getSB_state
        tst r24
        breq .LsruNotOk
    .LsruSB1DONE:
        mov r22,r29
        ldi r24,lo8(2)
        call getSR_state
        tst r24
        breq .LsruSR2k1NotDONE
        mov r20,r29
        mov r22,r17
        ldi r24,lo8(2)
        call getSB_state
        cpse r24,__zero_reg__
        rjmp .LsruSB2DONE
    .LsruSR2k1NotDONE:
        mov r22,r28
        ldi r24,lo8(2)
        call getSR_state
        tst r24
        breq .LsruNotOk
        mov r20,r29
        mov r22,r17
        ldi r24,lo8(2)
        call getSB_state
        tst r24
        breq .LsruNotOk
    .LsruSB2DONE:
        mov r22,r29
        ldi r24,lo8(3)
        call getSR_state
        tst r24
        breq .LsruSR3k1NotDONE
        mov r20,r29
        mov r22,r17
        ldi r24,lo8(3)
        call getSB_state
        cpse r24,__zero_reg__
        rjmp .LsruSB3DONE
    .LsruSR3k1NotDONE:
        mov r22,r28
        ldi r24,lo8(3)
        call getSR_state
        tst r24
        breq .LsruNotOk
        mov r20,r29
        mov r22,r17
        ldi r24,lo8(3)
        call getSB_state
        tst r24
        breq .LsruNotOk
    .LsruSB3DONE:
        mov r18,r29
        mov r20,r17
        mov r22,r16
        ldi r24,lo8(3)
        call addToTheta
    .LsruNotOk:
        subi r17,lo8(-(1))
        cpi r17,lo8(4)
        breq .+2
        rjmp .LOOPsru
        rjmp .LOOPsruJ
.LaddNextSR:
	mov r20,r28
	ldi r22,lo8(1)
	mov r24,r16
	call getARK_state
	tst r24
	breq .Lendsru
	mov r20,r28
	ldi r22,lo8(2)
	mov r24,r16
	call getARK_state
	tst r24
	breq .Lendsru
	mov r20,r28
	ldi r22,lo8(3)
	mov r24,r16
	call getARK_state
	tst r24
	breq .Lendsru
	cpi r28,lo8(10)
	breq .Lendsru
	ldi r18,lo8(1)
	add r18,r28
	ldi r20,0
	mov r22,r16
	ldi r24,lo8(2)
	pop r29
	pop r28
	pop r17
	pop r16
	jmp addToTheta
.Lendsru:
	pop r29
	pop r28
	pop r17
	pop r16
	ret

.global	mcUpdate
mcUpdate:
	push r17
	push r28
	push r29
	mov r29,r24
	mov r17,r22
	ldi r20,lo8(1)
	mov r22,r24
	mov r24,r17
	call setMC_state
	ldi r28,0
    .LmcuAddARK:
        mov r22,r29
        mov r24,r28
        call getSR_state
        tst r24
            breq .LmcuSRkDONE
            mov r18,r29
            mov r20,r17
            rjmp .LmcuSRkDONEend
        .LmcuSRkDONE:
            mov r20,r17
            add r20,r28
            andi r20,lo8(3)
            mov r18,r29
        .LmcuSRkDONEend:
        mov r22,r28
        ldi r24,0
        call addToTheta
        subi r28,lo8(-(1))
        cpi r28,lo8(4)
        brne .LmcuAddARK
	pop r29
	pop r28
	pop r17
	ret

.global	updateTheta
updateTheta:
	mov r25,r24
	mov r24,r18
	cpi r25,lo8(1)
        breq .LuTsbu
        brlo .LuTarku
        cpi r25,lo8(2)
        breq .LuTsru
        cpi r25,lo8(3)
        breq .LuTmcu
        ret
    .LuTarku:
        jmp arkUpdate
    .LuTsbu:
        jmp sbUpdate
    .LuTsru:
        jmp srUpdate
    .LuTmcu:
        mov r22,r20
        jmp mcUpdate

.global	initTheta
initTheta:
	push r28
	push r29
	sts theta_size,__zero_reg__
	ldi r29,0
    .LOOPinitTi:
        ldi r28,0
        .LOOPinitTj:
            ldi r18,0
            mov r20,r28
            mov r22,r29
            ldi r24,0
            call addToTheta
            subi r28,lo8(-(1))
            cpi r28,lo8(4)
            brne .LOOPinitTj
        subi r29,lo8(-(1))
        cpi r29,lo8(4)
        brne .LOOPinitTi
	pop r29
	pop r28
	ret

.global	init
init:
	call initARK_state
	call initSB_state
	call initSR_state
	call initMC_state
	jmp initTheta

.global	schedaes
schedaes:
	push r14
	push r15
	push r16
	push r17
	push r28
	push r29
	call init
    .LOOPschedaes:
        lds r24,theta_size
        tst r24
        breq .LthetaEmpty
        ldi r25,0
        call random
        movw r14,r24
        movw r30,r24
        clr r31
        lsl r30
        rol r31
        lsl r30
        rol r31
        subi r30,lo8(-(theta))
        sbci r31,hi8(-(theta))
        ld r28,Z
        ldd r16,Z+1
        ldd r29,Z+2
        ldd r17,Z+3
        mov r18,r16
        mov r20,r17
        mov r22,r29
        mov r24,r28
        call perform
        mov r24,r14
        call removeFromTheta
        mov r18,r16
        mov r20,r17
        mov r22,r29
        mov r24,r28
        call updateTheta
        rjmp .LOOPschedaes
    .LthetaEmpty:
	pop r29
	pop r28
	pop r17
	pop r16
	pop r15
	pop r14
	ret

.section .bss

.global	theta_size
.type	theta_size, @object
.size	theta_size, 1
theta_size:	.zero	1

.comm	theta,160,1

.global __do_clear_bss
