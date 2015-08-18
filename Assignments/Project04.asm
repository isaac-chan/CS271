TITLE Composite Numbers     (Project04.asm)

; Author: Isaac Chan
; Course / Project ID : Project 4              Date: 7/21/2015
; Description:  This program will introduce the program, prompt the user to enter the number of composite numbers they'd like to see,
;				validate the number to ensure it is within the bounds, calculate and display the composite numbers, and say bye.

INCLUDE Irvine32.inc

LOWER_LIMIT = 1
UPPER_LIMIT = 400
LINE_DISPLAY = 10
LINE_DISPLAY2 = 5		;change this depending on how many numbers per line for page display
PAGE_DISPLAY = 110		;change this depending on how many numbers to view per page

.data
intro_1			BYTE	"Composite Numbers: written by Isaac Chan", 10, 13, 0
extra_1			BYTE	"EC1: Output columns are aligned.", 10, 13, 0
extra_2			BYTE	"EC2: User can request to view more numbers, printed to pages.", 10, 13, 0
extra_2_note1	BYTE	"EC2 NOTE: I specifically decided not to use 'press any key to continue'", 10, 13, 0
extra_2_note2	BYTE	"          because the user would have no way to exit.", 10, 13, 0
intro_2			BYTE	"Enter the number of composite numbers you would like to see.", 10, 13, 0
intro_3			BYTE	"You can get up to 400 composites.", 10, 13, 0
prompt_1		BYTE	"Please enter a number within [1...400]: ", 0

prompt_invalid	BYTE	"Out of range. ", 0
prompt_invalid2	BYTE	"Enter a valid key.", 0
prompt_continue1	BYTE	"Want to continue? (0 for no, 1 for yes)", 10, 13, 0
bye_prompt1		BYTE	"Numbers certified by Isaac Chan. ", 0
bye_prompt2		BYTE 	"Bye.", 10, 13, 0

userInput		DWORD	?

spaces5			BYTE	"     ", 0
spaces4			BYTE	"    ", 0
spaces3			BYTE	"   ", 0
spaces2			BYTE	"  ", 0
spaces1			BYTE	" ", 0
userNum			DWORD	?
numCount		DWORD	0
tempNumCount	DWORD	0
checkNum		DWORD	2
numToTest		DWORD	4

.code
intro PROC		;introduce program and show directions
	mov		edx, OFFSET intro_1
	call	WriteString
	mov		edx, OFFSET extra_1
	call	WriteString
	mov		edx, OFFSET extra_2
	call	WriteString
	mov		edx, OFFSET extra_2_note1
	call	WriteString
	mov		edx, OFFSET extra_2_note2
	call	WriteString
	call	CrLf
	mov		edx, OFFSET intro_2
	call	WriteString
	mov		edx, OFFSET intro_3
	call	WriteString
	call	CrLf
	ret
intro ENDP

getNum PROC		;ask for number input and validate
	mov		edx, OFFSET prompt_1
	call	WriteString
	call	ReadInt
	mov		userNum, eax
	call	CrLf
	jmp		validate
getNum ENDP

validate PROC	;check if number is within limit
	cmp		eax, LOWER_LIMIT
	jl		outOfRange
	cmp		eax, UPPER_LIMIT
	jg		outOfRange
	ret			;made it here? number is valid. continue
outOfRange:		;number is invalid. prompt for new number
	mov		edx, OFFSET prompt_invalid
	call	WriteString
	jmp		getNum
validate ENDP

calculate PROC	;checks if a number is composite
tester:
	mov		ecx, numToTest
	
	xor     edx, edx			;this section mimics a modulus operation
	mov     eax, numToTest
	mov     ebx, checkNum
	div     ebx					;puts the modulo result into edx
	
	.if		edx == 0
		jmp		isComposite
	.else
		inc		checkNum
		mov		eax, numToTest
		cmp		checkNum, eax			;this could be more efficient (checknum/2?)
		jge		isNotComposite
		loop	tester
		.ENDIF
		
isComposite:					;returns to main, ready for printing
	ret
isNotComposite:					;skips printing, goes back to testing.
	inc		numToTest
	mov		checkNum, 2
	loop	tester
calculate ENDP

