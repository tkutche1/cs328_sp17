	.text
	.comm	pgmem,80,4

	.align	2
blah:
	stmfd	sp!, {fp, lr}	@ caller
	add	fp, sp, #4
	sub	sp, sp, #8	@ local vars and r0-r3
	stmfd	sp!, {r4-r8, r10}	@ save var registers
	str	r0, [fp, #-8]
	@ begin procedure instructions
	@ Assignment
	ldr	r8, =3
	str	r8, [r9, #48]

	@ WRITE Instruction
	ldr	r8, [fp, #-8]
	ldr	r7, [r9, #48]
	cmp	r7, #4	@ bounds checking
	bhi	err
	ldr	r6, =4
	mul	r7, r7, r6	@ indexing
	add	r7, r7, r8
	ldr	r1, [r9, r7]
	ldr	r0, =write
	bl	printf

	@ WRITE Instruction
	ldr	r8, [fp, #-8]
	add	r8, r8, #12
	ldr	r1, [r9, r8]
	ldr	r0, =write
	bl	printf

	ldmfd	sp!, {r4-r8, r10}	@ restore var registers
	sub	sp, fp, #4
	ldmfd	sp!, {fp, pc}	@ return


	.global	main

main:
	stmfd	sp!, {fp, lr}
	add	fp, sp, #4

	ldr	r9, .MEM	@ base register

	@ Assignment
	ldr	r8, =13
	str	r8, [r9, #28]

	@ Assignment
	ldr	r8, =14
	str	r8, [r9, #32]

	b	.L1_pool	@ literal pool
.ltorg

.L1_pool:
	@ Assignment
	ldr	r8, =14
	str	r8, [r9, #36]

	@ Assignment
	ldr	r8, =14
	str	r8, [r9, #40]

	@ Assignment
	ldr	r8, =14
	str	r8, [r9, #44]

	ldr	r0, =28	@ load address
	push	{r0}
	pop	{r0}
	bl	blah
	@ WRITE Instruction
	ldr	r1, [r9, #40]
	ldr	r0, =write
	bl	printf

	@ WRITE Instruction
	ldr	r1, =14
	ldr	r0, =write
	bl	printf

	b	.L2_pool	@ literal pool
.ltorg

.L2_pool:
	@ WRITE Instruction
	ldr	r1, [r9, #48]
	ldr	r0, =write
	bl	printf

	@ WRITE Instruction
	ldr	r1, =3
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
