all:
	bison -y -d file.y
	flex lexic.l
	gcc *.c -o parser -lm
clean:
	rm y.tab.c
	rm y.tab.h
	rm parser
	rm lex.yy.c