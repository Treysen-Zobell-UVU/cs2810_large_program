
; Prompt user to input and LC-3 command
; Take input, input ends when enter/return is encountered
; Check if input is "QUIT"
;    yes: exit
; Check if input it valid command
;    yes: display the matching opcode (ADD->0001)
;    no:  display an error
; loop back to the top

; R0 | System Register, In/Out (Reserved)
; R1 | Index Offset (Global)
; R2 | Jump Table Offset (Global)
; R3 |
; R4 |
; R5 |
; R6 | JSR Save Register (Reserved)
; R7 | JSR Register (Reserved)

; TRAP x23 -> Waits for console input, loads character into R0
; TRAP x21 -> Writes character in R0 to console

.ORIG x9000 ; ascii table
	.FILL x41 ; A
	.FILL x42 ; B
	.FILL x43 ; C
	.FILL x44 ; D
	.FILL x45 ; E
	.FILL x46 ; F
	.FILL x47 ; G
	.FILL x48 ; H
	.FILL x49 ; I
	.FILL x4A ; J
	.FILL x4B ; K
	.FILL x4C ; L
	.FILL x4D ; M
	.FILL x4E ; N
	.FILL x4F ; O
	.FILL x50 ; P
	.FILL x51 ; Q
	.FILL x52 ; R
	.FILL x53 ; S
	.FILL x54 ; T
	.FILL x55 ; U
	.FILL x56 ; V
	.FILL x57 ; W
	.FILL x58 ; X
	.FILL x59 ; Y
	.FILL x5A ; Z
	.FILL xA ; \n
	.FILL x20 ; [SPACE]
	.FILL x3A ; :
.END

.ORIG x9500 ; command prompt, x3A(:) terminated
	.FILL x45 ; E
	.FILL x6E ; n
	.FILL x74 ; t
	.FILL x65 ; e
	.FILL x72 ; r
	.FILL x20 ;  
	.FILL x4C ; L
	.FILL x43 ; C
	.FILL x33 ; 3
	.FILL x20 ;  
	.FILL x49 ; I
	.FILL x6E ; n
	.FILL x73 ; s
	.FILL x74 ; t
	.FILL x72 ; r
	.FILL x75 ; u
	.FILL x63 ; c
	.FILL x74 ; t
	.FILL x69 ; i
	.FILL x6F ; o
	.FILL x6E ; n
	.FILL x3A ; :
.END

.ORIG x9600 ; error message, x0A(\n) terminated
	.FILL x45 ; E
	.FILL x52 ; R
	.FILL x52 ; R
	.FILL x4F ; O
	.FILL x52 ; R
	.FILL x2C ; ,
	.FILL x20 ;  
	.FILL x49 ; I
	.FILL x4E ; N
	.FILL x56 ; V
	.FILL x41 ; A
	.FILL x4C ; L
	.FILL x49 ; I
	.FILL x44 ; D
	.FILL x20 ;  
	.FILL x49 ; I
	.FILL x4E ; N
	.FILL x53 ; S
	.FILL x54 ; T
	.FILL x52 ; R
	.FILL x55 ; U
	.FILL x43 ; C
	.FILL x54 ; T
	.FILL x49 ; I
	.FILL x4F ; O
	.FILL x4E ; N
	.FILL xA ; \n
.END

		.ORIG x3000
ASCII_TABLE .FILL x9000
PROMPT_LOC .FILL x9500
ERROR_LOC .FILL x9600

START	AND R1 R1 #0
		LEA R2 TABLE
		LD R3 ASCII_TABLE
		JSR PROMPT
		
AGAIN	LD R3 ASCII_TABLE	
		ADD R7 R2 R1
		LDR R7 R7 #0
		JSRR R7
		BRnzp AGAIN


EQUALS	NOT R4 R4
		ADD R4 R4 #1
		ADD R4 R0 R4
		RET
		
PROMPT	ADD R6 R7 #0
		LD R5 PROMPT_LOC
			LDR R0 R5 #0
			TRAP x21
			LDR R4 R3 #28 ; \n
			ADD R5 R5 #1
			JSR EQUALS
			BRnp #-6
		LDR R0 R3 #27 ; _
		TRAP x21
		ADD R7 R6 #0
		RET
		
FAIL 	ADD R6 R7 #0
		LD R5 ERROR_LOC
			LDR R0 R5 #0
			TRAP x21
			LDR R4 R3 #26 ; \n
			ADD R5 R5 #1
			JSR EQUALS
			BRnp #-6
		ADD R7 R6 #0
		RET
		
		
