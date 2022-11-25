# Отчет по ИДЗ №3

### Код на C
```c
#include <stdio.h>
#include <math.h>

void output(char *path, double e, int n) {
    FILE *fp = fopen(path, "w");
    if (fp == NULL) {
        printf("you must provide a valid file path\n");
        return;
    }
    fprintf(fp, "e = %.*f\n", n, e);
    fclose(fp);
}

int main(int argc, char** argv)
{
    if (argc != 2) {
        printf("you must a file path\n");
        return 1;
    }

    register double e asm("xmm0") = 1.0;
    register double term asm("xmm1") = 1.0;
    register double i asm("xmm2") = 1;

    while (term != 0.0) {
        term *= 1.0 / i;
        e += term;
        i++;
    }

    output(argv[1], e, 55);
}
```

### Компиляция программы без оптимизаций
```sh
gcc -masm=intel -S 24.c -o 24.s
```

### Компиляция программы с оптимизацией
```sh
gcc -O0 -Wall -masm=intel -S -fno-asynchronous-unwind-tables -fcf-protection=none 24.c -o 24c.s
```

### Тестовые прогоны
```sh
./a.out *out_path*
```

| Входные данные  | 24.s            | 24c.s           |
|-----------------|:---------------:|:---------------:|
| - | e = 2.7182818284590455348848081484902650117874145507812500000
 | e = 2.7182818284590455348848081484902650117874145507812500000
 |

### Комментарии в asm коде
```assembly
.L5:
	mov	rax, QWORD PTR .LC4[rip]
	movq	xmm0, rax					# e = xmm0 = 1.0
	movsd	xmm1, QWORD PTR .LC4[rip]	# term = xmm1 = 1.0
	movsd	xmm2, QWORD PTR .LC4[rip]	# i = xmm2 = 1.0
	jmp	.L7
```

### Разбиение Asm кода на две единицы компиляции
#### 33_1.s
```assembly
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
	mov	QWORD PTR -24[rbp], rdi
	movsd	QWORD PTR -32[rbp], xmm0
	mov	DWORD PTR -36[rbp], esi
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

```

#### 33_2.s
```assembly
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

```

#### Коплиляция программы из двух единиц компиляции
```bash
gcc 24_1.s 24_2.s -o part.out
```

### Сравнение размера программы на регистрах и на стеке

#### Размер программы на регистрах
114 строк
#### Размер программы на стеке
118 строк