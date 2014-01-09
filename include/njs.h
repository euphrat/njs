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


#define _STACK(S) ((stack<Data>*)((S).data))
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

NJS_MAIN_LIB_NJS_API bool njs_private_func_eval(stack<Data>& s);
NJS_MAIN_LIB_NJS_API void njs_private_func_if_helper(stack<Data>& this_, int njs_temp_bool);
NJS_MAIN_LIB_NJS_API void njs_private_func_if(stack<Data>& this_);
NJS_MAIN_LIB_NJS_API void njs_private_func_deepCopy(stack<Data>& stack1, stack<Data>& stack2);

#endif
