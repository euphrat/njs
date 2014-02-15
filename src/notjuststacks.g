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
	INCLUDE = "include";
	THIS = "this";
	NULL = "null";
	RETURN = "return";
	TYPEOF = "typeof";
	SPECIALSTACK = "ss";
	OPERATOR = "op";
	INIT = "init";
	PROGRAM;
	DEFINITION_LIST;	
	INCLUDE_LIST;	
	FUNCTION_DEFINITION;
	MEMBER_FUNCTION_LIST;
	MEMBER_FUNCTION_DEFINITION;
	MEMBER_VAR_LIST;
	SS_DEFINITION;
	STATEMENT;
	CPPINCLUDE;	
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
COPY: ":=";
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
DOLLAR: "$";
COMMA: ",";
COL: ":";
DOT: ".";
USE: "^";


TEXT:
  QUOTE (options {greedy=false;}:.)* QUOTE {};
  
CPPCODE:
  CPP! (options {greedy=false;}:.)* CPP! {};

IDENTIFIER options {testLiterals=true;}: 	
		LETTER(LETTER |'_' | DIGIT)*   
		;

NSFUNCID:
	DOLLAR! IDENTIFIER DOT IDENTIFIER;

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

program: (include_list)(definition_list)
{
	#program = #([PROGRAM,"PROGRAM"],#program);
};

include_list: (include_item)*
{
	#include_list = #([INCLUDE_LIST,"INCLUDE_LIST"],#include_list);
};

include_item: (INCLUDE^ TEXT (AT! TEXT)? (COL! IDENTIFIER));

definition_list: (function_definition | ss_definition)*
{
	#definition_list = #([DEFINITION_LIST,"DEFINITION_LIST"],#definition_list);
};

function_definition: (FUNC! x:IDENTIFIER^
{	
	NotJustStacksWalker.Symbol functionEntry = new NotJustStacksWalker.Symbol("", "sp", "", NotJustStacksWalker.libname, x.getText());
	if(NotJustStacksWalker.symbolTable.containsKey(functionEntry.toString()))
	{
		System.err.println("ERROR: Stack processor \""+ x.getText() + "\" has already been defined.");
	}
	else
	{
		NotJustStacksWalker.symbolTable.put(functionEntry.toString(), functionEntry);
	}
} 
((statement SEMI!)* | (cppinclude)* CPPCODE)  END!)
{
	#function_definition = #([FUNCTION_DEFINITION,"FUNCTION_DEFINITION"],#function_definition);	
};

ss_definition: (SPECIALSTACK! x:IDENTIFIER^
{	
	NotJustStacksWalker.Symbol ssEntry = new NotJustStacksWalker.Symbol("", "ss", "", NotJustStacksWalker.libname, x.getText());
	if(NotJustStacksWalker.symbolTable.containsKey(ssEntry.toString()))
	{
		System.err.println("ERROR: Specialized stack type \""+ x.getText() + "\" has already been defined.");
	}
	else
	{
		NotJustStacksWalker.symbolTable.put(ssEntry.toString(), ssEntry);
	}
} 
(member_variable_list)(member_func_list)  END!)
{
	#ss_definition = #([SS_DEFINITION,"SS_DEFINITION"],#ss_definition);	
};

member_variable_list: (newstack SEMI!)* //TODO burada member variablelari symbolTable'a ekleyecegiz ve daha sonra bunlari code generation da kullanacagiz!
{
	#member_variable_list = #([MEMBER_VAR_LIST,"MEMBER_VAR_LIST"],#member_variable_list);
};

member_func_list: ((init_func_definition)? (push_func_definition) (pop_func_definition) (size_func_definition))
{
	#member_func_list = #([MEMBER_FUNCTION_LIST,"MEMBER_FUNCTION_LIST"],#member_func_list);
};

init_func_definition: (
INIT^ ((statement_ss SEMI!)* | (cppinclude)* CPPCODE)  END!
);

push_func_definition: (
OPERATOR! PUSH^  ((statement_ss SEMI!)* | (cppinclude)* CPPCODE)  END!
);

pop_func_definition: (
OPERATOR! POP^  ((statement_ss SEMI!)* | (cppinclude)* CPPCODE)  END!
);

size_func_definition: (
OPERATOR! SIZE^  ((statement_ss SEMI!)* | (cppinclude)* CPPCODE)  END!
);

