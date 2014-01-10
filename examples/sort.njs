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
	minVal = this;
	minVal << min_of_stack; *minVal;
	rest = this;
	rest << minVal remove; *rest;
	rest << selection_sort; *rest;
	rest << minVal;
	this = rest;	
end

sp mergesort
	X << return else #this if; *X; *X;
	this << split; *this;
	this >> &A &B;
	A << mergesort; *A;
	B << mergesort; *B;
	this << &B &A merge; *this;	
end

sp split	
	n << 2 #this divide; *n;
	Empty;	
	X << &Empty &this n move; *X;	
	this;	
	X >> this this; 
end

sp move
	this >> n &A &B;			
	this << &B &A return else n if; *this; *this;
	A >> B;
	m << 1 n subtract; *m;	
	this << &B &A m move; *this;
end

sp merge
	this >> &B &A;
	this = A;	
	Q << return else #B if; *Q; *Q;
	this = B;
	Q << return else #A if; *Q; *Q;
	this;
	X << A B strcmp; *X;
	this << B popB else A popA then 0 X greater_than if; *this;
	this >> func;
	Z << &A &B func; *Z;	
	Z << merge; *Z;
	this >> Z;
	this = Z;
end

sp popA
	this >> &B &A;
	A >> null;
	this << &A &B;
end

sp popB
	this >> &B &A;
	B >> null;
	this << &A &B;
end

sp main	
	X = this;
	this << mergesort; *this;
	this << "Sorted stack:" print; *this;	
	Y << "" println_pop; *Y;
	X << split; *X;
	X >> &A &B;
	A << "A:" print; *A; Y << "" println_pop; *Y;	
	B << "B:" print; *B; Y << "" println_pop; *Y;
end
