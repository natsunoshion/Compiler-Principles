	.cpu cortex-a72
	.arch armv8-a
	.fpu vfpv3-d16
	.arch_extension crc
	.arm
.section .rodata
.global RADIUS
.size RADIUS, 4
RADIUS:
	.word 1085276160
.global PI
.size PI, 4
PI:
	.word 1078530011
.global EPS
.size EPS, 4
EPS:
	.word 897988541

	.text
	.global main
	.type main , %function
main:
	push {r4, r5, r6, r7, fp, lr}
	mov fp, sp
	sub sp, sp, #40
	lsr sp, sp, #3
	lsl sp, sp, #3
.L62:
	mvn r0, #39
	add r4, fp, r0
	mov r0, r4
	ldr r0, =-40
	add r0, fp, r0
	mov r1, #0
	mov r2, #40
	bl memset
	mvn r0, #39
	mov r0, r4
	mov r0, r4
	mov r0, #1065353216
	str r0, [r4]
	mov r0, r4
	bl getfarray
	mov r7, r0
	mov r0, #1
	mov r6, #1
	mov r0, #0
	mov r5, #0
.L70:
	bl getfloat
	vmov.f32 s1, s0
	ldr r2, =1078530011
	vmov s1, r2
	vmul.f32 s1, s0, s1
	vmul.f32 s4, s1, s0
	vcvt.s32.f32 s1, s0
	vmov r1, s1
	vmov s1, r1
	vcvt.f32.s32 s2, s1
	mov r0, r2
	vmov s1, r2
	vmul.f32 s1, s2, s1
	vmul.f32 s3, s1, s2
	mul r0, r1, r1
	vmov s1, r0
	vcvt.f32.s32 s2, s1
	mov r0, r2
	vmov s1, r2
	vmul.f32 s1, s2, s1
	vadd.f32 s2, s3, s1
	vmov.f32 s1, #2.000000
	vdiv.f32 s1, s2, s1
	vcvt.s32.f32 s1, s1
	vmov r4, s1
	mvn r0, #39
	add r1, fp, r0
	lsl r0, r5, #2
	add r1, r1, r0
	mov r0, r1
	vldr.32 s1, [r1]
	vadd.f32 s0, s1, s0
	vstr.32 s0, [r1]
	vmov.f32 s0, s4
	bl putfloat
	mov r0, #32
	bl putch
	mov r0, r4
	bl putint
	mov r0, #10
	bl putch
	mov r0, #10
	mul r6, r6, r0
	add r5, r5, #1
	vmov s0, r6
	vcvt.f32.s32 s1, s0
	ldr r0, =1315859240
	vmov s0, r0
	vcmp.f32 s1, s0
	vmrs APSR_nzcv, FPSCR
	moveq r0, #1
	movne r0, #0
	beq .L71
	b .L70
.L71:
	mvn r0, #39
	add r1, fp, r0
	mov r0, r1
	mov r0, r7
	bl putfarray
	mov r0, #0
	mov r0, #0
	mov sp, fp
	pop {r4, r5, r6, r7, fp, lr}
	bx lr

.LTORG
addr_RADIUS_0:
	.word RADIUS
addr_PI_0:
	.word PI
addr_EPS_0:
	.word EPS
