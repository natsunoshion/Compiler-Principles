%{
/*********************************************
修改Yacc程序，不进行表达式的计算，而是实现中缀表达式到后缀表达式的转换。
YACC file
**********************************************/
#include<stdio.h>
#include<stdlib.h>
#include<ctype.h>
#include<string.h> // 由于使用了 strlen 等字符串函数，所以需要引入 string.h
#ifndef YYSTYPE
#define YYSTYPE char* // 这里应当改为 char*，表达式是一个字符串
#endif
int yylex();
extern int yyparse(); // 该函数会一直调用 yylex，由 Bison 实现
FILE* yyin;
/* 临时数组，用于存放 yylex 读入的数字
   不能在yylex处定义，否则会产生野指针（指针是局部变量
*/
char num_str[100];
char* result;
void yyerror(const char* s);
char* concat(char* str1, char* str2, char* op); // 自定义 concat 函数
%}

// 给每个符号定义一个单词类别：加减、乘除、数字、左右括号
%token ADD MINUS
%token MUL DIV
%token NUMBER
%token LPAREN RPAREN

%left ADD MINUS
%left MUL DIV
%right UMINUS

%%


lines   :   lines expr ';'
          {
            printf("%s\n", $2);
          }
        | lines ';'
        |
        ;

expr    : expr ADD expr
          {
            $$ = concat($1, $3, "+");
          }
        | expr MINUS expr
          {
            $$ = concat($1, $3, "-");
          }
        | expr MUL expr
          {
            $$ = concat($1, $3, "*");
          }
        | expr DIV expr
          {
            $$ = concat($1, $3, "/");
          }
        | LPAREN expr RPAREN
          {
            // 由于使用了全局变量存数字字符串，那么这里就需要 malloc 数字的地址，否则地址冲突
            $$ = malloc(strlen($2));
            strcpy($$, $2);
          }
        | MINUS expr %prec UMINUS
          {
            // 与自己实现的 concat 函数参数不一样，那么就自己再写一遍
            $$ = malloc(strlen($2) + strlen("-"));
            strcpy($$, "-");
            strcat($$, $2);
          }
        | NUMBER
          {
            // 这里不能直接 `$$ = $1`，否则一直用的同一个地址
            $$ = malloc(strlen($1));
            strcpy($$, $1);
          }
        ;

%%

// programs section

char* concat(char* str1, char* str2, char* op) {

    // 拼接后缀字符串，为了便于阅读（特别是有负号的时候），中间添加空格，所以有 `+2`
    result = malloc(strlen(str1) + strlen(str2) + strlen(op) + 2); // result 也在全局区
    strcpy(result, str1);
    strcat(result, " ");
    strcat(result, str2);
    strcat(result, " ");
    strcat(result, op);

    return result;
}

int yylex()
{
    int t;
    while(1){
        t = getchar();
        if (t==' '||t=='\t'||t=='\n')
        {
            //do noting
        }
        else if (isdigit(t))
        {
            /* 解析多位数字返回字符串类型（因为最终的表达式是字符串）
               其中 yylval 是属性值
            */
            int i = 0;

            while (isdigit(t)) {
                num_str[i++] = t; // num_str 是全局变量
                t = getchar();
            }

            // 读入了非数字，回退
            ungetc(t, stdin);

            num_str[i] = '\0'; // 终止字符串
            yylval = num_str; // 直接返回字符串
            return NUMBER;
        }
        else if (t == '+')
        {
            return ADD;
        }
        else if (t == '-')
        {
            return MINUS;
        }
        // 识别其他符号
        else if (t == '*')
        {
            return MUL;
        }
        else if (t == '/')
        {
            return DIV;
        }
        else if (t == '(')
        {
            return LPAREN;
        }
        else if (t == ')')
        {
            return RPAREN;
        }
        else
        {
            return t;
        }
    }
}

int main(void)
{
    yyin = stdin;
    do
    {
        yyparse();
    }
    while (!feof(yyin));
    return 0;
}

void yyerror(const char* s){
    fprintf(stderr, "Parse error: %s\n", s);
    exit(1);
}