PRINT	ADD R2 R7 #0

		NOT R5 R5

		AND R3 R3 #0
		ADD R3 R3 #8 ; bitmask
		AND R0 R5 R3
		BRz #2 
			AND R0 R0 #0
			ADD R0 R0 #-1
		ADD R0 R0 #15
		ADD R0 R0 #15
		ADD R0 R0 #15
		ADD R0 R0 #4
		TRAP x21
		
		AND R3 R3 #0
		ADD R3 R3 #4 ; bitmask
		AND R0 R5 R3
		BRz #2 
			AND R0 R0 #0
			ADD R0 R0 #-1
		ADD R0 R0 #15
		ADD R0 R0 #15
		ADD R0 R0 #15
		ADD R0 R0 #4
		TRAP x21
		
		AND R3 R3 #0
		ADD R3 R3 #2 ; bitmask
		AND R0 R5 R3
		BRz #2 
			AND R0 R0 #0
			ADD R0 R0 #-1
		ADD R0 R0 #15
		ADD R0 R0 #15
		ADD R0 R0 #15
		ADD R0 R0 #4
		TRAP x21
		
		AND R3 R3 #0
		ADD R3 R3 #1 ; bitmask
		AND R0 R5 R3
		BRz #2 
			AND R0 R0 #0
			ADD R0 R0 #-1
		ADD R0 R0 #15
		ADD R0 R0 #15
		ADD R0 R0 #15
		ADD R0 R0 #4
		TRAP x21
		
		LD R3 ASCII_TABLE
		LDR R0 R3 #26 ; \n
		TRAP x21

		ADD R7 R2 #0
		RET

INPUT	ADD R4 R7 #0
		TRAP x20
		TRAP x21
		ADD R5 R0 #0
		ADD R5 R0 #-15
		ADD R5 R5 #-15
		ADD R5 R5 #-15
		ADD R5 R5 #-15
		ADD R5 R5 #-15
		ADD R5 R5 #-15
		ADD R5 R5 #-7
		BRn #3
			ADD R0 R0 #-15
			ADD R0 R0 #-15
			ADD R0 R0 #-2
		ADD R7 R4 #0
		RET


TABLE		.FILL ST_INIT	; S=0
			.FILL ST_A		; S=1
			.FILL ST_AD		; S=2
			.FILL ST_AN		; S=3
			.FILL ST_ADD	; S=4  0001 #1
			.FILL ST_AND	; S=5  0101 #5
			.FILL ST_B		; S=6
			.FILL ST_BR		; S=7  0000
			.FILL ST_J		; S=8
			.FILL ST_JM		; S=9
			.FILL ST_JS		; S=10
			.FILL ST_JMP	; S=11 1100
			.FILL ST_JSR	; S=12 0100
			.FILL ST_JSRR	; S=13 0100
			.FILL ST_L		; S=14
			.FILL ST_LD		; S=15 0010
			.FILL ST_LE		; S=16
			.FILL ST_LDI	; S=17 1010
			.FILL ST_LDR	; S=18 0110
			.FILL ST_LEA	; S=19 1110
			.FILL ST_N		; S=20
			.FILL ST_NO		; S=21
			.FILL ST_NOT	; S=22 1001
			.FILL ST_R		; S=23
			.FILL ST_RE		; S=24
			.FILL ST_RT		; S=25
			.FILL ST_RET	; S=26 1100
			.FILL ST_RTI	; S=27 1000
			.FILL ST_S		; S=28
			.FILL ST_ST		; S=29 0011
			.FILL ST_STI	; S=30 1011
			.FILL ST_STR	; S=31 0111
			.FILL ST_T		; S=32
			.FILL ST_TR		; S=33
			.FILL ST_TRA	; S=34
			.FILL ST_TRAP	; S=35 1111
			.FILL ST_Q		; S=36
			.FILL ST_QU		; S=37
			.FILL ST_QUI	; S=38
			.FILL ST_QUIT	; 3=39
			.FILL ST_FAIL	; S=40
		
