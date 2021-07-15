; convert your pow 3 equation to standard mode like ( x^3 + Ax^2 + Bx + C = 0 )
; then enter A,B,C as inputs and get results on S10, S11, S12 registers

; inputs: 
; enter A coefficient on line 43
; enter B coefficient on line 44
; enter C coefficient on line 45
; ***this code also contains a .c file***


;A ==> S0
;B ==> S1
;C ==> S2
;P ==> S3
;Q ==> S4
;DELTA ==> S5
; S10 ==> Root1
; S11 ==> Root2
; S12 ==> Root3

		AREA		powThreeEq, CODE, READONLY
		IMPORT 		input
		IMPORT		result
		IMPORT		calcCbrt
		IMPORT 		a
		IMPORT 		p
		IMPORT 		q
		IMPORT 		x1
		IMPORT 		x2
		IMPORT 		x3
		IMPORT		calcNegDelta
		ENTRY
		EXPORT __main
			
			
__main
		; ENABLE FPU
		LDR		R0, =0xE000ED88				; enable FPU
		LDR		R1, [R0]
		ORR		R1, R1, #(0xF << 20)		; ENABLE CP10 , CP11
		STR		R1, [R0]
		
		; enter A, B, C
		VLDR.F	S0, =0.0			; enter A
		VLDR.F	S1, =0.0			; enter B
		VMOV.F	S2, #5.0			; enter C
		
		; P = B - (A^2 / 3)
		VMUL.F	S3, S0, S0
		VMOV.F	S20, #3.0			; S20 used as temp register
		VDIV.F	S3, S3, S20
		VSUB.F	S3, S1, S3			; S3 ready 
		
		; Q = (2.A^3 / 27) - (AB / 3) + C
		VMUL.F	S6, S0, S1			; A*B
		VMOV.F	S20, #3.0			; S20 used as temp register
		VDIV.F	S6, S6, S20		; S6 = (AB / 3)
		VMUL.F	S4, S0, S0
		VMUL.F	S4, S4, S0			; A^3 in S4
		VMOV.F	S20, #2.0			; S20 used as temp register
		VMUL.F	S4, S4, S20			; 2*A^3 in S4
		VMOV.F	S20, #2.0			; S20 used as temp register
		VDIV.F	S4, S4, S20			; S4 = (2.A^3 / 27)
		VADD.F	S4, S4, S2			; S4 = (2.A^3 / 27) + C
		VADD.F	S4, S4, S6			; S4 = (2.A^3 / 27) - (AB / 3) + C
									; S4 ready
		
		; S3 and S4 ready
		; FINDING Delta
		VMUL.F	S6, S4, S4
		VMOV.F	S20, #4.0			; S20 used as temp register
		VDIV.F	S6, S6, S20
		VMUL.F	S5, S3, S3
		VMUL.F	S5, S5, S3
		VMOV.F	S20, #27.0			; S20 used as temp register
		VDIV.F	S5, S5, S20
		VADD.F	S5, S5, S6			; Delta(s5) = (S4^2 / 4) + (S3^3 / 27)
		
		
		
		; find answers based on Delta
		VCMP.F	S5, #0
		BEQ		DeltaZero
		BLT		DeltaNeg
		; else DELTA > 0
		; if S5 is positive there will be one answer Root1
		; X = cbrt( -S4/2 + SQRT(S5)) + cbrt(-S4/2 - SQRT(S5)) - A/3
		LDR		R0, =input
		LDR		R1, =result
		VSQRT.F	S5, S5
		VMOV.F	S20, #2.0			; S20 used as temp register here
		VDIV.F	S20, S4, S20		; (Q/2) stored in S20
		VNEG.F	S20, S20
		VADD.F	S6, S20, S5		; (-S4/2 + sqrt(S5)) stored in S6
		VSUB.F	S7, S20, S5		; (-S4/2 - sqrt(S5)) stored in S7
		VSTR.F	S6, [R0]			; store S6 value in input variable
		BL		calcCbrt			; calculate cube root of S6
		VLDR.F	S6, [R1]			; load result of cude root from result variable (R1 poiting to result variable)
		VSTR.F	S7, [R0]
		BL		calcCbrt
		VLDR.F	S7, [R1]
		VADD.F	S10, S6, S7			; (-S4/2 + SQRT(S5)) + (-S4/2 - SQRT(S5)) 
		VMOV.F	S20, #3.0			; S20 used as temp register
		VDIV.F	S20, S0, S20		; (A/3) ==> S20
		VSUB.F	S10, S10, S20		; cbrt( -S4/2 + SQRT(S5)) + cbrt(-S4/2 - SQRT(S5)) - A/3
		; final answer stored in S10
		B		STOP
		
		
DeltaNeg	; if S5 is negative there will be three answers Root1, Root2, Root3
		LDR		R0, =a
		LDR		R1, =p
		LDR		R2, =q
		LDR		R3, =x1
		LDR		R4, =x2
		LDR		R5, =x3
		VSTR.F	S0, [R0]
		VSTR.F	S3, [R1]
		VSTR.F	S4, [R2]
		BL		calcNegDelta
		VLDR.F	S10, [R3]
		VLDR.F	S11, [R4]
		VLDR.F	S12, [R5]
		B		STOP
		
		
		
DeltaZero	; if S5 is zero there will be three answers Root1, and Root2 == Root3
		; x1 = -2 * cbrt(S4/2) - (a/3) && x2 = x3 = cbrt(S4/2) - (a/3)
		VMOV.F	S20, #2.0			; S20 used as temp register
		VDIV.F	S6, S4, S20			; S4/2
		LDR		R0, =input
		LDR		R1, =result
		VSTR.F	S6, [R0]			; store S6 value in variable input (R0 pointing to that variable address)
		BL		calcCbrt			; find S6 cube root. result will be stored in result variable which R1 is pointing to its address
		VLDR.F	S6, [R1]			; load S6 from result variable
		VMOV.F	S20, #-2.0			; S20 used as temp register
		VMUL.F	S6, S6, S20			; -2 * cbrt(S4/2)
		VMOV.F	S20, #3.0			; S20 used as temp register
		VDIV.F	S20, S0, S20		; (a/3)
		VSUB.F	S10, S6, S20		; -2 * cbrt(S4/2) - (a/3) ==> Root1 stored in S10
		; finding Root2 and Root3
		VMOV.F	S6, #2.0			; S20 used as temp variable
		VDIV.F	S6, S4, S6			; (S4/2)
		VSTR.F	S6, [R0]			; store (S4/2) in input variable
		BL		calcCbrt			; calculate Cube Root for S6 value
		VLDR.F	S6, [R1]			; load result to S6 from result variable
									; S20 already equals (a/3)
		VSUB.F	S11, S6, S20		; cbrt(S4/2) - (a/3) will be stored in S11 ==> Root2 answer
		VMOV.F	S12, S11			; Root3 equals Root2 
		
		
		
STOP	B		STOP
		END




