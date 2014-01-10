#include "njs.h"

string Data::DataTypeStrings [] = {"STACK", "INTEGER", "DOUBLE", "TEXT", "SP", "IF", "THEN", "ELSE", "RETURN", "TYPEOF"};

void Data::destroy()
{
	switch (type){
		case DOUBLE: delete (double*)data; break;
		case INTEGER: delete (int*)data; break;
		case TEXT: delete (string*)data; break;
		case STACK: delete (stack<Data>*)data; break;
	}
	delete refcount;
}

Data::Data(void* data_, DataType type_) : data(data_), type(type_)
{
	refcount = new int;		
	*refcount = 1;
}

Data::Data(const Data& d)
{
	refcount = d.refcount;
	(*refcount)++;
	data = d.data;
	type = d.type;
}

Data& Data::operator=(const Data& d)
{
	(*refcount)--;
	if (*refcount == 0){
		destroy();
	}
	refcount = d.refcount;
	(*refcount)++;
	data = d.data;
	type = d.type;
	return *this;
}

Data::~Data()
{
	(*refcount)--;
	if (*refcount == 0){ destroy(); }
}


void njs_private_func_if_helper(stack<Data>& this_, int njs_temp_bool)
{
	this_.pop();	
	if (njs_temp_bool){
		while (!this_.empty() && this_.top().type != THEN){
			this_.pop();
		}
		if (!this_.empty()){
			this_.pop();
		}
		stack<Data> this__temp;
		while (!this_.empty() && this_.top().type != ELSE){
			this__temp.push(this_.top());
			this_.pop();
		}
		while (!this_.empty()){
			this_.pop();
		}
		while (!this__temp.empty()){
			this_.push(this__temp.top());
			this__temp.pop();
		}
	}
	else{
		while (!this_.empty() && this_.top().type != ELSE){
			this_.pop();
		}if (!this_.empty()){ this_.pop(); }
	}
}

void njs_private_func_if(stack<Data>& this_){
	this_.pop();
	if (!this_.empty()){
		Data njs_temp_data = this_.top();		
		if (njs_temp_data.type == INTEGER){
			njs_private_func_if_helper(this_, *(int*)njs_temp_data.data);
		}
		else 
		{
			njs_private_func_eval(this_);
			Data njs_temp_data = this_.top();
			if (njs_temp_data.type == INTEGER){
				njs_private_func_if_helper(this_, *(int*)njs_temp_data.data);
			}
		}
	}
}
void njs_private_func_deepCopy(stack<Data>& stack1, stack<Data>& stack2){
	stack<Data> tempStack, srcStack; while (!stack1.empty()){
		Data njs_temp_data = stack1.top(); 
		stack1.pop(); 
		Data copyData(NULL, IF); 
		switch (njs_temp_data.type){
			case INTEGER: copyData.data = new int(_INT(njs_temp_data)); copyData.type = INTEGER; break;
			case DOUBLE: copyData.data = new double(_DOUBLE(njs_temp_data)); copyData.type = DOUBLE; break;
			case TEXT: copyData.data = new string(_TEXT(njs_temp_data)); copyData.type = TEXT; break;
			case STACK: copyData.data = new stack<Data>; njs_private_func_deepCopy(*_STACK(njs_temp_data), *_STACK(copyData)); copyData.type = STACK; break;
			default: copyData.data = njs_temp_data.data; copyData.type = njs_temp_data.type; break;
		} 
		tempStack.push(copyData); srcStack.push(njs_temp_data);
	}
	while (!tempStack.empty()){ stack2.push(tempStack.top()); tempStack.pop(); stack1.push(srcStack.top()); srcStack.pop(); }
}
bool njs_private_func_eval(stack<Data>& s){
	if (!s.empty()){
		void(*njs_function)(stack<Data>&) = NULL;
		switch(s.top().type)
		{
			case SP: njs_function = (void(*)(stack<Data>&))s.top().data; s.pop(); njs_function(s); break;
			case IF: njs_private_func_if(s); break;
			case TYPEOF: s.pop(); if(!s.empty()) {s.push(Data(new string(Data::DataTypeStrings[s.top().type]), TEXT));} break;
			case RETURN: s.pop(); return false;		
		}		
	}
	return true;
}

