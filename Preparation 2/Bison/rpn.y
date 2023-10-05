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
            $$ = $2;
          }
        | MINUS expr %prec UMINUS
          {
            // 与自己实现的 concat 函数参数不一样，那么就自己再写一遍
            char* result = malloc(strlen($2) + strlen("-"));
            strcpy(result, $2);
            strcat(result, "-");
            $$ = result;
          }
        | NUMBER
          {
            $$ = $1;
          }
        ;

%%

// programs section

char* concat(char* str1, char* str2, char* op) {

    char* result = malloc(strlen(str1) + strlen(str2) + strlen(op));
    strcpy(result, str1);
    strcat(result, str2);
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
               其中yylval是属性值
            */
            char num_str[100]; 
            int i = 0;

            while (isdigit(t)) {
                num_str[i++] = t; 
                t = getchar();
            }

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