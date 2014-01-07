%% example run: ./sort 5 4 2 4 6 3 2

include "njsmath"
include "njsio"
include "njsstring"

sp min_of_stack
	N << return then 2 #this less_than if; *N; *N;	
	this >> X;
	this << min_of_stack; *this;	
	this >> Y;	
	A << X Y strcmp; *A;	
	Result << X else Y then A 0 greater_than if; *Result;	
	this << Result;	
end

sp remove
	this >> toBeRemoved;
	N << return then 1 #this less_than if; *N; *N;	
	toBeTested << this;
	this << toBeRemoved;
	this << strcmp;	*this;
	this >> cond;	
	Result << return else cond if; *Result; *Result;
	this << toBeRemoved remove; *this;
	this << toBeTested;
end

sp selection_sort
	N << return then 2 #this less_than if;
	*N; *N;
	minVal = &this;
	minVal << min_of_stack; *minVal;
	rest = &this;
	rest << minVal remove; *rest;
	rest << selection_sort; *rest;
	rest << minVal;
	this = &rest;	
end

sp main	
	this << selection_sort;
	*this;
	this << "Sorted stack:" println;	
	*this;
	
end
