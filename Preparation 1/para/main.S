	.arch armv7-a
	.fpu vfpv3-d16
	.eabi_attribute 28, 1
	.eabi_attribute 20, 1
	.eabi_attribute 21, 1
	.eabi_attribute 23, 3
	.eabi_attribute 24, 1
	.eabi_attribute 25, 1
	.eabi_attribute 26, 2
	.eabi_attribute 30, 6
	.eabi_attribute 34, 1
	.eabi_attribute 18, 4
	.file	"main.c"
	.text
	.section	.rodata
	.align	2
.LC0:
	.ascii	"\346\225\260\347\273\204\345\205\203\347\264\240\344"
	.ascii	"\271\213\345\222\214\344\270\272: %d\012\000"
	.text
	.align	1
	.global	main
	.syntax unified
	.thumb
	.thumb_func
	.type	main, %function
main:
	@ args = 0, pretend = 0, frame = 40
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, lr}
	sub	sp, sp, #40
	add	r7, sp, #0
	ldr	r2, .L6
.LPIC2:
	add	r2, pc
	ldr	r3, .L6+4
	ldr	r3, [r2, r3]
	ldr	r3, [r3]
	str	r3, [r7, #36]
	mov	r3, #0
	mov	r3, sp
	mov	r8, r3
	movw	r3, #10000
	str	r3, [r7, #8]
	movs	r3, #0
	str	r3, [r7, #12]
	ldr	r6, [r7, #8]
	subs	r3, r6, #1
	str	r3, [r7, #16]
	mov	r2, r6
	movs	r3, #0
	mov	r4, r2
	mov	r5, r3
	mov	r2, #0
	mov	r3, #0
	lsls	r3, r5, #5
	orr	r3, r3, r4, lsr #27
	lsls	r2, r4, #5
	mov	r2, r6
	movs	r3, #0
	mov	r0, r2
	mov	r1, r3
	mov	r2, #0
	mov	r3, #0
	lsls	r3, r1, #5
	orr	r3, r3, r0, lsr #27
	lsls	r2, r0, #5
	mov	r3, r6
	lsls	r3, r3, #2
	adds	r3, r3, #7
	lsrs	r3, r3, #3
	lsls	r3, r3, #3
	sub	sp, sp, r3
	mov	r3, sp
	adds	r3, r3, #3
	lsrs	r3, r3, #2
	lsls	r3, r3, #2
	str	r3, [r7, #20]
	movs	r3, #0
	str	r3, [r7, #4]
	b	.L2
.L3:
	ldr	r3, [r7, #20]
	ldr	r2, [r7, #4]
	ldr	r1, [r7, #4]
	str	r1, [r3, r2, lsl #2]
	ldr	r3, [r7, #4]
	adds	r3, r3, #1
	str	r3, [r7, #4]
.L2:
	ldr	r2, [r7, #4]
	ldr	r3, [r7, #8]
	cmp	r2, r3
	blt	.L3
	ldr	r3, [r7, #20]
	str	r3, [r7, #32]
	ldr	r3, [r7, #8]
	str	r3, [r7, #24]
	ldr	r3, [r7, #12]
	str	r3, [r7, #28]
	add	r1, r7, #24
	movs	r3, #0
	movs	r2, #0
	ldr	r0, .L6+8
.LPIC0:
	add	r0, pc
	bl	GOMP_parallel(PLT)
	ldr	r3, [r7, #28]
	str	r3, [r7, #12]
	ldr	r1, [r7, #12]
	ldr	r3, .L6+12
.LPIC1:
	add	r3, pc
	mov	r0, r3
	bl	printf(PLT)
	movs	r3, #0
	mov	sp, r8
	ldr	r1, .L6+16
.LPIC3:
	add	r1, pc
	ldr	r2, .L6+4
	ldr	r2, [r1, r2]
	ldr	r1, [r2]
	ldr	r2, [r7, #36]
	eors	r1, r2, r1
	mov	r2, #0
	beq	.L5
	bl	__stack_chk_fail(PLT)
.L5:
	mov	r0, r3
	adds	r7, r7, #40
	mov	sp, r7
	@ sp needed
	pop	{r4, r5, r6, r7, r8, pc}
.L7:
	.align	2
.L6:
	.word	_GLOBAL_OFFSET_TABLE_-(.LPIC2+4)
	.word	__stack_chk_guard(GOT)
	.word	main._omp_fn.0-(.LPIC0+4)
	.word	.LC0-(.LPIC1+4)
	.word	_GLOBAL_OFFSET_TABLE_-(.LPIC3+4)
	.size	main, .-main
	.global	__aeabi_idiv
	.global	__aeabi_idivmod
	.align	1
	.syntax unified
	.thumb
	.thumb_func
	.type	main._omp_fn.0, %function
main._omp_fn.0:
	@ args = 0, pretend = 0, frame = 24
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, lr}
	sub	sp, sp, #24
	add	r7, sp, #0
	str	r0, [r7, #4]
	ldr	r3, [r7, #4]
	ldr	r3, [r3, #8]
	str	r3, [r7, #16]
	ldr	r3, [r7, #4]
	ldr	r3, [r3]
	str	r3, [r7, #20]
	ldr	r6, [r7, #20]
	bl	omp_get_num_threads(PLT)
	mov	r8, r0
	bl	omp_get_thread_num(PLT)
	mov	r5, r0
	mov	r1, r8
	mov	r0, r6
	bl	__aeabi_idiv(PLT)
	mov	r3, r0
	mov	r4, r3
	mov	r1, r8
	mov	r0, r6
	bl	__aeabi_idivmod(PLT)
	mov	r3, r1
	cmp	r5, r3
	blt	.L9
.L12:
	mul	r2, r5, r4
	add	r3, r3, r2
	adds	r2, r3, r4
	cmp	r3, r2
	bge	.L13
	str	r3, [r7, #12]
.L11:
	ldr	r3, [r7, #12]
	cmp	r3, r2
	bge	.L13
	ldr	r3, [r7, #16]
	ldr	r1, [r7, #12]
	ldr	r1, [r3, r1, lsl #2]
	ldr	r3, [r7, #4]
	ldr	r3, [r3, #4]
	add	r1, r1, r3
	ldr	r3, [r7, #4]
	str	r1, [r3, #4]
	ldr	r3, [r7, #12]
	adds	r3, r3, #1
	str	r3, [r7, #12]
	b	.L11
.L9:
	movs	r3, #0
	adds	r4, r4, #1
	b	.L12
.L13:
	nop
	adds	r7, r7, #24
	mov	sp, r7
	@ sp needed
	pop	{r4, r5, r6, r7, r8, pc}
	.size	main._omp_fn.0, .-main._omp_fn.0
	.ident	"GCC: (Ubuntu 11.4.0-1ubuntu1~22.04) 11.4.0"
	.section	.note.GNU-stack,"",%progbits
