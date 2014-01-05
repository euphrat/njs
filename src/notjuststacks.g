//TODO:

class NotJustStacksLexer extends Lexer;

options {
	k=3;
	charVocabulary='\u0000'..'\u007F';
	testLiterals=false;
}

tokens {
	FUNC = "sp";
	END = "end";	
	IF = "if";
	THEN = "then";
	ELSE = "else";	
	WHILE = "while";		
	INCLUDE = "include";
	THIS = "this";
	NULL = "null";
	PROGRAM;	
	INCLUDE_LIST;
	FUNCTION_LIST;
	FUNCTION_DEFINITION;
	STATEMENT;	
}

COMMENT : "%"
	(options {greedy=false;} :.)*
	   "\n" {newline();}
	{$setType(Token.SKIP);}
	{}
;


WS    : ( ' '
	     | '\r' '\n' {newline(); }
	     | '\n'  {newline(); }
	     | '\t'
	 )
        {$setType(Token.SKIP);}
;	      

QUOTE: "\"";
NEWLINECHAR: "\\n";
TABCHAR: "\\t";
ASSIGN: "=";
SEMI : ";";
REF: "&";
PUSH: "<<";
POP: ">>";
SIZE: "#";
EVAL: "*";
CPP: "??";
LPAR: "(";
RPAR: ")";
AT: "@";


TEXT:
  QUOTE (options {greedy=false;}:.)* QUOTE {};
  
CPPINCLUDE:
  LPAR! TEXT RPAR!;
  
CPPCODE:
  CPP! (options {greedy=false;}:.)* CPP! {};

IDENTIFIER options {testLiterals=true;}: 	
		LETTER(LETTER |'_' | DIGIT)*   
		;



protected 
DIGIT:  ('0'..'9');

protected
LETTER :('a'..'z') |('A'..'Z');

protected
DIGSEQ: (DIGIT)+ ;

INTEGER: ('+'|'-')? DIGSEQ;

DOUBLE : INTEGER '.' DIGSEQ (('e'|'E') INTEGER)?;


class NotJustStacksParser extends Parser;

options {
	k=3;
	buildAST =true;
	
}

program: (inc:include_list)(funcs:function_list)
{
	#program = #([PROGRAM,"PROGRAM"],#program);
};

include_list: (INCLUDE! TEXT AT! TEXT)*
{
	#include_list = #([INCLUDE_LIST,"INCLUDE_LIST"],#include_list);
};

function_list: (funcdef: function_definition)+
{
	#function_list = #([FUNCTION_LIST,"FUNCTION_LIST"],#function_list);
};

function_definition: (FUNC! x:IDENTIFIER^
{
	if(NotJustStacksWalker.symbolTable.contains("@"+x.getText()))
	{
		System.err.println("ERROR: Redefition of stack processor \""+ x.getText() + "\".");
	}
	else
	{
		NotJustStacksWalker.symbolTable.add("@"+x.getText());
	}
} 
((statement SEMI!)* | (CPPINCLUDE)* CPPCODE)  END!)
{
	#function_definition = #([FUNCTION_DEFINITION,"FUNCTION_DEFINITION"],#function_definition);	
};


statement: 
(
EVAL^ evalarg |
popleft POP^ popright |
pushleft PUSH^ pushright |
assignleft ASSIGN^ assignright |
IDENTIFIER
);

evalarg:
(
	IDENTIFIER | THIS 
);

popleft:
(
	evalarg
);

popright:
(
	(REF^)? IDENTIFIER | THIS | NULL
);

pushleft:
(
	evalarg
);

pushright:
(
	(REF^ | SIZE^)? pushleft | INTEGER | DOUBLE | TEXT | IF | THEN | ELSE
);

assignleft:
(
	evalarg
);

assignright:
(
	(REF^)? pushleft
);



{
import java.io.PrintWriter;	
import java.io.File;
import java.io.FileReader;
import java.io.BufferedReader;
import java.util.concurrent.ConcurrentSkipListSet;
}

class NotJustStacksWalker extends TreeParser;


options {
 	buildAST=true;		
	k=1;
}

