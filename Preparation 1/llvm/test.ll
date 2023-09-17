; 常量声明、初始化
@RADIUS = dso_local constant float 5.500000e+00   ; 半径
@PI = dso_local constant float 0x400921FB60000000  ; 圆周率 PI
@EPS = dso_local constant float 0x3EB0C6F7A0000000 ; EPSILON 常量，即误差容忍范围

; 用于格式化字符串
@.str = constant [3 x i8] c"%f\00"
@.str.1 = constant [4 x i8] c"%f \00"
@.str.2 = constant [4 x i8] c"%d\0A\00"
@.str.3 = constant [2 x i8] c"\0A\00"

; 声明 LLVM 内置函数
declare void @llvm.memset.p0i8.i64(i8*, i8, i64, i1 immarg) #2  ; 内存填充函数
declare i32 @__isoc99_scanf(i8*, ...) #3  ; 输入函数
declare i32 @printf(i8*, ...) #3  ; 输出函数
declare float @llvm.fmuladd.f32(float, float, float) #1  ; 用于浮点数乘法和加法的函数

; 定义计算圆面积的函数
define dso_local float @circle_area(i32 %0) #0 {
  %2 = alloca i32
  store i32 %0, i32* %2
  %3 = load i32, i32* %2
  %4 = sitofp i32 %3 to float
  %5 = fmul float 0x400921FB60000000, %4        ; 计算 PI * radius * radius 部分
  %6 = load i32, i32* %2
  %7 = sitofp i32 %6 to float
  %8 = load i32, i32* %2
  %9 = load i32, i32* %2
  %10 = mul nsw i32 %8, %9
  %11 = sitofp i32 %10 to float
  %12 = fmul float %11, 0x400921FB60000000       ; 计算 (radius * radius) * PI 部分
  %13 = call float @llvm.fmuladd.f32(float %5, float %7, float %12) ; 合并两部分结果
  %14 = fdiv float %13, 2.000000e+00            ; 除以 2，得到圆面积
  ret float %14
}

; 定义主函数
define dso_local i32 @main() #0 {
  %1 = alloca i32          ; i
  %2 = alloca i32          ; p
  %3 = alloca i32          ; len
  %4 = alloca [10 x float] ; 包含 10 个浮点数的数组
  %5 = alloca i32          ; 数组长度
  %6 = alloca float        ; input
  %7 = alloca float        ; area
  %8 = alloca float        ; area_trunc
  %9 = alloca i32          ; 整数变量 i 的位数
  store i32 0, i32* %1     ; i = 0
  store i32 1, i32* %2     ; p = 1
  store i32 0, i32* %3     ; len = 0
  %10 = bitcast [10 x float]* %4 to i8*  ; 获取数组的内存指针
  call void @llvm.memset.p0i8.i64(i8* %10, i8 0, i64 40, i1 false) ; 初始化数组为零

  ; 将数组强制转换为结构体指针，以便管理和访问多个相关的浮点数
  %11 = bitcast i8* %10 to <{ float, float, [8 x float] }>*

  ; 初始化数组前两个元素
  %12 = getelementptr inbounds <{ float, float, [8 x float] }>, <{ float, float, [8 x float] }>* %11, i32 0, i32 0
  store float 1.000000e+00, float* %12
  %13 = getelementptr inbounds <{ float, float, [8 x float] }>, <{ float, float, [8 x float] }>* %11, i32 0, i32 1
  store float 2.000000e+00, float* %13
  store i32 40, i32* %5  ; 初始化数组长度（以字节为单位）
  br label %14

14: ; 主循环入口
  %15 = call i32 (i8*, ...) @__isoc99_scanf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str, i64 0, i64 0), float* %6) ; 输入浮点数
  %16 = load float, float* %6
  %17 = fmul float 0x400921FB60000000, %16       ; 计算 PI * input * input 部分
  %18 = load float, float* %6
  %19 = fmul float %17, %18                      ; 计算 (input * input) * PI 部分
  store float %19, float* %7
  %20 = load float, float* %6
  %21 = fptosi float %20 to i32                   ; 转换浮点数为整数
  %22 = call float @circle_area(i32 %21)   ; 调用计算圆面积的函数
  store float %22, float* %8
  %23 = load float, float* %6
  %24 = load i32, i32* %3
  %25 = sext i32 %24 to i64
  %26 = getelementptr inbounds [10 x float], [10 x float]* %4, i64 0, i64 %25
  %27 = load float, float* %26
  %28 = fadd float %27, %23                       ; 更新数组元素值
  store float %28, float* %26
  %29 = load float, float* %7
  %30 = fpext float %29 to double
  %31 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.1, i64 0, i64 0), double %30) ; 输出浮点数
  %32 = load float, float* %8
  %33 = fptosi float %32 to i32                   ; 转换浮点数为整数
  %34 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.2, i64 0, i64 0), i32 %33) ; 输出整数
  %35 = load i32, i32* %2
  %36 = mul nsw i32 %35, 10
  store i32 %36, i32* %2
  %37 = load i32, i32* %3
  %38 = add nsw i32 %37, 1
  store i32 %38, i32* %3
  %39 = load i32, i32* %2
  %40 = sitofp i32 %39 to double
  %41 = fcmp oeq double %40, 1.000000e+09
  br i1 %41, label %42, label %43 ; 条件判断，如果 i 等于 1e9（输入了 10 次）则跳出循环，否则继续循环

42: ; 循环终止
  br label %44

43: ; 循环继续
  br label %14

44: ; 输出浮点数数组
  store i32 0, i32* %9
  br label %45

45: ; 输出数组循环入口
  %46 = load i32, i32* %9
  %byte_len = load i32, i32* %5  ; 加载字节长度值
  %47 = sdiv i32 %byte_len, 4    ; 除以 4，获取数组的长度
  %48 = icmp slt i32 %46, %47
  br i1 %48, label %49, label %59 ; 条件判断，如果数组索引小于数组长度则继续输出，否则就跳出输出循环，输出最后的换行

49: ; 输出数组元素
  %50 = load i32, i32* %9
  %51 = sext i32 %50 to i64
  %52 = getelementptr inbounds [10 x float], [10 x float]* %4, i64 0, i64 %51
  %53 = load float, float* %52
  %54 = fpext float %53 to double
  %55 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.1, i64 0, i64 0), double %54) ; 输出浮点数
  br label %56

56: ; 更新数组索引
  %57 = load i32, i32* %9
  %58 = add nsw i32 %57, 1
  store i32 %58, i32* %9
  br label %45

59: ; 输出换行
  %60 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i64 0, i64 0))
  ret i32 0
}
