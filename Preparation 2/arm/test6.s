	.arch armv7-a

    .data
a: .float 0.0, 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0, 11.0, 12.0, 13.0, 14.0, 15.0
b: .float 0.0, 2.0, 4.0, 6.0, 8.0, 10.0, 12.0, 14.0, 16.0, 18.0, 20.0, 22.0, 24.0, 26.0, 28.0, 30.0
c: .float 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0

    .text
    .global main
    .type main , %function
main:
    push {fp, lr}

    ldr r0, =a
    ldr r1, =b
    ldr r2, =c
    mov r3, #4 @ 循环计数

loop:
    @ 从 r0 地址（也就是数组 a）处载入 4 个 32 位的浮点数，存入寄存器 q0
    vld1.f32 {q0}, [r0]
    @ 从 r1 地址（也就是数组 b）处载入 4 个 32 位的浮点数
    vld1.f32 {q1}, [r1]
    @ 向量化加法运算
    vadd.f32 q0, q0, q1
    @ 将寄存器 q0 中的 4 个 32 位的浮点数存入地址 r2（也就是数组 c）
    vst1.f32 {q0}, [r2]

    @ i += 4
    add r0, r0, #16
    add r1, r1, #16
    add r2, r2, #16

    @ 总共执行 4 次
    subs r3, r3, #1
    bne loop

    mov r0, #16
    ldr r1, =c
    bl putfarray

    pop {fp, lr}
    bx lr
