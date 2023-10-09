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

#define MAX_REGS 8

// 一样是节点，记录标识符名字对应的寄存器（而不是值），用数组
typedef struct VarNode {
    char* name;
    int reg;
    struct VarNode* next;
} VarNode;

VarNode* symbolTable = NULL; // 头指针

// 记录使用过的寄存器
int used_regs[MAX_REGS] = {0};
int expr_used_regs[MAX_REGS] = {0};

int yylex();
extern int yyparse(); // 该函数会一直调用 yylex，由 Bison 实现
FILE* yyin;
void yyerror(const char* s);
int search_reg(char* name);
int add_reg(char* name);
%}

/* 使用 union 定义 yylval 的类型，而不是 YYSTYPE
   也就是说，yylval 现在可以是下面的任意一种类型
   值得注意的是，这个应该放在 %} 之后，也就是定义部分
*/
%union {
    int ival; // 这里将 double 改为了 int，因为识别的是整数，要显示在汇编代码里面
    // 使用结构体，同时具备两个属性值
    struct {
        char sval[MAX_LEN]; // 现在它用来存储生成的汇编代码
        int reg;  // 表达式结果寄存器对应的编号
    } code;
}

// 给每个符号定义一个单词类别：加减、乘除、数字、左右括号
%token ADD MINUS
%token MUL DIV
/* %token NUMBER */
%token LPAREN RPAREN
%token ASSIGN

// 现在都是汇编语句，所以都应该是汇编代码
%token <ival> NUMBER
%token <code> VAR
%type <code> expr
%type <code> stmt

%left ADD MINUS
%left MUL DIV
%right UMINUS

%%


lines   :       lines stmt ';' {
                    printf("%s", $2.sval); // $2.sval 中已经换行
                    // 清空 expr_used_regs
                    memset(expr_used_regs, 0, sizeof(expr_used_regs));
                }
        |       lines ';'
        |
        ;

// stmt 替换原来的 expr，它除了表达式还包括赋值语句
stmt    :       VAR ASSIGN expr {
                    // 找未分配的寄存器
                    int reg = search_reg($1.sval);
                    if (reg == -1) {
                        reg = add_reg($1.sval);
                    }
                    // 设置属性
                    memset($1.sval, 0, sizeof($1.sval));
                    $1.reg = reg;

                    sprintf($$.sval, "%sMOV R%d, R%d\n", $3.sval, $1.reg, $3.reg);
                } // 先计算 expr，再从结果寄存器中取出给 VAR 对应的寄存器
        |       expr { $$ = $1; }
        ;

// 完善表达式的规则
expr    :       VAR {
                    // 找未分配的寄存器
                    int reg = search_reg($1.sval);
                    if (reg == -1) {
                        reg = add_reg($1.sval);
                    }

                    // 直接设置属性即可
                    memset($$.sval, 0, sizeof($$.sval));
                    $$.reg = reg;
                }
        |       expr ADD expr   {
                    // 找未保存变量的寄存器
                    int i;
                    for (i = 0; i < MAX_REGS; i++) {
                        if (!used_regs[i] && !expr_used_regs[i]) {
                            $$.reg = i;
                            break;
                        }
                    }

                    expr_used_regs[i] = 1;

                    sprintf($$.sval, "%s%sADD R%d, R%d, R%d\n", $1.sval, $3.sval, $$.reg, $1.reg, $3.reg);
                }
        |       expr MINUS expr {
                    // 找未保存变量的寄存器
                    int i;
                    for (i = 0; i < MAX_REGS; i++) {
                        if (!used_regs[i] && !expr_used_regs[i]) {
                            $$.reg = i;
                            break;
                        }
                    }

                    expr_used_regs[i] = 1;

                    sprintf($$.sval, "%s%sSUB R%d, R%d, R%d\n", $1.sval, $3.sval, $$.reg, $1.reg, $3.reg);
                }
        |       expr MUL expr   {
                    // 找未保存变量的寄存器
                    int i;
                    for (i = 0; i < MAX_REGS; i++) {
                        if (!used_regs[i] && !expr_used_regs[i]) {
                            $$.reg = i;
                            break;
                        }
                    }

                    expr_used_regs[i] = 1;

                    sprintf($$.sval, "%s%sMUL R%d, R%d, R%d\n", $1.sval, $3.sval, $$.reg, $1.reg, $3.reg);
                }
        |       expr DIV expr   {
                    // 找未保存变量的寄存器
                    int i;
                    for (i = 0; i < MAX_REGS; i++) {
                        if (!used_regs[i] && !expr_used_regs[i]) {
                            $$.reg = i;
                            break;
                        }
                    }

                    expr_used_regs[i] = 1;

                    sprintf($$.sval, "%s%sDIV R%d, R%d, R%d\n", $1.sval, $3.sval, $$.reg, $1.reg, $3.reg);
                }
        |       LPAREN expr RPAREN { $$ = $2; }
        |       MINUS expr %prec UMINUS {
                    // 使用同一个寄存器
                    $$.reg = $2.reg;

                    // 对寄存器取反
                    sprintf($$.sval, "%sNEG R%d\n", $2.sval, $2.reg);

                }
        |       NUMBER          {
                    // 找未保存变量的寄存器
                    int i;
                    for (i = 0; i < MAX_REGS; i++) {
                        if (!used_regs[i] && !expr_used_regs[i]) {
                            $$.reg = i;
                            break;
                        }
                    }

                    expr_used_regs[i] = 1;

                    sprintf($$.sval, "LDR R%d, =%d\n", $$.reg, $1);
                }
        ;

%%

// programs section

int search_reg(char* name) {
    VarNode* curr = symbolTable;
    while (curr != NULL) {
        if (strcmp(curr->name, name) == 0) {
            return curr->reg;
        }
        curr = curr->next;
    }
    return -1; // 未找到
}

int add_reg(char* name) {
    int i;
    for (i = 0; i < MAX_REGS; i++) {
        if (!used_regs[i] && !expr_used_regs[i]) {
            break;
        }
    }

    if (i == MAX_REGS) {
        perror("通过 perror 输出错误");
    }

    used_regs[i] = 1;


    // 新建节点，name: value
    VarNode* node = malloc(sizeof(VarNode));
    node->name = strdup(name);
    node->reg = i;
    node->next = symbolTable;
    symbolTable = node;

    return i; // 返回当前标识符对应的寄存器
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
            yylval.ival = 0;
            while (isdigit(t))
            {
                // 这里减 '0' 是为了将字符转为数字
                yylval.ival = yylval.ival * 10 + t - '0';
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

            strcpy(yylval.code.sval, varname); // 记录变量名
            yylval.code.reg = -1; // 寄存器号初始化为-1
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
