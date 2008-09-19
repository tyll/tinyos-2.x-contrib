import java.io.*;

import antlr.*;

import antlr.debug.misc.*;
import antlr.collections.*;

public class TempTest
{
    public static void main(String[] args)
    {
        for (int i=0; i<args.length; i++)
        {
        try
            {
	   
            String programName = args[i];
	    String str;
            String originalSource = "";
            DataInputStream dis = null;
	    String s = "/opt/tinyos-2.x/apps/timeTossim/cgram/examples/check_time3.c";
	    BufferedReader reader = new BufferedReader(new FileReader(s));
	    //System.out.println("typedef long long int sim_time_t;"); 
	    System.out.println("int check_time(long long int avr_time);");
	    
            if (programName.equals("-")) {
                dis = new DataInputStream( System.in );
            }   
            else {
                dis = new DataInputStream(new FileInputStream(programName));
            }
            GnuCLexer lexer =
                new GnuCLexer ( dis );
            lexer.setTokenObjectClass("CToken");
            lexer.initialize();
            // Parse the input expression.
            GnuCParser parser = new GnuCParser ( lexer );
            
            // set AST node type to TNode or get nasty cast class errors
            parser.setASTNodeType(TNode.class.getName());
            TNode.setTokenVocabulary("GNUCTokenTypes");

            // invoke parser
            try {
                parser.translationUnit();
            }
            catch (RecognitionException e) {
                System.err.println("Fatal IO error:\n"+e);
                System.exit(1);
            }
            catch (TokenStreamException e) {
                System.err.println("Fatal IO error:\n"+e);
                System.exit(1);
            }
	
	    	TNode superNode = new TNode();
		AST ast = parser.getAST();
        	superNode.addChild(((TNode)ast).deepCopyWithRightSiblings());
        
        	ASTFrame inputFrame = new ASTFrame("hello", superNode);
        	inputFrame.setVisible(true);
	
            // Garbage collection hint
            System.gc();

//          System.out.println("AST:" + parser.getAST());
//          TNode.printTree(parser.getAST());
    
            // run through the treeParser, doesn't do anything 
            // but verify that the grammar is ok
            GnuCTreeParser treeParser = new GnuCTreeParser();
            
            // set AST node type to TNode or get nasty cast class errors
            treeParser.setASTNodeType(TNode.class.getName());

            // walk that tree (it doesn't build a new tree -- 
            // it would just be a copy if it did)
            treeParser.translationUnit( parser.getAST() );

//          System.out.println(treeParser.getAST().toStringList());
            // Garbage collection hint
            System.gc();

            GnuCEmitter e = new GnuCEmitter(lexer.getPreprocessorInfoChannel());
			e.asmP = new AsmParser("asm.txt");
			e.asmP.parse();
            // set AST node type to TNode or get nasty cast class errors
            e.setASTNodeType(TNode.class.getName());

            // walk that tree
			
			AST ast1 = parser.getAST();
			((TNode)ast1).doubleLink();
			e.translationUnit( ast1 );
            //e.translationUnit( parser.getAST() );

            // Garbage collection hint
	    //while((str = reader.readLine()) != null)
	    //{
		//System.out.println(str);
            //}
            System.gc();
		
            }
        catch ( Exception e )
            {
            System.err.println ( "exception: " + e);
            e.printStackTrace();
            }
        }
	
    }
}

        

