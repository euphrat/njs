%% example run: ./sort 5 4 2 4 6 3 2

include "njsmath":math
include "njsio":io
include "njsstring":string
include "njscommon":common

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

sp ms_split	
	n << 2 #this $math.divide; *n;
	Empty;	
	X << &Empty &this n $common.move; *X;	
	this;	
	X >> this this; 
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

sp qs_split
	this >> pivot &X;	
	small; large;
	this << &large &small return else #X if; *this; *this;
	cmp << X pivot $string.strcmp; *cmp;
	small << X then 0 cmp $math.greater_than if; *small;
	large << X else 0 cmp $math.greater_than if; *large;	
	X >> null;
	A << &X pivot qs_split; *A;
	A >> &small2 &large2;
	small >> small2;
	large >> large2;	
	this << &large2 &small2;
end

%% mutual recursion example: quickmergesort :)

sp mergesort
	X << return then 2 #this $math.less_than if; *X; *X;
	this << ms_split; *this;
	this >> &A &B;	
	A << quicksort; *A;
	B << quicksort; *B;
	this << &B &A merge; *this;	
end

sp quicksort
	X << return then 2 #this $math.less_than if; *X; *X;
	this >> pivot;
	X << &this pivot qs_split; *X;
	X >> &small &large;
	small << mergesort; *small;
	large << mergesort; *large;
	large << pivot;
	this << &large &small $common.concatenate; *this;	
end

sp main	
	this << quicksort; *this;
	this << "Sorted stack:" $io.print; *this;	
	Y << "" $io.println_pop; *Y;	
end
