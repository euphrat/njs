include "njsmath"
include "njsio"
include "njsstring"

sp min_of_stack
	N << return;
	N << then;
	N << 2;
	N << #this;
	N << less_than;
	N << if;
	*N;
	*N;	
	this >> X;
	this << min_of_stack;
	*this;	
	this >> Y;	
	A << X;
	A << Y;	
	A << strcmp;
	*A;	
	Result << X;
	Result << else;
	Result << Y;
	Result << then;
	Result << A;
	Result << 0;
	Result << greater_than;
	Result << if;
	*Result;	
	this << Result;	
end

sp main	
	this << min_of_stack;
	*this;
	this << "Min of stack:";
	this << println;
	*this;
end
