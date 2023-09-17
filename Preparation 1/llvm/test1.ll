; 全局变量定义
@RADIUS = constant float 5.5
@PI = constant float 0x400921FB60000000
@EPS = constant float 0x3EB0C6F7A0000000
@.str = constant [3 x i8] c"%f\00"
@.str.1 = constant [4 x i8] c"%f \00"
@.str.2 = constant [4 x i8] c"%d\0A\00"

; circle_area 函数定义
define float @circle_area(i32 %radius) {
  %1 = sitofp i32 %radius to float
  %2 = fmul float 0x400921FB60000000, %1
  %3 = fmul float %1, %1
  %4 = fmul float %3, 0x400921FB60000000
  %5 = fadd float %2, %4
  %6 = fdiv float %5, 2.0
  ret float %6
}

; 主函数 main 的定义
define i32 @main() {
  %i = alloca i32
  %p = alloca i32
  %arr = alloca [10 x float]
  %len = alloca i32
  store i32 1, i32* %i
  store i32 0, i32* %p
  %1 = getelementptr inbounds [10 x float], [10 x float]* %arr, i32 0, i32 0
  store float 1.0, float* %1
  %2 = getelementptr inbounds [10 x float], [10 x float]* %arr, i32 0, i32 1
  store float 2.0, float* %2
  store i32 40, i32* %len
  br label %loop

loop: ; 循环开始
  %input = alloca float
  %area = alloca float
  %area_trunc = alloca i32
  %3 = load i32, i32* %i
  %4 = icmp eq i32 %3, 1000000000
  br i1 %4, label %endloop, label %loopbody

loopbody: ; 循环体
  %5 = call i32 (i8*, ...) @scanf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str, i64 0, i64 0), float* %input)
  %6 = load float, float* %input
  %7 = fmul float 0x400921FB60000000, %6
  %8 = fmul float %6, %6
  %9 = fmul float %8, 0x400921FB60000000
  %10 = fadd float %7, %9
  %11 = fdiv float %10, 2.0
  store float %11, float* %area
  %12 = fptosi float %11 to i32
  store i32 %12, i32* %area_trunc
  %13 = load i32, i32* %p
  %14 = getelementptr inbounds [10 x float], [10 x float]* %arr, i32 0, i32 %13
  %15 = load float, float* %14
  %16 = fadd float %15, %6
  store float %16, float* %14
  %17 = load i32, i32* %i
  %18 = mul i32 %17, 10
  store i32 %18, i32* %i
  %19 = load i32, i32* %p
  %20 = add i32 %19, 1
  store i32 %20, i32* %p
  br label %loop

endloop: ; 循环结束
  %21 = load i32, i32* %len
  br label %printloop

printloop: ; 输出浮点数数组
  %22 = load i32, i32* %p
  %23 = icmp slt i32 %22, %21
  br i1 %23, label %print, label %end

print: ; 输出
  %24 = load i32, i32* %p
  %25 = getelementptr inbounds [10 x float], [10 x float]* %arr, i32 0, i32 %24
  %26 = load float, float* %25
  %27 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.1, i64 0, i64 0), float %26)
  br label %incp

incp: ; 增加索引
  %28 = load i32, i32* %p
  %29 = add i32 %28, 1
  store i32 %29, i32* %p
  br label %printloop

end: ; 主函数返回
  ret i32 0
}

; 输入函数声明
declare i32 @scanf(i8*, ...) 

; 输出函数声明
declare i32 @printf(i8*, ...)
