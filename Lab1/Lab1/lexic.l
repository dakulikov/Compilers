
%{
    #include "y.tab.h"
	#include "stdlib.h"
    int yylex(void);
    void yyerror(char *);
	//#define YY_INPUT(buf,result,max_size)  {\
    result = GetNextChar(buf, max_size); \
    if (  result <= 0  ) \
      result = YY_NULL; \
    }
	

%}

%%

([0-9]+)|([0-9]*\.[0-9]+) {
					BeginToken(yytext);
                    yylval.value = atof(yytext);
                    return CONST;
                }

[a-zA-Z]        {
					BeginToken(yytext);
                    yylval.literal = *yytext;
                    return VAR;
                }


[-+()=*^\n]     {
					BeginToken(yytext);
                    return *yytext; 
                }

[ \t]           {	
					BeginToken(yytext);
				}

.               {
					BeginToken(yytext);
                    return yytext[0];
                }

%%
int yywrap(void)
{
    return 1;
}