{	
	public static PrintWriter code = null;
	public static PrintWriter headerCode = null;
	public static PrintWriter linkInfo = null;
	private String scope = null;
	public static ConcurrentSkipListSet<String> symbolTable = new ConcurrentSkipListSet<String>();
	public static boolean isExe = true;
	public static String libname = "";
	
	private String getLocalStackName(AST a)
	{
		return "njs_local_"+a;
	}
	
	private void updateSymbolTable(String libHeaderName)
	{
		try {
			BufferedReader br = new BufferedReader(new FileReader(libHeaderName));
			String line;
			while ((line = br.readLine()) != null) {
			   if(line.substring(0,2).equals("//"))
			   {
			   		symbolTable.add("@"+line.substring(2,line.length()));
			   }
			   else
			   {
			   		break;	
			   }
			}
			br.close();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}
	
	private void evalCode(String name)
	{
		if(name.equals("this_"))
		{
			code.println("\tnjs_private_func_eval(this_);");
		}
		else
		{
			code.println("\tnjs_private_func_eval(*_STACK("+name+"));");	
		}		
	}	
	
	private void popCode(String src, String dst)
	{
		if(dst.equals("this_"))
		{
			if(src.equals("this_"))
			{
				
			}
			else
			{
				code.println("\tif(!_STACK("+src+")->empty()){Data njs_temp_data = _STACK("+ src +")->top(); _STACK("+ src +")->pop(); this_.push(njs_temp_data);}");
			}
		}
		else
		{
			if(src.equals("this_"))
			{
				code.println("\tif(!this_.empty()){Data njs_temp_data = this_.top(); this_.pop(); _STACK(" + dst + ")->push(njs_temp_data);}");
			}
			else
			{
				code.println("\tif(!_STACK("+src+")->empty()){Data njs_temp_data = _STACK("+ src +")->top(); _STACK("+ src +")->pop(); _STACK(" + dst + ")->push(njs_temp_data);}");
			}
		}	
	}
	
	private void pushCode(String dst, String src)
	{
		if(dst.equals("this_"))
		{
			if(src.equals("this_"))
			{
				code.println("\tif(!this_.empty()){Data njs_temp_data = this_.top(); this_.push(njs_temp_data);}");
			}
			else
			{
				code.println("\tif(!_STACK("+src+")->empty()){Data njs_temp_data = _STACK("+ src +")->top(); this_.push(njs_temp_data);}");
			}
		}
		else
		{
			if(src.equals("this_"))
			{
				code.println("\tif(!this_.empty()){Data njs_temp_data = this_.top(); _STACK(" + dst + ")->push(njs_temp_data);}");
			}
			else
			{
				code.println("\tif(!_STACK("+src+")->empty()){Data njs_temp_data = _STACK("+ src +")->top(); _STACK(" + dst + ")->push(njs_temp_data);}");
			}
		}	
		
		
	}
	
	private void clearStackCode(String name)
	{
		//code.println("\twhile(!"+ name + ".empty()){"+ name + ".pop();}");
		if(name.equals("this_"))
		{
			code.println("\tthis_ = stack<Data>();");
		}
		else
		{
			code.println("\t*_STACK("+ name + ") = stack<Data>();");
		}
	}
	
	private void deepCopyCode(String dst, String src)
	{		
		if(dst.equals("this_"))
		{
			if(src.equals("this_"))
			{
				
			}
			else
			{
				code.println("\tnjs_private_func_deepCopy(*_STACK("+src+"),this_);");
			}
		}
		else
		{
			if(src.equals("this_"))
			{
				code.println("\tnjs_private_func_deepCopy(this_ ,*_STACK("+dst+"));");
			}
			else
			{
				code.println("\tnjs_private_func_deepCopy(*_STACK("+src+"),*_STACK("+dst+"));");
			}
		}
				
	}
	
	private void shallowCopyCode(String dst, String src)
	{
		if(dst.equals("this_"))
		{
			if(src.equals("this_"))
			{
				
			}
			else
			{
				code.println("\tthis_ = *_STACK(" +src+ ");");
			}
		}
		else
		{
			if(src.equals("this_"))
			{
				code.println("\t*_STACK("+dst+") = this_;");
			}
			else
			{
				code.println("\t*_STACK("+dst+") = *_STACK(" +src+ ");");
			}
		}
		
	}
	
	private void createVariableCode(String name)
	{
		code.println("\tData " + name + "(new stack<Data>, STACK);");
	}
}

program:
{
	if(!isExe)
	{
		String[] symbols = symbolTable.toArray(new String[0]);
		for(int i = 0; i < symbols.length; i++)
		{
			if(symbols[i].substring(0,1).equals("@"))
			{
				headerCode.println("//"+ symbols[i].substring(1));	
			}	
		}
	}
	
	headerCode.println("#ifndef NJS_PROGRAM_HEADER");
	headerCode.println("#define NJS_PROGRAM_HEADER");
	headerCode.println("#include<stack>");
	headerCode.println("#include\"njs.h\"");
	if(isExe)
	{
		headerCode.println("#define " + libname + "_NJS_API");
	}
	else
	{		
		headerCode.println("#ifdef _WIN32");
		headerCode.println("\t#ifdef " + libname + "_NJS_EXPORTS");
		headerCode.println("\t#define " + libname + "_NJS_API __declspec(dllexport)"); 
		headerCode.println("\t#else");
		headerCode.println("\t#define " + libname + "_NJS_API __declspec(dllimport)"); 
		headerCode.println("\t#endif");	
		headerCode.println("#else");
		headerCode.println("\t#define " + libname + "_NJS_API");
		headerCode.println("#endif");
	}	
	
	code.println("#include\"" + NotJustStacks.hFile + "\"");
	code.println("#include\"njs.h\"");
} 
#(PROGRAM include_list function_list)
{
	if(isExe)
	{
		code.println("int main(int argc, char* argv[]){stack<Data> mainStack; for(int i = 1; i < argc; i++) {Data d(new string(argv[i]), TEXT); mainStack.push(d);} njs_sp_main(mainStack);");	
		code.println("#ifdef _WIN32");
		code.println("cout << \"Press enter to continue...\" << endl; getchar();");
		code.println("#endif _WIN32");
		code.println("return 0;}");
	}
	headerCode.println("using namespace std;");	
	
	String[] symbols = symbolTable.toArray(new String[0]);
	for(int i = 0; i < symbols.length; i++)
	{
		if(symbols[i].substring(0,1).equals("@"))
		{
			headerCode.println(libname + "_NJS_API void njs_sp_"+ symbols[i].substring(1) + "(stack<Data>&);");	
		}	
	}
	
	headerCode.println("#endif");
};


include_list:
#(INCLUDE_LIST (TEXT)*)
{	
	int n = #INCLUDE_LIST.getNumberOfChildren();
	if(n > 0)
	{
		AST libname2include = #INCLUDE_LIST.getFirstChild();
		AST libnamePath = libname2include.getNextSibling();
		String libHeaderName = libnamePath.getText().substring(1, libnamePath.getText().length()-1) + "/"+ libname2include.getText().substring(1, libname2include.getText().length()-1) +".h";
		if(new File(libHeaderName).exists())
		{
			code.println("#include \""+ libHeaderName+ "\"");
			linkInfo.print(" -L"+libnamePath.getText().substring(1, libnamePath.getText().length()-1) +" -l" + libname2include.getText().substring(1, libname2include.getText().length()-1));
			updateSymbolTable(libHeaderName);
		}
		else
		{
			System.err.println("ERROR: Library "+ libname2include + " cannot be found.");	
		}
		for(int i = 1; i < n/2; i++)
		{
			libname2include = libnamePath.getNextSibling();	
			libnamePath = libname2include.getFirstChild();
			libHeaderName = libnamePath.getText().substring(1, libnamePath.getText().length()-1) + "/"+ libname2include.getText().substring(1, libname2include.getText().length()-1) +".h";
			if(new File(libHeaderName).exists())
			{
				code.println("#include \""+ libHeaderName+ "\"");
				linkInfo.println(libnamePath.getText().substring(1, libnamePath.getText().length()-1) +" ||| " + libname2include.getText().substring(1, libname2include.getText().length()-1));
				updateSymbolTable(libHeaderName);
			}
			else
			{
				System.err.println("ERROR: Library "+ libname2include + " cannot be found.");	
			}
		}		
	}
};

function_list:
#(FUNCTION_LIST (funcdef)*);

funcdef:
#(FUNCTION_DEFINITION func);


func:
#(IDENTIFIER {
	code.println("void njs_sp_" + #IDENTIFIER + "(stack<Data>& this_){");	
	scope = #IDENTIFIER.getText();	
} ((eval | pop | push | pop | newstack | assign)* | cppcode))
{
	code.println("}");
	scope = null;
}
;

