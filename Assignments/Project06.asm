TITLE Designing low-level I/O procedures     (Project06.asm)

; Author: Isaac Chan
; Course / Project ID : Project 6              Date: 8/6/2015
; Description:  This program asks the user for the number of random numbers they want, validates their input, generate
;				their numbers, display them, sort the numbers in descending order, display them sorted, and display the median.

INCLUDE Irvine32.inc

getString	MACRO	a, x
	push ecx
	push edx

	mov edx, a
	mov ecx, x
	call ReadString

	pop edx
	pop ecx
endm

displayString1	MACRO	a, x
	push 	edx
	push	eax
	mov		edx, a
	call	WriteString
	mov		eax, x
	call	WriteDec
	mov		al, ':'
	call	WriteChar
	pop		edx
	pop		eax
endm

displayString2	MACRO	a
	push 	edx
	push	eax
	mov		edx, a
	call	WriteString
	pop		edx
	pop		eax
endm

SIZE_MAX = 1000
INPUT_MAX = 10

.data
intro_1			BYTE	"Designing low-level I/O procedures: by Isaac Chan", 10, 13, 0
intro_2			BYTE	"Please provide 10 unsigned decimal integers. ", 10, 13
				BYTE	"Each number needs to be small enough to fit inside a 32 bit register.", 10, 13
				BYTE	"After you have finished inputting the raw numbers I will display a list ", 10, 13
				BYTE	"of the integers, their sum, and their average value.", 10, 13
				BYTE	"EC1: number each line of user input", 10, 13, 0
say_bye			BYTE	"We're finished, bye.", 10, 13, 0

prompt_invalid	BYTE	"Invalid input.", 10, 13, 0
prompt_1		BYTE	"Please enter integer ", 0
prompt_2		BYTE	"Try again: ", 0


array			DWORD 	INPUT_MAX	DUP(?)
user_input		DWORD	SIZE_MAX	DUP(?)		;string to int
user_string		DWORD	SIZE_MAX	DUP(?)		;int to string
sum				DWORD	?
average			DWORD	?
temp_count		DWORD	?
temp			DWORD	?
temp2			DWORD	?
comma			BYTE	", ", 0
space			BYTE	" ", 0

array_display	BYTE	"Your numbers: ", 10, 13, 0
sum_display		BYTE	"The sum of your numbers: ", 10, 13, 0
average_display	BYTE	"The average of your numbers: ", 10, 13, 0

.code
main PROC
	call	intro
	
	;gets numbers (in strings), converts to int, validates, fills array
	mov		temp_count, 1
	call	getNums
	
	;calculates sum and average of array numbers
	call	calculate

	;display
	mov		edx, OFFSET array_display
	call	WriteString
	call	display

	call 	bye
	exit
main ENDP

intro PROC		;introduces program
	mov		edx, OFFSET intro_1
	call	WriteString
	mov		edx, OFFSET intro_2
	call	WriteString
	call	CrLf
	ret
intro ENDP

bye	PROC
	mov		edx, OFFSET say_bye
	call	WriteString
	ret
bye	ENDP

getNums	PROC
	mov		esi, OFFSET array
	mov		ecx, INPUT_MAX
getNumLoop:
	call	readVal				;convert string to integer
	cmp		temp_count, INPUT_MAX+1
	je		done
	loop	getNumLoop
done:
	ret
getNums	ENDP

display PROC
;display array
	call	WriteVal
	
;display sum
	call	CrLf
	mov		edx, OFFSET sum_display
	call	WriteString
	mov		eax, sum
	call	WriteDec
	call	CrLf
	
;display average
	mov		edx, OFFSET average_display
	call	WriteString
	mov		eax, average
	call	WriteDec
	call	CrLf
	ret
display ENDP

calculate PROC
	mov		esi, OFFSET array
	mov		ecx, INPUT_MAX	
	mov		eax, 0
calcLoop:
	add		eax, [esi]
	add		esi, sizeof DWORD
	loop	calcLoop
	
	mov		sum, eax
	mov		ebx, 10
	div		ebx
	mov		average, eax
	
	ret
calculate ENDP

readVal PROC
getInput:
	displayString1 OFFSET prompt_1, temp_count
	mov		temp, (sizeof user_input)-1
	getString 	OFFSET user_input, temp
	
	mov 	esi, OFFSET user_input
	mov 	eax, 0
	mov 	ebx, 10
	mov		ecx, 0						;ecx holds the converted number per digit

	convert:
		lodsb							;byte from esi will go into ax
		cmp 	ax, 0	
		je 		done					;means end of string so done

		cmp 	ax, 30h					;48d or 30h is ascii 0
		JB 		invalid					;out of range
		cmp 	ax, 39h					;57d or 39h is ascii 9
		JA 		invalid					;out of range

		valid:
			sub 	ax, 30h				;convert to int
			xchg 	eax, ecx			;stored number to eax
			mul 	ebx					;multiply by 10
			JC 		invalid				;the number is too big - carry flag set

			xchg 	eax, ecx			;stored number back to ecx
			add 	ecx, eax			;add eax to stored number
			jmp 	convert				;continue converting
		invalid:
			displayString1 OFFSET prompt_invalid, OFFSET space
			jmp 	getInput

done:
	mov		esi, 0
	.if	temp_count == 1
		mov		array[esi], ecx
	.else
		mov		eax, temp_count
		mov		temp2, eax
		dec		temp2
		mov		eax, temp2
		mov		ebx, sizeof	DWORD
		mul		ebx
		add		esi, eax
		mov 	array[esi], ecx						;store the finished number into array position
		.endif
	inc		temp_count
	ret
readVal ENDP

writeVal PROC
	mov		esi, OFFSET array
	mov		ecx, INPUT_MAX
displayLoop:
	mov		eax, [esi]
	call	WriteDec
	.if		ecx == 1
		jmp		done
	.else
		displayString2	OFFSET comma
		add		esi, sizeof DWORD
		loop	displayLoop
		.endif
done:
	ret
writeVal ENDP

END main