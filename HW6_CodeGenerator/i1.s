	.text
	.comm	pgmem,44,4
	.global	main

main:
	push	{fp, lr}

	ldr	r11, .MEM	@ base register

	@ WRITE Instruction
	ldr	r0, =write
	ldr	r1, [r11, #0]
	bl	printf

	@ Assignment
	ldr	r9, =18
	str	r9, [r11, #40]

	@ Assignment
	ldr	r9, [r11, #40]
	str	r9, [r11, #20]

	@ WRITE Instruction
	ldr	r9, [r11, #0]
	cmp	r9, #3	@ bounds checking
	bhi	err
	ldr	r5, =4
	mul	r9, r9, r5	@ indexing
	add	r9, r9, #4
	ldr	r0, =write
	ldr	r1, [r11, r9]
	bl	printf

	@ WRITE Instruction
	ldr	r0, =write
	ldr	r1, [r11, #40]
	bl	printf

	b	.L1_pool	@ literal pool
.ltorg

.L1_pool:
	@ Assignment
	ldr	r9, [r11, #0]
	cmp	r9, #3	@ bounds checking
	bhi	err
	ldr	r5, =4
	mul	r9, r9, r5	@ indexing
	add	r9, r9, #4
	ldr	r5, [r11, #20]
	str	r5, [r11, r9]

	@ WRITE Instruction
	ldr	r0, =write
	ldr	r1, [r11, #20]
	bl	printf

	@ WRITE Instruction
	ldr	r9, [r11, #0]
	cmp	r9, #3	@ bounds checking
	bhi	err
	ldr	r5, =4
	mul	r9, r9, r5	@ indexing
	add	r9, r9, #4
	ldr	r0, =write
	ldr	r1, [r11, r9]
	bl	printf

	ldr	r0, =0
	pop	{fp, pc}	@ end main

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
