; Selection Sort using ARM Assembly
; inputs: 
; 1. Enter the array you want to be sorted on line 76 (DATA label)
; 2. Enter length of array on line 23 ( MOV  LENGTH, #<array_len> )


ARRAY		EQU		0x20000000
MINADR		RN 		R0
OUTER		RN		R1
INNER		RN		R2
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
			
			LDR		OUTER, =ARRAY			; load memory address (data stored in this address)
			SUB		LENGTH, LENGTH, #1 		; what ever the length is we are gonna iterate one less 
			MOV		CTRI, LENGTH			; outer loop counter
LP1			
			CBZ		CTRI, STOP				; if true ==> outer loop end
			BL		SetCTRJ					; inner loop counter	
			MOV		MINADR, OUTER
			ADD		INNER, OUTER, #4		; INNER initial value will be outer + 1
LP2			
			LDR		R7, [MINADR]			; min vlaue stored in R7
			LDR		R8, [INNER]				; inner value stored in R8
			CMP		R8, R7
			BGE		CNTULP2					
			; change MINADR value
			MOV		MINADR, INNER
			
CNTULP2		; continue inner loop
			ADD 	INNER, INNER, #4
			SUBS	CTRJ, CTRJ, #1
			BLS		CNTULP1
			B		LP2

CNTULP1		; continue outer loop
			; swap found minimum with first value
			LDR		R6, [MINADR]
			LDR		R7, [OUTER]
			STR		R6, [OUTER]
			STR		R7, [MINADR]
			SUB		CTRI, CTRI, #1
			ADD		OUTER, OUTER, #4
			CBZ		CTRI, STOP
			B		LP1
			
			
SetCTRJ 	; set inner loop counter based on outer counter
			MOV		R6, CTRI
			SUB		R6, R6, #1
			MOV		CTRJ, R6
			BX		LR
			
DATA		DCD		2, 3, 43, 56, 34, 55, 12 ; enter array you wanna sort
STOP		B		STOP

			END
			
; This code is contributed by Mohammad Amin Sarbazi
