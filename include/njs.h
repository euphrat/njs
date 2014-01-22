#ifndef NJS_HEADER
#define NJS_HEADER
#include<stack>
#include<string>
#include<iostream>

#ifdef _WIN32
	#ifdef NJS_MAIN_LIB_NJS_EXPORTS
	#define NJS_MAIN_LIB_NJS_API __declspec(dllexport)
	#else
	#define NJS_MAIN_LIB_NJS_API __declspec(dllimport)
	#endif
#else
	#define NJS_MAIN_LIB_NJS_API
#endif


#define _STACK(S) ((StackInterface*)((S).data))
#define _INT(S) (*(int*)((S).data))
#define _DOUBLE(S) (*(double*)((S).data))
#define _TEXT(S) (*(string*)((S).data))

using namespace std;

enum DataType {STACK, INTEGER, DOUBLE, TEXT, SP, IF, THEN, ELSE, RETURN, TYPEOF};

class NJS_MAIN_LIB_NJS_API Data
{
private:
	int* refcount;
	void destroy();
public:	
	static string DataTypeStrings [];
	void* data; DataType type;
	Data(void* data_, DataType type_);
	Data(const Data& d);
	Data& operator=(const Data& d);
	~Data();
};

class NJS_MAIN_LIB_NJS_API StackInterface
{
public:
	virtual ~StackInterface();
	virtual void push(const Data& it) = 0;
	virtual void pop() = 0;
	virtual Data& top() = 0;
	virtual bool empty() = 0;
	virtual size_t size() = 0;
	virtual void operator=(const Data& that) = 0;
};

class NJS_MAIN_LIB_NJS_API Stack : public StackInterface
{
public:
	virtual ~Stack();
	virtual void push(const Data& it);
	virtual void pop();
	virtual Data& top();
	virtual bool empty();
	virtual size_t size();
	virtual void operator=(const Data& that);
private:
	stack<Data> stack_;
};

NJS_MAIN_LIB_NJS_API bool njs_private_func_eval(Data& s);
NJS_MAIN_LIB_NJS_API void njs_private_func_if_helper(Data& this_, int njs_temp_bool);
NJS_MAIN_LIB_NJS_API void njs_private_func_if(Data& this_);
NJS_MAIN_LIB_NJS_API void njs_private_func_deepCopy(Data& stack1, Data& stack2);

#endif
