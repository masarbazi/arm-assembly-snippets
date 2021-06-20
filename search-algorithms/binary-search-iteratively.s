; Find result explaination:
; vlaue not found ==> you get -1 hex value in register R8
; value found ==> you get address of value in register R8

MIDVAL		RN			R7		; used for saving MIDDLE vlaue 
MIDDLE		RN			R8		; used for saving MIDDLE address
HEAD		RN			R9		; array head
BACK		RN			R10		; array last item | back
SIZE		RN			R11		; used for saving array size
VALUE		RN			R12		; used for saving value that you're searching for


			AREA			binarySearch, CODE, READONLY
			ENTRY
			EXPORT			__main
				
				
__main
				; initialization
				MOV			SIZE, #10			; enter ARRAY length
				MOV			VALUE, #13			; enter VALUE you wanna search for
				MOV			HEAD, #0
				MOV			BACK, #0			
				SUB			R0, SIZE, #1 		; R4 is used as offset of HEAD to set ARRAY BACK
				MOV			R1, #4
				MUL			R0, R0, R1
				ADR 		HEAD, ARRAY
				ADD			BACK, HEAD, R0		; HEAD and BACK pointers are initialized
SEARCH	
				BL			SETMIDDLE			; find MIDDLE of HEAD, BACK
				CMP			MIDDLE, HEAD
				BEQ			NOTFOUND
				LDR			MIDVAL, [MIDDLE]
				CMP			VALUE, MIDVAL
				BEQ			STOP				; VALUE == MIDVALUE
				BGT			GORIGHT				; VALUE > MIDVALUE
				B			GOLEFT				; VALUE < MIDVALUE


GORIGHT
				MOV.W		HEAD, MIDDLE
				B			SEARCH
				
GOLEFT
				MOV.W		BACK, MIDDLE
				B			SEARCH


SETMIDDLE		
				SUB			R0, BACK, HEAD
				MOV			R1, #4
				UDIV		R0, R0, R1
				MOV			R1, #2
				UDIV		R0, R0, R1
				MOV			R1, #4
				MUL			R0, R0, R1
				ADD			MIDDLE, HEAD, R0
				BX			LR
				
				
NOTFOUND		
				MOV			MIDDLE, #-1
				B			STOP
		

ARRAY			DCD			2, 12, 13, 23, 25, 30, 34, 41, 45, 54

STOP			B			STOP
				END

; This code is contributed by Mohammad Amin Sarbazi
