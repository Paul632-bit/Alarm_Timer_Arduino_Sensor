RS	EQU 	P2.6
EN	EQU 	P2.7
RW	EQU 	P2.5
DAT	EQU 	P0
	
	ORG		0000H
	MOV		33H,#14H
	MOV		34H,#3BH
	MOV		R7,#39H

;multiplication part	
	
	MOV		A, R7
	MOV		B, A
	MOV		A, 34H
	MUL		AB ; Multiply 3BH with 39H
	MOV 	37H, A; A= 23, P2
	MOV		A, B; B=0D
	MOV		R6, A; R6=0D
	MOV		A, R7
	MOV		B, A
	MOV		A, 33H
	MUL		AB ;Multiply 14H with 39H
	ADD		A, R6
	MOV		36H, A; P1=81
	MOV		A, B
	ADDC 	A, #00H
	MOV		35H, A
	
;Division part
	MOV 	A, #02H
	MOV		B, A
	MOV		A, 33H
	DIV		AB
	MOV		38H, A; 0AH IN 38H
	MOV		A, #02H; 1DH IN 39H
	MOV     B,A
	MOV		A,34H
	DIV		AB
	MOV		39H,A
	
	

    LCALL	 INIT_LCD
    LCALL	 CLEAR_LCD
    LCALL	 FST_LCD; Set Up LCD 1st line
    
    MOV 	A, #'T'
    LCALL 	WRITE_TEXT
    MOV 	A, #':'
    LCALL 	WRITE_TEXT
    MOV 	A, 33H
    LCALL 	WRITE_HEX
    MOV 	A, 34H
    LCALL 	WRITE_HEX
    MOV 	A, #'H'
    LCALL 	WRITE_TEXT
    MOV 	A, #' '
    LCALL 	WRITE_TEXT
    MOV 	A, #'U'
    LCALL 	WRITE_TEXT
    MOV 	A, #':'
    LCALL 	WRITE_TEXT
    MOV 	A, R7
    LCALL 	WRITE_HEX
    MOV 	A, #'H'
    LCALL 	WRITE_TEXT
    LCALL 	WAIT_LCD
    
    LCALL	INIT_LCD
    LCALL	 SED_LCD; Set Up LCD 2nd line
    
    
    MOV 	A, #'P'
    LCALL 	WRITE_TEXT
    MOV 	A, #':'
    LCALL 	WRITE_TEXT
    MOV 	A, 35H
    LCALL 	WRITE_HEX
    MOV 	A, 36H
    LCALL 	WRITE_HEX
    MOV 	A, 37H
    LCALL 	WRITE_HEX
    MOV		A,#' '
    LCALL	WRITE_TEXT
    MOV		A,#'Q'
    LCALL   WRITE_TEXT
    MOV     A,#':'
    LCALL	WRITE_TEXT
    MOV     A, 38H
    LCALL   WRITE_HEX
    MOV     A, 39H
    LCALL   WRITE_HEX
    LCALL   WAIT_LCD
		

INIT_LCD:
	CLR		RS			; command mode
	MOV		DAT, #38H	; 2 lines and 5x7 matrix
	SETB	EN
	CLR		EN			; high-to-low transition to EN
	LCALL	WAIT_LCD
	CLR		RS			; command mode
	MOV		DAT, #0CH	; display on, cursor off
	SETB	EN
	CLR		EN			; high-to-low transition to EN
	LCALL	WAIT_LCD
	CLR		RS			; command mode
	MOV		DAT, #06H	; shift cursor to right
	SETB	EN
	CLR		EN			; high-to-low transition to EN
	LCALL	WAIT_LCD
	RET

CLEAR_LCD:
	CLR		RS			; command mode
	MOV		DAT, #01H	; clear display screen
	SETB	EN
	CLR		EN			; high-to-low transition to EN
	LCALL	WAIT_LCD
	RET

SED_LCD:
	CLR		RS			; command mode
	MOV		DAT, #0C0H	; Jump to second line, position0
	SETB	EN
	CLR		EN			; high-to-low transition to EN
	LCALL	WAIT_LCD
	RET

FST_LCD:
	CLR		RS			; command mode
	CLR		RS			; command mode
	MOV		DAT, #80H	; Jump to second line, position0
	SETB	EN
	CLR		EN			; high-to-low transition to EN
	LCALL	WAIT_LCD
	RET
		
		
WRITE_HEX:
	PUSH	ACC 		;store Accumulator value on stack 
	ANL 	A, #0F0H	;to obtain the rightmost digit of the value stored in Accumulator 
	SWAP	A			;shifting the hexadecimal first digit to right
	MOV		DPTR, #HEX_TO_ASCII
	MOVC	A,  @A+DPTR	; use the value stored in A that is from '0-9' or 'A-F' as an index to search for the ASCII value in the HEX_TO_ASCII using datapointer
	LCALL	WRITE_TEXT
	POP		ACC
	ANL		A, #00FH		;to obtain the leftmost digit of the value stored in Accumulator 
	MOV		DPTR, #HEX_TO_ASCII
	MOVC	A,  @A+DPTR ;use the value stored in A that is from '0-9' or 'A-F' as an index to search for the ASCII value in the HEX_TO_ASCII using datapointer
	LCALL 	WRITE_TEXT
	RET
		
;Database used to define the ASCII characters from 0-9 and A-F
HEX_TO_ASCII: DB '0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'


WRITE_TEXT:
	SETB	RS			; data mode
	MOV		DAT, A		; pass value of A to data port
	SETB	EN
	CLR		EN			; high-to-low transition to EN
	LCALL	WAIT_LCD
	RET


WAIT_LCD:
	CLR		EN			; ensure LCD disabled
	CLR		RS			; command mode
	SETB	RW			; read from LCD
	MOV		DAT, #0FFH	; set data port as input port
	SETB	EN			; high-to-low transition to EN
	MOV		A, DAT		; read value from LCD
	JB		ACC.7, WAIT_LCD; if bit 7 is high, LCD is busy
	CLR		EN			; finish command
	CLR		RW			; turn off read from LCD
	RET
END