include "njsio":io
include "njscommon":common

sp main
	this << 5 $common.push_back; *this;
	this << $common.reverse; *this;
	this << $io.print; *this;
	X << "" $io.println_pop; *X;
end
