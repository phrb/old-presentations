; Ao programar em assembler, você precisa ter em mente o mapa de todos os
; registradores do processador.  No caso do Intel x86:
;
;     +-------------------+
; EAX |       AX| AH | AL |
;     +-------------------+
; EBX |       BX| BH | BL |
;     +-------------------+
; ECX |       CX| CH | CL |
;     +-------------------+
; EDX |       DX| DH | DL |
;     +-------------------+
; ESI |                   |
;     +-------------------+
; EDI |                   |
;     +-------------------+
; ESP |                   |
;     +-------------------+
; EBP |                   |
;     +-------------------+
; EIP |                   |
;     +-------------------+
;
; Os registradores EAX, EBX, ..., EDX são registradores de 32-bits para uso geral
; e podem ser usados para fazer contas, mover informações do processador para a
; memória, etc.  Entretanto, algumas instruções (como o div) apenas operam em
; alguns desses registradores.
;
; Note que alguns registradores estão dentro desses registradores. Por exemplo,
; o registrador AX são os 16 bits menos significativos do EAX, e por sua vez
; o AL e o AH são os 8 bits menos e mais significativos do registrador AX.
; Para o BX, CX e DX são análogos. Isso significa que modificar o AL, por
; exemplo, também modifica o AX e o EAX, então tome cuidado.
;
; Os registradores ESI e EDI são usados para lidar com strings e foram adicionados
; no Intel 80486, ou seja, software que usam esses registradores não podem ser
; usados em software para no Intel 80386.(grande coisa!). Por isso a arquitetura
; de 32-bits da intel é quebrada em i386, i486, i586 (Pentium), ...
;
; O registrador EIP possui a posição de memória contendo a instrução que está
; sendo executada. Ele pode ser modificado pelas instruções JMP, JL, ...,
; CALL, e RET, mas não por instruções de propósito geral.
;
; Os registradores ESP e EBP são usados para lidar com a pilha de execução.
; Segundo a convenção CDECL usada pelo Linux e GCC, Toda vez que chamamos uma
; função, o compilador precisa emitir código para que o processador faça o
; seguinte:
;
; * Empilhar os parâmetros (ex, push number).
; * Empilhar o endereço de memória da próxima instrução (push EIP)
; * Chamar a função (jmp func)
;
; Em seguida, a função chamada é encarregada de:
;
; * Salvar o endereço da base da pilha da função que a chamou. (push EBP)
; * Definir uma nova base para a pilha (mov EBP, ESP)
; * Fazer suas coisas que funções fazem.
; * Restaurar o endereço de topo da pilha da função anterior (mov ESP, EBP)
; * Restaurar o endereço da base da pilha da função anteiror (pop EBP)
; * Restaurar o ponteiro de execução da função anteiror (pop EIP).
;
; Porém, para lidar com o EIP, devemos usar instruções especiais:
;
; * Para empilhar e chamar a função: call func
; * Para desempilhar para o ponteiro de execução e pular para o endereço: ret
;
; Você pode ver mais sobre isso aqui (CDECL calling convention):
; https://en.wikibooks.org/wiki/X86_Disassembly/Calling_Conventions#CDECL



segment .text		; Segmento de texto => Somente leitura, execução permitida
global is_prime		; Exporte o símbolo is_prime para que seja visível para o linker.

; Função is_prime: retorna 1 se number é primo, 0 caso contrário.
; Nos processadores de arquitetura x86, o primeiro parâmetro é
; está na pilha.
;
; int is_prime (int number)
is_prime:

; Salva o stackframe.
	push ebp
	mov ebp, esp

; O padrão cdecl nos impõe que precisamos salvar alguns registradores
; caso queiramos usar. Os registradores EAX, ECX e EDX deverão ser
; salvos por quem nos chamou, no caso o compilador. Os restantes estão
; por nossa conta.  Como usamos apenas o EBX, então precisamos salvá-lo.

	push ebx

; Usaremos o registrador ECX como iterador.
; Note que a associação é da direita para a esquerda.
	mov ecx, 2							; Inicializa o ECX com 2.
	mov ebx, DWORD [ebp + 8]			; Mova o argumento da função que foi empilhado pelo compilador.
										; Note a keyword DWORD -- é ela que especifica quantos bytes
										; serão carregados no registrador EBX. No x86, Linux, em C:
										; * BYTE  - sizeof (char);      1 byte
										; * WORD  - sizeof (short);     2 bytes
										; * DWORD - sizeof (int);       4 bytes
										; * QWORD - sizeof (long long); 8 bytes

.while_iterator_less_than_n:
	cmp ebx, ecx						; Compara EDI com ECX (isso é temp := EDI - ECX)
	jle .prime  						; Pula para .prime se temp <= 0 (Jump Less Equal)

	mov eax, ebx						; Eu movi o argumento da função no ebx alí em mov ebx, [ebp + 8].
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

	pop ebx								; Restaura registrador salvo.

; Restaura o stackframe.
	mov esp, ebp
	pop ebp
	ret									; Instrução de retorno. Desempilha o endereço empilhado pelo compilador
										; e o restaura no EIP.  A execução voltará a quem me chamou.
