	.text
	.intel_syntax noprefix
	.file	"arithmetic.c"
	.globl	main                    # -- Begin function main
	.p2align	4, 0x90
	.type	main,@function
main:                                   # @main
	.cfi_startproc
# %bb.0:
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset rbp, -16
	mov	rbp, rsp
	.cfi_def_cfa_register rbp
	sub	rsp, 32
	mov	dword ptr [rbp - 4], 0
	mov	dword ptr [rbp - 8], edi
	mov	qword ptr [rbp - 16], rsi
	cmp	dword ptr [rbp - 8], 2
	je	.LBB0_2
# %bb.1:
	call	print_usage_message
	mov	dword ptr [rbp - 4], 1
	jmp	.LBB0_5
.LBB0_2:
	mov	rax, qword ptr [rbp - 16]
	mov	rdi, qword ptr [rax + 8]
	call	is_number
	test	al, 1
	jne	.LBB0_4
# %bb.3:
	mov	rax, qword ptr [rip + stdout@GOTPCREL]
	mov	rdi, qword ptr [rax]
	mov	rax, qword ptr [rbp - 16]
	mov	rdx, qword ptr [rax + 8]
	lea	rsi, [rip + .L.str]
	mov	al, 0
	call	fprintf@PLT
	mov	dword ptr [rbp - 4], 1
	jmp	.LBB0_5
.LBB0_4:
	mov	rax, qword ptr [rbp - 16]
	mov	rdi, qword ptr [rax + 8]
	call	atoi@PLT
	mov	rcx, qword ptr [rip + stdout@GOTPCREL]
	mov	dword ptr [rbp - 20], eax
	mov	rdi, qword ptr [rcx]
	mov	eax, dword ptr [rbp - 20]
	mov	qword ptr [rbp - 32], rdi # 8-byte Spill
	mov	edi, eax
	call	arithmetic
	mov	rdi, qword ptr [rbp - 32] # 8-byte Reload
	lea	rsi, [rip + .L.str.1]
	mov	edx, eax
	mov	al, 0
	call	fprintf@PLT
	mov	dword ptr [rbp - 4], 0
.LBB0_5:
	mov	eax, dword ptr [rbp - 4]
	add	rsp, 32
	pop	rbp
	.cfi_def_cfa rsp, 8
	ret
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
	.cfi_endproc
                                        # -- End function
	.p2align	4, 0x90         # -- Begin function print_usage_message
	.type	print_usage_message,@function
print_usage_message:                    # @print_usage_message
	.cfi_startproc
# %bb.0:
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset rbp, -16
	mov	rbp, rsp
	.cfi_def_cfa_register rbp
	mov	rax, qword ptr [rip + stdout@GOTPCREL]
	mov	rsi, qword ptr [rax]
	lea	rdi, [rip + .L.str.2]
	call	fputs@PLT
	pop	rbp
	.cfi_def_cfa rsp, 8
	ret
.Lfunc_end1:
	.size	print_usage_message, .Lfunc_end1-print_usage_message
	.cfi_endproc
                                        # -- End function
	.p2align	4, 0x90         # -- Begin function is_number
	.type	is_number,@function
is_number:                              # @is_number
	.cfi_startproc
# %bb.0:
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset rbp, -16
	mov	rbp, rsp
	.cfi_def_cfa_register rbp
	sub	rsp, 16
	mov	qword ptr [rbp - 16], rdi
.LBB2_1:                                # =>This Inner Loop Header: Depth=1
	mov	rax, qword ptr [rbp - 16]
	movsx	ecx, byte ptr [rax]
	cmp	ecx, 0
	je	.LBB2_5
# %bb.2:                                #   in Loop: Header=BB2_1 Depth=1
	call	__ctype_b_loc@PLT
	mov	rax, qword ptr [rax]
	mov	rcx, qword ptr [rbp - 16]
	mov	rdx, rcx
	add	rdx, 1
	mov	qword ptr [rbp - 16], rdx
	movsx	esi, byte ptr [rcx]
	movsxd	rcx, esi
	movzx	esi, word ptr [rax + 2*rcx]
	and	esi, 2048
	cmp	esi, 0
	jne	.LBB2_4
# %bb.3:
	mov	byte ptr [rbp - 1], 0
	jmp	.LBB2_6
.LBB2_4:                                #   in Loop: Header=BB2_1 Depth=1
	jmp	.LBB2_1
.LBB2_5:
	mov	byte ptr [rbp - 1], 1
.LBB2_6:
	mov	al, byte ptr [rbp - 1]
	and	al, 1
	movzx	eax, al
	add	rsp, 16
	pop	rbp
	.cfi_def_cfa rsp, 8
	ret
.Lfunc_end2:
	.size	is_number, .Lfunc_end2-is_number
	.cfi_endproc
                                        # -- End function
	.p2align	4, 0x90         # -- Begin function arithmetic
	.type	arithmetic,@function
arithmetic:                             # @arithmetic
	.cfi_startproc
# %bb.0:
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset rbp, -16
	mov	rbp, rsp
	.cfi_def_cfa_register rbp
	mov	dword ptr [rbp - 4], edi
	mov	dword ptr [rbp - 12], 0
	mov	dword ptr [rbp - 8], 1
.LBB3_1:                                # =>This Inner Loop Header: Depth=1
	mov	eax, dword ptr [rbp - 8]
	cmp	eax, dword ptr [rbp - 4]
	jge	.LBB3_4
# %bb.2:                                #   in Loop: Header=BB3_1 Depth=1
	mov	eax, dword ptr [rbp - 8]
	add	eax, dword ptr [rbp - 12]
	mov	dword ptr [rbp - 12], eax
# %bb.3:                                #   in Loop: Header=BB3_1 Depth=1
	mov	eax, dword ptr [rbp - 8]
	add	eax, 1
	mov	dword ptr [rbp - 8], eax
	jmp	.LBB3_1
.LBB3_4:
	mov	eax, dword ptr [rbp - 12]
	pop	rbp
	.cfi_def_cfa rsp, 8
	ret
.Lfunc_end3:
	.size	arithmetic, .Lfunc_end3-arithmetic
	.cfi_endproc
                                        # -- End function
	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"Error: %s is not a number!\n"
	.size	.L.str, 28

	.type	.L.str.1,@object        # @.str.1
.L.str.1:
	.asciz	"Arithmetic sum: %d\n"
	.size	.L.str.1, 20

	.type	.L.str.2,@object        # @.str.2
.L.str.2:
	.asciz	"arithmetic: Compute sum from 1 to n.\n\nUsage: arithmetic <n>\n"
	.size	.L.str.2, 61

	.ident	"clang version 10.0.1 "
	.section	".note.GNU-stack","",@progbits
	.addrsig
	.addrsig_sym print_usage_message
	.addrsig_sym is_number
	.addrsig_sym fprintf
	.addrsig_sym atoi
	.addrsig_sym arithmetic
	.addrsig_sym fputs
	.addrsig_sym __ctype_b_loc
	.addrsig_sym stdout
