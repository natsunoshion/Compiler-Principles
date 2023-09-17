#include <stdio.h>
#include <omp.h>

int main() {
    int n = 10000;
    int sum = 0;
    int arr[n];

    // 初始化数组
    for (int i = 0; i < n; i++) {
        arr[i] = i;
    }

    #pragma omp parallel for simd
    for (int i = 0; i < n; i++) {
        sum += arr[i];
    }

    printf("数组元素之和为: %d\n", sum);

    return 0;
}
