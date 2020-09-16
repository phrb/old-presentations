segment .text

global _start
extern main

	sys_exit        equ     1

; Referência: http://dbp-consulting.com/tutorials/debugging/linuxProgramStartup.html

; xor of anything with itself sets it to zero. so the xor    %ebp,%ebp sets %ebp
; to zero. This is suggested by the ABI (Application Binary Interface
; specification), to mark the outermost frame. Next we pop off the top of the
; stack. On entry we have argc, argv and envp on the stack, so the pop makes argc
; go into %esi. We're just going to save it and push it back on the stack in a
; minute. Since we popped off argc, %esp is now pointing at argv. The mov puts
; argv into %ecx without moving the stack pointer. Then we and the stack pointer
; with a mask that clears off the bottom four bits. Depending on where the stack
; pointer was it will move it lower, by 0 to 15 bytes. In any case it will make
; it aligned on an even multiple of 16 bytes. This alignment is done so that all
; of the stack variables are likely to be nicely aligned for memory and cache
; efficiency, in particular, this is required for SSE (Streaming SIMD
; Extensions), instructions that can work on vectors of single precision floating
; point simultaneously. In a particular run, the %esp was 0xbffff770 on entry to
; _start. After we popped argc off the stack, %esp was 0xbffff774. It moved up to
; a higher address (putting things on the stack moves down in memory, taking
; things off moves up in memory). After the and the stack pointer is back at
; 0xbffff770. 

_start:
	xor rbp, rbp
	pop rdi						; argc
	mov rsi, rsp				; argv
	and rsp, 0xfffffffffffffff0

	call main

	mov ebx, eax
	mov eax, sys_exit
	int 0x80
