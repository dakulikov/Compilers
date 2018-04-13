#pragma once
#include "stdio.h"
#include "math.h"
#define SIZE 256
struct SMemberOfPolynom
{
	char literals[SIZE];
	double  powers[SIZE];
	double  coefficient;
	int numLiter;
};

struct SMemberOfPolynom * powPolyMember(struct SMemberOfPolynom* in, double power);
struct SMemberOfPolynom * mulMembers(struct SMemberOfPolynom* first, struct SMemberOfPolynom* second);
void initMemberOfPolynom(struct SMemberOfPolynom* in, char liter, double constant);
void printMember(struct SMemberOfPolynom* in);