
segment .text
global print_it

;Chamadas de sistema
	sys_exit        equ     1
	sys_read        equ     3
	sys_write       equ     4
	stdin           equ     0
	stdout          equ     1
	stderr          equ     3


; void print (int n, char *str)

print_it:
	push ebp
	mov ebp, esp

	push ebx

	mov eax, sys_write
	mov ebx, stdout
	mov ecx, DWORD [ebp + 12]
	mov edx, DWORD [ebp + 8]

	int 0x80

	pop ebx

	mov esp, ebp
	pop ebp
	ret
