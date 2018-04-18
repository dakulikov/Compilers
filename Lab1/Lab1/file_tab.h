typedef union 
{
	double value;
	char literal;
	struct SMemberOfPolynom * polynomsMember;
	struct SExpressionOfPolynom * polynomsExpression;

} YYSTYPE;
#define	CONST	258
#define	VAR	259


extern YYSTYPE yylval;
