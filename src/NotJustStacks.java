import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.InputStream;
import java.io.PrintWriter;

import antlr.RecognitionException;
import antlr.TokenStreamException;
import antlr.collections.AST;
//import antlr.debug.misc.ASTFrame;


public class NotJustStacks {
	
	public static String cppFile = "njstemp.cpp";	
	public static String hFile = "njstemp.h";
	public static String linkInfoFile = "njslink.txt";

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		if(args.length == 2 && args[0].equals("-exe") )
		{
			NotJustStacksWalker.isExe = true;
		}
		else if(args.length == 3 && args[0].equals("-lib"))
		{			
			NotJustStacksWalker.isExe = false;
			NotJustStacksWalker.libname = args[2].toUpperCase();
			hFile = args[2]+".h";
		}
		else
		{
			System.err.println("USAGE: njsc -exe filename.njs filename.exe OR njsc -lib filename.njs libraryname");		
			return;
		}		
		if(!new File(args[1]).exists())
		{
			System.err.println("The input file does not exist.");		
			return;
		}
		InputStream in = null;
		try {
			in = new FileInputStream(args[1]);
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} 
		NotJustStacksLexer lexer = new NotJustStacksLexer(in);
		NotJustStacksParser parser = new NotJustStacksParser(lexer);
		try {
			parser.program();
		} catch (RecognitionException | TokenStreamException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		NotJustStacksWalker.Symbol s = new NotJustStacksWalker.Symbol("", "sp", NotJustStacksWalker.libname, "main");
		if(NotJustStacksWalker.isExe && !NotJustStacksWalker.symbolTable.containsKey(s.toString()))
		{
			System.err.println("ERROR: Stack processor \"main\" is missing.");
			return;
		}
		AST tree = parser.getAST();		
		try {
			NotJustStacksWalker.code = new PrintWriter(cppFile);
			NotJustStacksWalker.headerCode = new PrintWriter(hFile);
			NotJustStacksWalker.linkInfo = new PrintWriter(linkInfoFile);
		} catch (FileNotFoundException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		NotJustStacksWalker walker = new NotJustStacksWalker();			
		try {
			walker.program(tree);			
		} catch (RecognitionException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		NotJustStacksWalker.code.close();
		NotJustStacksWalker.headerCode.close();
		NotJustStacksWalker.linkInfo.close();
		//ASTFrame frame = new ASTFrame("Not Just Stacks", tree);
		//frame.setVisible(true);		
	}
}
