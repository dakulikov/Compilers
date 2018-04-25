%{
	#define alloca malloc
	#define YYERROR_VERBOSE 1
	#define YYDEBUG 1
	int yylex(void);
	void yyerror(char*);
	#include "stdio.h"
	#include "SMemberOfPolynom.h"
	#include "SExpressionOfPolynom.h"
	struct assignedExpression
	{
		char var;
		struct SExpressionOfPolynom* polynom;
	};
	struct assignedExpression variablesWithExpressions[256]={0};
	int numAssignedExpressions=0;
	struct SExpressionOfPolynom* findExpression(char var)
	{
		//printf("NUM ASSIGNED EXPRESSION %d",numAssignedExpressions);
		for (int i=0;i<numAssignedExpressions;i++)
		{
			if (variablesWithExpressions[i].var==var)
				return variablesWithExpressions[i].polynom;
		}
		return 0;
	}
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
%type <polynomsMember> memberOfPolynom
%type <polynomsExpression> program
%type <polynomsExpression> variableWithPolynom
%left '='
%left '-' '+'
%right NEG
%left  '*'
%right '^'

%%


program:
		 variableWithPolynom expressionOfPolynom ':' '\n'{	
										struct SExpressionOfPolynom* out = (struct SExpressionOfPolynom*) malloc(sizeof(struct SExpressionOfPolynom)); 
										out->arraySize = 10;
										out->arrayOfPolynomsMembersPtr = (struct SMemberOfPolynom**) malloc(10 * sizeof(struct SMemberOfPolynom*));
										out->numMembers = 0;
										printf("CALCULATE VARIABLES \n");
										printExpression($2);
										printf("\n");
										for (int i=0;i<$2->numMembers;i++)
										{
											struct SExpressionOfPolynom* temp2 = (struct SExpressionOfPolynom*) malloc(sizeof(struct SExpressionOfPolynom)); 
											if (findExpression($2->arrayOfPolynomsMembersPtr[i]->literals[0]))
											{
											struct SExpressionOfPolynom* temp1 = copyExpression(findExpression($2->arrayOfPolynomsMembersPtr[i]->literals[0]));
											for (int j=1;j<$2->arrayOfPolynomsMembersPtr[i]->numLiter;j++)
											{
												if (findExpression($2->arrayOfPolynomsMembersPtr[i]->literals[0]))
												{
													struct SExpressionOfPolynom* temp2=copyExpression(findExpression($2->arrayOfPolynomsMembersPtr[i]->literals[j]));
													temp1=mulExpressions(temp1,temp2);
												}
											}
											if ($2->arrayOfPolynomsMembersPtr[i]->coefficient>0)
											addExpression(out,temp1,1);
											else
											addExpression(out,temp1,0);
											}
											else
												printf("ERROR: variable %c not found\n",$2->arrayOfPolynomsMembersPtr[i]->literals[0]);
										}
										$$=out;
										printExpression(out);
									 }
variableWithPolynom:
expressionOfPolynom '=' expressionOfPolynom '\n'  {
																	printf( "DECLARE OF VARIABLE: ");
																	printExpression($1);
																	printf("=");
																	printExpression($3);
																	printf("\n");
																	$$=$3;	
																	if ($1->numMembers>1)
																	{
																		printf("ERROR: variable should not expression\n");			
																		//exit(1);
																	}
																	if ($1->arrayOfPolynomsMembersPtr[0]->numLiter>1)
																	printf("ERROR: variable should be simple liter\n");
																	if($1->arrayOfPolynomsMembersPtr[0]->powers[0]>1)
																	printf("ERROR: variable should be without power\n");
																	if($1->arrayOfPolynomsMembersPtr[0]->coefficient!=1)
																	printf("ERROR: variable shoule be without coefficient");
																	variablesWithExpressions[numAssignedExpressions].var=$1->arrayOfPolynomsMembersPtr[0]->literals[0];
																	variablesWithExpressions[numAssignedExpressions].polynom=$3;
																	printExpression($3);
																	numAssignedExpressions++;
															}
|variableWithPolynom expressionOfPolynom '=' expressionOfPolynom '\n' {printf( "DECLARE OF VARIABLE: ");
																	printExpression($2);
																	printf("=");
																	printExpression($4);
																	printf("\n");
																	$$=$4;	
																	if ($2->numMembers>1)
																	{
																		printf("ERROR: variable should not be expression\n");			
																	}
																	if ($2->arrayOfPolynomsMembersPtr[0]->numLiter>1)
																	printf("ERROR: variable should be simple liter\n");
																	if($2->arrayOfPolynomsMembersPtr[0]->powers[0]>1)
																	printf("ERROR: variable should be without power\n");
																	if($2->arrayOfPolynomsMembersPtr[0]->coefficient!=1)
																	printf("ERROR: variable shoule be without coefficient");
																	variablesWithExpressions[numAssignedExpressions].var=$2->arrayOfPolynomsMembersPtr[0]->literals[0];
																	variablesWithExpressions[numAssignedExpressions].polynom=$4;
																	$4->brackets=1;
																	printExpression($4);
																	numAssignedExpressions++;
																	}
expressionOfPolynom: 
		memberOfPolynom	 							 {
														$$=(struct SExpressionOfPolynom*) malloc(sizeof(struct SExpressionOfPolynom)); 
														initExpressionOfPolynom($$,$1);
													 }
		|expressionOfPolynom '+' expressionOfPolynom {$$=$1;addExpression($1,$3,1);}
		|expressionOfPolynom '-' expressionOfPolynom {$$=$1;addExpression($1,$3,0);}
		|'('expressionOfPolynom')'					 {$$=$2; $2->brackets=1;printf("\nBRACKETS \n");}
		|expressionOfPolynom '*' expressionOfPolynom {$$=mulExpressions($1,$3);}
/*		|expressionOfPolynom expressionOfPolynom {		
														printf("MUL MEMBERS:");
														printExpression($1);
														printf("*");
														printExpression($2);
														printf("\n");
										 			    if($1->numMembers==1 && $2->numMembers==1)
															$$=mulExpressions($1,$2);
														else
														{
															PrintError("it should be members only! Line %d:c%d to %d:c%d",
												                        @1.first_line, @1.first_column,
												                        @2.last_line, @1.last_column);
														}
												 }
*/
		|expressionOfPolynom '^' expressionOfPolynom{
													printf("POWERED EXPRESSION: \n");
													printf("("); printExpression($1); printf(")");
													printf("^");
													printf("("); printExpression($3); printf(")");
													printf("\n");
													struct SExpressionOfPolynom* temp1,*temp2;
													temp1 = copyExpression($1);

													if ($1->arrayOfPolynomsMembersPtr[0]->coefficient == 0.0 && $3->arrayOfPolynomsMembersPtr[0]->coefficient == 0.0) 
													{
														 PrintError("Indeterminate 0^0! Line %d:c%d to %d:c%d",
												                        @1.first_line, @1.first_column,
												                        @3.last_line, @3.last_column);
													}

													
													if ($3->numMembers==1&&$3->arrayOfPolynomsMembersPtr[0]->numLiter==0)
													{
														for (int i=1;i<$3->arrayOfPolynomsMembersPtr[0]->coefficient;i++)
														{
															temp2 = copyExpression($1);
															temp1=mulExpressions(temp1,temp2);
														}
													}
													else
													{
														PrintError("released only ^ CONST! Line %d:c%d to %d:c%d",
														            @3.first_line, @3.first_column,
														            @3.last_line, @3.last_column);
													}
													$$=temp1;
												 }
			| '-' expressionOfPolynom %prec NEG 	
													{
														$$ = negateExpression($2);
													}
		
memberOfPolynom:
		CONST 	{   $$ = (struct SMemberOfPolynom*) malloc(sizeof(struct SMemberOfPolynom)); initMemberOfPolynom($$,0,$1);}
		|VAR 	{   $$ = (struct SMemberOfPolynom*) malloc(sizeof(struct SMemberOfPolynom)); initMemberOfPolynom($$,$1,0);}
%%