#include "SExpressionOfPolynom.h"
#include "string.h"
void initExpressionOfPolynom(struct SExpressionOfPolynom* in, struct SMemberOfPolynom* initValue)
{
	printf("INIT EXPRESSION = ");
	printMember(initValue);
	printf("\n");
	in->arraySize = 10;
	in->arrayOfPolynomsMembersPtr = (struct SMemberOfPolynom**) malloc(10 * sizeof(struct SMemberOfPolynom*));
	in->arrayOfPolynomsMembersPtr[0] = initValue;
	in->numMembers = 1;
	in->brackets = 0;
}
struct SExpressionOfPolynom* copyExpression(struct SExpressionOfPolynom* in)
{
	struct SExpressionOfPolynom* tempExpr = (struct SExpressionOfPolynom*) malloc(sizeof(struct SExpressionOfPolynom));
	tempExpr->arraySize = 10;
	tempExpr->arrayOfPolynomsMembersPtr = (struct SMemberOfPolynom**) malloc(in->numMembers * sizeof(struct SMemberOfPolynom*));
	tempExpr->numMembers = in->numMembers;
	tempExpr->brackets = in->brackets;
	for (int i = 0; i < in->numMembers; i++)
	{
		struct SMemberOfPolynom* tempMemb = (struct SMemberOfPolynom*)malloc(sizeof(struct SMemberOfPolynom));
		memcpy(tempMemb, in->arrayOfPolynomsMembersPtr[i], sizeof(struct SMemberOfPolynom));
		tempExpr->arrayOfPolynomsMembersPtr[i] = tempMemb;
	}
	return tempExpr;
}
struct SExpressionOfPolynom* mulExpressions(struct SExpressionOfPolynom* first, struct SExpressionOfPolynom* second)
{
	printf("\nSTART MUL EXPRESSIONS ");
	printf("(");
	printExpression(first);
	printf(")");
	printf("*");
	printf("(");
	printExpression(second);
	printf(")");

	struct SExpressionOfPolynom* out = (struct SExpressionOfPolynom *)malloc(sizeof(struct SExpressionOfPolynom));
	out->arraySize = 10;
	out->arrayOfPolynomsMembersPtr = (struct SMemberOfPolynom**) malloc(10 * sizeof(struct SMemberOfPolynom*));
	out->numMembers = 0;
	
