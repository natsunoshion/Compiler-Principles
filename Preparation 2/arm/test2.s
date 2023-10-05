	.arch armv8-a
	.arch_extension crc
	.arm
	.text
	.global main
	.type main , %function
main:
	push {fp, lr}
	mov fp, sp
.L1:
	@ dummy 	defs:{ fp }
	ldr r0, =1092616192
	vmov.f32 s0, r0
	bl putfloat	@ defs:{ lr r12 s0 r0 r1 r2 r3 }	uses:{ s0 fp }
	mov r0, #0
	@ dummy 	uses:{ r0 }
	pop {fp, lr}
	bx lr

