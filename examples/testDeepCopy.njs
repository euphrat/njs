%%testDeepCopy

include "njsio"

sp main
	A << 3 4 5 6 7 "njs" typeof; *A;
	B << &A;
	C << &B;
	X := C;
	X >> &P;
	P >> &R;	
	R << println; *R;	
end