display	PROC		;displays the numbers and spaces.
	.if		tempNumCount >= LINE_DISPLAY	;goes to next line after printing 10
		call	CrLf
		mov		eax, numToTest				;prints number
		call	WriteInt
		mov		edx, OFFSET spaces3			;prints spaces
		call	WriteString
		.if		numToTest < 10				;aligns columns
			mov		edx, OFFSET spaces2
			call	WriteString
		.elseif	numToTest < 100
			mov		edx, OFFSET spaces1
			call	WriteString
		.else
			.ENDIF	
		inc		numToTest				;adds 1 to make next number
		mov		checkNum, 2				;resets starting check number
		mov		tempNumCount, 0			;resets tempNumCount
		inc		tempNumCount			;adds 1 to tempNumCount
		inc		numCount				;adds 1 to number count
		ret
	.else		;stays in the same line
		mov		eax, numToTest			;prints number
		call	WriteInt
		mov		edx, OFFSET spaces3		;prints spaces
		call	WriteString
		.if		numToTest < 10			;aligns columns
			mov		edx, OFFSET spaces2
			call	WriteString
		.elseif	numToTest < 100
			mov		edx, OFFSET spaces1
			call	WriteString
		.else
			.ENDIF
		inc		numToTest				;adds 1 to make next number
		mov		checkNum, 2				;resets starting check number
		inc		tempNumCount			;adds 1 to tempNumCount
		inc		numCount				;adds 1 to number count
		ret
	.ENDIF
	
display	ENDP

displayMore	PROC
.if		tempNumCount >= LINE_DISPLAY2	;goes to next line after printing 5
	call	CrLf
	mov		eax, numToTest				;prints number
	call	WriteInt
	mov		edx, OFFSET spaces5			;prints spaces
	call	WriteString
	.if		numToTest < 10				;aligns columns
		mov		edx, OFFSET spaces5
		call	WriteString
	.elseif	numToTest < 100
		mov		edx, OFFSET spaces4
		call	WriteString
	.elseif numToTest < 1000
		mov		edx, OFFSET spaces3
		call	WriteString
	.elseif numToTest < 10000
		mov		edx, OFFSET spaces2
		call	WriteString
	.elseif	numToTest < 100000
		mov		edx, OFFSET spaces1
		call	WriteString
	.else
		.ENDIF	
	inc		numToTest				;adds 1 to make next number
	mov		checkNum, 2				;resets starting check number
	mov		tempNumCount, 0			;resets tempNumCount
	inc		tempNumCount			;adds 1 to tempNumCount
	inc		numCount				;adds 1 to number count
	ret
.else		;stays in the same line
	mov		eax, numToTest				;prints number
	call	WriteInt
	mov		edx, OFFSET spaces5			;prints spaces
	call	WriteString
	.if		numToTest < 10				;aligns columns
		mov		edx, OFFSET spaces5
		call	WriteString
	.elseif	numToTest < 100
		mov		edx, OFFSET spaces4
		call	WriteString
	.elseif numToTest < 1000
		mov		edx, OFFSET spaces3
		call	WriteString
	.elseif numToTest < 10000
		mov		edx, OFFSET spaces2
		call	WriteString
	.elseif	numToTest < 100000
		mov		edx, OFFSET spaces1
		call	WriteString
	.else
		.ENDIF
	inc		numToTest				;adds 1 to make next number
	mov		checkNum, 2				;resets starting check number
	inc		tempNumCount			;adds 1 to tempNumCount
	inc		numCount				;adds 1 to number count
	ret
	.ENDIF
	
displayMore	ENDP

bye	Proc		;displays bye messages
	call	CrLf
	mov		edx, OFFSET prompt_continue1
	call	WriteString
	call	ReadInt
	mov		userInput, eax
	.if			userInput == 1
		call	CrLf
		ret
	.elseif		userInput == 0
		call	CrLf
		mov		edx, OFFSET bye_prompt1
		call	WriteString
		mov		edx, OFFSET bye_prompt2
		call	WriteString
		ret
	.elseif		userInput != 0 && userInput != 1
		mov		edx, OFFSET prompt_invalid2
		call	WriteString
		jmp		bye
	.else
		.ENDIF


bye	ENDP

main PROC
	call	intro
	call	getNum
displayLoop:	;loop for printing
	call	calculate
	call	display
	mov		eax, userNum
	cmp		eax, numCount		;compares userNum to number count
	.if		eax == numCount		;it finished
		call	bye
		.if		userInput == 1
			mov		tempNumCount, 0			;resets tempNumCount
			add		userNum, PAGE_DISPLAY
			call	displayLoop2
		.else	
			call	exitFnc
			.ENDIF
	.else						;not done yet, keep going!
		jmp		displayLoop
		.ENDIF
displayLoop2:	;loop if user wants to keep going
	call	calculate
	call	displaymore
	mov		eax, userNum
	cmp		eax, numCount		;compares userNum to number count
	.if		eax == numCount		;it finished
		call	bye			
		.if		userInput == 1
			add		userNum, PAGE_DISPLAY
			call	displayLoop2
		.else	
			call	exitFnc
			.ENDIF
	.else						;not done yet, keep going!
		jmp		displayLoop2
		.ENDIF
exitFnc:
	exit
	
main ENDP
END main