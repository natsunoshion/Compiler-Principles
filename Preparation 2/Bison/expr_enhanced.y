%{
/*********************************************
将所有的词法分析功能均放在 yylex 函数内实现，为 +、-、*、\、(、 ) 每个运算符及整数分别定义一个单词类别，在 yylex 内实现代码，能
识别这些单词，并将单词类别返回给词法分析程序。
实现功能更强的词法分析程序，可识别并忽略空格、制表符、回车等
空白符，能识别多位十进制整数。
YACC file
**********************************************/
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>

// 标识符长度不超过 256
#define MAX_LEN 256

// 符号表的链表节点结构
typedef struct VarNode {
    char* name;
    double value;
    struct VarNode* next;
} VarNode;

VarNode* symbolTable = NULL; // 头指针

int yylex();
extern int yyparse(); // 该函数会一直调用 yylex，由 Bison 实现
FILE* yyin;
void yyerror(const char* s);

// 查找变量
double get_value(char* name);

// 插入变量
void set_value(char* name, double value);
%}

/* 使用 union 定义 yylval 的类型，而不是 YYSTYPE
   也就是说，yylval 现在可以是下面的任意一种类型
   值得注意的是，这个应该放在 %} 之后，也就是定义部分
*/
%union {
    double dval;
    char* sval;
}

// 给每个符号定义一个单词类别：加减、乘除、数字、左右括号
%token ADD MINUS
%token MUL DIV
/* %token NUMBER */
%token LPAREN RPAREN
%token ASSIGN

%token <dval> NUMBER // 数字对应 dval
%token <sval> VAR // 标识符对应 sval
%type <dval> expr // 表达式的属性值设置为 dval
%type <dval> stmt // 语句的属性值设置为 dval

%left ADD MINUS
%left MUL DIV
%right UMINUS

%%


lines   :       lines stmt ';' { printf("%f\n", $2); }
        |       lines ';'
        |
        ;

// stmt 替换原来的 expr，它除了表达式还包括赋值语句
stmt    :       VAR ASSIGN expr { set_value($1, $3); $$ = $3; } // 这里也需要把 expr 的值传给 stmt，方便打印输出
        |       expr { $$ = $1; }
        ;

// 完善表达式的规则
expr    :       VAR { $$ = get_value($1); }
        |       expr ADD expr   { $$ = $1 + $3; }
        |       expr MINUS expr { $$ = $1 - $3; }
        |       expr MUL expr   { $$ = $1 * $3; }
        |       expr DIV expr   { $$ = $1 / $3; }
        |       LPAREN expr RPAREN { $$ = $2; }
        |       MINUS expr %prec UMINUS   {$$ = -$2;} // %prec 是赋予优先级
        |       NUMBER          {$$ = $1;}
        ;

%%

// programs section

// 查找变量
double get_value(char* name) {
    VarNode* curr = symbolTable;
    while (curr != NULL) {
        if (strcmp(curr->name, name) == 0) {
        return curr->value;
        }
        curr = curr->next;
    }
    return 0; // 未找到
}

// 插入变量
void set_value(char* name, double value) {
    // 新建节点，name: value
    VarNode* node = malloc(sizeof(VarNode));
    node->name = strdup(name);
    node->value = value;
    node->next = symbolTable;
    symbolTable = node;
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
            /* 解析多位数字返回数字类型
               其中yylval是属性值
            */
            yylval.dval = 0;
            while (isdigit(t))
            {
                // 这里减 '0' 是为了将字符转为数字
                yylval.dval = yylval.dval * 10 + t - '0';
                t = getchar();
            }
            ungetc(t, stdin);
            return NUMBER;
        }
        // 识别变量（标识符）
        else if (isalpha(t) || (t == '_')) // 以字母或下划线打头
        {
            char varname[MAX_LEN];
            int i = 0;
            varname[i++] = t;
            while(isalnum(t = getchar()))
            {
                varname[i++] = t;
            }
            // 回退一个字符
            ungetc(t, stdin);
            varname[i] = '\0';

            yylval.sval = strdup(varname);
            return VAR;
        }
        // 识别等号
        else if (t == '=') {
            return ASSIGN;
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
