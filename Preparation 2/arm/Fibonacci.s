	.arch armv8-a
	.arch_extension crc
	.arm
	.text
	.global main
	.type main , %function
main:
	push {r4, r5, r6, r7, fp, lr}
	mov fp, sp
.L7:                               	@ succs = .L16, .L68
	@ dummy 	defs:{ fp }
	bl getint	@ defs:{ lr r12 r0 r1 r2 r3 }	uses:{ fp }
	mov r7, r0
	mov r0, #0
	bl putint	@ defs:{ lr r12 r0 r1 r2 r3 }	uses:{ r0 fp }
	mov r0, #1
	bl putint	@ defs:{ lr r12 r0 r1 r2 r3 }	uses:{ r0 fp }
	cmp r7, #1
	bgt .L68
	b .L16
.L68:                               	@ preds = .L7                               	@ succs = .L69, .L16
	mov r0, #0
	mov r5, #1
	mov r4, #1
	add r6, r0, r5
	add r0, r0, r5
	bl putint	@ defs:{ lr r12 r0 r1 r2 r3 }	uses:{ r0 fp }
	add r1, r4, #1
	cmp r1, r7
	blt .L69
	b .L16
.L69:                               	@ succs = .L69, .L16
	mov r0, r5
	mov r4, r1
	mov r5, r6
	add r6, r0, r5
	add r0, r0, r5
	bl putint	@ defs:{ lr r12 r0 r1 r2 r3 }	uses:{ r0 fp }
	add r1, r4, #1
	cmp r1, r7
	blt .L69
	b .L16
.L16:                               	@ preds = .L7
	mov r0, #0
	@ dummy 	uses:{ r0 }
	pop {r4, r5, r6, r7, fp, lr}
	bx lr