newstack:
x:IDENTIFIER
{
	if(!symbolTable.contains(x+"@"+scope))
	{
		symbolTable.add(x+"@"+scope);
		createVariableCode(getLocalStackName(x));		
	}
	else
	{
		clearStackCode(getLocalStackName(x));		
	}
};

cppcode:
((y:CPPINCLUDE {headerCode.println("#include<"+y.getText().substring(1, y.getText().length()-1)+">");})* x:CPPCODE)
{
	code.println(x);
};

assign:
#(ASSIGN (x1:IDENTIFIER | x2:THIS) (x3:IDENTIFIER | x4:THIS | #(x5:REF (x50:IDENTIFIER | x51:THIS))))
{
	if(x1 != null)
	{
		boolean exist = true; 
		if(!symbolTable.contains(x1+"@"+scope))
		{
			symbolTable.add(x1+"@"+scope);
			createVariableCode(getLocalStackName(x1));			
			exist = false;
		}	
		
		if(x3 != null)
		{
			if(symbolTable.contains(x3+"@"+scope) && !x1.getText().equals(x3.getText()))
			{	
				if(exist)
				{
					clearStackCode(getLocalStackName(x1));
				}				
				deepCopyCode(getLocalStackName(x1), getLocalStackName(x3));
			}			
			else
			{
				System.err.println("ERROR: Stack \""+ x3 + "\" does not exist in stack processor \"" + scope + "\"");
			}	
		}
		else if(x4 != null)
		{
			clearStackCode(getLocalStackName(x1));
			deepCopyCode(getLocalStackName(x1), "this_");
		}
		else
		{
			if(x50 != null && !x1.getText().equals(x50.getText()))
			{
				shallowCopyCode(getLocalStackName(x1), getLocalStackName(x50));
			}
			else
			{
				shallowCopyCode(getLocalStackName(x1), "this_");
			}
		}
	}
	else
	{		
		if(x3 != null)
		{
			if(symbolTable.contains(x3+"@"+scope))
			{	
				clearStackCode("this_");				
				deepCopyCode("this_", getLocalStackName(x3));
			}			
			else
			{
				System.err.println("ERROR: Stack \""+ x3 + "\" does not exist in stack processor \"" + scope + "\"");
			}	
		}
		else if(x5 != null)		
		{
			if(x50 != null)
			{
				shallowCopyCode("this_", getLocalStackName(x50));
			}			
		}
	}
};

