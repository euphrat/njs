sp strcmp
("cstring")
??
	if(_STACK(this_)->size() >= 2)
	{
		Data X = _STACK(this_)->top();
		_STACK(this_)->pop();
		Data Y = _STACK(this_)->top();
		_STACK(this_)->pop();
		if(X.type == TEXT && Y.type == TEXT)
		{
			_STACK(this_)->push(Data(new int(strcmp(_TEXT(X).c_str(), _TEXT(Y).c_str())), INTEGER));				
		}		
	}
??	
end
