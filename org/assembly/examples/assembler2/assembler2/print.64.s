
segment .text
global print_it

;Chamadas de sistema
	sys_write       equ     1
	stdin           equ     0
	stdout          equ     1
	stderr          equ     3


; void print (int n, char *str)

print_it:
	push rbp
	mov rbp, rsp

	mov rdx, rdi 

	mov rax, sys_write
	mov rdi, stdout

	; rdx tem o tamanho da string
	; rsi jã tem a sting pois é o segundo argumeto da função

	syscall

	mov rsp, rbp
	pop rbp
	ret
