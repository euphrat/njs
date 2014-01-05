sp add
??
	if(this_.size() >= 2)
	{
		Data X = this_.top();
		this_.pop();
		Data Y = this_.top();
		this_.pop();
		if(X.type == INTEGER && Y.type == INTEGER)
		{
			this_.push(Data(new int(_INT(X) + _INT(Y)), INTEGER));		
		}
		else if(X.type == INTEGER && Y.type == DOUBLE)
		{
			this_.push(Data(new double(_INT(X) + _DOUBLE(Y)), DOUBLE));		
		}
		else if(X.type == DOUBLE && Y.type == INTEGER)
		{		
			this_.push(Data(new double(_DOUBLE(X) + _INT(Y)), DOUBLE));
		}
		else if(X.type == DOUBLE && Y.type == DOUBLE)
		{		
			this_.push(Data(new double(_DOUBLE(X) + _DOUBLE(Y)), DOUBLE));
		}
	}
??
end

sp multiply
??
	if(this_.size() >= 2)
	{
		Data X = this_.top();
		this_.pop();
		Data Y = this_.top();
		this_.pop();
		if(X.type == INTEGER && Y.type == INTEGER)
		{
			this_.push(Data(new int(_INT(X) * _INT(Y)), INTEGER));		
		}
		else if(X.type == INTEGER && Y.type == DOUBLE)
		{
			this_.push(Data(new double(_INT(X) * _DOUBLE(Y)), DOUBLE));		
		}
		else if(X.type == DOUBLE && Y.type == INTEGER)
		{		
			this_.push(Data(new double(_DOUBLE(X) * _INT(Y)), DOUBLE));
		}
		else if(X.type == DOUBLE && Y.type == DOUBLE)
		{		
			this_.push(Data(new double(_DOUBLE(X) * _DOUBLE(Y)), DOUBLE));
		}
	}
??
end

sp subtract
??
	if(this_.size() >= 2)
	{
		Data X = this_.top();
		this_.pop();
		Data Y = this_.top();
		this_.pop();
		if(X.type == INTEGER && Y.type == INTEGER)
		{
			this_.push(Data(new int(_INT(X) - _INT(Y)), INTEGER));		
		}
		else if(X.type == INTEGER && Y.type == DOUBLE)
		{
			this_.push(Data(new double(_INT(X) - _DOUBLE(Y)), DOUBLE));		
		}
		else if(X.type == DOUBLE && Y.type == INTEGER)
		{		
			this_.push(Data(new double(_DOUBLE(X) - _INT(Y)), DOUBLE));
		}
		else if(X.type == DOUBLE && Y.type == DOUBLE)
		{		
			this_.push(Data(new double(_DOUBLE(X) - _DOUBLE(Y)), DOUBLE));
		}
	}
??
end

sp divide
??
	if(this_.size() >= 2)
	{
		Data X = this_.top();
		this_.pop();
		Data Y = this_.top();
		this_.pop();
		if(X.type == INTEGER && Y.type == INTEGER)
		{
			this_.push(Data(new int(_INT(X) / _INT(Y)), INTEGER));		
		}
		else if(X.type == INTEGER && Y.type == DOUBLE)
		{
			this_.push(Data(new double(_INT(X) / _DOUBLE(Y)), DOUBLE));		
		}
		else if(X.type == DOUBLE && Y.type == INTEGER)
		{		
			this_.push(Data(new double(_DOUBLE(X) / _INT(Y)), DOUBLE));
		}
		else if(X.type == DOUBLE && Y.type == DOUBLE)
		{		
			this_.push(Data(new double(_DOUBLE(X) / _DOUBLE(Y)), DOUBLE));
		}
	}
??
end

sp mod
??
	if(this_.size() >= 2)
	{
		Data X = this_.top();
		this_.pop();
		Data Y = this_.top();
		this_.pop();
		if(X.type == INTEGER && Y.type == INTEGER)
		{
			this_.push(Data(new int(_INT(X) % _INT(Y)), INTEGER));		
		}		
	}
??
end

sp pow
("cmath","m")
??
	if(this_.size() >= 2)
	{
		Data X = this_.top();
		this_.pop();
		Data Y = this_.top();
		this_.pop();
		if(X.type == INTEGER && Y.type == INTEGER)
		{
			this_.push(Data(new int(pow(_INT(X) , _INT(Y))), INTEGER));		
		}
		else if(X.type == INTEGER && Y.type == DOUBLE)
		{
			this_.push(Data(new double(pow(_INT(X) , _DOUBLE(Y))), DOUBLE));		
		}
		else if(X.type == DOUBLE && Y.type == INTEGER)
		{		
			this_.push(Data(new double(pow(_DOUBLE(X) , _INT(Y))), DOUBLE));
		}
		else if(X.type == DOUBLE && Y.type == DOUBLE)
		{		
			this_.push(Data(new double(pow(_DOUBLE(X) , _DOUBLE(Y))), DOUBLE));
		}
	}
