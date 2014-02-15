include "njsio":io
include "njscommon":common

ss MyStack
	container;

	op <<
		^container;
	end

	op >>
		^container;
	end

	op #
		^container;
	end
end

ss Queue
	container; mode;

	init
		mode << 0;
	end
	
	op <<
		X << $common.reverse then mode if; *X;
		container << X; *container;
		mode >> null;
		mode << 0;
		^container;
	end
	
	op >>
		X << $common.reverse else mode if; *X;
		container << X; *container;
		mode >> null;
		mode << 1;
		^container;
	end
	
	op #
		^container;
	end
end

sp main
	this << 5 $common.push_back; *this;
	this << $common.reverse; *this;
	this << $io.print; *this;
	X << "" $io.println_pop; *X;
	A << 3 2 1;
	B << 5 4;
	Y << &B &A $common.concatenate; *Y;
	Y << $io.print; *Y;
	X << "" $io.println_pop; *X;
end