cppinclude:
(
	LPAR! TEXT (COMMA! TEXT)? RPAR!
)
{
	#cppinclude = #([CPPINCLUDE,"CPPINCLUDE"],#cppinclude);	
};

statement: 
(
EVAL^ evalarg |
popleft POP^ (popright)+ |
pushleft PUSH^ (pushright)+ |
assignleft ASSIGN^ assignright |
assignleft COPY^ assignright |
newstack
);

statement_ss:
(
	statement | USE^ evalarg
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
	(REF^ | SIZE^)? pushleft | INTEGER | DOUBLE | TEXT | IF | THEN | ELSE | RETURN | TYPEOF | NSFUNCID
);

assignleft:
(
	evalarg
);

assignright:
(
	pushleft
);

newstack: 
(
	evalarg
);


{
import java.io.PrintWriter;	
import java.io.File;
import java.io.FileReader;
import java.io.BufferedReader;
import java.util.concurrent.ConcurrentSkipListSet;
import java.util.concurrent.ConcurrentSkipListMap;
import java.util.NavigableSet;
}

class NotJustStacksWalker extends TreeParser;


options {
 	buildAST=true;		
	k=1;
}

{	
	static class Symbol
	{
		public String scope;
		public String entryType;
		public String varType;
		public String namespace;
		public String name;
		
		// Symbol Table key format: entryType@varType@scope@namespace::name
		public Symbol(String scope, String entryType, String varType, String namespace, String name)
		{
			this.scope = scope;
			this.entryType = entryType;
			this.varType = varType;
			this.namespace = namespace;
			this.name = name;
		}
		
		public String toString()
		{
			String ns = namespace;
			if(!namespace.equals(""))
			{
				ns += "::";
			}
			return entryType+"@"+varType+"@"+scope+"@"+ns+name;
		}	
	}
	
	
	public static PrintWriter code = null;
	public static PrintWriter headerCode = null;
	public static PrintWriter linkInfo = null;
	private String scope = null;
	public static ConcurrentSkipListMap<String,Symbol> symbolTable = new ConcurrentSkipListMap<String,Symbol>();
	public static boolean isExe = true;
	public static String libname = "EXE";
	private static ConcurrentSkipListMap<String,String> namespaceMap = new ConcurrentSkipListMap<String,String>();
	
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
			   if(line.startsWith("//"))
			   {
			   		String functionName = line.substring(2,line.length());			   					   		
			   		Symbol functionEntry = new Symbol("", "sp", "", "", functionName);			   		
			   		if(symbolTable.containsKey(functionEntry.toString()))
			   		{
			   			System.err.println("ERROR: Stack processor \""+ functionName + "\" has already been defined.");
			   		}
			   		else
			   		{
			   			symbolTable.put(functionEntry.toString(), functionEntry);
			   		}
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
			code.println("\t{bool eval_status = njs_private_func_eval(this_); if(!eval_status) return;}");
		}
		else
		{
			code.println("\t{bool eval_status = njs_private_func_eval("+name+"); if(!eval_status) return;}");	
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
				code.println("\tif(!_STACK("+src+")->empty()){Data njs_temp_data = _STACK("+ src +")->top(); _STACK("+ src +")->pop(); _STACK(this_)->push(njs_temp_data);}");
			}
		}
		else
		{
			if(src.equals("this_"))
			{
				code.println("\tif(!_STACK(this_)->empty()){Data njs_temp_data = _STACK(this_)->top(); _STACK(this_)->pop(); _STACK(" + dst + ")->push(njs_temp_data);}");
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
				code.println("\tif(!_STACK(this_)->empty()){Data njs_temp_data = _STACK(this_)->top(); _STACK(this_)->push(njs_temp_data);}");
			}
			else
			{
				code.println("\tif(!_STACK("+src+")->empty()){Data njs_temp_data = _STACK("+ src +")->top(); _STACK(this_)->push(njs_temp_data);}");
			}
		}
		else
		{
			if(src.equals("this_"))
			{
				code.println("\tif(!_STACK(this_)->empty()){Data njs_temp_data = _STACK(this_)->top(); _STACK(" + dst + ")->push(njs_temp_data);}");
			}
			else
			{
				code.println("\tif(!_STACK("+src+")->empty()){Data njs_temp_data = _STACK("+ src +")->top(); _STACK(" + dst + ")->push(njs_temp_data);}");
			}
		}	
		
		
	}
	
	private void clearStackCode(String name)
	{		
		if(name.equals("this_"))
		{
			code.println("\t*_STACK(this_) = Stack();");
		}
		else
		{
			code.println("\t*_STACK("+ name + ") = Stack();");
		}
	}
	
	private void deepCopyCode(String dst, String src)
	{		
		if(dst.equals("this_"))
		{
			if(!src.equals("this_"))
			{
				code.println("\tnjs_private_func_deepCopy("+src+",this_);");
			}
		}
		else
		{
			if(src.equals("this_"))
			{
				code.println("\tnjs_private_func_deepCopy(this_ ,"+dst+");");
			}
			else
			{
				code.println("\tnjs_private_func_deepCopy("+src+","+dst+");");
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
				code.println("\t_STACK(this_)->operator=(" +src+ ");");
			}
		}
		else
		{
			if(src.equals("this_"))
			{
				code.println("\t_STACK("+dst+")->operator=(this_);");
			}
			else
			{
				code.println("\t_STACK("+dst+")->operator=(" +src+ ");");
			}
		}		
	}
	
	private void createVariableCode(String name)
	{
		code.println("\tData " + name + "(new Stack, STACK);");
	}
}

