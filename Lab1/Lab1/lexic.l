
%{
    #include "file_tab.h"
	#include "stdlib.h"
    int yylex(void);
    void yyerror(char *);
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


[-+()=!*^\n$:]     {
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