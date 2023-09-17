; 声明外部函数
declare i32 @getint()
declare i32 @getfarray(float*)
declare i32 @getch()
declare void @putint(i32)
declare void @putch(i32)
declare void @putfarray(i32, float*)

; 常量声明、初始化
@RADIUS = constant float 5.5
@PI = constant float 0x400921FB60000000  ; 由于精度问题，这里必须使用 IEEE 标准
@EPS = constant float 0x3EB0C6F7A0000000

; 定义计算圆面积的函数
define float @circle_area(i32 %radius) {
    %1 = sitofp i32 %radius to float
    %2 = load float, float* @PI  ; 加载常量 @PI 到变量 %2 中
    %3 = fmul float %2, %1
    %4 = fmul float %1, %1
    %5 = fmul float %4, %2
    %6 = fadd float %3, %5
    %7 = fdiv float %6, 2.0
    ret float %7
}

; 定义主函数
define i32 @main() {
    %i = alloca i32       ; 变量 i
    %p = alloca i32       ; 变量 p
    %arr = alloca [10 x float]  ; 数组 arr
    %len = alloca i32      ; 变量 len

    store i32 1, i32* %i   ; 初始化 i = 1
    store i32 0, i32* %p   ; 初始化 p = 0

    %1 = bitcast [10 x float]* %arr to i32*   ; 获取数组 arr 的指针
    call i32 @getfarray(i32* %1)   ; 调用外部函数获取数组数据
    store i32 10, i32* %len  ; 初始化数组长度为 10

    br label %loop   ; 进入循环

loop:
    %2 = load i32, i32* %i   ; 加载变量 i
    %3 = icmp eq i32 %2, 1000000000   ; 检查是否达到循环结束条件
    br i1 %3, label %endloop, label %loopbody   ; 根据条件跳转到结束循环或循环体

loopbody:
    %input = call i32 @getfloat()   ; 调用外部函数获取浮点数输入
    %4 = sitofp i32 %input to float   ; 将输入转换为浮点数
    %5 = fmul float %4, %4   ; 计算 input * input
    %6 = load float, float* @PI  ; 加载常量 @PI 到变量 %6 中
    %7 = fmul float %6, %4   ; 计算 PI * input
    %8 = fmul float %5, %6   ; 计算 input * input * PI
    %9 = fadd float %7, %8   ; 计算 area = PI * input + input * input * PI
    %10 = call float @circle_area(i32 %input)   ; 调用计算圆面积的函数
    %11 = fadd float %10, %9   ; 计算 area_trunc = 圆面积 + area
    %12 = load i32, i32* %p   ; 加载变量 p
    %13 = getelementptr [10 x float], [10 x float]* %arr, i32 0, i32 %12   ; 获取数组元素指针
    %14 = load float, float* %13   ; 加载数组元素值
    %15 = fadd float %14, %4   ; 更新数组元素值
    store float %15, float* %13   ; 存储新的数组元素值
    call void @putfloat(float %9)   ; 输出浮点数 area
    call void @putch(i32 32)   ; 输出空格
    call void @putint(i32 %input)   ; 输出整数 input
    call void @putch(i32 10)   ; 输出换行
    %16 = load i32, i32* %i   ; 加载变量 i
    %17 = mul nsw i32 %16, 10   ; 计算 i * 10
    store i32 %17, i32* %i   ; 存储新的 i
    %18 = load i32, i32* %p   ; 加载变量 p
    %19 = add nsw i32 %18, 1   ; 计算 p + 1
    store i32 %19, i32* %p   ; 存储新的 p
    %20 = load i32, i32* %i   ; 加载变量 i
    %21 = icmp eq i32 %20, 1000000000   ; 检查是否达到循环结束条件
    br i1 %21, label %endloop, label %loop   ; 根据条件跳转到结束循环或继续循环

endloop:
    %22 = load i32, i32* %len   ; 加载数组长度
    call void @putfarray(i32 %22, i32* %1)   ; 输出数组
    ret i32 0   ; 返回0表示程序结束
}
