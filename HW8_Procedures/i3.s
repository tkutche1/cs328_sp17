	.text
	.comm	pgmem,44,4

	.align	2
sum:
	str	fp, [sp, #-4]!	@ leaf function
	add	fp, sp, #0
	sub	sp, sp, #24	@ local vars and r0-r3
	stmfd	sp!, {r4-r8, r10}	@ save var registers
	str	r0, [fp, #-12]
	str	r1, [fp, #-16]
	str	r2, [fp, #-20]
	str	r3, [fp, #-24]
	@ Initialize stack frame for locals
	mov	r4, #0
	str	r4, [fp, #-8]
	@ begin return expression
	ldr	r4, [fp, #-12]
	ldr	r5, [fp, #-16]
	add	r4, r4, r5
	ldr	r5, [fp, #-20]
	add	r4, r4, r5
	ldr	r5, [fp, #-24]
	add	r4, r4, r5
	ldr	r5, [fp, #8]
	add	r4, r4, r5
	ldr	r5, [fp, #12]
	add	r4, r4, r5
	ldr	r5, [fp, #16]
	add	r4, r4, r5
	ldr	r5, [fp, #-8]
	add	r4, r4, r5
	mov	r0, r4
	ldmfd	sp!, {r4-r8, r10}	@ restore var registers
	sub	sp, fp, #0
	ldr	fp, [sp], #4
	bx	lr	@ return to caller


	.global	main

main:
	stmfd	sp!, {fp, lr}
	add	fp, sp, #4

	ldr	r9, .MEM	@ base register

	@ WRITE Instruction
	sub	sp, sp, #12
	mov	r5, sp	@ copy of stack pointer
	ldr	r0, =24
	push	{r0}
	ldr	r0, =23
	push	{r0}
	ldr	r0, =22
	push	{r0}
	ldr	r0, =21
	push	{r0}
	ldr	r0, =20
	push	{r0}
	ldr	r0, =19
	push	{r0}
	ldr	r0, =18
	push	{r0}
	pop	{r0, r1, r2, r3}
	pop	{r8}
	str	r8, [r5, #4]
	pop	{r8}
	str	r8, [r5, #8]
	pop	{r8}
	str	r8, [r5, #12]
	bl	sum
	add	sp, sp, #12
	mov	r1, r0
	ldr	r0, =write
	bl	printf

	@ WRITE Instruction
	ldr	r1, =147
	ldr	r0, =write
	bl	printf

	ldr	r0, =0
	ldmfd	sp!, {fp, pc}	@ end main

err:
	ldr	r0, =stderr
	ldr	r0, [r0]
	ldr	r1, =emsg
	bl	fprintf
	ldr	r0, =1
	bl	exit	@ quit

.MEM:
	.word	pgmem	@ program memory

	.data

write:
	.asciz	"%d\n"

read:
	.asciz	"%d"

emsg:
	.asciz	"error: invalid number\n"

num:
	.word	0
	.end
