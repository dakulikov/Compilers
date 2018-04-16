%{
	#define alloca malloc
	#define YYERROR_VERBOSE 1
	#define YYDEBUG 1
	int yylex(void);
	void yyerror(const char*);
	#include "stdio.h"
	#include "SMemberOfPolynom.h"
	#include "SExpressionOfPolynom.h"
%}


%union 
{
	double value;
	char literal;
	struct SMemberOfPolynom * polynomsMember;
	struct SExpressionOfPolynom * polynomsExpression;
};

%token <value> CONST
%token <literal> VAR

%type <polynomsExpression> expressionOfPolynom
//%type <polynomsMember> variableOfPolynom
%type <polynomsMember> memberOfPolynom
%type <polynomsExpression> program
%left '-'
%left '+'
%left '*'

%%

program:
		expressionOfPolynom '\n' {$$=$1; printf("END\n");printExpression($1);printf("\n");}
expressionOfPolynom:
		memberOfPolynom								 {$$=(struct SExpressionOfPolynom*) malloc(sizeof(struct SExpressionOfPolynom)); initExpressionOfPolynom($$,$1);}
		|expressionOfPolynom '+' expressionOfPolynom {$$=$1;addExpression($1,$3,1);}
		|expressionOfPolynom '-' expressionOfPolynom {$$=$1;addExpression($1,$3,0);}
		|'('expressionOfPolynom ')'					 {$$=$2; $2->brackets=1;printf("\nBRACKETS \n");}
		|expressionOfPolynom '*' expressionOfPolynom {$$=mulExpressions($1,$3);}

memberOfPolynom:
		CONST 								{   $$ = (struct SMemberOfPolynom*) malloc(sizeof(struct SMemberOfPolynom)); initMemberOfPolynom($$,0,$1);}
		|VAR 						     	{   $$ = (struct SMemberOfPolynom*) malloc(sizeof(struct SMemberOfPolynom)); initMemberOfPolynom($$,$1,0);}
		|memberOfPolynom memberOfPolynom   	{   $$ = mulMembers($1,$2); free($2);}
	    |memberOfPolynom '*' memberOfPolynom{   $$ = mulMembers($1,$3); free($3);}
		|memberOfPolynom '^' CONST			{   $$ = powPolyMember($1,$3);}
		|'(' memberOfPolynom ')'            {   $$ = $2; $$->brackets=1;printf("MEMBER BRACKETS ");}
%%


void yyerror(const char *s) {
   PrintError(s);
}