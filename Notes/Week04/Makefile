
numbers2: numbers2.o scanner.o
	gcc -o numbers2 numbers2.o scanner.o

numbers2.o: numbers2.c tokens.h
	gcc -Wall -c numbers2.c

scanner.o: scanner.c tokens.h
	gcc -Wall -c scanner.c

numbers2.c:	numbers2.l
	flex -o numbers2.c numbers2.l