program:
{
	if(!isExe)
	{		
		NavigableSet<String> navSet = symbolTable.navigableKeySet();
		String[] symbols = navSet.toArray(new String[0]);
		for(int i = 0; i < symbols.length; i++)
		{
			if(symbols[i].startsWith("sp@"))
			{
				headerCode.println("//"+ symbols[i].substring(5));	
			}	
		}
	}	
	
	headerCode.println("#ifndef " + libname + "_NJS_HEADER");
	headerCode.println("#define " + libname + "_NJS_HEADER");
	headerCode.println("#include<stack>");
	headerCode.println("#include\"njs.h\"");	
	headerCode.println("namespace " + libname + "{");
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
#(PROGRAM include_list definition_list)
{
	code.println("}");
	if(isExe)
	{
		code.println("int main(int argc, char* argv[]){Data mainStack(new Stack, STACK); for(int i = 1; i < argc; i++) {Data d(new string(argv[i]), TEXT); _STACK(mainStack)->push(d);}"+ libname + "::njs_sp_main(mainStack);");	
		code.println("#ifdef _WIN32");
		code.println("cout << \"Press enter to continue...\" << endl; getchar();");
		code.println("#endif _WIN32");
		code.println("return 0;}");
	}	
	
	NavigableSet<String> navSet = symbolTable.navigableKeySet();
	String[] symbols = navSet.toArray(new String[0]);	
	for(int i = 0; i < symbols.length; i++)
	{		
		String spKeyPrefix = "sp@@@"+libname+"::";	
		String ssKeyPrefix = "ss@@@"+libname+"::";	
		if(symbols[i].startsWith(spKeyPrefix))
		{			
			String temp = symbols[i].replace(spKeyPrefix, "");
			headerCode.println(libname + "_NJS_API void njs_sp_"+ temp + "(Data&);");	
		}				
		else if(symbols[i].startsWith(ssKeyPrefix))
		{			
			String temp = symbols[i].replace(ssKeyPrefix, "");
			headerCode.println("class "+ libname + "_NJS_API njs_ss_"+ temp + " : public StackInterface{");
			headerCode.println("public:");
			headerCode.println("\tvirtual ~Stack();");
			headerCode.println("\tvirtual void push(const Data& it);");
			headerCode.println("\tvirtual void pop();");
			headerCode.println("\tvirtual Data& top();");
			headerCode.println("\tvirtual bool empty();");
			headerCode.println("\tvirtual size_t size();");
			headerCode.println("\tvirtual void operator=(const Data& that);");
			headerCode.println("};");	
		}
	}
	headerCode.println("}");
	headerCode.println("using namespace std;");
	headerCode.println("#endif");
};


include_list:
#(INCLUDE_LIST (x:INCLUDE
{	
	int numTexts = x.getNumberOfChildren();
	AST firstChild = x.getFirstChild();
	String libraryName = firstChild.getText();
	libraryName = libraryName.substring(1, libraryName.length()-1);
	String headerFileName = libraryName + ".h";
	String libraryDir = null;		
	if(numTexts == 1) // just header file
	{
		libraryDir = System.getenv("NJS_HOME") + "/njslib/";			
	}
	else if(numTexts == 2)
	{
		AST child = firstChild.getNextSibling();
		String temp = child.getText();
		if(child.getType() == TEXT)
		{
			libraryDir = temp.substring(1, temp.length()-1);
		}
		else
		{
			namespaceMap.put(temp, libraryName.toUpperCase());
			libraryDir = System.getenv("NJS_HOME") + "/njslib/";	
		}
	}
	else
	{
		AST temp = firstChild.getNextSibling();
		String temp1 = temp.getText();
		String temp2 = temp.getNextSibling().getText();
		libraryDir = temp1.substring(1, temp1.length()-1);
		namespaceMap.put(temp2, libraryName.toUpperCase());
	}
	String headerFullPath = libraryDir + "/" + headerFileName;		
	if(new File(headerFullPath).exists())
	{
		code.println("#include \""+ headerFileName + "\"");
		linkInfo.print(" -L" + libraryDir +" -l" + libraryName + " -I" + libraryDir);
		updateSymbolTable(headerFullPath);
	}
	else
	{
		System.err.println("ERROR: Library "+ libraryName + " cannot be found.");
	}	
}
)*)
{
code.println("namespace " + libname + "{");
};

