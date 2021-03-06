#pragma once
#include <stdio.h>
#include <math.h>
#include <ctype.h>
#include <string.h>
#include <memory.h>
#include <stdlib.h>
#include <stdarg.h>
#include <float.h>
#include "SMemberOfPolynom.h"
#include "SExpressionOfPolynom.h"
/*
* global variable
*/
extern int debug;

/*
* lex & parse
*/
extern int yylex(void);
extern int yyparse(void);
extern void yyerror(char*);

/*
* ccalc.c
*/
extern void DumpRow(void);
extern int GetNextChar(char *b, int maxBuffer);
extern void BeginToken(char*);
extern void PrintError(char *s, ...);
