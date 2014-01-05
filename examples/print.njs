include "njsio"@"/home/firat/git/njs/njslib/"
include "njsmath"@"/home/firat/git/njs/njslib/"

sp main
	this << println_text;
	*this;
	this << println_pop_text;
	*this;
	this << println_pop_text;
	*this;
	X << "abc";
	X << 3;
	X << 5;
	X << pow;
	*X;
	X << main;
	X << if;
	X << then;
	X << else;
	X << println;
	*X;
	X << "*******";
	X << println;
	*X;
end