definition_list:
#(DEFINITION_LIST (funcdef | ssdef)*);

statement: (eval | pop | push | pop | newstack | clearthis | assign | deepcopy);

funcdef:
#(FUNCTION_DEFINITION func);

ssdef:
#(SS_DEFINITION ss);

ss:
#(IDENTIFIER mvlist mflist);

mvlist:
#(MEMBER_VAR_LIST (newstack)*);

mflist:
#(MEMBER_FUNCTION_LIST (initdef)? (pushdef) (popdef) (sizedef));

initdef:
#(INIT ((statement)* use| cppcode));

pushdef:
#(PUSH ((statement)* use| cppcode));

popdef:
#(POP ((statement)* use | cppcode));

sizedef:
#(SIZE ((statement)* use | cppcode));

use:
#(USE (IDENTIFIER | THIS));

func:
#(IDENTIFIER {
	code.println("void njs_sp_" + #IDENTIFIER + "(Data& this_){");	
	scope = #IDENTIFIER.getText();	
} ((statement)* | cppcode))
{
	code.println("}");
	scope = null;
}
;

newstack:
x:IDENTIFIER
{	
	Symbol s = new Symbol(scope, "var", "Stack", libname, x.getText());
	if(!symbolTable.containsKey(s.toString()))
	{
		symbolTable.put(s.toString(), s);
		createVariableCode(getLocalStackName(x));		
	}
	else
	{
		clearStackCode(getLocalStackName(x));		
	}
};

clearthis:
x:THIS
{	
	clearStackCode("this_");	
};

cppcode:
((y:CPPINCLUDE {			
			AST includeFileTree = y.getFirstChild();
			String includeFile = includeFileTree.getText();
			headerCode.println("}");
			headerCode.println("#include"+includeFile);
			headerCode.println("namespace " + libname + "{");			
			if(y.getNumberOfChildren() > 1)
			{
				AST libraryTree = includeFileTree.getNextSibling();
				String libraryName = libraryTree.getText();
				libraryName = libraryName.substring(1, libraryName.length()-1);
				linkInfo.print(" -l"+libraryName);
			}			
	       })* 
x:CPPCODE)
{
	code.println(x);
};

assign:
#(ASSIGN (x1:IDENTIFIER | x2:THIS) (x3:IDENTIFIER | x4:THIS))
{
	if(x1 != null)
	{			
		Symbol s1 = new Symbol(scope, "var", "Stack", libname, x1.getText());	
		if(!symbolTable.containsKey(s1.toString()))
		{
			symbolTable.put(s1.toString(), s1);
			createVariableCode(getLocalStackName(x1));			
		}		
		if(x3 != null)
		{
			Symbol s3 = new Symbol(scope, "var", "Stack", libname, x3.getText());
			if(symbolTable.containsKey(s3.toString()))
			{
				if(!x1.getText().equals(x3.getText()))
				{								
					shallowCopyCode(getLocalStackName(x1), getLocalStackName(x3));
				}
			}			
			else
			{
				System.err.println("ERROR: Stack \""+ x3 + "\" does not exist in stack processor \"" + scope + "\"");
			}	
		}
		else if(x4 != null)
		{			
			shallowCopyCode(getLocalStackName(x1), "this_");
		}		
	}
	else
	{		
		if(x3 != null)
		{
			Symbol s3 = new Symbol(scope, "var", "Stack", libname, x3.getText());
			if(symbolTable.containsKey(s3.toString()))
			{								
				shallowCopyCode("this_", getLocalStackName(x3));
			}			
			else
			{
				System.err.println("ERROR: Stack \""+ x3 + "\" does not exist in stack processor \"" + scope + "\"");
			}	
		}		
	}
};

