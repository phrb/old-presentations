; Primeiro, comece lendo o cabeçalho do is_prime.32.s
;
; No AMD64 (ou x86_64, x64, é a mesma coisa) temos ainda mais registradores:


;     +-------------------+-------------------+
; RAX |                EAX |       AX| AH | AL |
;     +--------------------+-------------------+
; RBX |                EBX |       BX| BH | BL |
;     +--------------------+-------------------+
; RCX |                ECX |       CX| CH | CL |
;     +--------------------+-------------------+
; RDX |                EDX |       DX| DH | DL |
;     +--------------------+-------------------+
; RSI |                ESI |                   |
;     +--------------------+-------------------+
; RDI |                EDI |                   |
;     +--------------------+-------------------+
; RSP |                ESP |                   |
;     +--------------------+-------------------+
; RBP |                EBP |                   |
;     +--------------------+-------------------+
; RIP |                EIP |                   |
;     +--------------------+-------------------+
; R8  |                R8D |      R8W|    | R8B|
;     +----------------------------------------+
; R9  |                R9D |      R9W|    | R9B|
;     +----------------------------------------+
; e vai até
;     +----------------------------------------+
; R15 |                R9D |      R9W|    | R9B|
;     +----------------------------------------+
;
;
; Temos mais registradores, RAX, RBX, etc. Eles são todos de 64-bits.
; Esses registradores são análogos as suas versões de 32-bits.
; Como há mais registradores, a convenção de chamadas de função
; também muda.  Quando há poucos parâmetros, os argumentos são
; passados via registradores.

segment .text		; Segmento de texto => Somente leitura, execução permitida
global is_prime		; Exporte o símbolo is_prime para que seja visível para o linker.

; Função is_prime: retorna 1 se number é primo, 0 caso contrário.
; Nos processadores de arquitetura AMD64, o primeiro parâmetro é
; jogado no registrador RDI.
;
; Note que tanto o argumento quanto o retorno são ints, que no Linux
; AMD64 têm 32-bits. Então na verdade:
;
; * O argumento 'number' está em EDI.
; * O retorno precisa estar em EAX.
;
; Veja mais sobre:
; https://aaronbloomfield.github.io/pdr/book/x86-64bit-ccc-chapter.pdf
;
; int is_prime (int number)
is_prime:

; Salva o stackframe.
	push rbp
	mov rbp, rsp

; Usaremos o registrador ecx como iterador.
; Inicia o iterador com 2.
; Note que a associação é da direita para a esquerda.
	mov ecx, 2

; O padrão cdecl nos impõe que precisamos salvar alguns registradores
; caso queiramos usar. Nesse caso, os registradores RBX, RBP e R12 ao 15
; deverão ser salvos.  Sorte a nossa. Não modificamos nenhum desses
; registradores ou os registradores que são parte deles.

.while_iterator_less_than_n:
	cmp edi, ecx						; Compara EDI com ECX (isso é temp := EDI - RCX)
	jle .prime  						; Pula para .prime se temp <= 0 (Jump Less Equal)

	mov eax, edi						; Mova o argumento da função que está no EDI para o EAX
	xor edx, edx						; Zere o registrador EDX. A instrução XOR é mais rápida que o MOV
	div ecx								; Divida o que está em EDX:EAX por ECX. Resto é guardado no EDX
										; Quociente no EAX. Veja a documentação da instrução.

	test edx, edx						; Compare EDX com zero. A instrução test faz AND lógico
	je .not_prime						; Se igual, pule para .not_prime (Jump Equal)
	inc ecx								; Incremente ECX.

	jmp .while_iterator_less_than_n		; Pule de volta para esse label aí

.prime:									; Caso em que é primo.

	mov eax, 1							; o EAX é o registrador que o padrão define onde estará o
										; retorno no caso da função retornar um inteiro.
	jmp .return

.not_prime:								; Caso em que não é primo.
	xor eax, eax						; Zere o EAX. Note que não há jump aqui. Por que ele não é necessário?

.return:
; Restaura o stackframe.
	mov rsp, rbp
	pop rbp
	ret									; Instrução de retorno. Desempilha o endereço empilhado pelo compilador
										; e o restaura no RIP.  A execução voltará a quem me chamou.
