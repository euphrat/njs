sp strcmp
("cstring")
??
	if(this_.size() >= 2)
	{
		Data X = this_.top();
		this_.pop();
		Data Y = this_.top();
		this_.pop();
		if(X.type == TEXT && Y.type == TEXT)
		{
			this_.push(Data(new int(strcmp(_TEXT(X).c_str(), _TEXT(Y).c_str())), INTEGER));				
		}		
	}
??	
end