; States
ST_INIT
		ADD R6 R7 #0
		
		JSR INPUT
		
		LDR R4 R3 #0 ; A
		JSR EQUALS
		BRnp #1
			ADD R1 R1 #1	; ST_A(1-0)
			
		LDR R4 R3 #1 ; B
		JSR EQUALS
		BRnp #1
			ADD R1 R1 #6	; ST_B(6-0)
			
		LDR R4 R3 #9 ; J
		JSR EQUALS
		BRnp #1
			ADD R1 R1 #8	; ST_J(8-0)
			
		LDR R4 R3 #11 ; L
		JSR EQUALS
		BRnp #1
			ADD R1 R1 #14	; ST_L(14-0)
			
		LDR R4 R3 #13
		JSR EQUALS
		BRnp #2
			ADD R1 R1 #15	; ST_N(20-0)
			ADD R1 R1 #5
			
		LDR R4 R3 #16 ; Q
		JSR EQUALS
		BRnp #3
			ADD R1 R1 #15	; ST_S(36-0)
			ADD R1 R1 #15
			ADD R1 R1 #6
			
		LDR R4 R3 #17 ; R
		JSR EQUALS
		BRnp #2
			ADD R1 R1 #15	; ST_R(23-0)
			ADD R1 R1 #8
			
		LDR R4 R3 #18 ; S
		JSR EQUALS
		BRnp #2
			ADD R1 R1 #15	; ST_S(28-0)
			ADD R1 R1 #13
			
		LDR R4 R3 #19 ; T
		JSR EQUALS
		BRnp #3
			ADD R1 R1 #15	; ST_S(32-0)
			ADD R1 R1 #15
			ADD R1 R1 #2
			
		LDR R4 R3 #26 ; \n
		JSR EQUALS
		BRnp #2
			JSR FAIL
			JSR START
			
		AND R4 R4 #0	; Else R4=0
		ADD R0 R1 #0
		JSR EQUALS
		BRnp #3
			ADD R1 R1 #15
			ADD R1 R1 #15
			ADD R1 R1 #10	; ST_FAIL
		
		ADD R7 R6 #0
		RET

ST_A
		ADD R6 R7 #0
		
		JSR INPUT
		
		LDR R4 R3 #3 ; D
		JSR EQUALS
		BRnp #1
			ADD R1 R1 #1	; ST_AD(2-1)
			
		LDR R4 R3 #13 ; N
		JSR EQUALS
		BRnp #1
			ADD R1 R1 #2	; ST_AN(3-1)
			
		LDR R4 R3 #26 ; \n
		JSR EQUALS
		BRnp #2
			JSR FAIL
			JSR START
		
		ADD R7 R6 #0
		
		AND R4 R4 #0	; Else R4=1
		ADD R4 R4 #1
		ADD R0 R1 #0
		JSR EQUALS
		BRnp #3
			ADD R1 R1 #15
			ADD R1 R1 #15
			ADD R1 R1 #9	; ST_FAIL
		
		ADD R7 R6 #0
		RET

ST_AD
		ADD R6 R7 #0
		
		JSR INPUT
		
		LDR R4 R3 #3 ; D
		JSR EQUALS
		BRnp #1
			ADD R1 R1 #2	; ST_ADD(4-2)
			
		LDR R4 R3 #26 ; \n
		JSR EQUALS
		BRnp #2
			JSR FAIL
			JSR START
		
		AND R4 R4 #0	; Else
		ADD R4 R4 #2
		ADD R0 R1 #0
		JSR EQUALS
		BRnp #3
			ADD R1 R1 #15
			ADD R1 R1 #15
			ADD R1 R1 #8	; ST_FAIL
		
		ADD R7 R6 #0
		RET
		
ST_AN
		ADD R6 R7 #0
		
		JSR INPUT
		
		LDR R4 R3 #3 ; D
		JSR EQUALS
		BRnp #1
			ADD R1 R1 #2	; ST_AND(5-3)
			
		LDR R4 R3 #26 ; \n
		JSR EQUALS
		BRnp #2
			JSR FAIL
			JSR START
			
		AND R4 R4 #0	; Else
		ADD R4 R4 #3
		ADD R0 R1 #0
		JSR EQUALS
		BRnp #3
			ADD R1 R1 #15
			ADD R1 R1 #15
			ADD R1 R1 #7	; ST_FAIL
		
		ADD R7 R6 #0
		RET
		
ST_ADD ; --------------
		ADD R6 R7 #0
		
		JSR INPUT
		
		LDR R4 R3 #26 ; \n
		JSR EQUALS
		BRnp #4
			AND R5 R5 #0
			ADD R5 R5 #1
			JSR PRINT
			JSR START
			
		AND R4 R4 #0	; Else
		ADD R4 R4 #4
		ADD R0 R1 #0
		JSR EQUALS
		BRnp #3
			ADD R1 R1 #15
			ADD R1 R1 #15
			ADD R1 R1 #6	; ST_FAIL
		
		ADD R7 R6 #0
		RET
		