??
end

sp less_than
??
	if(this_.size() >= 2)
	{
		Data X = this_.top();
		this_.pop();
		Data Y = this_.top();
		this_.pop();
		if(X.type == INTEGER && Y.type == INTEGER)
		{
			this_.push(Data(new int(_INT(X) < _INT(Y)), INTEGER));		
		}
		else if(X.type == INTEGER && Y.type == DOUBLE)
		{
			this_.push(Data(new int(_INT(X) < _DOUBLE(Y)), INTEGER));		
		}
		else if(X.type == DOUBLE && Y.type == INTEGER)
		{		
			this_.push(Data(new int(_DOUBLE(X) < _INT(Y)), INTEGER));
		}
		else if(X.type == DOUBLE && Y.type == DOUBLE)
		{		
			this_.push(Data(new int(_DOUBLE(X) < _DOUBLE(Y)), INTEGER));
		}
	}
??
end

sp greater_than
??
	if(this_.size() >= 2)
	{
		Data X = this_.top();
		this_.pop();
		Data Y = this_.top();
		this_.pop();
		if(X.type == INTEGER && Y.type == INTEGER)
		{
			this_.push(Data(new int(_INT(X) > _INT(Y)), INTEGER));		
		}
		else if(X.type == INTEGER && Y.type == DOUBLE)
		{
			this_.push(Data(new int(_INT(X) > _DOUBLE(Y)), INTEGER));		
		}
		else if(X.type == DOUBLE && Y.type == INTEGER)
		{		
			this_.push(Data(new int(_DOUBLE(X) > _INT(Y)), INTEGER));
		}
		else if(X.type == DOUBLE && Y.type == DOUBLE)
		{		
			this_.push(Data(new int(_DOUBLE(X) > _DOUBLE(Y)), INTEGER));
		}
	}
??
end

sp less_than_or_equal
??
	if(this_.size() >= 2)
	{
		Data X = this_.top();
		this_.pop();
		Data Y = this_.top();
		this_.pop();
		if(X.type == INTEGER && Y.type == INTEGER)
		{
			this_.push(Data(new int(_INT(X) <= _INT(Y)), INTEGER));		
		}
		else if(X.type == INTEGER && Y.type == DOUBLE)
		{
			this_.push(Data(new int(_INT(X) <= _DOUBLE(Y)), INTEGER));		
		}
		else if(X.type == DOUBLE && Y.type == INTEGER)
		{		
			this_.push(Data(new int(_DOUBLE(X) <= _INT(Y)), INTEGER));
		}
		else if(X.type == DOUBLE && Y.type == DOUBLE)
		{		
			this_.push(Data(new int(_DOUBLE(X) <= _DOUBLE(Y)), INTEGER));
		}
	}
??
end

sp greater_than_or_equal
??
	if(this_.size() >= 2)
	{
		Data X = this_.top();
		this_.pop();
		Data Y = this_.top();
		this_.pop();
		if(X.type == INTEGER && Y.type == INTEGER)
		{
			this_.push(Data(new int(_INT(X) >= _INT(Y)), INTEGER));		
		}
		else if(X.type == INTEGER && Y.type == DOUBLE)
		{
			this_.push(Data(new int(_INT(X) >= _DOUBLE(Y)), INTEGER));		
		}
		else if(X.type == DOUBLE && Y.type == INTEGER)
		{		
			this_.push(Data(new int(_DOUBLE(X) >= _INT(Y)), INTEGER));
		}
		else if(X.type == DOUBLE && Y.type == DOUBLE)
		{		
			this_.push(Data(new int(_DOUBLE(X) >= _DOUBLE(Y)), INTEGER));
		}
	}
??
end

sp equal
??
	if(this_.size() >= 2)
	{
		Data X = this_.top();
		this_.pop();
		Data Y = this_.top();
		this_.pop();
		if(X.type == INTEGER && Y.type == INTEGER)
		{
			this_.push(Data(new int(_INT(X) == _INT(Y)), INTEGER));		
		}
		else if(X.type == INTEGER && Y.type == DOUBLE)
		{
			this_.push(Data(new int(_INT(X) == _DOUBLE(Y)), INTEGER));		
		}
		else if(X.type == DOUBLE && Y.type == INTEGER)
		{		
			this_.push(Data(new int(_DOUBLE(X) == _INT(Y)), INTEGER));
		}
		else if(X.type == DOUBLE && Y.type == DOUBLE)
		{		
			this_.push(Data(new int(_DOUBLE(X) == _DOUBLE(Y)), INTEGER));
		}
	}
??
end
