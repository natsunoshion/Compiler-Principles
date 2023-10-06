	.arch armv7-a

	.text
	.global main
	.type main , %function
main:
	push {r4, fp, lr} @ 由于后面使用寄存器 r4 保存了 a[1] 局部变量，按照 ATPCS 规范，需要保存该寄存器
	mov fp, sp
	sub sp, sp, #36 @ 为 9 个 int 数组元素（局部变量）腾出空间

	@ 逐步把 9 个数组元素存入栈中，也就是二维数组按行主序展开为一维数组
	mov r0, #1
	str r0, [fp, #-36]
	mov r0, #2
	str r0, [fp, #-32]
	mov r0, #3
	str r0, [fp, #-28]
	mov r0, #4
	str r0, [fp, #-24]
	mov r0, #5
	str r0, [fp, #-20]
	mov r0, #6
	str r0, [fp, #-16]
	mov r0, #7
	str r0, [fp, #-12]
	mov r0, #8
	str r0, [fp, #-8]
	mov r0, #9
	str r0, [fp, #-4]

	@ 调用 getint 函数，将用户输入存入 r0 寄存器，即 r0 = getint()
	bl getint
	@ a[1][0] = r0
	str r0, [fp, #-24]
	@ 计算 a[1] 的地址，存入 r4 中
	add r4, fp, #-24

	@ putarray 的两个参数分别为 3 和 a[1]，通过 r0 和 r1 传递
	mov r1, r4
	mov r0, #3
	@ 调用 putarray 函数
	bl putarray

	@ 计算 a[2][0] + a[2][1]，存入 r0
	ldr r0, [fp, #-12]   @ r0 = [fp, #-12]
	ldr r1, [fp, #-8]    @ r1 = [fp, #-8]
	add r0, r0, r1       @ r0 = r0 + r1
	@ 调用 putint 输出
	bl putint

	@ 主函数返回，恢复栈帧
	mov r0, #0
	add sp, sp, #36 @ 清除局部变量空间
	pop {r4, fp, lr}
	bx lr