ST_AND ; --------------
		ADD R6 R7 #0
		
		JSR INPUT
		
		LDR R4 R3 #26 ; \n
		JSR EQUALS
		BRnp #4
			AND R5 R5 #0
			ADD R5 R5 #5
			JSR PRINT
			JSR START
			
		AND R4 R4 #0	; Else
		ADD R4 R4 #5
		ADD R0 R1 #0
		JSR EQUALS
		BRnp #3
			ADD R1 R1 #15
			ADD R1 R1 #15
			ADD R1 R1 #5	; ST_FAIL
		
		ADD R7 R6 #0
		RET
		
ST_B
		ADD R6 R7 #0
		
		JSR INPUT
		
		LDR R4 R3 #17 ; R
		JSR EQUALS
		BRnp #1
			ADD R1 R1 #1	; ST_BR(7-6)
			
		LDR R4 R3 #26 ; \n
		JSR EQUALS
		BRnp #2
			JSR FAIL
			JSR START
			
		AND R4 R4 #0	; Else
		ADD R4 R4 #6
		ADD R0 R1 #0
		JSR EQUALS
		BRnp #2
			ADD R1 R1 #15
			ADD R1 R1 #15
			ADD R1 R1 #4	; ST_FAIL
		
		ADD R7 R6 #0
		RET
		
ST_BR
		ADD R6 R7 #0
		
		JSR INPUT
		
		LDR R4 R3 #26 ; \n
		JSR EQUALS
		BRnp #4
			AND R5 R5 #0
			ADD R5 R5 #0
			JSR PRINT
			JSR START
			
		AND R4 R4 #0	; Else
		ADD R4 R4 #7
		ADD R0 R1 #0
		JSR EQUALS
		BRnp #2
			ADD R1 R1 #15
			ADD R1 R1 #15
			ADD R1 R1 #3	; ST_FAIL
		
		ADD R7 R6 #0
		RET

ST_J
		ADD R6 R7 #0
		
		JSR INPUT
		
		LDR R4 R3 #12 ; M
		JSR EQUALS
		BRnp #1
			ADD R1 R1 #1	; ST_JM(9-8)
			
		LDR R4 R3 #18 ; S
		JSR EQUALS
		BRnp #1
			ADD R1 R1 #2	; ST_JS(10-8)
			
		LDR R4 R3 #26 ; \n
		JSR EQUALS
		BRnp #2
			JSR FAIL
			JSR START
			
		AND R4 R4 #0	; Else
		ADD R4 R4 #8
		ADD R0 R1 #0
		JSR EQUALS
		BRnp #2
			ADD R1 R1 #15
			ADD R1 R1 #15
			ADD R1 R1 #2	; ST_FAIL
		
		ADD R7 R6 #0
		RET

ST_JM
		ADD R6 R7 #0
		
		JSR INPUT
		
		LDR R4 R3 #15 ; P
		JSR EQUALS
		BRnp #1
			ADD R1 R1 #2	; ST_JMP(11-9)
			
		LDR R4 R3 #26 ; \n
		JSR EQUALS
		BRnp #2
			JSR FAIL
			JSR START
			
		AND R4 R4 #0	; Else
		ADD R4 R4 #9
		ADD R0 R1 #0
		JSR EQUALS
		BRnp #2
			ADD R1 R1 #15
			ADD R1 R1 #15
			ADD R1 R1 #1	; ST_FAIL
		
		ADD R7 R6 #0
		RET
		
ST_JS
		ADD R6 R7 #0
		
		JSR INPUT
		
		LDR R4 R3 #17 ; R
		JSR EQUALS
		BRnp #1
			ADD R1 R1 #2	; ST_JSR(12-10)
			
		LDR R4 R3 #26 ; \n
		JSR EQUALS
		BRnp #2
			JSR FAIL
			JSR START
			
		AND R4 R4 #0	; Else
		ADD R4 R4 #10
		ADD R0 R1 #0
		JSR EQUALS
		BRnp #2
			ADD R1 R1 #15
			ADD R1 R1 #15	; ST_FAIL
		
		ADD R7 R6 #0
		RET
		
ST_JMP
		ADD R6 R7 #0
		
		JSR INPUT
		
		LDR R4 R3 #26 ; \n
		JSR EQUALS
		BRnp #4
			AND R5 R5 #0
			ADD R5 R5 #12
			JSR PRINT
			JSR START
			
		AND R4 R4 #0	; Else
		ADD R4 R4 #11
		ADD R0 R1 #0
		JSR EQUALS
		BRnp #2
			ADD R1 R1 #15
			ADD R1 R1 #14	; ST_FAIL
		
		ADD R7 R6 #0
		RET
		
