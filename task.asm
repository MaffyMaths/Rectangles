CODESG SEGMENT PARA 'CODE'
assume CS:CODESG, DS:CODESG
org	100h
start:
JMP	BEGIN
	CR	EQU	13
	LF	EQU	10
;=============================macro=================================
 print_letter	macro	letter
	push	AX
	push	DX
	mov	DL, letter
	mov	AH,	02
	int	21h
	pop		DX
	pop		AX
endm
;===================================================================
   print_mes	macro	message
   	local	msg, nxt
   	push	AX
   	push	DX
   	mov		DX,	offset msg
   	mov		AH,	09h
   	int	21h
   	pop		DX
    pop		AX
   	jmp nxt
msg	DB message,'$'
nxt:
 	endm

BEGIN:
		mov ax, 1003h
		mov bl, 0
		int 10h
		print_letter	CR
		print_letter	LF
;
		mov CX,20  				; число a
cycle:
		push    CX              ; общее кол-во квадратов а*б
		mov     CX, 10			; число б
inside:
		push	CX
		call	rand8
		mov 	bl, 25
		div 	bl
		mov 	dh, ah
		call 	rand8
		mov 	bl, 25
		div 	bl
		cmp 	dh, ah
		jge 	low_y
high_y:
		mov ch, dh
		mov dh, ah
		jmp with_x
low_y:
		mov ch, ah
		mov dh, dh
		jmp with_x
with_x:
		call	rand8
		mov 	bl, 80
		div 	bl
		mov 	dh, ah
		call 	rand8
		mov 	bl, 80
		div 	bl
		cmp 	dh, ah
		jge 	low_x
high_x:
		mov cl, dh
		mov dh, ah
		jmp print
low_x:
		mov cl, ah
		mov dl, dh
		jmp print		
print:
		call rand8
		mov bh, al
		mov al, 0
		mov ah, 06h
		int 10h
		;mov		DX,	offset msg
		;mov		AH,	09h
		;int	21h
		print_letter	CR
		print_letter	LF
		call sleep
		pop	CX
		loop	inside
		pop	CX
		loop	cycle
;
		int	20h
; rand8
; Возвращает случайное 8-битное число в AL.
; Переменная seed должна быть инициализирована заранее,
; например из области данных BIOS, как в примере для конгруэнтного генератора.
rand8	proc near
		push bx
		push dx
		push cx
		
		mov	AX,		word ptr	seed
		mov	CX,		8	

newbit:	mov		BX,		AX
		and		BX,		002Dh
		xor		BH,	BL
		clc
		jpe		shift
		stc
shift:	rcr		AX,	1
		loop	newbit
		mov		word	ptr	seed,	AX
		mov		AH,	0
		
		pop cx
		pop dx
		pop bx
	ret
rand8 endp

sleep proc near
	push cx
	push ax
	mov cx, 65000
	xor ax, ax
metka:
	inc ax
	loop metka
	pop ax
	pop cx
	ret
sleep endp

seed	dw 1
x 		db 1
y 		db 1
msg 	db 'rectangles!','$'
CODESG ends
  end start

  