	for (int k = 0; k < first->numMembers; k++)
	{
		
		for (int g = 0; g < second->numMembers; g++)
		{
			struct SMemberOfPolynom* temp = (struct SMemberOfPolynom*)malloc(sizeof(struct SMemberOfPolynom));
			initMemberOfPolynom(temp,0,0);
			int i = 0, j = 0;
			int presence = 0;
			struct SExpressionOfPolynom* addedExp = (struct SExpressionOfPolynom *)malloc(sizeof(struct SExpressionOfPolynom));
			printf("MUL MEMBERS ");
			printMember(first->arrayOfPolynomsMembersPtr[k]);
			printf("*");
			printMember(second->arrayOfPolynomsMembersPtr[g]);
			memcpy(temp, first->arrayOfPolynomsMembersPtr[k],sizeof(struct SMemberOfPolynom));
			while (second->arrayOfPolynomsMembersPtr[g]->literals[i])
			{
				j = 0;
				presence = 0;
				while (first->arrayOfPolynomsMembersPtr[k]->literals[j])
				{
					if (first->arrayOfPolynomsMembersPtr[k]->literals[j] == second->arrayOfPolynomsMembersPtr[g]->literals[i])
					{
						presence = 1;
						temp->powers[j] += second->arrayOfPolynomsMembersPtr[g]->powers[i];	
					}
					j++;
				}
				if (!presence)
				{
					temp->literals[temp->numLiter] = second->arrayOfPolynomsMembersPtr[g]->literals[i];
					temp->powers[temp->numLiter] = second-> arrayOfPolynomsMembersPtr[g]->powers[i];
					temp->numLiter++;
				};
				i++;
			}
				
			temp->coefficient *= second->arrayOfPolynomsMembersPtr[g]->coefficient;
			temp->brackets = 0;
			second->arrayOfPolynomsMembersPtr[g]->brackets = 0;
			printf(" = ");
			printMember(temp);
			printf("\n");
			initExpressionOfPolynom(addedExp, temp);
			addExpression(out, addedExp,1);
		}
	}
	for (int i = 0; i < first->numMembers; i++)
		free(first->arrayOfPolynomsMembersPtr[i]);
	free(first->arrayOfPolynomsMembersPtr);
	free(first);
	for (int i = 0; i < second->numMembers; i++)
		free(second->arrayOfPolynomsMembersPtr[i]);
	free(second->arrayOfPolynomsMembersPtr);
	free(second);
	printf("END MUL EXPRESSIONS: =");
	printExpression(out);
	printf("\n");
	return out;
}
void addExpression(struct SExpressionOfPolynom* first, struct SExpressionOfPolynom* second,bool operation)
{
	printf("ADD EXPRESSION ");
	printExpression(first);
	if (operation)
		printf("+");
	else
		printf("-");
	printExpression(second);
	for (int i = 0; i < second->numMembers; i++)
	{
		struct SMemberOfPolynom * temp = isContain(first, second->arrayOfPolynomsMembersPtr[i]);
		if (temp)
		{
			if (operation)

				temp->coefficient += second->arrayOfPolynomsMembersPtr[i]->coefficient;
			else
				if (second->brackets||i==0)
					temp->coefficient -= second->arrayOfPolynomsMembersPtr[i]->coefficient;
			if (temp->coefficient == 0)
			{
		
				memcpy(temp, first->arrayOfPolynomsMembersPtr[first->numMembers - 1], sizeof(struct SMemberOfPolynom));
				free(first->arrayOfPolynomsMembersPtr[first->numMembers-1]);
				first->numMembers--;
			}
			free(second->arrayOfPolynomsMembersPtr[i]);
		}
		else
		{
			if (first->arraySize == first->numMembers)
			{
				first->arrayOfPolynomsMembersPtr = (struct SMemberOfPolynom**)realloc(first->arrayOfPolynomsMembersPtr, 10 * first->arraySize * sizeof(struct SMemberOfPolynom*));
				first->arraySize *= 10;
			}
			first->arrayOfPolynomsMembersPtr[first->numMembers] = second->arrayOfPolynomsMembersPtr[i];
			if (!operation)
				if (second->brackets||i==0)
				first->arrayOfPolynomsMembersPtr[first->numMembers]->coefficient = -first->arrayOfPolynomsMembersPtr[first->numMembers]->coefficient;
			first->numMembers++;

		}
	}
	printf("=");
	printExpression(first);
	printf("\n");
	first->brackets = 0;
	free(second->arrayOfPolynomsMembersPtr);
	free(second);
}


struct SMemberOfPolynom* isContain(struct SExpressionOfPolynom* in, struct SMemberOfPolynom* neededValue)
{
	for (int i = 0; i < in->numMembers;i++)
	{
		if (isEqualLiterals(in->arrayOfPolynomsMembersPtr[i], neededValue))
			return in->arrayOfPolynomsMembersPtr[i];
	}
	return 0;
}
bool isEqualLiterals(struct SMemberOfPolynom * first, struct SMemberOfPolynom * second)
{
	if (first->numLiter == second->numLiter)
	{
		for (int i = 0; i < first->numLiter; i++)
		{
			bool flag = 0;
			for (int j = 0; j < second->numLiter; j++)
			{
				if (first->literals[i] == second->literals[j] && first->powers[i] == second->powers[j])
				{
					flag = 1;
				}
			}
			if (!flag)
				return 0;
		}
	}
	else
		return 0;
	return 1;
}
void printExpression(struct SExpressionOfPolynom*in)
{
	if (in->numMembers>0)
		printMember(in->arrayOfPolynomsMembersPtr[0]);
	else
		printf(" 0 ");
	for (int i=1; i < in->numMembers; i++)
	{
		if (in->arrayOfPolynomsMembersPtr[i]->coefficient > 0)
			printf("+");
		printMember(in->arrayOfPolynomsMembersPtr[i]);
	}
}