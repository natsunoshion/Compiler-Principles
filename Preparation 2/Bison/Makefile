all: $(arg1)

$(arg1).tab.c $(arg1).tab.h:	$(arg1).y
	bison -t -v -d $(arg1).y

$(arg1): $(arg1).tab.c $(arg1).tab.h
	gcc -o $(arg1) $(arg1).tab.c

clean:
	rm $(arg1) $(arg1).tab.c lex.yy.c $(arg1).tab.h $(arg1).output
