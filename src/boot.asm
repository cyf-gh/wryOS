;------------------------------------------------------------
; 	@authoer: cyf
;	@date: 2020.2.7
;	@brief Read 10 cylinders to memory
;------------------------------------------------------------

;====== constants ======
_cyls 		equ 10
_c_enter 	equ 0ah
;=======================
		
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>START>>>>>>>>>>>>>>>>>>>>
	org 7c00h
	jmp _ENTRY
	nop

%include	"./src/inc/fat12hdr.inc"

_ENTRY:

	mov ax, 0
	mov ss, ax
	mov sp, 7c00h
	mov ds, ax

; Start reading disk
	mov ax, 0820h
	mov es, ax	; read from 0820h

	mov ch, 0	; cylinder 0
	mov dh, 0	; head 0
	mov cl, 2	; sector 2

_READLOOP:
	mov si, 0	; fail time

_RETRY:
	mov ah, 02h	; 13h-02h read disk
	mov al, 1
	mov bx, 0
	mov dl, 0
	int 13h		; 13h-02h read disk	

	jnc _NEXT_ADDR

	add si, 1
	cmp si, 5
	jae _ERR

	mov ah, 0
	mov dl,	0
	int 13h		; 13h-0(ah) reset driver
	
	jmp _RETRY

_NEXT_ADDR:
	mov ax, es
	add ax, 20h
	mov es, ax	; address move 20h after

	add cl, 1	; sector + 1
	cmp cl, 18
	jbe _READLOOP	; cl <= 18 ? read

	mov cl, 1
	add dh, 1
	cmp dh, 2
	jb _READLOOP	; dh < 2 ? read

	mov dh, 0
	add ch, 1
	cmp ch, _cyls
	jb _READLOOP	; ch < 1


	mov	[0x0ff0], ch
	jmp	0xc400
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<END<<<<<<<<<<<<<

;===== error helper =====
_ERR:
	mov si, _ERR_MSG

_ERR_MSG:
	DB		_c_enter, _c_enter
	DB		"Load error..."
	DB		_c_enter
	DB		0

	;RESB		0x7dfe-$	
	times 510-($-$$) db 0
	dw 0xaa55
;=========================
