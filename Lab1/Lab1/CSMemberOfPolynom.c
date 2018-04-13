#pragma once
#include "SMemberOfPolynom.h"
#include "stdio.h"
#include "stdlib.h"
#include "string.h"
void initMemberOfPolynom(struct SMemberOfPolynom* in,char liter,double constant)
{
	in->coefficient = 1;
	memset(in->literals, 0, SIZE * sizeof(char));
	memset(in->powers, 0, SIZE * sizeof(double));
	in->numLiter = 0;
	printf("INIT ");
	if (liter)
	{
		in->literals[0] = liter;
		in->coefficient = 1;
		in->powers[0] = 1;
		in->numLiter = 1;
		printf(" %c \n", liter);
	}
	if (constant)
	{

		in->coefficient = constant;
		printf(" %0.0f \n", in->coefficient);
	}
	printf("\n");
}
struct SMemberOfPolynom * powPolyMember(struct SMemberOfPolynom* in, double power)
{
	printf("POW MEMBER ");
	printf("%c^%0.0f\n", in->literals[in->numLiter-1],power);
	if (in->numLiter != 0)
	{
		if (in->powers[in->numLiter - 1] != 1)
		{
			in->powers[in->numLiter - 1] = pow(in->powers[in->numLiter - 1], power);
		}
		else
			in->powers[in->numLiter - 1] = power;
		printf("= %c^%0.0f", in->literals[in->numLiter - 1], in->powers[in->numLiter - 1]);
	}
	else
	{
		in->coefficient= pow(in->coefficient, power);
		printf("= %0.0f\n", in->coefficient);
	}
	
	return in;
}

struct SMemberOfPolynom * mulMembers(struct SMemberOfPolynom* first, struct SMemberOfPolynom* second)
{

	int i = 0, j = 0;
	int presence = 0;
	printf("MUL MEMBERS ");
	printMember(first);
	printf("*");
	printMember(second);
	while (second->literals[i])
	{
		j = 0;
		presence = 0;
		while (first->literals[j])
		{
			if (first->literals[j] == second->literals[i])
			{
				presence = 1;
				first->powers[j] += second->powers[i];
			}
			j++;
		}
		if (!presence)
		{
			first->literals[first->numLiter] = second->literals[i];
			first->powers[first->numLiter] = second->powers[i];
			first->numLiter++;
		}
		i++;
	}
	first->coefficient *= second->coefficient;
	printf(" = ");
	printMember(first);
	printf("\n");
	return first;

}
void printMember(struct SMemberOfPolynom* in)
{
	int i = 0;
	if (in->coefficient!=1)
		printf("%0.0f", in->coefficient);
	while (in->literals[i])
	{
		printf("%c", in->literals[i]);
		if (in->powers[i] > 1)
		{
			printf("^%0.0f", in->powers[i]);
		}
		i++;
	}
}