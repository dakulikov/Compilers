#pragma once
#ifndef SEXPRESSIONOFPOLYNOM_H
#define SEXPRESSIONOFPOLYNOM_H

#include "SMemberOfPolynom.h"
struct SExpressionOfPolynom
{
	struct SMemberOfPolynom** arrayOfPolynomsMembersPtr;
	int arraySize;
	int numMembers;
	bool brackets;
};
void initExpressionOfPolynom(struct SExpressionOfPolynom* in, struct SMemberOfPolynom* initValue);
void printExpression(struct SExpressionOfPolynom* in);
struct SMemberOfPolynom* isContain(struct SExpressionOfPolynom* in, struct SMemberOfPolynom* neededValue);
bool isEqualLiterals(struct SMemberOfPolynom * first, struct SMemberOfPolynom * second);
void addExpression(struct SExpressionOfPolynom* first, struct SExpressionOfPolynom* second, bool operation);
struct SExpressionOfPolynom* mulExpressions(struct SExpressionOfPolynom* first, struct SExpressionOfPolynom* second);
struct SExpressionOfPolynom* copyExpression(struct SExpressionOfPolynom* in);
struct SExpressionOfPolynom *negateExpression(struct SExpressionOfPolynom* ex);

#endif // !SEXPRESSIONOFPOLYNOM_H