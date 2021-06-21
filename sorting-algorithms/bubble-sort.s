; Bubble Sort using ARM Assembly
; inputs: 
; 1. Enter the array you want to be sorted on line 66 (DATA label)
; 2. Enter length of array on line 23 ( MOV  LENGTH, #<array_len> )


ARRAY		EQU		0x20000000
POINTER		RN 		R0
PRE			RN		R1
POST		RN		R2
CTRJ		RN		R3
CTRI		RN		R4
LENGTH		RN		R5


			AREA 		myCode, CODE, READONLY
			ENTRY
			EXPORT		__main


__main
			; initialization
			MOV		LENGTH, #7			; enter array length
			; loading data array to memory address of 0x20000000 (defined memory address at first instruction)
			ADR		R6, DATA
			LDR		R7, =ARRAY
			MOV		R9, LENGTH
InitArray	
			LDR		R8, [R6]
			STR		R8, [R7], #4;
			ADD		R6, R6, #4;
			SUBS	R9, #1;
			BGT		InitArray
			; end loading data
			
			SUB		LENGTH, LENGTH, #1 		; what ever the length is we are gonna iterate one less 
			MOV		CTRI, LENGTH			; outer loop counter
LP1			
			CBZ		CTRI, STOP				; if true ==> outer loop end
			MOV		CTRJ, LENGTH			; inner loop counter
			LDR		POINTER, =ARRAY			; load memory address (data stored in this address)
			
LP2			
			LDR		PRE, [POINTER]			; load value from RAM to compare with next value
			LDR		POST, [POINTER, #4]		; next value (this is how bubble sorting works, comparing two values next to eachother:) )
			CMP 	PRE, POST				
			BLT		CNTULP2
			; DO SWAP
			MOV		R6, POINTER
			STR		POST, [R6]
			STR		PRE, [R6, #4]
			
CNTULP2		; continue inner loop
			ADD 	POINTER, POINTER, #4
			SUB		CTRJ, CTRJ, #1
			CBZ		CTRJ, CNTULP1
			B		LP2

CNTULP1		; continue outer loop
			SUB		CTRI, CTRI, #1
			CBZ		CTRI, STOP
			B		LP1
			
			
DATA		DCD		2, 3, 43, 56, 34, 55, 12 ; enter array you wanna sort
STOP		B		STOP

			END
			
; This code is contributed by Mohammad Amin Sarbazi



