eval:
#(EVAL (x1:IDENTIFIER | x2:THIS))
{
	if(x1 != null)
	{
		if(symbolTable.contains(x1+"@"+scope))
		{
			evalCode(getLocalStackName(x1));			
		}
		else
		{
			System.err.println("ERROR: Stack \""+ x1 + "\" does not exist in stack processor \"" + scope + "\"");
		}
	}		
	else
	{
		evalCode("this_");		
	}		
};

pop:
#(POP (x1:IDENTIFIER | x2:THIS) (x3:IDENTIFIER | x4:THIS | x5:NULL | #(x6:REF x60:IDENTIFIER)))
{
	if(x1 != null) //IDENTIFIER
	{
		if(symbolTable.contains(x1+"@"+scope))
		{
			if(x3 != null) // IDENTIFIER
			{
				if(!symbolTable.contains(x3+"@"+scope))
				{
					symbolTable.add(x3+"@"+scope);
					createVariableCode(getLocalStackName(x3));					
				}
				popCode(getLocalStackName(x1), getLocalStackName(x3));				
			}
			else if(x4 != null) //THIS
			{
				popCode(getLocalStackName(x1), "this_");				
			}
			else if(x5 != null)//NULL
			{
				code.println("\tif(!_STACK("+ getLocalStackName(x1) +")->empty()){_STACK("+ getLocalStackName(x1) +")->pop();}");
			}
			else
			{
				if(!symbolTable.contains(x60+"@"+scope))
				{
					symbolTable.add(x60+"@"+scope);
					createVariableCode(getLocalStackName(x60));					
				}
				code.println("\tif(!_STACK("+ getLocalStackName(x1) + ")->empty() && _STACK("+ getLocalStackName(x1) + ")->top().type == STACK){");
				shallowCopyCode(getLocalStackName(x60), getLocalStackName(x1) );
				code.println("\t_STACK("+ getLocalStackName(x1) + ")->pop();");
				code.println("\t}");	
			}	
		}
		else
		{
			System.err.println("ERROR: Stack \""+ x1 + "\" does not exist in stack processor \"" + scope + "\"");
		}	
	}
	else //THIS
	{
		if(x3 != null) // IDENTIFIER
		{
			if(!symbolTable.contains(x3+"@"+scope))
			{
				symbolTable.add(x3+"@"+scope);
				createVariableCode(getLocalStackName(x3));				
			}
			popCode("this_", getLocalStackName(x3));			
		}
		else if(x4 != null) //THIS
		{
			popCode("this_", "this_");
		}
		else if(x5 != null)//NULL
		{
			code.println("\tif(!this_.empty()){this_.pop();}");
		}
		else
		{
			if(!symbolTable.contains(x60+"@"+scope))
			{
				symbolTable.add(x60+"@"+scope);
				createVariableCode(getLocalStackName(x60));				
			}
			code.println("\tif(!this_.empty() && this_.top().type == STACK){");
			shallowCopyCode(getLocalStackName(x60), "this_.top()");
			code.println("\tthis_.pop();");
			code.println("\t}");	
		}		
	}
	
};


