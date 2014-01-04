sp print_int
??
	if(!this_.empty() && this_.top().type == INTEGER)
	{
		cout << *(int*)this_.top().data;	
	}
	else
	{
		cerr << "(No INTEGER)";
	}
??
end

sp println_int
??
	if(!this_.empty() && this_.top().type == INTEGER)
	{
		cout << *(int*)this_.top().data << endl;	
	}
	else
	{
		cerr << "(No INTEGER)" << endl;
	}
??
end

sp print_double
??
	if(!this_.empty() && this_.top().type == DOUBLE)
	{
		cout << *(double*)this_.top().data;	
	}
	else
	{
		cerr << "(No DOUBLE)" << endl;
	}
??
end

sp println_double
??
	if(!this_.empty() && this_.top().type == DOUBLE)
	{
		cout << *(double*)this_.top().data << endl;	
	}
	else
	{
		cerr << "(No DOUBLE)" << endl;
	}
??
end

sp print_text
??
	if(!this_.empty() && this_.top().type == TEXT)
	{
		cout << *(string*)this_.top().data;	
	}
	else
	{
		cerr << "(No TEXT)";
	}
??
end

sp println_text
??
	if(!this_.empty() && this_.top().type == TEXT)
	{
		cout << *(string*)this_.top().data << endl;	
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
	if(!this_.empty() && this_.top().type == INTEGER)
	{
		cout << *(int*)this_.top().data;
		this_.pop();	
	}
	else
	{
		cerr << "(No INTEGER)";
	}
??
end

sp println_pop_int
??
	if(!this_.empty() && this_.top().type == INTEGER)
	{
		cout << *(int*)this_.top().data << endl;
		this_.pop();	
	}
	else
	{
		cerr << "(No INTEGER)" << endl;
	}
??
end

sp print_pop_double
??
	if(!this_.empty() && this_.top().type == DOUBLE)
	{
		cout << *(double*)this_.top().data;
		this_.pop();	
	}
	else
	{
		cerr << "(No DOUBLE)" << endl;
	}
??
end

sp println_pop_double
??
	if(!this_.empty() && this_.top().type == DOUBLE)
	{
		cout << *(double*)this_.top().data << endl;
		this_.pop();	
	}
	else
	{
		cerr << "(No DOUBLE)" << endl;
	}
??
end

sp print_pop_text
??
	if(!this_.empty() && this_.top().type == TEXT)
	{
		cout << *(string*)this_.top().data;
		this_.pop();	
	}
	else
	{
		cerr << "(No TEXT)";
	}
??
end

sp println_pop_text
??
	if(!this_.empty() && this_.top().type == TEXT)
	{
		cout << *(string*)this_.top().data << endl;
		this_.pop();	
	}
	else
	{
		cerr << "(No TEXT)" << endl;
	}
??
end

sp println_pop
??
	while(!this_.empty()){
		Data A = this_.top();
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
			case FUNCTION:
				cout << "STACK_PROCESSOR [name]" << endl; break;
			case STACK:
				stack<Data> temp = *(stack<Data>*)A.data;
				cout << "STACK [" << temp.size() << "]" << endl;			
				break;			
		}
		this_.pop();
	}
??
end
