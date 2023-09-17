// 常量声明、初始化
// 浮点数常量及运算
const float RADIUS = 5.5, PI = 3.141592653589793, EPS = 1e-6;

// 函数
float circle_area(int radius)
{
    return (PI * radius * radius + (radius * radius) * PI) / 2;
}

int main()
{
    // 数据类型 int
    // 变量初始化
    int i = 1, p = 0;
    // 浮点数变量
    // 数组
    float arr[10] = {1.0, 2.0};
    int len      = getfarray(arr); // 获取数组长度

    // 语句
    while (1) {
        // 输入输出
        float input = getfloat();
        float area = PI * input * input, area_trunc = circle_area(input);
        arr[p] += input;

        putfloat(area);
        putch(' ');
        putint(area_trunc);

        putch(10);
        i *= 10;
        p = p + 1;

        // break 和 continue 语句
        if (i == 1e9)
            break;
        else
            continue;
    }
    putfarray(len, arr); // 输出浮点数数组
    return 0;
}
