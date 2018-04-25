all:
	bison -y -d file.y -o y.tab.c
	flex lexic.l
	gcc *.c -o parser -lm
clean:
	rm y.tab.c
	rm y.tab.h
	rm parser
	rm lex.yy.c