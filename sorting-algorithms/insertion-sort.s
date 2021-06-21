; Insertion Sort using ARM Assembly
; inputs: 
; 1. Enter the array you want to be sorted on line 66 (DATA label)
; 2. Enter length of array on line 23 ( MOV  LENGTH, #<array_len> )


ARRAY		EQU		0x20000000
KEY			RN 		R0
OUTER		RN		R1
INNER		RN		R2
CTRI		RN		R3
CTRJ		RN		R4
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
			
			LDR		OUTER, =ARRAY
			ADD		OUTER, OUTER, #4	; OUTER initial value: address of index 1
			MOV		CTRI, #1			; outer loop counter
LP1			
			CMP		CTRI, LENGTH
			BEQ		STOP				; loop till CTRI < LENGTH
			LDR		KEY, [OUTER]
			SUB		INNER, OUTER, #4
			SUB		CTRJ, CTRI, #1
			
LP2			
			; while( ctrj >=0 #1 && array[ctrj] > key )
			CMP		CTRJ, #0	; #1
			BLT		CNTULP1
			LDR		R6, [INNER]	; #2 	| R6 = array[crtj]
			CMP		R6, KEY
			BLS		CNTULP1
			; else condition == true
			STR		R6, [INNER, #4]
			B		CNTULP2
			
CNTULP2		; continue inner loop
			SUB		INNER, INNER, #4
			SUB		CTRJ, CTRJ, #1
			B		LP2

CNTULP1		; continue outer loop
			STR		KEY, [INNER, #4]
			ADD		OUTER, OUTER, #4
			ADD		CTRI, CTRI, #1
			B		LP1
			

			
			
DATA		DCD		2, 3, 43, 56, 34, 55, 12 ; enter array you wanna sort
STOP		B		STOP

			END
			
; This code is contributed by Mohammad Amin Sarbazi
