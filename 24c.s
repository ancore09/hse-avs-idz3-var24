	.file	"24.c"
	.intel_syntax noprefix
	.text
	.section	.rodata
.LC0:
	.string	"w"
	.align 8
.LC1:
	.string	"you must provide a valid file path"
.LC2:
	.string	"e = %.*f\n"
	.text
	.globl	output
	.type	output, @function
output:
	push	rbp
	mov	rbp, rsp
	sub	rsp, 48
	mov	QWORD PTR -24[rbp], rdi 		# rdi = path
	movsd	QWORD PTR -32[rbp], xmm0	# xmm0 = e
	mov	DWORD PTR -36[rbp], esi			# esi = precision
	mov	rax, QWORD PTR -24[rbp]
	lea	rdx, .LC0[rip]
	mov	rsi, rdx
	mov	rdi, rax
	call	fopen@PLT
	mov	QWORD PTR -8[rbp], rax
	cmp	QWORD PTR -8[rbp], 0
	jne	.L2
	lea	rax, .LC1[rip]
	mov	rdi, rax
	call	puts@PLT
	jmp	.L1
.L2:
	mov	rcx, QWORD PTR -32[rbp]
	mov	edx, DWORD PTR -36[rbp]
	mov	rax, QWORD PTR -8[rbp]
	movq	xmm0, rcx
	lea	rcx, .LC2[rip]
	mov	rsi, rcx
	mov	rdi, rax
	mov	eax, 1
	call	fprintf@PLT
	mov	rax, QWORD PTR -8[rbp]
	mov	rdi, rax
	call	fclose@PLT
.L1:
	leave
	ret
	.size	output, .-output
	.section	.rodata
.LC3:
	.string	"you must a file path"
	.text
	.globl	main
	.type	main, @function
main:
	push	rbp
	mov	rbp, rsp
	sub	rsp, 16
	mov	DWORD PTR -4[rbp], edi			# edi = argc
	mov	QWORD PTR -16[rbp], rsi			# rsi = argv
	cmp	DWORD PTR -4[rbp], 2
	je	.L5
	lea	rax, .LC3[rip]
	mov	rdi, rax
	call	puts@PLT
	mov	eax, 1
	jmp	.L6
.L5:
	mov	rax, QWORD PTR .LC4[rip]
	movq	xmm0, rax					# e = xmm0 = 1.0
	movsd	xmm1, QWORD PTR .LC4[rip]	# term = xmm1 = 1.0
	movsd	xmm2, QWORD PTR .LC4[rip]	# i = xmm2 = 1.0
	jmp	.L7
.L8:
	movapd	xmm4, xmm2
	movsd	xmm3, QWORD PTR .LC4[rip]	# xmm3 = 0
	divsd	xmm3, xmm4
	mulsd	xmm1, xmm3
	addsd	xmm0, xmm1
	movq	rax, xmm0
	movq	xmm0, rax
	movapd	xmm3, xmm2
	movsd	xmm2, QWORD PTR .LC4[rip]	# xmm2 = 0
	addsd	xmm2, xmm3
.L7:
	movapd	xmm3, xmm1
	pxor	xmm4, xmm4
	ucomisd	xmm3, xmm4
	jp	.L8
	pxor	xmm4, xmm4
	ucomisd	xmm3, xmm4
	jne	.L8
	movq	rax, xmm0
	mov	rdx, QWORD PTR -16[rbp]
	add	rdx, 8
	mov	rdx, QWORD PTR [rdx]
	mov	esi, 55
	movq	xmm0, rax
	mov	rdi, rdx
	call	output
	mov	eax, 0
.L6:
	leave
	ret
	.size	main, .-main
	.section	.rodata
	.align 8
.LC4:
	.long	0
	.long	1072693248
	.ident	"GCC: (Ubuntu 11.3.0-1ubuntu1~22.04) 11.3.0"
	.section	.note.GNU-stack,"",@progbits
