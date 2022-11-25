    .intel_syntax noprefix
	.text
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
	mov	DWORD PTR -4[rbp], edi
	mov	QWORD PTR -16[rbp], rsi
	cmp	DWORD PTR -4[rbp], 2
	je	.L5
	lea	rax, .LC3[rip]
	mov	rdi, rax
	call	puts@PLT
	mov	eax, 1
	jmp	.L6
.L5:
	mov	rax, QWORD PTR .LC4[rip]
	movq	xmm0, rax
	movsd	xmm1, QWORD PTR .LC4[rip]
	movsd	xmm2, QWORD PTR .LC4[rip]
	jmp	.L7
.L8:
	movapd	xmm4, xmm2
	movsd	xmm3, QWORD PTR .LC4[rip]
	divsd	xmm3, xmm4
	mulsd	xmm1, xmm3
	addsd	xmm0, xmm1
	movq	rax, xmm0
	movq	xmm0, rax
	movapd	xmm3, xmm2
	movsd	xmm2, QWORD PTR .LC4[rip]
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