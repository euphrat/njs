sp print_int
??
	if(!_STACK(this_)->empty() && _STACK(this_)->top().type == INTEGER)
	{
		cout << *(int*)_STACK(this_)->top().data;	
	}
	else
	{
		cerr << "(No INTEGER)";
	}
??
end

sp println_int
??
	if(!_STACK(this_)->empty() && _STACK(this_)->top().type == INTEGER)
	{
		cout << *(int*)_STACK(this_)->top().data << endl;	
	}
	else
	{
		cerr << "(No INTEGER)" << endl;
	}
??
end

sp print_double
??
	if(!_STACK(this_)->empty() && _STACK(this_)->top().type == DOUBLE)
	{
		cout << *(double*)_STACK(this_)->top().data;	
	}
	else
	{
		cerr << "(No DOUBLE)" << endl;
	}
??
end

sp println_double
??
	if(!_STACK(this_)->empty() && _STACK(this_)->top().type == DOUBLE)
	{
		cout << *(double*)_STACK(this_)->top().data << endl;	
	}
	else
	{
		cerr << "(No DOUBLE)" << endl;
	}
??
end

sp print_text
??
	if(!_STACK(this_)->empty() && _STACK(this_)->top().type == TEXT)
	{
		cout << *(string*)_STACK(this_)->top().data;	
	}
	else
	{
		cerr << "(No TEXT)";
	}
??
end

sp println_text
??
	if(!_STACK(this_)->empty() && _STACK(this_)->top().type == TEXT)
	{
		cout << *(string*)_STACK(this_)->top().data << endl;	
	}
	else
	{
		cerr << "(No TEXT)" << endl;
	}
??
end


%%%%%%%%%%%


sp print_pop_int
??
	if(!_STACK(this_)->empty() && _STACK(this_)->top().type == INTEGER)
	{
		cout << *(int*)_STACK(this_)->top().data;
		_STACK(this_)->pop();	
	}
	else
	{
		cerr << "(No INTEGER)";
	}
??
end

sp println_pop_int
??
	if(!_STACK(this_)->empty() && _STACK(this_)->top().type == INTEGER)
	{
		cout << *(int*)_STACK(this_)->top().data << endl;
		_STACK(this_)->pop();	
	}
	else
	{
		cerr << "(No INTEGER)" << endl;
	}
??
end

sp print_pop_double
??
	if(!_STACK(this_)->empty() && _STACK(this_)->top().type == DOUBLE)
	{
		cout << *(double*)_STACK(this_)->top().data;
		_STACK(this_)->pop();	
	}
	else
	{
		cerr << "(No DOUBLE)" << endl;
	}
??
end

sp println_pop_double
??
	if(!_STACK(this_)->empty() && _STACK(this_)->top().type == DOUBLE)
	{
		cout << *(double*)_STACK(this_)->top().data << endl;
		_STACK(this_)->pop();	
	}
	else
	{
		cerr << "(No DOUBLE)" << endl;
	}
??
end

sp print_pop_text
??
	if(!_STACK(this_)->empty() && _STACK(this_)->top().type == TEXT)
	{
		cout << *(string*)_STACK(this_)->top().data;
		_STACK(this_)->pop();	
	}
	else
	{
		cerr << "(No TEXT)";
	}
??
end

sp println_pop_text
??
	if(!_STACK(this_)->empty() && _STACK(this_)->top().type == TEXT)
	{
		cout << *(string*)_STACK(this_)->top().data << endl;
		_STACK(this_)->pop();	
	}
	else
	{
		cerr << "(No TEXT)" << endl;
	}
??
end

sp println_pop
??
	while(!_STACK(this_)->empty()){
		Data A = _STACK(this_)->top();
		switch(A.type)
		{
			case DOUBLE:
				cout << *(double*)A.data << endl; break;
			case INTEGER:
				cout << *(int*)A.data << endl; break;
			case TEXT:
				cout << *(string*)A.data << endl; break;
			case IF:
				cout << "IF" << endl; break;
			case THEN:
				cout << "THEN" << endl; break;
			case ELSE:
				cout << "ELSE" << endl; break;
			case SP:
				cout << "STACK_PROCESSOR [name]" << endl; break;
			case STACK:
				stack<Data> temp = *(stack<Data>*)A.data;
				cout << "STACK [" << temp.size() << "]" << endl;			
				break;			
		}
		_STACK(this_)->pop();
	}
??
end

sp print_pop
??
	while(!_STACK(this_)->empty()){
		Data A = _STACK(this_)->top();
		switch(A.type)
		{
			case DOUBLE:
				cout << *(double*)A.data << " "; break;
			case INTEGER:
				cout << *(int*)A.data << " "; break;
			case TEXT:
				cout << *(string*)A.data << " "; break;
			case IF:
				cout << "IF" << " "; break;
			case THEN:
				cout << "THEN" << " "; break;
			case ELSE:
				cout << "ELSE" << " "; break;
			case RETURN:
				cout << "RETURN" << " "; break;
			case SP:
				cout << "STACK_PROCESSOR [name]" << " "; break;
			case STACK:
				stack<Data> temp = *(stack<Data>*)A.data;
				cout << "STACK [" << temp.size() << "]" << " ";			
				break;			
		}
		_STACK(this_)->pop();
	}
??
end

sp println
	copy = this;
	this << println_pop;
	*this;
	this = copy;
end

sp print
	copy = this;
	this << print_pop;
	*this;
	this = copy;
end
