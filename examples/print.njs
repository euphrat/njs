include "njsmath":math 
include "njsio":io

sp main
	this << $io.println_text;
	*this;
	this << $io.println_pop_text;
	*this;
	this << $io.println_pop_text;
	*this;
	X << "abc";
	X << 3;
	X << 5;
	X << $math.pow;
	*X;
	X << main;
	X << if;
	X << then;
	X << else;
	X << $io.println;
	*X;
	X << "*******";
	X << $io.println;
	*X;
end