push:
#(PUSH (x1:IDENTIFIER | x2:THIS) (x3:IDENTIFIER | x4:THIS | #(x5:REF (x50:IDENTIFIER | x51:THIS)) | #(x6:SIZE (x60:IDENTIFIER | x61:THIS)) | x7:DOUBLE | x8:TEXT | x9:INTEGER | x10:IF | x11:THEN | x12:ELSE))
{
	if(x1 != null) //IDENTIFIER
	{
		if(!symbolTable.contains(x1+"@"+scope))
		{
			symbolTable.add(x1+"@"+scope);			
			createVariableCode(getLocalStackName(x1));
		}
		if(x3 != null) //IDENTIFIER
		{
			if(symbolTable.contains(x3+"@"+scope))
			{					
				pushCode(getLocalStackName(x1), getLocalStackName(x3));
			}
			else if(symbolTable.contains("@"+x3)) //FUNCTION
			{
				code.println("\t{Data njs_temp_data(&njs_sp_"+ x3 + ",SP); _STACK(" + getLocalStackName(x1) + ")->push(njs_temp_data);}");
			}
			else
			{
				System.err.println("ERROR: Stack \""+ x3 + "\" does not exist in stack processor \"" + scope + "\"");
			}
		}
		else if(x4 != null) //THIS
		{
			pushCode(getLocalStackName(x1), "this_");			
		}
		else if(x5 != null) //REF
		{
			if(x50 != null)
			{
				if(symbolTable.contains(x50+"@"+scope))
				{
					code.println("\t{Data njs_temp_data(new stack<Data>(*_STACK(" + getLocalStackName(x50) + ")), STACK); _STACK(" + getLocalStackName(x1) + ")->push(njs_temp_data);}");
				}
				else
				{
					System.err.println("ERROR: Stack \""+ x50 + "\" does not exist in stack processor \"" + scope + "\"");
				}
			}
			else
			{
				code.println("\t{Data njs_temp_data(new stack<Data>(this_), STACK); _STACK(" + getLocalStackName(x1) + ")->push(njs_temp_data);}");
			}
		}
		else if(x6 != null) //SIZE
		{
			if(x60 != null)
			{
				if(symbolTable.contains(x60+"@"+scope))
				{
					code.println("\t{Data njs_temp_data(new int, INTEGER); *(int*)njs_temp_data.data = (int)_STACK("+ getLocalStackName(x60) + ")->size(); _STACK(" + getLocalStackName(x1) + ")->push(njs_temp_data);}");
				}
				else
				{
					System.err.println("ERROR: Stack \""+ x60 + "\" does not exist in stack processor \"" + scope + "\"");
				}
			}
			else
			{
				code.println("\t{Data njs_temp_data(new int, INTEGER); *(int*)njs_temp_data.data = (int)this_.size(); _STACK(" + getLocalStackName(x1) + ")->push(njs_temp_data);}");
			}
		}
		else if(x7 != null)//DOUBLE
		{			
			code.println("\t{Data njs_temp_data(new double, DOUBLE); *(double*)njs_temp_data.data = " + x7 + "; _STACK(" + getLocalStackName(x1) + ")->push(njs_temp_data);}");
		}
		else if(x8 != null)//TEXT
		{
			code.println("\t{Data njs_temp_data(new string, TEXT); *(string*)njs_temp_data.data = " + x8 + "; _STACK(" + getLocalStackName(x1) + ")->push(njs_temp_data);}");
		}
		else if(x9 != null)//INTEGER
		{
			code.println("\t{Data njs_temp_data(new int, INTEGER); *(int*)njs_temp_data.data = " + x9 + "; _STACK(" + getLocalStackName(x1) + ")->push(njs_temp_data);}");
		}
		else if(x10 != null)//IF
		{
			code.println("\t{Data njs_temp_data(NULL, IF); _STACK(" + getLocalStackName(x1) + ")->push(njs_temp_data);}");
		}
		else if(x11 != null)
		{
			code.println("\t{Data njs_temp_data(NULL, THEN); _STACK(" + getLocalStackName(x1) + ")->push(njs_temp_data);}");
		}
		else
		{
			code.println("\t{Data njs_temp_data(NULL, ELSE); _STACK(" + getLocalStackName(x1) + ")->push(njs_temp_data);}");
		}
	}
	else //THIS
	{
		if(x3 != null) //IDENTIFIER
		{
			if(symbolTable.contains(x3+"@"+scope))
			{	
				pushCode("this_", getLocalStackName(x3));				
			}
			else if(symbolTable.contains("@"+x3)) //FUNCTION
			{
				code.println("\t{Data njs_temp_data(&njs_sp_"+ x3 + ",SP); this_.push(njs_temp_data);}");
			}
			else
			{
				System.err.println("ERROR: Stack \""+ x3 + "\" does not exist in stack processor \"" + scope + "\"");
			}
		}
		else if(x4 != null) //THIS
		{
			pushCode("this_", "this_");			
		}
		else if(x5 != null) //REF
		{
			if(x50 != null)
			{
				if(symbolTable.contains(x50+"@"+scope))
				{
					code.println("\t{Data njs_temp_data(new stack<Data>(*_STACK("+getLocalStackName(x50)+")), STACK); this_.push(njs_temp_data);}");
				}
				else
				{
					System.err.println("ERROR: Stack \""+ x50 + "\" does not exist in stack processor \"" + scope + "\"");
				}
			}
			else
			{
				code.println("\t{Data njs_temp_data(new stack<Data>(this_), STACK); this_.push(njs_temp_data);}");
			}
			
		}
		else if(x6 != null) //SIZE
		{
			if(x60 != null)
			{
				if(symbolTable.contains(x60+"@"+scope))
				{
					code.println("\t{Data njs_temp_data(new int, INTEGER); *(int*)njs_temp_data.data = (int)_STACK("+ getLocalStackName(x60) + ")->size(); this_.push(njs_temp_data);}");
				}
				else
				{
					System.err.println("ERROR: Stack \""+ x60 + "\" does not exist in stack processor \"" + scope + "\"");
				}
			}
			else
			{
				code.println("\t{Data njs_temp_data(new int, INTEGER); *(int*)njs_temp_data.data = (int)this_.size(); this_.push(njs_temp_data);}");
			}			
		}
		else if(x7 != null)//DOUBLE
		{
			code.println("\t{Data njs_temp_data(new double, DOUBLE); *(double*)njs_temp_data.data = " + x7 + "; this_.push(njs_temp_data);}");
		}
		else if(x8 != null)//TEXT
		{
			code.println("\t{Data njs_temp_data(new string, TEXT); *(string*)njs_temp_data.data = " + x8 + "; this_.push(njs_temp_data);}");
		}
		else if(x9 != null)
		{
			code.println("\t{Data njs_temp_data(new int, INTEGER); *(int*)njs_temp_data.data = " + x9 + "; this_.push(njs_temp_data);}");
		}
		else if(x10 != null)//IF
		{
			code.println("\t{Data njs_temp_data(NULL, IF); this_.push(njs_temp_data);}");
		}
		else if(x11 != null)
		{
			code.println("\t{Data njs_temp_data(NULL, THEN); this_.push(njs_temp_data);}");
		}
		else
		{
			code.println("\t{Data njs_temp_data(NULL, ELSE); this_.push(njs_temp_data);}");
		}
	}
};


