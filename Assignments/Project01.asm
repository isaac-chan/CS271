TITLE Integer Arithmetic     (Project00.asm)

; Author: Isaac Chan
; Course / Project ID : Project 1                Date: 6/24/15
; Description:  This program will display my name and program title to the screen,
;	display instructions for the user, prompt the user to enter two numbers, calculate the sum, difference,
;   product, integer quotient and remainder of the numbers, and display a terminating message.

INCLUDE Irvine32.inc

.data
intro_1					BYTE	"Integer Arithmetic by Isaac Chan", 0
intro_2					BYTE    "Enter 2 numbers and I'll display the sum, difference, product, quotient, and remainder.", 0
EC1						BYTE	"EC1: Repeat until the user chooses to quit.", 0
EC2						BYTE	"EC2: Program verifies second number is less than first.", 0
EC3						BYTE	"EC3: Calculate and display the quotient as a floating-point number, rounded to the nearest .001. *IT DOESN'T DISPLAY TO .001 AND ISN'T ROUNDED*", 0
prompt_1				BYTE	"Enter your first number: ", 0
number_1				DWORD   ?
prompt_2				BYTE	"Enter your second number: ", 0
number_2				DWORD   ?
number_check			BYTE	"The second number must be less than the first!", 0
zero_check				BYTE	"You cannot divide by 0!", 0
result_sum				DWORD   ?
result_difference		DWORD	?
result_product			DWORD	?
result_quotient			DWORD	?
result_remainder		DWORD	?
quotient_temp			DWORD	?
result_floatquotient	REAL4	?
result_float1			REAL4	?
result_float2			REAL4	?
display_sum				BYTE	" + ", 0
display_difference		BYTE	" - ", 0
display_product			BYTE	" x ", 0
display_quotient		BYTE	" / ", 0    ;try to get ÷ to work
display_remainder		BYTE	" remainder ", 0
display_equals			BYTE	" = ", 0
continue				BYTE	"Do you want to continue (0 no, 1 yes)", 0
continue_answer			DWORD	?
goodBye					BYTE	"Bye...", 0
	
.code
main PROC

;Introduce programmer and instructions
	mov		edx, OFFSET intro_1
	call	WriteString
	call	CrLf
	mov		edx, OFFSET intro_2
	call	WriteString
	call	CrLf
	mov		edx, OFFSET EC1
	call	WriteString
	call	CrLf
	mov		edx, OFFSET EC2
	call	WriteString
	call	CrLf
	mov		edx, OFFSET EC3
	call	WriteString
	call	CrLf
	call	CrLf
	
;Get 1st number
Program_start:
	mov		edx, OFFSET prompt_1
	call	WriteString
	call	ReadInt
	mov		number_1, eax

;Get 2nd number
	mov		edx, OFFSET prompt_2
	call	WriteString
	call	ReadInt
	mov		number_2, eax
	call	CrLf

;Check number_2 is not 0
	mov		eax, number_2
	.if		number_2==0
			mov		edx, OFFSET zero_check
			call	WriteSTring
			call	CrLf
			exit
	.else
			.endif

;Check that number_1 is larger than number_2
	mov		eax, number_1
	mov		ebx, number_2
	Check:
		.if			eax < ebx
			mov		edx, OFFSET number_check
			call	WriteString
			call	CrLf
			exit
		.else
			.ENDIF

;Calculate sum
	mov		eax, number_1
	add		eax, number_2
	mov		result_sum, eax

;Calculate difference
	mov		eax, number_1
	sub		eax, number_2
	mov		result_difference, eax

;Calculate product
	mov		eax, number_1
	mov		ebx, number_2
	mul		ebx
	mov		result_product, eax

;Calculate quotient
	mov		eax, number_1
	cdq
	mov		ebx, number_2
	div		ebx
	mov		result_quotient, eax

;Calculate remainder
	mov		eax, number_2
	mov		ebx, result_quotient
	mul		ebx
	mov		quotient_temp, eax
	mov		eax, number_1
	sub		eax, quotient_temp
	mov		result_remainder, eax

;Convert to float (REAL8) then store.
	fld		number_1
	fst		result_float1
	fld		number_2
	fst		result_float2
	fld		result_float2
	fld		ST
	fld		result_float1
	fdiv	ST, ST(1)
	fst		result_floatquotient

;Report sum
	mov		eax, number_1
	call	WriteDec
	mov		edx, OFFSET display_sum
	call	WriteString
	mov		eax, number_2
	call	WriteDec
	mov		edx, OFFSET display_equals
	call	WriteString
	mov		eax, result_sum
	call	WriteDec
	call	CrLf

;Report difference
	mov		eax, number_1
	call	WriteDec
	mov		edx, OFFSET display_difference
	call	WriteString
	mov		eax, number_2
	call	WriteDec
	mov		edx, OFFSET display_equals
	call	WriteString
	mov		eax, result_difference
	call	WriteDec
	call	CrLf

;Report product
	mov		eax, number_1
	call	WriteDec
	mov		edx, OFFSET display_product
	call	WriteString
	mov		eax, number_2
	call	WriteDec
	mov		edx, OFFSET display_equals
	call	WriteString
	mov		eax, result_product
	call	WriteDec
	call	CrLf

;Report quotient
	mov		eax, number_1
	call	WriteDec
	mov		edx, OFFSET display_quotient
	call	WriteString
	mov		eax, number_2
	call	WriteDec
	mov		edx, OFFSET display_equals
	call	WriteString
	mov		eax, result_quotient
	call	WriteDec

;Report remainder
	mov		edx, OFFSET display_remainder
	call	WriteString
	mov		eax, result_remainder
	call	WriteDec
	call	CrLf

;Report float quotient
	mov		eax, number_1
	call	WriteDec
	mov		edx, OFFSET display_quotient
	call	WriteString
	mov		eax, number_2
	call	WriteDec
	mov		edx, OFFSET display_equals
	call	WriteString
	mov		eax, result_floatquotient
	call	WriteFloat
	call	CrLf

;Do you want to continue
	mov		edx, OFFSET continue
	call	WriteString
	call	ReadInt
	mov		eax, continue_answer
	jnz		Program_start

;Say "Good-bye"
	mov		edx, OFFSET goodBye
	call	WriteString
	call	CrLf

	exit	; exit to operating system
main ENDP

END main