sp add
??
	if(_STACK(this_)->size() >= 2)
	{
		Data X = _STACK(this_)->top();
		_STACK(this_)->pop();
		Data Y = _STACK(this_)->top();
		_STACK(this_)->pop();
		if(X.type == INTEGER && Y.type == INTEGER)
		{
			_STACK(this_)->push(Data(new int(_INT(X) + _INT(Y)), INTEGER));		
		}
		else if(X.type == INTEGER && Y.type == DOUBLE)
		{
			_STACK(this_)->push(Data(new double(_INT(X) + _DOUBLE(Y)), DOUBLE));		
		}
		else if(X.type == DOUBLE && Y.type == INTEGER)
		{		
			_STACK(this_)->push(Data(new double(_DOUBLE(X) + _INT(Y)), DOUBLE));
		}
		else if(X.type == DOUBLE && Y.type == DOUBLE)
		{		
			_STACK(this_)->push(Data(new double(_DOUBLE(X) + _DOUBLE(Y)), DOUBLE));
		}
	}
??
end

sp multiply
??
	if(_STACK(this_)->size() >= 2)
	{
		Data X = _STACK(this_)->top();
		_STACK(this_)->pop();
		Data Y = _STACK(this_)->top();
		_STACK(this_)->pop();
		if(X.type == INTEGER && Y.type == INTEGER)
		{
			_STACK(this_)->push(Data(new int(_INT(X) * _INT(Y)), INTEGER));		
		}
		else if(X.type == INTEGER && Y.type == DOUBLE)
		{
			_STACK(this_)->push(Data(new double(_INT(X) * _DOUBLE(Y)), DOUBLE));		
		}
		else if(X.type == DOUBLE && Y.type == INTEGER)
		{		
			_STACK(this_)->push(Data(new double(_DOUBLE(X) * _INT(Y)), DOUBLE));
		}
		else if(X.type == DOUBLE && Y.type == DOUBLE)
		{		
			_STACK(this_)->push(Data(new double(_DOUBLE(X) * _DOUBLE(Y)), DOUBLE));
		}
	}
??
end

sp subtract
??
	if(_STACK(this_)->size() >= 2)
	{
		Data X = _STACK(this_)->top();
		_STACK(this_)->pop();
		Data Y = _STACK(this_)->top();
		_STACK(this_)->pop();
		if(X.type == INTEGER && Y.type == INTEGER)
		{
			_STACK(this_)->push(Data(new int(_INT(X) - _INT(Y)), INTEGER));		
		}
		else if(X.type == INTEGER && Y.type == DOUBLE)
		{
			_STACK(this_)->push(Data(new double(_INT(X) - _DOUBLE(Y)), DOUBLE));		
		}
		else if(X.type == DOUBLE && Y.type == INTEGER)
		{		
			_STACK(this_)->push(Data(new double(_DOUBLE(X) - _INT(Y)), DOUBLE));
		}
		else if(X.type == DOUBLE && Y.type == DOUBLE)
		{		
			_STACK(this_)->push(Data(new double(_DOUBLE(X) - _DOUBLE(Y)), DOUBLE));
		}
	}
??
end

sp divide
??
	if(_STACK(this_)->size() >= 2)
	{
		Data X = _STACK(this_)->top();
		_STACK(this_)->pop();
		Data Y = _STACK(this_)->top();
		_STACK(this_)->pop();
		if(X.type == INTEGER && Y.type == INTEGER)
		{
			_STACK(this_)->push(Data(new int(_INT(X) / _INT(Y)), INTEGER));		
		}
		else if(X.type == INTEGER && Y.type == DOUBLE)
		{
			_STACK(this_)->push(Data(new double(_INT(X) / _DOUBLE(Y)), DOUBLE));		
		}
		else if(X.type == DOUBLE && Y.type == INTEGER)
		{		
			_STACK(this_)->push(Data(new double(_DOUBLE(X) / _INT(Y)), DOUBLE));
		}
		else if(X.type == DOUBLE && Y.type == DOUBLE)
		{		
			_STACK(this_)->push(Data(new double(_DOUBLE(X) / _DOUBLE(Y)), DOUBLE));
		}
	}
??
end

sp mod
??
	if(_STACK(this_)->size() >= 2)
	{
		Data X = _STACK(this_)->top();
		_STACK(this_)->pop();
		Data Y = _STACK(this_)->top();
		_STACK(this_)->pop();
		if(X.type == INTEGER && Y.type == INTEGER)
		{
			_STACK(this_)->push(Data(new int(_INT(X) % _INT(Y)), INTEGER));		
		}		
	}
??
end

sp pow
("cmath","m")
??
	if(_STACK(this_)->size() >= 2)
	{
		Data X = _STACK(this_)->top();
		_STACK(this_)->pop();
		Data Y = _STACK(this_)->top();
		_STACK(this_)->pop();
		if(X.type == INTEGER && Y.type == INTEGER)
		{
			_STACK(this_)->push(Data(new int(pow(_INT(X) , _INT(Y))), INTEGER));		
		}
		else if(X.type == INTEGER && Y.type == DOUBLE)
		{
			_STACK(this_)->push(Data(new double(pow(_INT(X) , _DOUBLE(Y))), DOUBLE));		
		}
		else if(X.type == DOUBLE && Y.type == INTEGER)
		{		
			_STACK(this_)->push(Data(new double(pow(_DOUBLE(X) , _INT(Y))), DOUBLE));
		}
		else if(X.type == DOUBLE && Y.type == DOUBLE)
		{		
			_STACK(this_)->push(Data(new double(pow(_DOUBLE(X) , _DOUBLE(Y))), DOUBLE));
		}
	}
