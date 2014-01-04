all:
	cd src && java -cp "../lib/antlr.jar" antlr.Tool notjuststacks.g && javac -cp "../lib/antlr.jar" -Xlint *.java && cd .. 
	mv src/*.class bin/.
	mv src/*.txt bin/.
	mv src/*.smap bin/.
	
clean:
	rm -f bin/*.class
	rm -f bin/*.txt
	rm -f bin/*.smap
	rm -f src/NotJustStacksL*
	rm -f src/NotJustStacksP*
	rm -f src/NotJustStacksW*