deepcopy:
#(COPY (x1:IDENTIFIER | x2:THIS) (x3:IDENTIFIER | x4:THIS))
{
	if(x1 != null)
	{
		boolean exists = true;	
		Symbol s1 = new Symbol(scope, "var", "Stack", libname, x1.getText());	
		if(!symbolTable.containsKey(s1.toString()))
		{
			symbolTable.put(s1.toString(), s1);
			createVariableCode(getLocalStackName(x1));	
			exists = false;		
		}		
		if(x3 != null)
		{
			Symbol s3 = new Symbol(scope, "var", "Stack", libname, x3.getText());
			if(symbolTable.containsKey(s3.toString()))
			{								
				if(!x1.getText().equals(x3.getText()))
				{
					if(exists)
					{
						clearStackCode(getLocalStackName(x1));	
					}
					deepCopyCode(getLocalStackName(x1), getLocalStackName(x3));
				}
			}			
			else
			{
				System.err.println("ERROR: Stack \""+ x3 + "\" does not exist in stack processor \"" + scope + "\"");
			}	
		}
		else if(x4 != null)
		{	
			if(exists)
			{
				clearStackCode(getLocalStackName(x1));	
			}		
			deepCopyCode(getLocalStackName(x1), "this_");
		}		
	}
	else
	{		
		if(x3 != null)
		{
			Symbol s3 = new Symbol(scope, "var", "Stack", libname, x3.getText());
			if(symbolTable.containsKey(s3.toString()))
			{								
				deepCopyCode("this_", getLocalStackName(x3));
			}			
			else
			{
				System.err.println("ERROR: Stack \""+ x3 + "\" does not exist in stack processor \"" + scope + "\"");
			}	
		}		
	}
};

