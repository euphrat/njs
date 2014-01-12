%% example run: ./sort 5 4 2 4 6 3 2

include "njsmath":math
include "njsio":io
include "njsstring":string

sp min_of_stack
	N << return then 2 #this $math.less_than if; *N; *N;	
	this >> X;
	this << min_of_stack; *this;	
	this >> Y;	
	A << X Y $string.strcmp; *A;	
	Result << X else Y then A 0 $math.greater_than if; *Result;	
	this << Result;	
end

sp remove
	this >> toBeRemoved;
	N << return then 1 #this $math.less_than if; *N; *N;	
	toBeTested << this;
	this << toBeRemoved;
	this << $string.strcmp;	*this;
	this >> cond;	
	Result << return else cond if; *Result; *Result;
	this << toBeRemoved remove; *this;
	this << toBeTested;
end

sp selection_sort
	N << return then 2 #this $math.less_than if;
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
	X << return then 2 #this $math.less_than if; *X; *X;
	this << split; *this;
	this >> &A &B;	
	A << mergesort; *A;
	B << mergesort; *B;
	this << &B &A merge; *this;	
end

sp split	
	n << 2 #this $math.divide; *n;
	Empty;	
	X << &Empty &this n move; *X;	
	this;	
	X >> this this; 
end

sp move
	this >> n &A &B;			
	this << &B &A return else n if; *this; *this;
	A >> B;
	m << 1 n $math.subtract; *m;	
	this << &B &A m move; *this;
end

sp merge
	this >> &B &A;
	this = A;	
	Q << return else #B if; *Q; *Q;
	this = B;
	Q << return else #A if; *Q; *Q;
	this;
	X << A B $string.strcmp; *X;
	this << B popB else A popA then 0 X $math.greater_than if; *this;
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
	this << "Sorted stack:" $io.print; *this;	
	Y << "" $io.println_pop; *Y;	
end
