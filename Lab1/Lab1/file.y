
%{
	#define alloca malloc
	//#define YYERROR_VERBOSE 1
	//#define YYDEBUG 1
	int yylex(void);
	void yyerror(char*);
	#include "stdio.h"
	#include "SMemberOfPolynom.h"
%}


%union 
{
	double value;
	char literal;
	struct SMemberOfPolynom * polynomsMember;
};

%token <value> CONST
%token <literal> VAR

%type <polynomsMember> memberOfPolynom
%type <polynomsMember> program
%%
program:
		memberOfPolynom '\n' {$$=$1; /*printf("END\n");printMember($$);printf("\n");*/}
memberOfPolynom:
		CONST 								{   $$ = (struct SMemberOfPolynom*) malloc(sizeof(struct SMemberOfPolynom)); initMemberOfPolynom($$,0,$1);}
		|VAR 						     	{   $$ = (struct SMemberOfPolynom*) malloc(sizeof(struct SMemberOfPolynom)); initMemberOfPolynom($$,$1,0);}
		|memberOfPolynom memberOfPolynom	{   $$ = mulMembers($1,$2); free($2);}
	    |memberOfPolynom '*' memberOfPolynom{   $$ = mulMembers($1,$3); free($3);}
		|memberOfPolynom '^' CONST			{   $$ = powPolyMember($1,$3);}
%%


void yyerror(char *s) {
   printf("ERROR");
}