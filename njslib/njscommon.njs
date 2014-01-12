include "njsmath":math

sp reverse_aux
	this >> &Full;
	this >> &Empty;
	Full >> Empty;
	X << reverse_aux then #Full if; *X;
	this << &Empty &Full X; *this;
end

sp reverse
	A;
	X << &A &this reverse_aux; *X;
	X >> null &A;
	this = A;
end

sp push_back
	this >> Item;
	this << reverse; *this;
	this << Item reverse; *this;
end

sp move
	this >> n &A &B;			
	this << &B &A return else n if; *this; *this;
	A >> B;
	m << 1 n $math.subtract; *m;	
	this << &B &A m move; *this;
end

sp concatenate
	this >> &A &B;
	A << reverse; *A;
	X << &A &B #B move; *X;
	X >> null &A;
	A << reverse; *A;
	this = A;
end