ST_JSR
		ADD R6 R7 #0
		
		JSR INPUT
		
		LDR R4 R3 #17 ; R
		JSR EQUALS
		BRnp #1
			ADD R1 R1 #1	; ST_JSRR(13-12)
			
		LDR R4 R3 #26 ; \n
		JSR EQUALS
		BRnp #4
			AND R5 R5 #0
			ADD R5 R5 #4
			JSR PRINT
			JSR START
			
		AND R4 R4 #0	; Else
		ADD R4 R4 #12
		ADD R0 R1 #0
		JSR EQUALS
		BRnp #2
			ADD R1 R1 #15
			ADD R1 R1 #13	; ST_FAIL
		
		ADD R7 R6 #0
		RET
		
ST_JSRR
		ADD R6 R7 #0
		
		JSR INPUT
		
		LDR R4 R3 #26 ; \n
		JSR EQUALS
		BRnp #4
			AND R5 R5 #0
			ADD R5 R5 #4
			JSR PRINT
			JSR START
			
		AND R4 R4 #0	; Else
		ADD R4 R4 #13
		ADD R0 R1 #0
		JSR EQUALS
		BRnp #2
			ADD R1 R1 #15
			ADD R1 R1 #12	; ST_FAIL
		
		ADD R7 R6 #0
		RET
ST_L
		ADD R6 R7 #0
		
		JSR INPUT
		
		LDR R4 R3 #3 ; D
		JSR EQUALS
		BRnp #1
			ADD R1 R1 #1	; ST_LD(15-14)
			
		LDR R4 R3 #4 ; E
		JSR EQUALS
		BRnp #1
			ADD R1 R1 #2	; ST_LE(16-14)
			
		LDR R4 R3 #26 ; \n
		JSR EQUALS
		BRnp #2
			JSR FAIL
			JSR START
			
		AND R4 R4 #0	; Else
		ADD R4 R4 #14
		ADD R0 R1 #0
		JSR EQUALS
		BRnp #2
			ADD R1 R1 #15
			ADD R1 R1 #11	; ST_FAIL
		
		ADD R7 R6 #0
		RET

ST_LD
		ADD R6 R7 #0
		
		JSR INPUT
		
		LDR R4 R3 #8 ; I
		JSR EQUALS
		BRnp #1
			ADD R1 R1 #2	; ST_LDI(17-15)
			
		LDR R4 R3 #17 ; R
		JSR EQUALS
		BRnp #1
			ADD R1 R1 #3	; ST_LDR(18-15)
			
		LDR R4 R3 #26 ; \n
		JSR EQUALS
		BRnp #4
			AND R5 R5 #0
			ADD R5 R5 #2
			JSR PRINT
			JSR START
			
		AND R4 R4 #0	; Else
		ADD R4 R4 #15
		ADD R0 R1 #0
		JSR EQUALS
		BRnp #2
			ADD R1 R1 #15
			ADD R1 R1 #10	; ST_FAIL
		
		ADD R7 R6 #0
		RET
		
ST_LE
		ADD R6 R7 #0
		
		JSR INPUT
		
		LDR R4 R3 #0 ; A
		JSR EQUALS
		BRnp #1
			ADD R1 R1 #3	; ST_LEA(19-16)
			
		LDR R4 R3 #26 ; \n
		JSR EQUALS
		BRnp #2
			JSR FAIL
			JSR START
			
		AND R4 R4 #0	; Else
		ADD R4 R4 #15
		ADD R4 R4 #1
		ADD R0 R1 #0
		JSR EQUALS
		BRnp #2
			ADD R1 R1 #15
			ADD R1 R1 #9	; ST_FAIL
		
		ADD R7 R6 #0
		RET
		
ST_LDI
		ADD R6 R7 #0
		
		JSR INPUT
		
		LDR R4 R3 #26 ; \n
		JSR EQUALS
		BRnp #4
			AND R5 R5 #0
			ADD R5 R5 #10
			JSR PRINT
			JSR START
			
		AND R4 R4 #0	; Else
		ADD R4 R4 #15
		ADD R4 R4 #2
		ADD R0 R1 #0
		JSR EQUALS
		BRnp #2
			ADD R1 R1 #15
			ADD R1 R1 #8	; ST_FAIL
			
		ADD R7 R6 #0
		RET
		
ST_LDR
		ADD R6 R7 #0
		
		JSR INPUT
		
		LDR R4 R3 #26 ; \n
		JSR EQUALS
		BRnp #4
			AND R5 R5 #0
			ADD R5 R5 #6
			JSR PRINT
			JSR START
			
		AND R4 R4 #0	; Else
		ADD R4 R4 #15
		ADD R4 R4 #3
		ADD R0 R1 #0
		JSR EQUALS
		BRnp #2
			ADD R1 R1 #15
			ADD R1 R1 #7	; ST_FAIL
			
		ADD R7 R6 #0
		RET
		
