#include "njs.h"

string Data::DataTypeStrings [] = {"STACK", "INTEGER", "DOUBLE", "TEXT", "SP", "IF", "THEN", "ELSE", "RETURN", "TYPEOF"};

void Data::destroy()
{
	switch (type){
		case DOUBLE: delete (double*)data; break;
		case INTEGER: delete (int*)data; break;
		case TEXT: delete (string*)data; break;
		case STACK: delete (StackInterface*)data; break;
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

StackInterface::~StackInterface(){}

void StackInterface::pop(const Data& that)
{
	_STACK(that)->push(top());
	pop();
}

bool StackInterface::empty()
{
	return size() == 0;
}

Stack::~Stack(){}

void Stack::push(const Data& it)
{
	stack_.push(it);
}

void Stack::pop()
{
	stack_.pop();
}

Data& Stack::top()
{
	return stack_.top();
}

size_t Stack::size()
{
	return stack_.size();
}

void Stack::operator=(const Data& that)
{
	*this = *(Stack*)_STACK(that);
}

void njs_private_func_if_helper(Data& this_, int njs_temp_bool)
{
	_STACK(this_)->pop();
	if (njs_temp_bool){
		while (!_STACK(this_)->empty() && _STACK(this_)->top().type != THEN){
			_STACK(this_)->pop();
		}
		if (!_STACK(this_)->empty()){
			_STACK(this_)->pop();
		}
		Data this__temp(new Stack, STACK);
		while (!_STACK(this_)->empty() && _STACK(this_)->top().type != ELSE){
			_STACK(this_)->pop(this__temp);
		}
		while (!_STACK(this_)->empty()){
			_STACK(this_)->pop();
		}
		while (!_STACK(this__temp)->empty()){
			_STACK(this__temp)->pop(this_);
		}
	}
	else{
		while (!_STACK(this_)->empty() && _STACK(this_)->top().type != ELSE){
			_STACK(this_)->pop();
		}if (!_STACK(this_)->empty()){ _STACK(this_)->pop(); }
	}
}

void njs_private_func_if(Data& this_){
	_STACK(this_)->pop();
	if (!_STACK(this_)->empty()){
		Data njs_temp_data = _STACK(this_)->top();
		if (njs_temp_data.type == INTEGER){
			njs_private_func_if_helper(this_, _INT(njs_temp_data));
		}
		else 
		{
			njs_private_func_eval(this_);
			Data njs_temp_data = _STACK(this_)->top();
			if (njs_temp_data.type == INTEGER){
				njs_private_func_if_helper(this_, _INT(njs_temp_data));
			}
		}
	}
}
void njs_private_func_deepCopy(Data& stack1, Data& stack2){
	Data tempStack(new Stack, STACK), srcStack(new Stack, STACK);
	while (!_STACK(stack1)->empty()){
		Data njs_temp_data = _STACK(stack1)->top();
		_STACK(stack1)->pop();
		Data copyData(NULL, IF); 
		switch (njs_temp_data.type){
			case INTEGER:
				copyData.data = new int(_INT(njs_temp_data));
				copyData.type = INTEGER;
				break;
			case DOUBLE:
				copyData.data = new double(_DOUBLE(njs_temp_data));
				copyData.type = DOUBLE;
				break;
			case TEXT:
				copyData.data = new string(_TEXT(njs_temp_data));
				copyData.type = TEXT;
				break;
			case STACK:
				copyData.data = new Stack;
				njs_private_func_deepCopy(njs_temp_data, copyData);
				copyData.type = STACK;
				break;
			default:
				copyData.data = njs_temp_data.data;
				copyData.type = njs_temp_data.type;
				break;
		} 
		_STACK(tempStack)->push(copyData); _STACK(srcStack)->push(njs_temp_data);
	}
	while (!_STACK(tempStack)->empty()){
		_STACK(tempStack)->pop(stack2);
		_STACK(srcStack)->pop(stack1);
	}
}
bool njs_private_func_eval(Data& s){
	if (!_STACK(s)->empty()){
		void(*njs_function)(Data&) = NULL;
		switch(_STACK(s)->top().type)
		{
			case SP:
				njs_function = (void(*)(Data&))_STACK(s)->top().data;
				_STACK(s)->pop();
				njs_function(s);
				break;
			case IF:
				njs_private_func_if(s);
				break;
			case TYPEOF:
				_STACK(s)->pop();
				if(!_STACK(s)->empty()) {
					_STACK(s)->push(Data(new string(Data::DataTypeStrings[_STACK(s)->top().type]), TEXT));
				}
				break;
			case RETURN: _STACK(s)->pop();
			return false;
		}		
	}
	return true;
}

