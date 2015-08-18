TITLE Integer Accumulator     (Project03.asm)

; Author: Isaac Chan
; Course / Project ID : Project 3              Date: 7/8/2015
; Description:  This program will introduce the programmer, get the user's name, prompt the user to enter numbers
;				until they enter a number outside of the bounds, and display some messages about their numbers.

INCLUDE Irvine32.inc

LOWER_LIMIT = -100
UPPER_LIMIT = -1

.data
userName		BYTE	33 DUP(0)
userNum			SDWORD	?
intro_1			BYTE	"Integer Accumulator by Isaac Chan", 0
intro_2			BYTE	"EC1: Number the lines during user input.", 0
intro_3			BYTE	"EC2: Calculate and display the average as a floating-point number, rounded to the nearest .001. ****EASILY OVERFLOWS****", 0
prompt_1		BYTE	"What's your name? ", 0
prompt_2		BYTE	"Hello, ", 0
prompt_3		BYTE	"Please enter numbers in [-100, -1].", 0
prompt_4		BYTE	"Enter a non-negative number when you are finished to see results.", 0
prompt_5		BYTE	"Enter number ", 0
prompt_6		BYTE	"You entered ", 0
prompt_7		BYTE	" valid numbers.", 0
prompt_8		BYTE	"The sum of your valid numbers is ", 0
prompt_9		BYTE	"The rounded average is ", 0
prompt_10		BYTE	"The float average is ", 0
colon			BYTE	": ", 0
period			BYTE	".", 0

prompt_invalid1	BYTE	"Out of range. Enter a number in [-100, -1]", 0
prompt_invalid2	BYTE	"Try inputting some numbers!", 0
num_count		SDWORD 	?
sum_count		SDWORD	?
average			SDWORD	?

float_num_count	REAL8	?
float_sum_count	REAL8	?
float_average	REAL4	?

bye_prompt1		BYTE	"Thanks for using the Integer Accumulator.", 0
bye_prompt2		BYTE 	"Bye, ", 0

.code
main PROC

;Introduce programmer
	mov		edx, OFFSET intro_1
	call	WriteString
	call	CrLf
	mov		edx, OFFSET intro_2
	call	WriteString
	call	CrLf
	mov		edx, OFFSET intro_3
	call	WriteString
	call	CrLf

;Get user name and say hi
	mov		edx, OFFSET prompt_1
	call	WriteString
	mov		edx, OFFSET userName
	mov		ecx, 32
	call	ReadString
	mov		edx, OFFSET prompt_2
	call	WriteString
	mov		edx, OFFSET userName
	call	WriteString
	mov		edx, OFFSET period
	call	WriteString
	call	CrLf

;Display instructions
instructions:
	mov 	edx, OFFSET prompt_3
	call	WriteString
	call	CrLf
	mov 	edx, OFFSET prompt_4
	call	WriteString
	call	CrLf
	call	CrLf

;Get numbers
	mov		num_count, 1
getNum:
	mov		edx, OFFSET prompt_5
	call	WriteString
	mov		eax, num_count
	call	WriteDec
	mov		edx, OFFSET colon
	call	WriteString
	call	ReadInt
	cmp		eax, LOWER_LIMIT
	JL		outOfRange
	cmp		eax, UPPER_LIMIT
	JG		timeToExit
	call	goodNum
	
goodNum:
	inc		num_count
	add		sum_count, eax
	dec		num_count
	call	getAverage
	
outOfRange:
	mov		edx, OFFSET prompt_invalid1
	call	WriteString
	call	CrLf
	call	getNum
	
getAverage:
	mov		eax, sum_count
	cdq
	mov		ebx, num_count
	idiv	ebx
	mov		average, eax

	
	fild	num_count			;num_count -> ST(0) ->ST(1)
	fst		float_num_count
	cdq
	fild	sum_count			;sum_count -> ST(0)
	fst		float_sum_count
	fdiv	ST(0), ST(1)		;ST(0) = num_count / sum_count
	fst		float_average		;ST(0) = float_average
	
	inc		num_count
	call	getNum
	
timeToExit:
	.if		num_count == 1
		mov		edx, OFFSET	prompt_invalid2
		call	WriteString
		call	CrLf
		call	CrLf
		call	instructions
	.else
		call	CrLf
		mov		edx, OFFSET prompt_6
		call	WriteString
		dec		num_count
		mov		eax, num_count
		call	WriteDec
		mov		edx, OFFSET prompt_7
		call	WriteString
		call	CrLf
		mov		edx, OFFSET prompt_8
		call	WriteString
		mov		eax, sum_count
		call	WriteInt
		mov		edx, OFFSET period
		call	WriteString
		call	CrLf
		mov		edx, OFFSET prompt_9
		call	WriteString
		mov		eax, average
		call	WriteInt
		mov		edx, OFFSET period
		call	WriteString
		call	CrLf
		mov		edx, OFFSET prompt_10
		call	WriteString
		;mov		eax, float_average
		call	WriteFloat
		mov		edx, OFFSET period
		call	WriteString
		call	CrLf
		call	CrLf
		mov		edx, OFFSET bye_prompt1
		call	WriteString
		call	CrLf
		mov		edx, OFFSET bye_prompt2
		call	WriteString
		mov		edx, OFFSET userName
		call	WriteString
		mov		edx, OFFSET period
		call	WriteString
		call	CrLf
		exit
		.ENDIF
	
main ENDP

END main