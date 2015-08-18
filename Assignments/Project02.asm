TITLE Fibonacci Numbers     (Project02.asm)

; Author: Isaac Chan
; Course / Project ID : Project 2              Date: 7/1/2015
; Description:  This program will introduce the programmer, get the user's name, take the user's desired starting number, 
; print the corresponding numbers as per the Fibonacci pattern, and say goodbye.

INCLUDE Irvine32.inc

UPPER_LIMIT = 46
LINE_DISPLAY = 5

.data
userName		BYTE	33 DUP(0)
userNum			DWORD	?
intro_1			BYTE	"Fibonacci Numbers", 0
intro_2			BYTE	"By Isaac Chan", 0
prompt_1		BYTE	"What's your name? ", 0
prompt_2		BYTE	"Enter the number of Fibonacci terms to be displayed.", 0
prompt_3		BYTE	"Give the number as an integer in the range [1 .. 46].", 0
prompt_4		BYTE	"How many Fibonacci terms do you want? ", 0
prompt_invalid	BYTE	"Out of range. Enter a number in [1 .. 46]", 0
result			DWORD	?
space			BYTE	"     ", 0

ecxSave_1		DWORD	?
temp			DWORD	1
temp_result1	DWORD	?
temp_result2	DWORD	1

bye_prompt1		BYTE	"Results certified by Isaac Chan.", 0
bye_prompt2		BYTE 	"Bye, ", 0

.code
main PROC

;Introduce programmer
	mov		edx, OFFSET intro_1
	call	WriteString
	call	CrLf
	mov 	edx, OFFSET intro_2
	call	WriteString
	call	CrLf

;Get user name
	mov		edx, OFFSET prompt_1
	call	WriteString
	mov		edx, OFFSET userName
	mov		ecx, 32
	call	ReadString

;Display instructions
	mov 	edx, OFFSET prompt_2
	call	WriteString
	call	CrLf
	mov 	edx, OFFSET prompt_3
	call	WriteString
	call	CrLf

;Get user number
getNum:
	mov 	edx, OFFSET prompt_4
	call	WriteString
	call	ReadInt
	mov		userNum, eax

;Verify userNum is less than or equal to 46 in post-test loop
verifyLoop:
	mov		eax, userNum
	cmp		eax, UPPER_LIMIT
	jg		tooBig
	jle		goodInt
tooBig:
	mov		edx, OFFSET prompt_invalid
	call	WriteString
	call	CrLf
	call	getNum
goodInt:
	
;Print Fibonacci sequence  (working, 5 per line)
	mov		ecx, userNum
    mov		eax, 0   						;a = 0
    mov		ebx, 1    	 					;b = 1
	mov		temp_result1, eax				;temp1 = a
	mov		temp_result2, ebx				;temp2 = b
	
fibonacci:  				;outer loop
	cmp		ecx, 0
    je		fibonacciDone					;check if done
	mov		eax, temp_result1				;eax = a
	mov		ebx, temp_result2				;ebx = b
    mov		edx, eax						;edx = a
    add		edx, temp_result2				;edx = a + b
    mov		eax, ebx						;a = b
    mov		ebx, edx						;b = sum
	mov		temp_result1, eax				;save temp1 (a)
	mov		temp_result2, ebx				;save temp2 (b)
	.if		ecx > 0
		jmp		lineDisplay
	.else
		jmp		fibonacciDone				;failsafe
		.ENDIF
		
lineDisplay: 				;inner loop
	mov		edx, OFFSET	temp_result2
	call	WriteInt
	mov		edx, OFFSET space
	call	WriteString
	mov		ebx, temp						;temp = 1
    cmp		ebx, LINE_DISPLAY				;cmp 0 to 5
    je		lineDisplayDone					;if equals = next line function
    inc		ebx								;++
	mov		temp, ebx						;save temp value
	loop	fibonacci
	jmp		fibonacci
	
lineDisplayDone:
	call	CrLf
	mov 	temp, 1
    loop	fibonacci
	
fibonacciDone:	
	
;Say "Good-bye"
	call	CrLf
	mov		edx, OFFSET bye_prompt1
	call	WriteString
	call 	CrLf
	mov		edx, OFFSET bye_prompt2
	call	WriteString
	mov		edx, OFFSET userName
	call 	WriteString
	call	CrLf

	exit	; exit to operating system
main ENDP

END main