ST_LEA
		ADD R6 R7 #0
		
		JSR INPUT
		
		LDR R4 R3 #26 ; \n
		JSR EQUALS
		BRnp #4
			AND R5 R5 #0
			ADD R5 R5 #14
			JSR PRINT
			JSR START
			
		AND R4 R4 #0	; Else
		ADD R4 R4 #15
		ADD R4 R4 #4
		ADD R0 R1 #0
		JSR EQUALS
		BRnp #2
			ADD R1 R1 #15
			ADD R1 R1 #6	; ST_FAIL
			
		ADD R7 R6 #0
		RET
		
ST_N
		ADD R6 R7 #0
		
		JSR INPUT
		
		LDR R4 R3 #14 ; O
		JSR EQUALS
		BRnp #1
			ADD R1 R1 #1	; ST_NO(21-20)
			
		LDR R4 R3 #26 ; \n
		JSR EQUALS
		BRnp #2
			JSR FAIL
			JSR START
			
		AND R4 R4 #0	; Else
		ADD R4 R4 #15
		ADD R4 R4 #5
		ADD R0 R1 #0
		JSR EQUALS
		BRnp #2
			ADD R1 R1 #15
			ADD R1 R1 #5	; ST_FAIL
		
		ADD R7 R6 #0
		RET
		
ST_NO
		ADD R6 R7 #0
		
		JSR INPUT
		
		LDR R4 R3 #19 ; R
		JSR EQUALS
		BRnp #1
			ADD R1 R1 #1	; ST_NOT(22-21)
			
		LDR R4 R3 #26 ; \n
		JSR EQUALS
		BRnp #2
			JSR FAIL
			JSR START
			
		AND R4 R4 #0	; Else
		ADD R4 R4 #15
		ADD R4 R4 #6
		ADD R0 R1 #0
		JSR EQUALS
		BRnp #1
			ADD R1 R1 #15
			ADD R1 R1 #4	; ST_FAIL
		
		ADD R7 R6 #0
		RET
		
ST_NOT
		ADD R6 R7 #0
		
		JSR INPUT
		
		LDR R4 R3 #26 ; \n
		JSR EQUALS
		BRnp #4
			AND R5 R5 #0
			ADD R5 R5 #9
			JSR PRINT
			JSR START
			
		AND R4 R4 #0	; Else
		ADD R4 R4 #15
		ADD R4 R4 #7
		JSR EQUALS
		BRnp #2
			ADD R1 R1 #15
			ADD R1 R1 #3	; ST_FAIL
			
		ADD R7 R6 #0
		RET
		
ST_R
		ADD R6 R7 #0
		
		JSR INPUT
		
		LDR R4 R3 #4 ; E
		JSR EQUALS
		BRnp #1
			ADD R1 R1 #1	; ST_RE(24-23)
			
		LDR R4 R3 #19 ; T
		JSR EQUALS
		BRnp #1
			ADD R1 R1 #2	; ST_RT(27-25)
			
		LDR R4 R3 #26 ; \n
		JSR EQUALS
		BRnp #2
			JSR FAIL
			JSR START
			
		AND R4 R4 #0	; Else
		ADD R4 R4 #15
		ADD R4 R4 #8
		JSR EQUALS
		BRnp #1
			ADD R1 R1 #15
			ADD R1 R1 #2	; ST_FAIL
		
		ADD R7 R6 #0
		RET
		
ST_RE
		ADD R6 R7 #0
		
		JSR INPUT
		
		LDR R4 R3 #19 ; T
		JSR EQUALS
		BRnp #1
			ADD R1 R1 #2	; ST_RET(26-25)
			
		LDR R4 R3 #26 ; \n
		JSR EQUALS
		BRnp #2
			JSR FAIL
			JSR START
			
		AND R4 R4 #0	; Else
		ADD R4 R4 #15
		ADD R4 R4 #9
		JSR EQUALS
		BRnp #1
			ADD R1 R1 #15
			ADD R1 R1 #1	; ST_FAIL
		
		ADD R7 R6 #0
		RET
		
