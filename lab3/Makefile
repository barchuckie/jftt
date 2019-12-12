all: calculator

calculator: lexer parser
	g++ calc.tab.c lex.yy.c -o calc

lexer: 
	C:\Users\barch\Downloads\win_flex_bison-2.5.20\win_flex.exe calc.l

parser:
	C:\Users\barch\Downloads\win_flex_bison-2.5.20\win_bison.exe -d calc.y

clean:
	rm calc.tab.* lex.yy.c