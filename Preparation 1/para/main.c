#include <stdio.h>

int main() {
    int i;
    int arr[10];

    // 初始化数组
    for (i = 0; i < 10; i++) {
        arr[i] = i;
    }

    // 使用编译指令展开循环
    #pragma unroll
    for (i = 0; i < 10; i++) {
        printf("arr[%d] = %d\n", i, arr[i]);
    }

    return 0;
}
