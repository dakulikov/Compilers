#pragma once
#include "stdio.h"
#include "stdlib.h"
#include "math.h"
#include "y.tab.h"
#define SIZE 256
#define bool char
struct SMemberOfPolynom
{
	char literals[SIZE];
	double  powers[SIZE];
	double  coefficient;
	bool brackets;
	int numLiter;
};

struct SMemberOfPolynom * powPolyMember(struct SMemberOfPolynom* in, double power, YYLTYPE *bloc);
struct SMemberOfPolynom * mulMembers(struct SMemberOfPolynom* first, struct SMemberOfPolynom* second);
void initMemberOfPolynom(struct SMemberOfPolynom* in, char liter, double constant);
void printMember(struct SMemberOfPolynom* in);