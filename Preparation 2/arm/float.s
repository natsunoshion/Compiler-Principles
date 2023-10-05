	.arch armv7-a
	.fpu vfpv3-d16 @ 开启浮点运算扩展

	.text @ 代码段
	.global main
	.type main , %function
main:
	@ 保存寄存器
	push {fp, lr}
	@ 更新栈帧
	mov fp, sp
.L0:
	ldr r0, =0x41200000 @ IEEE 格式，对应的浮点数为 10.0
	vmov.f32 s0, r0 @ 使用 vmov 将 r0 移动到浮点寄存器 s0
	bl putfloat 
	mov r0, #0 @ 主函数的返回值为0
	@ 还原栈帧
	mov sp, fp
	pop {fp, lr}
	bx lr
