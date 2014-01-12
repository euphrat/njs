include "njsio":io
include "njsmath":math

sp hanoi
	this >> &A;
	n << #A;
	K << return else then n if; *K; *K;
	this << &A n hanoi2; *this;
end

sp hanoi2
	this >> n;
	this >> &A &B &C;	
	this << &C &B &A return else then n if; *this; *this;
	N << 1 n $math.subtract; *N;
	X << &B &C &A N hanoi2; *X;
	X >> &A &C &B;	
	A >> C;	
	Y << &C &A &B N hanoi2; *Y;
	Y >> &B &A &C;	
	this << &C &B &A;	
end

sp main
	A = this;
	B; C; % create empty stacks
	X << &C &B &A hanoi; *X;
	X >> &A &B &C;	
	A << "A:" $io.print; *A;
	X << "" $io.println_pop; *X;
	B << "B:" $io.print; *B;
	X << "" $io.println_pop; *X;
	C << "C:" $io.print; *C;
	X << "" $io.println_pop; *X;
end