ST_RT
		ADD R6 R7 #0
		
		JSR INPUT
		
		LDR R4 R3 #8 ; I
		JSR EQUALS
		BRnp #1
			ADD R1 R1 #2	; ST_RTI(27-25)
			
		LDR R4 R3 #26 ; \n
		JSR EQUALS
		BRnp #2
			JSR FAIL
			JSR START
			
		AND R4 R4 #0	; Else
		ADD R4 R4 #15
		ADD R4 R4 #10
		JSR EQUALS
		BRnp #1
			ADD R1 R1 #15	; ST_FAIL
		
		ADD R7 R6 #0
		RET
		
ST_RET
		ADD R6 R7 #0
		
		JSR INPUT
		
		LDR R4 R3 #26 ; \n
		JSR EQUALS
		BRnp #4
			AND R5 R5 #0
			ADD R5 R5 #12
			JSR PRINT
			JSR START
			
		AND R4 R4 #0	; Else
		ADD R4 R4 #15
		ADD R4 R4 #11
		JSR EQUALS
		BRnp #1
			ADD R1 R1 #14	; ST_FAIL
			
		ADD R7 R6 #0
		RET
		
ST_RTI
		ADD R6 R7 #0
		
		JSR INPUT
		
		LDR R4 R3 #26 ; \n
		JSR EQUALS
		BRnp #4
			AND R5 R5 #0
			ADD R5 R5 #8
			JSR PRINT
			JSR START
			
		AND R4 R4 #0	; Else
		ADD R4 R4 #15
		ADD R4 R4 #12
		JSR EQUALS
		BRnp #1
			ADD R1 R1 #13	; ST_FAIL
			
		ADD R7 R6 #0
		RET
		
ST_S
		ADD R6 R7 #0
		
		JSR INPUT
		
		LDR R4 R3 #19 ; T
		JSR EQUALS
		BRnp #1
			ADD R1 R1 #1	; ST_ST(29-28)
		
		LDR R4 R3 #26 ; \n
		JSR EQUALS
		BRnp #2
			JSR FAIL
			JSR START
			
		AND R4 R4 #0	; Else
		ADD R4 R4 #15
		ADD R4 R4 #13
		JSR EQUALS
		BRnp #1
			ADD R1 R1 #12	; ST_FAIL
		
		ADD R7 R6 #0
		RET
		
ST_ST
		ADD R6 R7 #0
		
		JSR INPUT
		
		LDR R4 R3 #8 ; I
		JSR EQUALS
		BRnp #1
			ADD R1 R1 #1	; ST_STI(30-29)
			
		LDR R4 R3 #17 ; R
		JSR EQUALS
		BRnp #1
			ADD R1 R1 #2	; ST_STR(31-29)
			
		LDR R4 R3 #26 ; \n
		JSR EQUALS
		BRnp #4
			AND R5 R5 #0
			ADD R5 R5 #3
			JSR PRINT
			JSR START
			
		AND R4 R4 #0	; Else
		ADD R4 R4 #15
		ADD R4 R4 #14
		JSR EQUALS
		BRnp #1
			ADD R1 R1 #11	; ST_FAIL
		
		ADD R7 R6 #0
		RET
		
ST_STI
		ADD R6 R7 #0
		
		JSR INPUT
		
		LDR R4 R3 #26 ; \n
		JSR EQUALS
		BRnp #4
			AND R5 R5 #0
			ADD R5 R5 #11
			JSR PRINT
			JSR START
			
		AND R4 R4 #0	; Else
		ADD R4 R4 #15
		ADD R4 R4 #15
		JSR EQUALS
		BRnp #1
			ADD R1 R1 #10	; ST_FAIL
			
		ADD R7 R6 #0
		RET
		
ST_STR
		ADD R6 R7 #0
		
		JSR INPUT
		
		LDR R4 R3 #26 ; \n
		JSR EQUALS
		BRnp #4
			AND R5 R5 #0
			ADD R5 R5 #7
			JSR PRINT
			JSR START
			
		AND R4 R4 #0	; Else
		ADD R4 R4 #15
		ADD R4 R4 #15
		ADD R4 R4 #1
		JSR EQUALS
		BRnp #1
			ADD R1 R1 #9	; ST_FAIL
			
		ADD R7 R6 #0
		RET
		
ST_T
		ADD R6 R7 #0
		
		JSR INPUT
		
		LDR R4 R3 #17 ; R
		JSR EQUALS
		BRnp #1
			ADD R1 R1 #1	; ST_TR(33-32)
			
		LDR R4 R3 #26 ; \n
		JSR EQUALS
		BRnp #2
			JSR FAIL
			JSR START
			
		AND R4 R4 #0	; Else
		ADD R4 R4 #15
		ADD R4 R4 #15
		ADD R4 R4 #2
		JSR EQUALS
		BRnp #1
			ADD R1 R1 #8	; ST_FAIL
		
		ADD R7 R6 #0
		RET
		
