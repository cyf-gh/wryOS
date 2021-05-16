    org 0xc400
	mov ax,cs
	mov ds,ax
	mov es,ax

	mov dh,0

_LOOP_PRINT:
	call _PRINT_STR
	jmp _LOOP_PRINT

_PRINT_STR:
	mov ax, MSG
	mov bp, ax
	mov cx, 21
	mov ax, 01301h
	mov bx, 000ch
	int 10h
	add dh, 1
	ret

MSG:
	db "cyf hao shuai!!!"

