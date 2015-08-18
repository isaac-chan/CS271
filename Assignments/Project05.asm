TITLE Sorting Random Integers     (Project05.asm)

; Author: Isaac Chan
; Course / Project ID : Project 5              Date: 7/30/2015
; Description:  This program asks the user for the number of random numbers they want, validates their input, generate
;				their numbers, display them, sort the numbers in descending order, display them sorted, and display the median.

INCLUDE Irvine32.inc

MIN = 10
MAX = 200
LO = 100
HI = 999
DISPLAY_COUNT = 10

.data
intro_1			BYTE	"Sorting Random Integers: by Isaac Chan", 10, 13, 0
intro_2			BYTE	"This program generates random numbers in the range [100 .. 999],", 10, 13, 0
intro_3			BYTE	"displays the original list, sorts the list, and calculates the", 10, 13, 0
intro_4			BYTE	"median value. Finally, it displays the list sorted in descending order.", 10, 13, 0
bye				BYTE	"We're finished, bye.", 10, 13, 0

prompt_1		BYTE	"How many numbers do you want generated? [10 .. 200]: ", 0
prompt_invalid	BYTE	"Invalid input.", 10, 13, 0

displayUnsorted	BYTE	"Unsorted Array: ", 10, 13, 0
displaySorted	BYTE	"Sorted Array, highest to lowest: ", 10, 13, 0

displayMedian	BYTE	"Median value: ", 0

array			DWORD	MAX DUP(?)
userNum			DWORD	?
spaces			DWORD	"  ", 0
tempCount		DWORD   ?

.code
main PROC
	call	Randomize						;to not get same numbers every time
	call	intro							;introduction
	call	getUserNum						;number of values user wants to see
	call	fillArray						;populates array with random numbers

	call	CrLf
	mov		edx, OFFSET displayUnsorted		
	call	WriteString
	mov		ecx, OFFSET array				;prepares address of array for displayArray function
	call	displayArray					;displays the unsorted array
	
	call	CrLf
	call	bubbleSort
	
	mov		edx, OFFSET displaySorted
	call	WriteString
	mov		ecx, OFFSET array				;prepares address of array for displayArray function
	call	displayArray					;displays the sorted array
	
	call	CrLf
	mov		edx, OFFSET displayMedian
	call	WriteString
	mov		ecx, OFFSET array
	call	calcMedian						;gets median value
	call	CrLf
	
	mov		edx, OFFSET bye
	call	WriteString	
	
	exit
main ENDP

intro PROC		;introduces program
	mov		edx, OFFSET intro_1
	call	WriteString
	call	CrLf
	mov		edx, OFFSET intro_2
	call	WriteString
	mov		edx, OFFSET intro_3
	call	WriteString
	mov		edx, OFFSET intro_4
	call	WriteString
	call	CrLf
	ret
intro ENDP

getUserNum PROC	;gets data and validates that it is within range
	mov		edx, OFFSET prompt_1
	call	WriteString
	call	ReadInt
	cmp		eax, MIN
	jl		badNum
	cmp		eax, MAX
	jg		badNum
goodNum:			;validation passed
	mov		userNum, eax
	ret
badNum:				;validation failed
	mov		edx, OFFSET prompt_invalid
	call	WriteString
	call	getUserNum
getUserNum ENDP

fillArray PROC		;fill array with random numbers
	mov		ecx, userNum			;mov to loop counter
	mov		esi, 0					;reset esi
getRandNum:
	mov		eax, HI
	sub		eax, LO
	inc		eax
	call 	RandomRange				;eax within [LO..HI]
	add 	eax, LO					;rand num is now in eax
	
	mov		array[esi*sizeof DWORD], eax	;adds num to position in array
	inc		esi								;prepares position for next num
	loop	getRandNum
	ret								;array now filled with random numbers
fillArray ENDP

displayArray PROC
	mov		eax, 0
	mov		esi, 0
	mov		tempCount, 0
	mov		ecx, userNum
display:
	.if		tempCount == DISPLAY_COUNT		;to fulfill 10 per line requirement
		mov		tempCount, 0
		call	CrLf
	.else
		.ENDIF
	mov		eax, array[esi*sizeof DWORD]	;gets number at that position (*4 also works)
	call	WriteDec						;prints
	mov		edx, OFFSET spaces				;not so cramped!
	call	WriteString				
	inc		esi								;prepares next position
	inc		tempCount
	loop 	display							;prints whole array
	
	call	CrLf
	ret
displayArray ENDP

bubbleSort PROC
	mov 	ecx, userNum
	dec 	ecx 			;decrement count by 1
L1: 
	push 	ecx 			;save outer loop count
	mov 	esi, OFFSET array 		;point to first value
L2: 
	mov 	eax, [esi]		;get array value
	cmp 	[esi+4], eax 	;compare a pair of values
	jl 		L3 				;if [ESI] <= [ESI+4], no exchange
	xchg 	eax, [esi+4] 	;exchange the pair
	mov 	[esi], eax
L3: 
	add 	esi, 4 			;move both pointers forward
	loop 	L2 				;inner loop
	pop 	ecx				;retrieve outer loop count
	loop 	L1 				;else repeat outer loop
L4: 
	ret
bubbleSort ENDP

calcMedian PROC		;if there is an even number, takes the average of the middle values. if odd, takes middle value.
	xor     edx, edx			;this section mimics a modulus operation
	mov     eax, usernum
	mov     ebx, 2
	cdq
	div     ebx					;puts the modulo result into edx

	.if		edx == 0			;usernum is even
		dec		eax
		mov		esi, eax
		mov		eax, array[esi*4]
		inc		esi
		add		eax, array[esi*4]
		cdq
		div		ebx
		call	WriteDec
		ret
	.else						;usernum is odd
		mov		esi, eax		;get array value at middle position
		mov		eax, array[esi*4]
		call	WriteDec
		ret
		.endif
calcMedian ENDP
END main