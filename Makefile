all: compiler
	cd njslib && make && cd ..
	cd examples && make && cd ..


compiler:
	cd src && java -cp "../lib/antlr.jar" antlr.Tool notjuststacks.g && javac -cp "../lib/antlr.jar" -Xlint *.java && cd .. 
	mv src/*.class bin/.
	mv src/*.txt bin/.
	mv src/*.smap bin/.	
	g++ -shared -fPIC -I${NJS_HOME}/include -fpermissive -w -o bin/libnjs.so src/njs.cpp
	
clean:
	rm -f bin/*.class
	rm -f bin/*.txt
	rm -f bin/*.smap
	rm -f bin/libnjs.so
	rm -f src/NotJustStacksL*
	rm -f src/NotJustStacksP*
	rm -f src/NotJustStacksW*
	cd njslib && make clean && cd ..
	cd examples && make clean && cd ..