ST_TR
		ADD R6 R7 #0
		
		JSR INPUT
		
		LDR R4 R3 #0 ; A
		JSR EQUALS
		BRnp #1
			ADD R1 R1 #1	; ST_TRA(34-33)
			
		LDR R4 R3 #26 ; \n
		JSR EQUALS
		BRnp #2
			JSR FAIL
			JSR START
			
		AND R4 R4 #0	; Else
		ADD R4 R4 #15
		ADD R4 R4 #15
		ADD R4 R4 #3
		JSR EQUALS
		BRnp #1
			ADD R1 R1 #7	; ST_FAIL
		
		ADD R7 R6 #0
		RET
		
ST_TRA
		ADD R6 R7 #0
		
		JSR INPUT
		
		LDR R4 R3 #15 ; P
		JSR EQUALS
		BRnp #1
			ADD R1 R1 #1	; ST_TRAP(35-34)
			
		LDR R4 R3 #26 ; \n
		JSR EQUALS
		BRnp #2
			JSR FAIL
			JSR START
			
		AND R4 R4 #0	; Else
		ADD R4 R4 #15
		ADD R4 R4 #15
		ADD R4 R4 #4
		JSR EQUALS
		BRnp #1
			ADD R1 R1 #6	; ST_FAIL
		
		ADD R7 R6 #0
		RET
		
ST_TRAP
		ADD R6 R7 #0
		
		JSR INPUT
		
		LDR R4 R3 #26 ; \n
		JSR EQUALS
		BRnp #4
			AND R5 R5 #0
			ADD R5 R5 #15
			JSR PRINT
			JSR START
			
		AND R4 R4 #0	; Else
		ADD R4 R4 #15
		ADD R4 R4 #15
		ADD R4 R4 #5
		JSR EQUALS
		BRnp #1
			ADD R1 R1 #5	; ST_FAIL
		
		ADD R7 R6 #0
		RET

ST_Q
		ADD R6 R7 #0
		
		JSR INPUT
		
		LDR R4 R3 #20 ; U
		JSR EQUALS
		BRnp #1
			ADD R1 R1 #1	; ST_QU(37-36)
			
		LDR R4 R3 #26 ; \n
		JSR EQUALS
		BRnp #2
			JSR FAIL
			JSR START
			
		AND R4 R4 #0	; Else
		ADD R4 R4 #15
		ADD R4 R4 #15
		ADD R4 R4 #2
		JSR EQUALS
		BRnp #1
			ADD R1 R1 #4	; ST_FAIL
		
		ADD R7 R6 #0
		RET
		
ST_QU
		ADD R6 R7 #0
		
		JSR INPUT
		
		LDR R4 R3 #8 ; I
		JSR EQUALS
		BRnp #1
			ADD R1 R1 #1	; ST_QUI(38-37)
			
		LDR R4 R3 #26 ; \n
		JSR EQUALS
		BRnp #2
			JSR FAIL
			JSR START
			
		AND R4 R4 #0	; Else
		ADD R4 R4 #15
		ADD R4 R4 #15
		ADD R4 R4 #3
		JSR EQUALS
		BRnp #1
			ADD R1 R1 #3	; ST_FAIL
		
		ADD R7 R6 #0
		RET
		
ST_QUI
		ADD R6 R7 #0
		
		JSR INPUT
		
		LDR R4 R3 #19 ; T
		JSR EQUALS
		BRnp #1
			ADD R1 R1 #1	; ST_QUIT(39-38)
			
		LDR R4 R3 #26 ; \n
		JSR EQUALS
		BRnp #2
			JSR FAIL
			JSR START
			
		AND R4 R4 #0	; Else
		ADD R4 R4 #15
		ADD R4 R4 #15
		ADD R4 R4 #4
		JSR EQUALS
		BRnp #1
			ADD R1 R1 #2	; ST_FAIL
		
		ADD R7 R6 #0
		RET
		
ST_QUIT
		ADD R6 R7 #0
		
		JSR INPUT
		
		LDR R4 R3 #26 ; \n
		JSR EQUALS
		BRnp #1
			HALT
			
		ADD R1 R1 #1	; ST_FAIL
		
		ADD R7 R6 #0
		RET

ST_FAIL
		ADD R6 R7 #0
		
		JSR INPUT
		
		LDR R4 R3 #26 ; \n
		JSR EQUALS
		BRnp #2
			JSR FAIL
			JSR START
		
		ADD R7 R6 #0
		RET

		.END
