include "njsio"@"/home/firat/git/njs/njslib/"

sp main
	this << println_text;
	*this;
	this << println_pop_text;
	*this;
	this << println_pop_text;
	*this;
	X << "abc";
	X << 3.4;
	X << 5;
	X << main;
	X << if;
	X << then;
	X << else;
	X << println_pop;
	*X;
end
