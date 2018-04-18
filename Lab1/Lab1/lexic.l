
%{
    #include "y.tab.h"
	#include "stdlib.h"
    #include "float.h"
    int yylex(void);
    void yyerror(char *);

#ifdef __linux__ 
#define yy_current_buffer YY_CURRENT_BUFFER_LVALUE
#endif

#define YY_INPUT(buf,result,max_size) \
	if ( yy_current_buffer->yy_is_interactive ) \
		{ \
		int c = '*', n; \
		for ( n = 0; n < max_size && \
			     (c = getc( yyin )) != EOF&& c!='$' ; ++n ) \
			buf[n] = (char) c; \
		if ( c == '\n' ) \
			buf[n++] = (char) c; \
		if ( c == EOF && ferror( yyin ) ) \
			YY_FATAL_ERROR( "input in flex scanner failed" ); \
		result = n; \
		} \
	else if ( ((result = fread( buf, 1, max_size, yyin )) == 0) \
		  && ferror( yyin ) ) \
		YY_FATAL_ERROR( "input in flex scanner failed" );
	

%}

%option yylineno

%%

([0-9]+)|([0-9]*\.[0-9]+) {
					BeginToken(yytext);
                    yylval.value = atof(yytext);
                    printf("CONST %f\n", yylval.value);
//                    if (FLT_DIG < strlen(yytext))
//                        printf("WARNING digits are more than precision limit\n", yylval.value);
                    return CONST;
                }

[a-zA-Z]       {
					BeginToken(yytext);
                    yylval.literal = *yytext;
                    printf("VAR %c\n", *yytext);
                    return VAR;
                }


[-+()=!*^\n$:]     {
					BeginToken(yytext);
                    printf("TOKEN %c\n", *yytext);
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

void yyerror(char *s) {
    PrintError("%s. Line: %d", s, yylineno);
}