??
end

sp less_than
??
	if(_STACK(this_)->size() >= 2)
	{
		Data X = _STACK(this_)->top();
		_STACK(this_)->pop();
		Data Y = _STACK(this_)->top();
		_STACK(this_)->pop();
		if(X.type == INTEGER && Y.type == INTEGER)
		{
			_STACK(this_)->push(Data(new int(_INT(X) < _INT(Y)), INTEGER));		
		}
		else if(X.type == INTEGER && Y.type == DOUBLE)
		{
			_STACK(this_)->push(Data(new int(_INT(X) < _DOUBLE(Y)), INTEGER));		
		}
		else if(X.type == DOUBLE && Y.type == INTEGER)
		{		
			_STACK(this_)->push(Data(new int(_DOUBLE(X) < _INT(Y)), INTEGER));
		}
		else if(X.type == DOUBLE && Y.type == DOUBLE)
		{		
			_STACK(this_)->push(Data(new int(_DOUBLE(X) < _DOUBLE(Y)), INTEGER));
		}
	}
??
end

sp greater_than
??
	if(_STACK(this_)->size() >= 2)
	{
		Data X = _STACK(this_)->top();
		_STACK(this_)->pop();
		Data Y = _STACK(this_)->top();
		_STACK(this_)->pop();
		if(X.type == INTEGER && Y.type == INTEGER)
		{
			_STACK(this_)->push(Data(new int(_INT(X) > _INT(Y)), INTEGER));		
		}
		else if(X.type == INTEGER && Y.type == DOUBLE)
		{
			_STACK(this_)->push(Data(new int(_INT(X) > _DOUBLE(Y)), INTEGER));		
		}
		else if(X.type == DOUBLE && Y.type == INTEGER)
		{		
			_STACK(this_)->push(Data(new int(_DOUBLE(X) > _INT(Y)), INTEGER));
		}
		else if(X.type == DOUBLE && Y.type == DOUBLE)
		{		
			_STACK(this_)->push(Data(new int(_DOUBLE(X) > _DOUBLE(Y)), INTEGER));
		}
	}
??
end

sp less_than_or_equal
??
	if(_STACK(this_)->size() >= 2)
	{
		Data X = _STACK(this_)->top();
		_STACK(this_)->pop();
		Data Y = _STACK(this_)->top();
		_STACK(this_)->pop();
		if(X.type == INTEGER && Y.type == INTEGER)
		{
			_STACK(this_)->push(Data(new int(_INT(X) <= _INT(Y)), INTEGER));		
		}
		else if(X.type == INTEGER && Y.type == DOUBLE)
		{
			_STACK(this_)->push(Data(new int(_INT(X) <= _DOUBLE(Y)), INTEGER));		
		}
		else if(X.type == DOUBLE && Y.type == INTEGER)
		{		
			_STACK(this_)->push(Data(new int(_DOUBLE(X) <= _INT(Y)), INTEGER));
		}
		else if(X.type == DOUBLE && Y.type == DOUBLE)
		{		
			_STACK(this_)->push(Data(new int(_DOUBLE(X) <= _DOUBLE(Y)), INTEGER));
		}
	}
??
end

sp greater_than_or_equal
??
	if(_STACK(this_)->size() >= 2)
	{
		Data X = _STACK(this_)->top();
		_STACK(this_)->pop();
		Data Y = _STACK(this_)->top();
		_STACK(this_)->pop();
		if(X.type == INTEGER && Y.type == INTEGER)
		{
			_STACK(this_)->push(Data(new int(_INT(X) >= _INT(Y)), INTEGER));		
		}
		else if(X.type == INTEGER && Y.type == DOUBLE)
		{
			_STACK(this_)->push(Data(new int(_INT(X) >= _DOUBLE(Y)), INTEGER));		
		}
		else if(X.type == DOUBLE && Y.type == INTEGER)
		{		
			_STACK(this_)->push(Data(new int(_DOUBLE(X) >= _INT(Y)), INTEGER));
		}
		else if(X.type == DOUBLE && Y.type == DOUBLE)
		{		
			_STACK(this_)->push(Data(new int(_DOUBLE(X) >= _DOUBLE(Y)), INTEGER));
		}
	}
??
end

sp equal
??
	if(_STACK(this_)->size() >= 2)
	{
		Data X = _STACK(this_)->top();
		_STACK(this_)->pop();
		Data Y = _STACK(this_)->top();
		_STACK(this_)->pop();
		if(X.type == INTEGER && Y.type == INTEGER)
		{
			_STACK(this_)->push(Data(new int(_INT(X) == _INT(Y)), INTEGER));		
		}
		else if(X.type == INTEGER && Y.type == DOUBLE)
		{
			_STACK(this_)->push(Data(new int(_INT(X) == _DOUBLE(Y)), INTEGER));		
		}
		else if(X.type == DOUBLE && Y.type == INTEGER)
		{		
			_STACK(this_)->push(Data(new int(_DOUBLE(X) == _INT(Y)), INTEGER));
		}
		else if(X.type == DOUBLE && Y.type == DOUBLE)
		{		
			_STACK(this_)->push(Data(new int(_DOUBLE(X) == _DOUBLE(Y)), INTEGER));
		}
	}
??
end
