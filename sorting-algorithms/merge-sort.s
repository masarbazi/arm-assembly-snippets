; Merge Sort using ARM Assembly
; inputs: 
; 1. Enter array you want to be sorted on line 190 ( DATA label )
; 2. Enter length of array on line 25 ( MOV		LENGTH, #<enter legnth here> )


ArrayAdr	EQU			0x20000000
SplitedArr	EQU			0x20000100
LeftArray	EQU			0x20000200
RightArray	EQU			0x20000300
StackStart	EQU			0x20001000


LENGTH		RN 			R12



			AREA		mergeSort, CODE, READONLY
			ENTRY
			EXPORT		__main
				
				
__main
			; initialization
			MOV		LENGTH, #6			; enter array length
			LDR		SP, =StackStart
			; loading data array to memory address of 0x20000000 (defined memory address at first instruction)
			ADR		R0, DATA
			LDR		R1, =ArrayAdr
			MOV		R3, LENGTH
InitArray	
			LDR		R2, [R0]
			STR		R2, [R1], #4;
			ADD		R0, R0, #4;
			SUBS	R3, #1;
			BGT		InitArray
			; end loading data
			LDR		R4, =SplitedArr	; splited arrays left right index will be stored as array in this address. consider R4 as pointer
			MOV		R0, #0			; initial left 
			SUB		R1, LENGTH, #1	; initial right
			PUSH	{R0, R1}
			STMIA	R4, {R0, R1}
			ADD		R4, R4, #8
SORT		; ARRAY will be splited to small parts
			POP		{R0, R1}
			; R2 => used to calc and store middle
			ADD		R2, R0, R1
			MOV		R3, #2
			UDIV	R2, R2, R3
			; if (middle != left)
			CMP		R0, R2
			BEQ		SkipLSide		; skip storing {left, middle}
			PUSH 	{R0, R2}
			STMIA	R4, {R0, R2}
			ADD		R4, R4, #8
SkipLSide
			ADD		R2, R2, #1
			; if (middle + 1 != right)
			CMP		R2, R1
			BEQ		SkipRSide		; skip storing {middle, right}
			; {R2, R1} will be stored as {R1, R2}. so stored R1 in R3 to get stored after R2
			MOV		R3, R1
			PUSH 	{R2, R3}
			STMIA	R4, {R2, R3}
			ADD		R4, R4, #8
SkipRSide	
			LDR		R0, =StackStart
			CMP		SP, R0
			BNE		SORT
			;SUB		R4, R4, #4		; R4 pointing to the last element of splited arrays indexs
			
MERGE		; merge splited arrays
			; R0 -> snippet start, R1 -> snippet end, R2 -> snippet middle
			LDMDB	R4, {R0, R1}	; pop splited arrays from last index to first
			SUB		R4, R4, #8
			ADD		R2, R0, R1
			MOV		R3, #2
			UDIV	R2, R2, R3		; middle ready
			; R5 -> left array counter, R6 -> right array counter
			SUB		R5, R2, R0
			ADD		R5, R5, #1
			SUB		R6, R1, R2		; counters ready
			; turn indexes to addresses
			MOV		R3, #4
			MUL		R0, R0, R3
			MUL		R1, R1, R3
			MUL 	R2, R2, R3
			LDR		R3, =ArrayAdr
			ADD		R0, R0, R3
			ADD		R1, R1, R3
			ADD		R2, R2, R3		; addresses ready
			; load left array
			; R7 as index
			MOV		R7, #0
			LDR		R8, =LeftArray
LoadLeft	
			CMP		R7, R5			; till index == left array size
			BEQ		BreakLoadLeft
			MOV		R10, #4
			MUL		R9, R7, R10
			ADD		R9, R9, R0		; add index value to left address
			LDR		R10, [R9]
			STR		R10, [R8]
			ADD		R7, R7, #1
			ADD		R8, R8, #4
			B		LoadLeft
BreakLoadLeft
			MOV		R7, #0
			LDR		R8, =RightArray
LoadRight
			CMP		R7, R6
			BEQ		BreakLoadRight
			MOV		R10, #4
			MUL		R9, R7, R10
			ADD		R9, R9, #4
			ADD		R9, R9, R2		; add index value to middle address
			LDR		R10, [R9]
			STR		R10, [R8]
			ADD		R7, R7, #1
			ADD		R8, R8, #4
			B		LoadRight
BreakLoadRight
			
			; merge with priority 
			MOV		R10, #0			; I counter
			MOV		R11, #0			; J counter
MergeSnippets
			CMP		R10, R5			; while ( i < n1 && j < n2 )
			BEQ		BreakMergeSnippets
			CMP		R11, R6
			BEQ 	BreakMergeSnippets		
			LDR		R8, =LeftArray	; loading Left array item
			MOV		R7, #4
			MUL		R3, R10, R7
			ADD		R3, R3, R8		; R3 holds the left array item address
			LDR		R3, [R3]		; R3 holds the left array item value
			PUSH 	{R3}			; store left item in stack
			LDR		R8, =RightArray	; loading Right array item
			MOV		R7, #4
			MUL		R3, R11, R7
			ADD		R3, R3, R8		; R3 holder the right array item address
			LDR		R3, [R3]		; R3 holds the right array item value
			PUSH 	{R3}			; store right item in stack
			; compare right and left items
			POP 	{R7, R8}		; R7 == right item && R8 == left item
			CMP		R7, R8
			BLT		StoreRightItem
StoreLeftItem						; ( right >= left )
			STR		R8, [R0], #4	; store left item to main array and increament index after
			ADD		R10, #1			; I++
			B		MergeSnippets
StoreRightItem						; ( right < left )
			STR		R7, [R0], #4	; store right item to main array and increament index after
			ADD		R11, #1			; J++
			B		MergeSnippets
			
BreakMergeSnippets
			
CopyLeft	; copy remaining elements of left array if any
			CMP		R10, R5
			BEQ		BreakCopyLeft
			MOV		R3, #4
			MUL		R7, R10, R3
			LDR		R3, =LeftArray
			ADD		R7, R7, R3			; R7 holds the address of remained item
			LDR		R7, [R7]			; R7 holds the value of remained item
			ADD		R10, #1				; I++
			STR		R7, [R0], #4		; store remained value in main array and increament. K++
			B		CopyLeft
BreakCopyLeft

CopyRight	; copy remaining elements of right array if any
			CMP		R11, R6
			BEQ		BreakCopyRight
			MOV		R3, #4
			MUL		R7, R11, R3
			LDR		R3, =RightArray
			ADD		R7, R7, R3			; R7 holds the address of remained item
			LDR		R7, [R7]			; R7 holds the value of remained item
			ADD		R11, #1				; J++
			STR		R7, [R0], #4		; sotre remained value in main array and increament. K++
			B		CopyRight
BreakCopyRight
			
			LDR		R7, =SplitedArr
			CMP		R4, R7				; all items in splited array have been checked
			BNE		MERGE
			
					
			
DATA		DCD		19, 12, 13, 5, 6, 7 	; enter array you wanna sort
STOP		B		STOP

			END
			
; This code is contributed by Mohammad Amin Sarbazi
			