eval:
#(EVAL (x1:IDENTIFIER | x2:THIS))
{
	if(x1 != null)
	{
		Symbol s1 = new Symbol(scope, "var", "Stack", libname, x1.getText());
		if(symbolTable.containsKey(s1.toString()))
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
#(POP (x1:IDENTIFIER | x2:THIS) ((x3:IDENTIFIER | x4:THIS | x5:NULL | #(x6:REF x60:IDENTIFIER))
{
	if(x1 != null) //IDENTIFIER
	{
		Symbol s1 = new Symbol(scope, "var", "Stack", libname, x1.getText());
		if(symbolTable.containsKey(s1.toString()))
		{
			if(x3 != null) // IDENTIFIER
			{
				Symbol s3 = new Symbol(scope, "var", "Stack", libname, x3.getText());
				if(!symbolTable.containsKey(s3.toString()))
				{
					symbolTable.put(s3.toString(), s3);
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
				Symbol s60 = new Symbol(scope, "var", "Stack", libname, x60.getText());
				if(!symbolTable.containsKey(s60.toString()))
				{
					symbolTable.put(s60.toString(), s60);
					createVariableCode(getLocalStackName(x60));					
				}
				code.println("\tif(!_STACK("+ getLocalStackName(x1) + ")->empty() && _STACK("+ getLocalStackName(x1) + ")->top().type == STACK){");
				shallowCopyCode(getLocalStackName(x60), "_STACK("+ getLocalStackName(x1) + ")->top()" );
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
			Symbol s3 = new Symbol(scope, "var", "Stack", libname, x3.getText());
			if(!symbolTable.containsKey(s3.toString()))
			{
				symbolTable.put(s3.toString(), s3);
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
			code.println("\tif(!_STACK(this_)->empty()){_STACK(this_)->pop();}");
		}
		else
		{
			Symbol s60 = new Symbol(scope, "var", "Stack", libname, x60.getText());
			if(!symbolTable.containsKey(s60.toString()))
			{
				symbolTable.put(s60.toString(), s60);
				createVariableCode(getLocalStackName(x60));				
			}
			code.println("\tif(!_STACK(this_)->empty() && _STACK(this_)->top().type == STACK){");
			shallowCopyCode(getLocalStackName(x60), "_STACK(this_)->top()");
			code.println("\t_STACK(this_)->pop();");
			code.println("\t}");	
		}		
	}
	x3 = x4 = x5 = x6 = x60 = null;
}
)*)
;


push:
#(PUSH (x1:IDENTIFIER | x2:THIS) ((x3:IDENTIFIER | x4:THIS | #(x5:REF (x50:IDENTIFIER | x51:THIS)) | #(x6:SIZE (x60:IDENTIFIER | x61:THIS)) | x7:DOUBLE | x8:TEXT | x9:INTEGER | x10:IF | x11:THEN | x12:ELSE | x13:RETURN | x14:TYPEOF | x15:NSFUNCID)
{
	if(x1 != null) //IDENTIFIER
	{
		Symbol s1 = new Symbol(scope, "var", "Stack", libname, x1.getText());
		if(!symbolTable.containsKey(s1.toString()))
		{
			symbolTable.put(s1.toString(), s1);			
			createVariableCode(getLocalStackName(x1));
		}
		if(x3 != null) //IDENTIFIER
		{
			Symbol s3 = new Symbol(scope, "var", "Stack", libname, x3.getText());
			Symbol s3_2 = new Symbol("", "sp", "", libname, x3.getText());
			if(symbolTable.containsKey(s3.toString()))
			{					
				pushCode(getLocalStackName(x1), getLocalStackName(x3));
			}
			else if(symbolTable.containsKey(s3_2.toString())) //FUNCTION
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
				Symbol s50 = new Symbol(scope, "var", "Stack", libname, x50.getText());
				if(symbolTable.containsKey(s50.toString()))
				{
					code.println("\t{Data njs_temp_data(new Stack(*(Stack*)_STACK(" + getLocalStackName(x50) + ")), STACK); _STACK(" + getLocalStackName(x1) + ")->push(njs_temp_data);}");
				}
				else
				{
					System.err.println("ERROR: Stack \""+ x50 + "\" does not exist in stack processor \"" + scope + "\"");
				}
			}
			else
			{
				code.println("\t{Data njs_temp_data(new Stack(*(Stack*)_STACK(this_)), STACK); _STACK(" + getLocalStackName(x1) + ")->push(njs_temp_data);}");
			}
		}
		else if(x6 != null) //SIZE
		{
			if(x60 != null)
			{
				Symbol s60 = new Symbol(scope, "var", "Stack", libname, x60.getText());
				if(symbolTable.containsKey(s60.toString()))
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
				code.println("\t{Data njs_temp_data(new int, INTEGER); *(int*)njs_temp_data.data = (int)_STACK(this_)->size(); _STACK(" + getLocalStackName(x1) + ")->push(njs_temp_data);}");
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
		else if(x12 != null)
		{
			code.println("\t{Data njs_temp_data(NULL, ELSE); _STACK(" + getLocalStackName(x1) + ")->push(njs_temp_data);}");
		}
		else if(x13 != null)
		{
			code.println("\t{Data njs_temp_data(NULL, RETURN); _STACK(" + getLocalStackName(x1) + ")->push(njs_temp_data);}");
		}
		else if(x14 != null)
		{
			code.println("\t{Data njs_temp_data(NULL, TYPEOF); _STACK(" + getLocalStackName(x1) + ")->push(njs_temp_data);}");
		}
		else
		{			
			String[] parts = x15.getText().split("\\.");			
			if(namespaceMap.containsKey(parts[0]))
			{
				String ns = namespaceMap.get(parts[0]);
				Symbol s3 = new Symbol("", "sp", "", ns, parts[1]);
				if(symbolTable.containsKey(s3.toString())) //FUNCTION
				{
					code.println("\t{Data njs_temp_data(&" + ns +"::njs_sp_"+ parts[1] + ",SP); _STACK(" + getLocalStackName(x1) + ")->push(njs_temp_data);}");
				}
				else
				{
					System.err.println("ERROR: Stack processor \""+ x15 + "\" is not defined.");
				}
			}
			else
			{
				System.err.println("ERROR: Library alias \"" + parts[0] + "\" does not exist.");
			}			
		}
	}
	else //THIS
	{
		if(x3 != null) //IDENTIFIER
		{
			Symbol s3 = new Symbol(scope, "var", "Stack", libname, x3.getText());
			Symbol s3_2 = new Symbol("", "sp", "", libname, x3.getText());
			if(symbolTable.containsKey(s3.toString()))
			{	
				pushCode("this_", getLocalStackName(x3));				
			}
			else if(symbolTable.containsKey(s3_2.toString())) //FUNCTION
			{
				code.println("\t{Data njs_temp_data(&njs_sp_"+ x3 + ",SP); _STACK(this_)->push(njs_temp_data);}");
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
				Symbol s50 = new Symbol(scope, "var", "Stack", libname, x50.getText());			
				if(symbolTable.containsKey(s50.toString()))
				{
					code.println("\t{Data njs_temp_data(new Stack(*(Stack*)_STACK("+getLocalStackName(x50)+")), STACK); _STACK(this_)->push(njs_temp_data);}");
				}
				else
				{
					System.err.println("ERROR: Stack \""+ x50 + "\" does not exist in stack processor \"" + scope + "\"");
				}
			}
			else
			{
				code.println("\t{Data njs_temp_data(new Stack(*(Stack*)_STACK(this_)), STACK); _STACK(this_)->push(njs_temp_data);}");
			}
			
		}
		else if(x6 != null) //SIZE
		{
			if(x60 != null)
			{
				Symbol s60 = new Symbol(scope, "var", "Stack", libname, x60.getText());			
				if(symbolTable.containsKey(s60.toString()))
				{
					code.println("\t{Data njs_temp_data(new int, INTEGER); *(int*)njs_temp_data.data = (int)_STACK("+ getLocalStackName(x60) + ")->size(); _STACK(this_)->push(njs_temp_data);}");
				}
				else
				{
					System.err.println("ERROR: Stack \""+ x60 + "\" does not exist in stack processor \"" + scope + "\"");
				}
			}
			else
			{
				code.println("\t{Data njs_temp_data(new int, INTEGER); *(int*)njs_temp_data.data = (int)_STACK(this_)->size(); _STACK(this_)->push(njs_temp_data);}");
			}			
		}
		else if(x7 != null)//DOUBLE
		{
			code.println("\t{Data njs_temp_data(new double, DOUBLE); *(double*)njs_temp_data.data = " + x7 + "; _STACK(this_)->push(njs_temp_data);}");
		}
		else if(x8 != null)//TEXT
		{
			code.println("\t{Data njs_temp_data(new string, TEXT); *(string*)njs_temp_data.data = " + x8 + "; _STACK(this_)->push(njs_temp_data);}");
		}
		else if(x9 != null)
		{
			code.println("\t{Data njs_temp_data(new int, INTEGER); *(int*)njs_temp_data.data = " + x9 + "; _STACK(this_)->push(njs_temp_data);}");
		}
		else if(x10 != null)//IF
		{
			code.println("\t{Data njs_temp_data(NULL, IF); _STACK(this_)->push(njs_temp_data);}");
		}
		else if(x11 != null)
		{
			code.println("\t{Data njs_temp_data(NULL, THEN); _STACK(this_)->push(njs_temp_data);}");
		}
		else if(x12 != null)
		{
			code.println("\t{Data njs_temp_data(NULL, ELSE); _STACK(this_)->push(njs_temp_data);}");
		}
		else if(x13 != null)
		{
			code.println("\t{Data njs_temp_data(NULL, RETURN); _STACK(this_)->push(njs_temp_data);}");
		}
		else if(x14 != null)
		{
			code.println("\t{Data njs_temp_data(NULL, TYPEOF); _STACK(this_)->push(njs_temp_data);}");
		}
		else
		{
			String[] parts = x15.getText().split("\\.");
			if(namespaceMap.containsKey(parts[0]))
			{
				String ns = namespaceMap.get(parts[0]);
				Symbol s3 = new Symbol("", "sp", "", ns, parts[1]);
				if(symbolTable.containsKey(s3.toString())) //FUNCTION
				{
					code.println("\t{Data njs_temp_data(&" + ns +"::njs_sp_"+ parts[1] + ",SP); _STACK(this_)->push(njs_temp_data);}");
				}
				else
				{
					System.err.println("ERROR: Stack processor \""+ x15 + "\" is not defined.");
				}
			}
			else
			{
				System.err.println("ERROR: Library alias \"" + parts[0] + "\" does not exist.");
			}	
		}
	}
	x3 = x4 = x5 = x6 = x7 = x8 = x9 = x10 = x11 = x12 = x13 = x14 = x15 = x50 = x51 = x60 = x61 = null;
}
)*)
;


