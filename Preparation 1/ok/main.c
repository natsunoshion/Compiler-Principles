#include <stdio.h>

int main() {
    int a, b, i, t, n;
    // 我是注释
    /*
        我也是
    */
    _Pragma ("message( \"the _Pragma way\")") 
    #if 1
    a = 0;
    #endif

    a = 0;
    b = 1;
    i = 1;
    scanf("%d", &n);
    printf("%d\n%d\n", a, b);
    while (i < n) {
        t = b;
        b = a + b;
        printf("%d\n", b);
        a = t;
        i = i + 1;
    }
    return 0;
}
