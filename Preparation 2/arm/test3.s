	.arch armv7-a
	.fpu vfpv3-d16 @ 开启浮点运算扩展

@ 数据段
	.data
f:  .word 1092616192 @ IEEE 格式，对应于 10.0
					 @ 其实使用 .float 10.0 也可以，.float 是伪指令

@ 代码段
	.text
	.global main
	.type main , %function
main:
	push {r4, fp, lr}
	vpush {s4}
	mov fp, sp
	sub sp, sp, #8

	@ 将 1.0 存到 [fp - 8]，将 0（默认未显式初始化的数组元素为 0）存到 [fp - 4]
	vmov.f32 s4, #1065353216 @ IEEE 格式，对应于 1.0
	vstr.32 s4, [fp, #-8]
	mov r0, #0 @ 这里必须以 r0 作为中转，否则报错 Error: immediate out of range -- `vmov.f32 s4,#0.0'
	vmov.f32 s4, r0
	vstr.32 s4, [fp, #-4]

	@ putfloat(f)
	ldr r0, _bridge @ r0 = &_bridge
	ldr r0, [r0] @ r0 = 10.0
	vmov.f32 s0, r0
	bl putfloat @ s0 是浮点数的函数参数

	@ 换行
	mov r0, #10
	bl putch

	# s0 = a * b[0]，然后 s0 作为函数参数，调用 putfloat
	vmul.f32 s0, s4, s0
	bl putfloat

	@ 换行
	mov r0, #10
	bl putch

	@ putfarray(2, b)
	add r4, fp, #-8
	mov r1, r4
	mov r0, #2
	bl putfarray

	@ return 0
	mov r0, #0
	add sp, sp, #8
	vpop {s4}
	pop {r4, fp, lr}
	bx lr

@ 桥接全局变量
_bridge:
	.word f

	.section .note.GNU-stack,"",%
