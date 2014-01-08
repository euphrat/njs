include "njsio"
include "njsmath"

sp hanoi
	this >> &A;
	n << #A;
	K << return else then n if; *K; *K;
	this << &A n hanoi2; *this;
end

sp hanoi2
	this >> n;
	this >> &A;
	this >> &B;
	this >> &C;
	this << &C &B &A return else then n if; *this; *this;
	N << 1 n subtract; *N;
	X << &B &C &A N hanoi2; *X;
	X >> &A;
	X >> &C;
	X >> &B;
	A >> C;	
	Y << &C &A &B N hanoi2; *Y;
	Y >> &B;
	Y >> &A;
	Y >> &C;
	this << &C &B &A;	
end

sp main
	A = this;
	B;
	C;
	X << &C &B &A hanoi; *X;
	X >> &A;
	X >> &B;
	X >> &C;
	A << "A:" print; *A;
	X << "" println_pop; *X;
	B << "B:" print; *B;
	X << "" println_pop; *X;
	C << "C:" print; *C;
	X << "" println_pop; *X;
end
