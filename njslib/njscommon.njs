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

