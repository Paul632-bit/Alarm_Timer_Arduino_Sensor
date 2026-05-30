BEEP BIT P1.5
		
		ORG		0000H
		AJMP	START
		ORG		001BH
		AJMP 	TIMER1
		
START:	MOV		R1, #9  	; R1 = (1) 2  3	 4	= Thousands place
		MOV 	R2, #5 	    ; R2 =  1 (2) 3	 4	= Hundreds place
		MOV 	R3, #5 		; R3 =  1  2 (3) 4	= Tens place
		MOV		R4, #7 		; R4 =  1  2  3 (4)	= Ones place
		MOV 	R0,#100	    ; count 100 times
		SETB	EA			; enable Interrupt
		SETB	ET1			; enable Timer 1 Interrupt
		MOV		TMOD, #00010000B ; Interrupt X used, timer mode, use Timer, Mode 1
		MOV		TH1, #0F6H
		MOV		TL1, #3BH		; Initial count = F63BH, I.E. COUNT EVERY 0.25 SECONDS
		SETB	TR1				; Start counting
			
INIT:	MOV 	DPTR, #LED_TABLE
		
		
LOOP:	MOV     A, R4			; display ones digit
		MOVC	A, @A+DPTR
		CLR		P2.2
		CLR		P2.3
		CLR 	P2.4
		MOV		P0,A
		ACALL   DELAY
		
		MOV     A, R3			; display tens digit
		MOVC	A, @A+DPTR
		SETB	P2.2
		CLR		P2.3
		CLR 	P2.4
		MOV		P0,A
		ACALL   DELAY

		MOV     A, R2			; display hundred digit
		MOVC	A, @A+DPTR
		CLR		P2.2
		SETB	P2.3
		CLR 	P2.4
		MOV		P0,A
		ACALL   DELAY
		
		MOV     A, R1			; display thousand digit
		MOVC	A, @A+DPTR
		SETB	P2.2
		SETB	P2.3
		CLR 	P2.4
		MOV		P0,A
		ACALL   DELAY
			
		SJMP 	LOOP
		
TIMER1:	CLR		TR1			; Stop Timer1
		CLR		TF1			; Reset Timer 1 Overflow Flag
		DJNZ	R0,EXIT		; Check done 100 times or not? If not, go to EXIT
		MOV		R0, #100		; Reset R0 to 100
		CJNE	R4, #7, BorrowDigit0
		CJNE	R3, #0, BorrowDigit0
		CJNE    R2, #5, BorrowDigit0
		CJNE	R1, #8, BorrowDigit0	
		SJMP	BUZZ

BorrowDigit0: 
		MOV		A, R4
		CJNE	R4, #1, BorrowDigit1 ; for Ones
		MOV		R4, #9
		CJNE	R3, #0, BorrowDigit2 ; for Tens
		MOV		R3, #9
		CJNE	R2, #0, BorrowDigit3 ; for Hundres
		MOV		R2, #9
		CJNE	R1, #0, BorrowDigit4 ; for Thousands
		MOV		R1, #9
		SJMP EXIT
		
BorrowDigit1:	
		DEC		A		; Decrement by 2
		DEC		A
		MOV		R4, A
		SJMP EXIT

BorrowDigit2:	
		DEC R3
		SJMP EXIT
		
BorrowDigit3:	
		DEC R2
		SJMP EXIT
		
BorrowDigit4:
		DEC R1
		SJMP EXIT
		
EXIT:	
		MOV		TH1, #0F6H
		MOV		TL1, #3BH		; Reset initial count to F63BH
		SETB	TR1				; Start Timer 1
		RETI

DELAY:	MOV	R5,	#50
LP1:	MOV R6, #25
		DJNZ R6,$
		DJNZ R5, LP1
		RET	
DELAY2:	MOV	R5,	#100
LP2:	MOV R6, #50
		DJNZ R6,$
		DJNZ R5, LP2
		RET	
	
LED_TABLE:	DB	03FH, 06H, 05BH, 04FH, 066H, 06DH, 07DH, 07H, 07FH, 06FH

BUZZ:	
		MOV     A, R4			; display ones digit
		MOVC	A, @A+DPTR
		CLR		P2.2
		CLR		P2.3
		CLR 	P2.4
		MOV		P0,A
		ACALL   DELAY
		
		MOV     A, R3			; display tens digit
		MOVC	A, @A+DPTR
		SETB	P2.2
		CLR		P2.3
		CLR 	P2.4
		MOV		P0,A
		ACALL   DELAY

		MOV     A, R2			; display hundred digit
		MOVC	A, @A+DPTR
		CLR		P2.2
		SETB	P2.3
		CLR 	P2.4
		MOV		P0,A
		ACALL   DELAY
		
		MOV     A, R1			; display thousand digit
		MOVC	A, @A+DPTR
		SETB	P2.2
		SETB	P2.3
		CLR 	P2.4
		MOV		P0,A
		ACALL   DELAY
		
		CPL BEEP 		; Toggle P1.5
		ACALL DELAY2 	; Delay longer
		SJMP BUZZ
END