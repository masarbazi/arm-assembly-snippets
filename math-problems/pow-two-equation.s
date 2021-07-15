; inputs:
; line 24 ==> A coefficient
; line 25 ==> B coefficient
; line 26 ==> C coefficient

;X1			RN		S0
;X2			RN		S1
;X3			RN		S2
;DELTA		RN		S3
;ROOT1		RN		S4
;ROOT2		RN		S5

			AREA	powTwoEq, CODE, READONLY
			ENTRY
			EXPORT	__main
				
				
__main
			LDR		R0, =0xE000ED88				; enable FPU (floating point unit)
			LDR		R1, [R0]
			ORR		R1, R1, #(0xF << 20)		; ENABLE CP10 , CP11
			STR		R1, [R0]
			
			VMOV.F	S0, #1.0					; input: enter A
			VMOV.F	S1, #5.0					; input: enter B
			VMOV.F	S2, #4.0					; input: enter C
			; roots for these inputs should be (-1 && -4) stored in S4 and S5
			
			; calculating delta
			VMUL.F	S3, S1, S1
			VMOV.F	S6, #4.0			; 4 is one of the operands to calculate delta value
			VMUL.F	S6, S6, S0
			VMUL.F	S6, S6, S2
			VSUB.F	S3, S3, S6			; DELTA(S3) = B^2 - 4AC
			; precalculation of sqrt(delta) and -B which will be used in finding ROOTs
			VSQRT.F	S3, S3	
			VNEG.F	S1, S1				; x2 = -x2
			VMOV.F	S6, #2.0
			VMUL.F	S0, S0, S6			; S0 = S0 * 2
			VCMP.F	S3, #0				; compare delta with 0
			BLT		STOP				; delta less than 0 => branch to stop (end program)
			BEQ		FINDONE				; delta == 0 => branch to FindOne
			; FIND TWO					; else (delta > 0) => find two 
			VADD.F	S4, S1, S3
			VDIV.F	S4, S4, S0			; done with ROOT1
			VSUB.F	S5, S1, S3
			VDIV.F	S5, S5, S0			; done with ROOT2
			B		STOP				; end program

FINDONE
			VADD.F	S4, S1, S3
			VDIV.F	S4, S4, S0			; done with ROOT1
			B		STOP				; end program

STOP		B		STOP
			END
				
; This code is contributed by Mohammad Amin Sarbazi