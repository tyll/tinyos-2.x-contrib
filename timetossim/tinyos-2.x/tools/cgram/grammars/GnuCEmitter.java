// $ANTLR 2.7.6 (2005-12-22): "expandedGnuCEmitter.g" -> "GnuCEmitter.java"$

import antlr.TreeParser;
import antlr.Token;
import antlr.collections.AST;
import antlr.RecognitionException;
import antlr.ANTLRException;
import antlr.NoViableAltException;
import antlr.MismatchedTokenException;
import antlr.SemanticException;
import antlr.collections.impl.BitSet;
import antlr.ASTPair;
import antlr.collections.impl.ASTArray;

import java.io.*;
import java.util.*;

import antlr.CommonAST;
import antlr.DumpASTVisitor;


public class GnuCEmitter extends antlr.TreeParser       implements GnuCEmitterTokenTypes
 {

String p2="";
String l2="";
public int dirCnt=0;
private String a;
private String func_name;
private String prevF="";
private String path;
private String path_func;
private boolean loopFlag = false;
private boolean loop2Flag = false;
private boolean loopInsideFlag = false;
private String printString ="";
private String printString2 ="";
private String line;
private String line_func;
private String lineDir;
private String previousLine="";
private String previousPath="";
private boolean check = false;
private boolean check_func = false;
private boolean x = false;
public AsmParser  asmP;
public String[] paths = new String[100];
public String[] lines = new String[100];
public boolean isFunction = false;
public String forReturn;
public String forWhile;
public Boolean returnAlert=false;
int tabs = 0;
PrintStream currentOutput = System.out;
int lineNum = 1;
String currentSource = "";
LineObject trueSourceFile;
final int lineDirectiveThreshold = Integer.MAX_VALUE;
PreprocessorInfoChannel preprocessorInfoChannel = null;
Stack sourceFiles = new Stack();

GnuCEmitter( PreprocessorInfoChannel preprocChannel )
{
        preprocessorInfoChannel = preprocChannel;
	
}

void transform(){
String p="";
String l="";
String c;
SourceFile currF;
SourceLine  currL;
currF = asmP.fList.first;
int count=0;

if(!( (previousLine.compareTo(line) == 0)  && (previousPath.compareTo(path)==0) ) || (prevF.compareTo(func_name)!=0)){
	while(currF != null)
	{
		if((currF.path.compareTo(path) == 0) || (currF.component.compareTo(path)== 0))
		{
			String ct="";
			p = currF.path;
			currL = currF.line;
			while(currL != null)
			{
				if((currL.lineNum.compareTo(line) == 0) && (currL.inFunction.compareTo(func_name)==0))
				{
					l=currL.lineNum;
					count++;
					ct= "check_time(" + currL.numOfCycles + ");" ;
					previousLine = line;
					previousPath = path;
					prevF = func_name;
				}
				currL = currL.nextLine;
			}
			if(!(count > 1))
			{
				if(count == 1){
					System.out.println("");
					//System.out.println ("printf(\"" + p + ":" + l + "\\n\");");
					System.out.print(ct);
				}
				/*
				else{
					currL = currF.line;
					while(currL != null)
					{
				if((currL.lineNum.compareTo(line) == 0) && (currL.inFunction.compareTo(func_name)==0))
					{
					previousLine = line;
					previousPath = path;
					prevF = func_name;
					System.out.println("");
					System.out.print("check_time(" + currL.numOfCycles + ");");
		
					
					}
					currL = currL.nextLine;
					}
				}
				*/
			}
			else{
				boolean b = false;
				currL = currF.line;
				while(currL != null)
				{
				if((currL.lineNum.compareTo(line) == 0) && (currL.inFunction.compareTo(func_name)==0))
				{
					p2 = path;
					l2 = line;
					if(!b){
						b = true;
						printString =  String.valueOf(currL.numOfCycles);
						System.out.println("");
						System.out.print("check_time(" + (currL.numOfCycles) + ");");
						
					}
					else{
						printString +=  "+" + String.valueOf(currL.numOfCycles);
					}
					
				}
				currL = currL.nextLine;
				}
				loopFlag = true;
			}
			break;
		}
		currF = currF.nextFile;
	}
} 

}

void parseLine(int i){
	int sIndex;
	int eIndex;
	System.out.println();
	switch(i){

	case 1:
		if((sIndex = lineDir.indexOf("\"")) != -1){
			eIndex = lineDir.indexOf("\"",sIndex+1);
			paths[dirCnt] = lineDir.substring(sIndex+1,eIndex);
			lines[dirCnt++] = lineDir.substring(2,sIndex-1);
		}
		else{
			line = lineDir.substring(6);
		}
		break;
	case 2:
		if((sIndex = lineDir.indexOf("\"")) != -1){
			eIndex = lineDir.indexOf("\"",sIndex+1);
			path = lineDir.substring(sIndex+1,eIndex);
			line = lineDir.substring(2,sIndex-1);
			transform();
		}
		else{
			line = lineDir.substring(6);
			transform();
		}
		break;
	case 3:
		if((sIndex = lineDir.indexOf("\"")) != -1){
			eIndex = lineDir.indexOf("\"",sIndex+1);
			path_func = lineDir.substring(sIndex+1,eIndex);
			line_func = lineDir.substring(2,sIndex-1);
		}
		else{
			line = lineDir.substring(6);
		}
		break;
	
	default:
		break;
	}

}

void preTransform(){
	path=path_func;
	line=line_func;
	//System.out.println("function printing");
	transform();
}


/*
	public void adjustWhile(TNode cmp_AST){
		
		TNode node = (TNode)cmp_AST.getFirstChild();

		while(node != null){
			if(node.getType()==LITERAL_while){
				TNode dir = node.getPrevSibling();
				if (dir==null) {continue;}
				if (dir.getType() == PREPROC_DIRECTIVE){
					TNode dir2 = new TNode();
					//dir.removeSelf();
					//dir.makeAlone();
					dir2.initialize(dir);
					//node.addSibling(dir2);
					TNode curr = (TNode)node.getFirstChild();
					while(curr!=null){
						if(curr.getType() == NCompoundStatement){
							//TNode temp = (TNode)curr.getFirstChild();
							//curr.removeChildren();
							//curr.addChild(dir);
							((TNode)curr.getLastChild()).addSiblingBefore(dir2);
							dir2.setLineNum(((TNode)dir2.getNextSibling()).getLineNum()-1);
							break;
						}
						curr=(TNode)curr.getNextSibling();
					}
				}
			}
			if(node.getType()==LITERAL_switch){
				TNode dir = node.getPrevSibling();
				if (dir==null) {continue;}
				if (dir.getType() == PREPROC_DIRECTIVE){
					int sIndex;
					int eIndex;
					String linedir;
					String ps;
					String ls;
					SourceFile currf;
					SourceLine  currl;
					currf = asmP.fList.first;
					linedir = dir.getText();
					if((sIndex = linedir.indexOf("\"")) != -1){
						eIndex = linedir.indexOf("\"",sIndex+1);
						ps = linedir.substring(sIndex+1,eIndex);
						ls = linedir.substring(2,sIndex-1);
						
						while(currf != null)
						{
							if((currf.path.compareTo(ps) == 0) )
							{
								currl = currf.line;
								while(currl != null){
								   if(currl.lineNum.compareTo(ls) == 0){
								       currl.numOfCycles = (currl.numOfCycles * 3) / 4;
								       break;
								   }
									currl = currl.nextLine;		
								}
								break;
							}
							currf = currf.nextFile;
						}
					}
				}
			}
			node = (TNode)node.getNextSibling();
		}
	}
*/

public void adjustWhile(TNode cmp_AST){
		
		TNode node = (TNode)cmp_AST.getFirstChild();

		while(node != null){
			if(node.getType()==LITERAL_while){
				TNode dir = node.getPrevSibling();
				if (dir==null) {node = (TNode)node.getNextSibling();continue;}
				if (dir.getType() == PREPROC_DIRECTIVE){
					TNode dir2 = new TNode();	
					TNode curr = (TNode)node.getFirstChild();
					while(curr!=null){
						if(curr.getType() == NCompoundStatement){

						   int sIndex;
					           int eIndex;
					           String linedir;
					           String ps;
						   String ls;
						   SourceFile currf;
						   SourceLine  currl;
						   currf = asmP.fList.first;
					 	   linedir = dir.getText();
						   if((sIndex = linedir.indexOf("\"")) != -1){
						     eIndex = linedir.indexOf("\"",sIndex+1);
						     ps = linedir.substring(sIndex+1,eIndex);
						     ls = linedir.substring(2,sIndex-1);
						
						     while(currf != null)
						     {
					if((currf.path.compareTo(ps) == 0) || (currf.component.compareTo(ps)== 0) )
						       {
							 currl = currf.line;
							 while(currl != null){
						  	   if(currl.lineNum.compareTo(ls) == 0){
						           TNode stmnt = new TNode();
							   TNode postFix = new TNode();
							   TNode id = new TNode();
							   TNode funcCall = new TNode();
							   TNode num= new TNode();
							   TNode par= new TNode();
							   stmnt.setType(NStatementExpr);
							   stmnt.addChild(postFix);
							   postFix.setType(NPostfixExpr);
							   postFix.addChild(id);
							   id.setType(ID);
							   id.setText("check_time");
							   id.addSibling(funcCall);
							   funcCall.setType(NFunctionCallArgs);
							   funcCall.setText("(");
							   funcCall.addChild(num);
							   num.setType(Number);
							   num.setText(Double.toString(currl.numOfCycles));
							   num.addSibling(par);
							   par.setType(RPAREN);
							   par.setText(")");
							 //stmnt.setLineNum(((TNode)curr.getLastChild()).getLineNum());
							   ((TNode)curr.getLastChild()).addSiblingBefore(stmnt);
						           break;
						         }
							   currl = currl.nextLine;		
							 }
							   break;
							 }
							   currf = currf.nextFile;
						      }
						     }

							//TNode temp = (TNode)curr.getFirstChild();
							//curr.removeChildren();
							//curr.addChild(dir);
							
						//dir2.setLineNum(((TNode)dir2.getNextSibling()).getLineNum()-1);
							//break;
						}
						curr=(TNode)curr.getNextSibling();
					}
				}
			}
			if(node.getType()==LITERAL_switch){
				
				TNode dir = node.getPrevSibling();
				if (dir==null) {continue;}
				if (dir.getType() == PREPROC_DIRECTIVE){
					
					int sIndex;
					int eIndex;
					String linedir;
					String ps;
					String ls;
					SourceFile currf;
					SourceLine  currl;
					currf = asmP.fList.first;
					linedir = dir.getText();
					if((sIndex = linedir.indexOf("\"")) != -1){
						eIndex = linedir.indexOf("\"",sIndex+1);
						ps = linedir.substring(sIndex+1,eIndex);
						ls = linedir.substring(2,sIndex-1);
						while(currf != null)
						{
					if((currf.path.compareTo(ps) == 0) || (currf.component.compareTo(ps)== 0))
							{
								
								currl = currf.line;
								while(currl != null){
								   if(currl.lineNum.compareTo(ls) == 0){
								       currl.numOfCycles = (currl.numOfCycles * 3) / 4;
								       break;
								   }
									currl = currl.nextLine;		
								}
								break;
							}
							currf = currf.nextFile;
						}
					}
				}
			}
			node = (TNode)node.getNextSibling();
		}
	}

	


public void adjustReturn(TNode cmp_AST){

	TNode node = (TNode)cmp_AST.getLastChild();
	TNode dir = node.getPrevSibling();
	if (dir==null) {return;}
	if (dir.getType() == PREPROC_DIRECTIVE){
		forReturn = dir.getText();
		returnAlert = true;
	}


    
}

public void directPrint(){

}


void initializePrinting()
{
    Vector preprocs = preprocessorInfoChannel.extractLinesPrecedingTokenNumber( new Integer(1) );
    printPreprocs(preprocs);
/*    if ( currentSource.equals("") ) {
        trueSourceFile = new LineObject(currentSource);
        currentOutput.println("# 1 \"" + currentSource + "\"\n");
        sourceFiles.push(trueSourceFile);
    } 
*/
}

void finalizePrinting() {
    // flush any leftover preprocessing instructions to the stream

    printPreprocs( 
        preprocessorInfoChannel.extractLinesPrecedingTokenNumber( 
                new Integer( preprocessorInfoChannel.getMaxTokenNumber() + 1 ) ));
    //print a newline so file ends at a new line
    currentOutput.println();
}

void printPreprocs( Vector preprocs ) 
{
    // if there was a preprocessingDirective previous to this token then
    // print a newline and the directive, line numbers handled later
    if ( preprocs.size() > 0 ) {  
        if ( trueSourceFile != null ) {
            currentOutput.println();  //make sure we're starting a new line unless this is the first line directive
        }
        lineNum++;
        Enumeration e = preprocs.elements();
        while (e.hasMoreElements())
        {
            Object o = e.nextElement();
            if ( o.getClass().getName().equals("LineObject") ) {
                LineObject l = (LineObject) o;

                // we always return to the trueSourceFile, we never enter it from another file
                // force it to be returning if in fact we aren't currently in trueSourceFile
                if (( trueSourceFile != null ) //trueSource exists
                        && ( !currentSource.equals(trueSourceFile.getSource()) ) //currently not in trueSource
                        && ( trueSourceFile.getSource().equals(l.getSource())  ) ) { //returning to trueSource
                    l.setEnteringFile( false );
                    l.setReturningToFile( true );
                }


                // print the line directive
                currentOutput.println(l);
                lineNum = l.getLine();
                currentSource = l.getSource();


                // the very first line directive always represents the true sourcefile
                if ( trueSourceFile == null ) {
                    trueSourceFile = new LineObject(currentSource);
                    sourceFiles.push(trueSourceFile);
                }

                // keep our own stack of files entered
                if ( l.getEnteringFile() ) {
                    sourceFiles.push(l);
                }

                // if returning to a file, pop the exited files off the stack
                if ( l.getReturningToFile() ) {
                    LineObject top = (LineObject) sourceFiles.peek();
                    while (( top != trueSourceFile ) && (! l.getSource().equals(top.getSource()) )) {
                        sourceFiles.pop();
                        top = (LineObject) sourceFiles.peek();
                    }
                }
            }
            else { // it was a #pragma or such
                currentOutput.println(o);
                lineNum++;
            }
        }
    }

}

void print( TNode t ) {
    int tLineNum = t.getLocalLineNum();
    if ( tLineNum == 0 ) tLineNum = lineNum;

    Vector preprocs = preprocessorInfoChannel.extractLinesPrecedingTokenNumber((Integer)t.getAttribute("tokenNumber"));
    printPreprocs(preprocs);
    
    if ( (lineNum != tLineNum) ) {
        // we know we'll be newlines or a line directive or it probably
        // is just the case that this token is on the next line
        // either way start a new line and indent it
        currentOutput.println();
        lineNum++;      
        printTabs();
    }

    if ( lineNum == tLineNum ){
        // do nothing special, we're at the right place
    }
    else {  
        int diff = tLineNum - lineNum;
        if ( lineNum < tLineNum ) {
            // print out the blank lines to bring us up to right line number
            for ( ; lineNum < tLineNum ; lineNum++ ) {
                currentOutput.println();
            }
            printTabs();
        }
        else { // just reset lineNum
            lineNum = tLineNum; 
        }
    }
    currentOutput.print( t.getText() + " " );
}


/* This was my attempt at being smart about line numbers
   It didn't work quite right but I don't know why, I didn't
   have enough test cases.  Worked ok compiling rcs and ghostscript
*/
void printAddingLineDirectives( TNode t ) {
    int tLineNum = t.getLocalLineNum();
    String tSource = (String) t.getAttribute("source");

    if ( tSource == null ) tSource = currentSource;
    if ( tLineNum == 0 ) tLineNum = lineNum;

    Vector preprocs = preprocessorInfoChannel.extractLinesPrecedingTokenNumber((Integer)t.getAttribute("tokenNumber"));
    printPreprocs(preprocs);
    
    if ( (lineNum != tLineNum) || !currentSource.equals(tSource) ) {  
        // we know we'll be newlines or a line directive or it probably
        // is just the case that this token is on the next line
        // either way start a new line and indent it
        currentOutput.println();
        lineNum++;      
        printTabs();
    }

    if ( ( lineNum == tLineNum ) && ( currentSource.equals(tSource) ) ){
        // do nothing special, we're at the right place
    }
    else if ( currentSource.equals(tSource) ) {  
        int diff = tLineNum - lineNum;
        if (diff > 0 && diff < lineDirectiveThreshold) {
            // print out the blank lines to bring us up to right line number
            for ( ; lineNum < tLineNum ; lineNum++ ) {
                currentOutput.println();
            }
        }
        else { // print line directive to get us to right line number
            // preserve flags 3 and 4 if present in current file
            if ( ! sourceFiles.empty() ) {
                LineObject l = (LineObject) sourceFiles.peek();
                StringBuffer tFlags = new StringBuffer("");
                if (l.getSystemHeader()) {
                    tFlags.append(" 3");
                }
                if (l.getTreatAsC()) {
                    tFlags.append(" 4");
                }
                currentOutput.println("# " + tLineNum + " \"" + tSource + "\"" + tFlags.toString());
                lineNum = tLineNum; 
            }
        }

        printTabs();
    }
    else { // different source
        Enumeration sources = sourceFiles.elements();
        // see if we're returning to a file we entered earlier
        boolean returningToEarlierFile = false;
        while (sources.hasMoreElements()) {
            LineObject l = (LineObject) sources.nextElement();
            if (l.getSource().equals(tSource)) {
                returningToEarlierFile = true;
                break;
            }
        }       
        if (returningToEarlierFile) {
            // pop off the files we're exiting, but never pop the trueSourceFile
            LineObject l = (LineObject) sourceFiles.peek();
            while ( ( l != trueSourceFile ) &&(! l.getSource().equals(tSource) ) ) {
                sourceFiles.pop();
                l = (LineObject) sourceFiles.peek();
            }
            
            // put in the return flag, plus others as needed
            StringBuffer tFlags = new StringBuffer(" 2");
            if (l.getSystemHeader()) {
                tFlags.append(" 3");
            }
            if (l.getTreatAsC()) {
                tFlags.append(" 4");
            }

            currentOutput.println("# " + tLineNum + " \"" + tSource + "\"" + tFlags);
            lineNum = tLineNum;
            currentSource = tSource;
            printTabs();
        }
        else {  // entering a file that wasn't in the original source
                // pretend we're entering it from top of stack
            currentOutput.println("# " + tLineNum + " \"" + tSource + "\"" + " 1");
            lineNum = tLineNum;
            currentSource = tSource;
            printTabs();
        }
    }
    currentOutput.print( t.getText() + " " );
}

/** It is not ok to print newlines from the String passed in as 
it will screw up the line number handling **/
void print( String s ) {
    currentOutput.print( s + " " );
}

void printTabs() {
    for ( int i = 0; i< tabs; i++ ) {
        currentOutput.print( "\t" );
    }
}
    
void commaSep( TNode t ) {
    print( t );
    if ( t.getNextSibling() != null ) {
        print( "," );
    }
}
    
        int traceDepth = 0;
        public void reportError(RecognitionException ex) {
          if ( ex != null)   {
           System.err.println("ANTLR Tree Parsing RecognitionException Error: " + ex.getClass().getName() + " " + ex );
                ex.printStackTrace(System.err);
          }
        }
        public void reportError(NoViableAltException ex) {
                System.err.println("ANTLR Tree Parsing NoViableAltException Error: " + ex.toString());
                TNode.printTree( ex.node );
                ex.printStackTrace(System.err);
        }
        public void reportError(MismatchedTokenException ex) {
          if ( ex != null)   {
                TNode.printTree( ex.node );
                System.err.println("ANTLR Tree Parsing MismatchedTokenException Error: " + ex );
                ex.printStackTrace(System.err);
          }
        }
        public void reportError(String s) {
                System.err.println("ANTLR Error from String: " + s);
        }
        public void reportWarning(String s) {
                System.err.println("ANTLR Warning from String: " + s);
        }
        protected void match(AST t, int ttype) throws MismatchedTokenException {
                //System.out.println("match("+ttype+"); cursor is "+t);
                super.match(t, ttype);
        }
        public void match(AST t, BitSet b) throws MismatchedTokenException {
                //System.out.println("match("+b+"); cursor is "+t);
                super.match(t, b);
        }
        protected void matchNot(AST t, int ttype) throws MismatchedTokenException {
                //System.out.println("matchNot("+ttype+"); cursor is "+t);
                super.matchNot(t, ttype);
                }
        public void traceIn(String rname, AST t) {
          traceDepth += 1;
          for (int x=0; x<traceDepth; x++) System.out.print(" ");
          super.traceIn(rname, t);   
        }
        public void traceOut(String rname, AST t) {
          for (int x=0; x<traceDepth; x++) System.out.print(" ");
          super.traceOut(rname, t);
          traceDepth -= 1;
        }



public GnuCEmitter() {
	tokenNames = _tokenNames;
}

	public final void translationUnit(AST _t) throws RecognitionException {
		
		TNode translationUnit_AST_in = (_t == ASTNULL) ? null : (TNode)_t;
		
		if ( inputState.guessing==0 ) {
			initializePrinting();
		}
		{
		if (_t==null) _t=ASTNULL;
		switch ( _t.getType()) {
		case PREPROC_DIRECTIVE:
		case LITERAL_asm:
		case SEMI:
		case NDeclaration:
		case NFunctionDef:
		case NTypeMissing:
		{
			externalList(_t);
			_t = _retTree;
			break;
		}
		case 3:
		{
			break;
		}
		default:
		{
			throw new NoViableAltException(_t);
		}
		}
		}
		if ( inputState.guessing==0 ) {
			finalizePrinting();
		}
		_retTree = _t;
	}
	
	public final void externalList(AST _t) throws RecognitionException {
		
		TNode externalList_AST_in = (_t == ASTNULL) ? null : (TNode)_t;
		
		try {      // for error handling
			{
			int _cnt5=0;
			_loop5:
			do {
				if (_t==null) _t=ASTNULL;
				if ((_tokenSet_0.member(_t.getType()))) {
					externalDef(_t);
					_t = _retTree;
				}
				else {
					if ( _cnt5>=1 ) { break _loop5; } else {throw new NoViableAltException(_t);}
				}
				
				_cnt5++;
			} while (true);
			}
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				if (_t!=null) {_t = _t.getNextSibling();}
			} else {
			  throw ex;
			}
		}
		_retTree = _t;
	}
	
	public final void externalDef(AST _t) throws RecognitionException {
		
		TNode externalDef_AST_in = (_t == ASTNULL) ? null : (TNode)_t;
		TNode p = null;
		TNode s = null;
		
		try {      // for error handling
			if (_t==null) _t=ASTNULL;
			switch ( _t.getType()) {
			case NDeclaration:
			{
				declaration(_t);
				_t = _retTree;
				break;
			}
			case NFunctionDef:
			{
				functionDef(_t);
				_t = _retTree;
				break;
			}
			case LITERAL_asm:
			{
				asm_expr(_t);
				_t = _retTree;
				break;
			}
			case PREPROC_DIRECTIVE:
			{
				p = (TNode)_t;
				match(_t,PREPROC_DIRECTIVE);
				_t = _t.getNextSibling();
				if ( inputState.guessing==0 ) {
					print(p);
				}
				break;
			}
			case NTypeMissing:
			{
				typelessDeclaration(_t);
				_t = _retTree;
				break;
			}
			case SEMI:
			{
				s = (TNode)_t;
				match(_t,SEMI);
				_t = _t.getNextSibling();
				if ( inputState.guessing==0 ) {
					print( s );
				}
				break;
			}
			default:
			{
				throw new NoViableAltException(_t);
			}
			}
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				if (_t!=null) {_t = _t.getNextSibling();}
			} else {
			  throw ex;
			}
		}
		_retTree = _t;
	}
	
	public final void declaration(AST _t) throws RecognitionException {
		
		TNode declaration_AST_in = (_t == ASTNULL) ? null : (TNode)_t;
		TNode s = null;
		
		try {      // for error handling
			AST __t13 = _t;
			TNode tmp1_AST_in = (TNode)_t;
			match(_t,NDeclaration);
			_t = _t.getFirstChild();
			declSpecifiers(_t);
			_t = _retTree;
			{
			if (_t==null) _t=ASTNULL;
			switch ( _t.getType()) {
			case NInitDecl:
			{
				initDeclList(_t);
				_t = _retTree;
				break;
			}
			case SEMI:
			{
				break;
			}
			default:
			{
				throw new NoViableAltException(_t);
			}
			}
			}
			{
			int _cnt16=0;
			_loop16:
			do {
				if (_t==null) _t=ASTNULL;
				if ((_t.getType()==SEMI)) {
					s = (TNode)_t;
					match(_t,SEMI);
					_t = _t.getNextSibling();
					if ( inputState.guessing==0 ) {
						print( s );
					}
				}
				else {
					if ( _cnt16>=1 ) { break _loop16; } else {throw new NoViableAltException(_t);}
				}
				
				_cnt16++;
			} while (true);
			}
			_t = __t13;
			_t = _t.getNextSibling();
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				if (_t!=null) {_t = _t.getNextSibling();}
			} else {
			  throw ex;
			}
		}
		_retTree = _t;
	}
	
	public final void functionDef(AST _t) throws RecognitionException {
		
		TNode functionDef_AST_in = (_t == ASTNULL) ? null : (TNode)_t;
		TNode p = null;
		TNode v = null;
		
		try {      // for error handling
			AST __t148 = _t;
			TNode tmp2_AST_in = (TNode)_t;
			match(_t,NFunctionDef);
			_t = _t.getFirstChild();
			{
			if (_t==null) _t=ASTNULL;
			switch ( _t.getType()) {
			case LITERAL_volatile:
			case LITERAL_struct:
			case LITERAL_union:
			case LITERAL_enum:
			case LITERAL_extern:
			case LITERAL_static:
			case LITERAL_const:
			case LITERAL_void:
			case LITERAL_char:
			case LITERAL_short:
			case LITERAL_int:
			case LITERAL_long:
			case LITERAL_float:
			case LITERAL_double:
			case LITERAL_signed:
			case LITERAL___builtin_va_list:
			case LITERAL_unsigned:
			case NTypedefName:
			case LITERAL_inline:
			case LITERAL___inline:
			case LITERAL_typeof:
			case LITERAL___complex:
			{
				functionDeclSpecifiers(_t);
				_t = _retTree;
				break;
			}
			case PREPROC_DIRECTIVE:
			case NDeclarator:
			{
				break;
			}
			default:
			{
				throw new NoViableAltException(_t);
			}
			}
			}
			{
			_loop151:
			do {
				if (_t==null) _t=ASTNULL;
				if ((_t.getType()==PREPROC_DIRECTIVE)) {
					p = (TNode)_t;
					match(_t,PREPROC_DIRECTIVE);
					_t = _t.getNextSibling();
					if ( inputState.guessing==0 ) {
						print(p);check=true; lineDir = p.getText(); parseLine(1);
					}
				}
				else {
					break _loop151;
				}
				
			} while (true);
			}
			declarator(_t);
			_t = _retTree;
			{
			_loop153:
			do {
				if (_t==null) _t=ASTNULL;
				switch ( _t.getType()) {
				case NDeclaration:
				{
					declaration(_t);
					_t = _retTree;
					break;
				}
				case VARARGS:
				{
					v = (TNode)_t;
					match(_t,VARARGS);
					_t = _t.getNextSibling();
					if ( inputState.guessing==0 ) {
						print( v );
					}
					break;
				}
				default:
				{
					break _loop153;
				}
				}
			} while (true);
			}
			if ( inputState.guessing==0 ) {
				isFunction = true;
			}
			compoundStatement(_t);
			_t = _retTree;
			if ( inputState.guessing==0 ) {
				returnAlert = false;
			}
			_t = __t148;
			_t = _t.getNextSibling();
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				if (_t!=null) {_t = _t.getNextSibling();}
			} else {
			  throw ex;
			}
		}
		_retTree = _t;
	}
	
	public final void asm_expr(AST _t) throws RecognitionException {
		
		TNode asm_expr_AST_in = (_t == ASTNULL) ? null : (TNode)_t;
		TNode a = null;
		TNode v = null;
		TNode lc = null;
		TNode rc = null;
		TNode s = null;
		
		try {      // for error handling
			AST __t10 = _t;
			a = _t==ASTNULL ? null :(TNode)_t;
			match(_t,LITERAL_asm);
			_t = _t.getFirstChild();
			if ( inputState.guessing==0 ) {
				print( a );
			}
			{
			if (_t==null) _t=ASTNULL;
			switch ( _t.getType()) {
			case LITERAL_volatile:
			{
				v = (TNode)_t;
				match(_t,LITERAL_volatile);
				_t = _t.getNextSibling();
				if ( inputState.guessing==0 ) {
					print( v );
				}
				break;
			}
			case LCURLY:
			{
				break;
			}
			default:
			{
				throw new NoViableAltException(_t);
			}
			}
			}
			lc = (TNode)_t;
			match(_t,LCURLY);
			_t = _t.getNextSibling();
			if ( inputState.guessing==0 ) {
				print( lc ); tabs++;
			}
			expr(_t);
			_t = _retTree;
			rc = (TNode)_t;
			match(_t,RCURLY);
			_t = _t.getNextSibling();
			if ( inputState.guessing==0 ) {
				tabs--; print( rc );
			}
			s = (TNode)_t;
			match(_t,SEMI);
			_t = _t.getNextSibling();
			if ( inputState.guessing==0 ) {
				print( s );
			}
			_t = __t10;
			_t = _t.getNextSibling();
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				if (_t!=null) {_t = _t.getNextSibling();}
			} else {
			  throw ex;
			}
		}
		_retTree = _t;
	}
	
	public final void typelessDeclaration(AST _t) throws RecognitionException {
		
		TNode typelessDeclaration_AST_in = (_t == ASTNULL) ? null : (TNode)_t;
		TNode s = null;
		
		try {      // for error handling
			AST __t8 = _t;
			TNode tmp3_AST_in = (TNode)_t;
			match(_t,NTypeMissing);
			_t = _t.getFirstChild();
			initDeclList(_t);
			_t = _retTree;
			s = (TNode)_t;
			match(_t,SEMI);
			_t = _t.getNextSibling();
			_t = __t8;
			_t = _t.getNextSibling();
			if ( inputState.guessing==0 ) {
				print( s );
			}
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				if (_t!=null) {_t = _t.getNextSibling();}
			} else {
			  throw ex;
			}
		}
		_retTree = _t;
	}
	
	public final void initDeclList(AST _t) throws RecognitionException {
		
		TNode initDeclList_AST_in = (_t == ASTNULL) ? null : (TNode)_t;
		
		try {      // for error handling
			initDecl(_t);
			_t = _retTree;
			{
			_loop90:
			do {
				if (_t==null) _t=ASTNULL;
				if ((_t.getType()==NInitDecl)) {
					if ( inputState.guessing==0 ) {
						print( "," );
					}
					initDecl(_t);
					_t = _retTree;
				}
				else {
					break _loop90;
				}
				
			} while (true);
			}
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				if (_t!=null) {_t = _t.getNextSibling();}
			} else {
			  throw ex;
			}
		}
		_retTree = _t;
	}
	
	public final void expr(AST _t) throws RecognitionException {
		
		TNode expr_AST_in = (_t == ASTNULL) ? null : (TNode)_t;
		
		try {      // for error handling
			if (_t==null) _t=ASTNULL;
			switch ( _t.getType()) {
			case ASSIGN:
			case STAR:
			case DIV_ASSIGN:
			case PLUS_ASSIGN:
			case MINUS_ASSIGN:
			case STAR_ASSIGN:
			case MOD_ASSIGN:
			case RSHIFT_ASSIGN:
			case LSHIFT_ASSIGN:
			case BAND_ASSIGN:
			case BOR_ASSIGN:
			case BXOR_ASSIGN:
			case LOR:
			case LAND:
			case BOR:
			case BXOR:
			case BAND:
			case EQUAL:
			case NOT_EQUAL:
			case LT:
			case LTE:
			case GT:
			case GTE:
			case LSHIFT:
			case RSHIFT:
			case PLUS:
			case MINUS:
			case DIV:
			case MOD:
			case NCommaExpr:
			{
				binaryExpr(_t);
				_t = _retTree;
				break;
			}
			case QUESTION:
			{
				conditionalExpr(_t);
				_t = _retTree;
				break;
			}
			case NCast:
			{
				castExpr(_t);
				_t = _retTree;
				break;
			}
			case INC:
			case DEC:
			case LITERAL_sizeof:
			case NUnaryExpr:
			case LITERAL___alignof:
			{
				unaryExpr(_t);
				_t = _retTree;
				break;
			}
			case NPostfixExpr:
			{
				postfixExpr(_t);
				_t = _retTree;
				break;
			}
			case ID:
			case CharLiteral:
			case NExpressionGroup:
			case NStringSeq:
			case Number:
			{
				primaryExpr(_t);
				_t = _retTree;
				break;
			}
			case NEmptyExpression:
			{
				emptyExpr(_t);
				_t = _retTree;
				break;
			}
			case LPAREN:
			{
				compoundStatementExpr(_t);
				_t = _retTree;
				break;
			}
			case NInitializer:
			case NLcurlyInitializer:
			{
				initializer(_t);
				_t = _retTree;
				break;
			}
			case NRangeExpr:
			{
				rangeExpr(_t);
				_t = _retTree;
				break;
			}
			case NGnuAsmExpr:
			{
				gnuAsmExpr(_t);
				_t = _retTree;
				break;
			}
			default:
			{
				throw new NoViableAltException(_t);
			}
			}
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				if (_t!=null) {_t = _t.getNextSibling();}
			} else {
			  throw ex;
			}
		}
		_retTree = _t;
	}
	
	public final void declSpecifiers(AST _t) throws RecognitionException {
		
		TNode declSpecifiers_AST_in = (_t == ASTNULL) ? null : (TNode)_t;
		
		try {      // for error handling
			{
			int _cnt19=0;
			_loop19:
			do {
				if (_t==null) _t=ASTNULL;
				switch ( _t.getType()) {
				case LITERAL_typedef:
				case LITERAL_auto:
				case LITERAL_register:
				case LITERAL_extern:
				case LITERAL_static:
				case LITERAL_inline:
				case LITERAL___inline:
				{
					storageClassSpecifier(_t);
					_t = _retTree;
					break;
				}
				case LITERAL_volatile:
				case LITERAL_const:
				{
					typeQualifier(_t);
					_t = _retTree;
					break;
				}
				case LITERAL_struct:
				case LITERAL_union:
				case LITERAL_enum:
				case LITERAL_void:
				case LITERAL_char:
				case LITERAL_short:
				case LITERAL_int:
				case LITERAL_long:
				case LITERAL_float:
				case LITERAL_double:
				case LITERAL_signed:
				case LITERAL___builtin_va_list:
				case LITERAL_unsigned:
				case NTypedefName:
				case LITERAL_typeof:
				case LITERAL___complex:
				{
					typeSpecifier(_t);
					_t = _retTree;
					break;
				}
				default:
				{
					if ( _cnt19>=1 ) { break _loop19; } else {throw new NoViableAltException(_t);}
				}
				}
				_cnt19++;
			} while (true);
			}
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				if (_t!=null) {_t = _t.getNextSibling();}
			} else {
			  throw ex;
			}
		}
		_retTree = _t;
	}
	
	public final void storageClassSpecifier(AST _t) throws RecognitionException {
		
		TNode storageClassSpecifier_AST_in = (_t == ASTNULL) ? null : (TNode)_t;
		TNode a = null;
		TNode b = null;
		TNode c = null;
		
		try {      // for error handling
			if (_t==null) _t=ASTNULL;
			switch ( _t.getType()) {
			case LITERAL_auto:
			{
				a = (TNode)_t;
				match(_t,LITERAL_auto);
				_t = _t.getNextSibling();
				if ( inputState.guessing==0 ) {
					print( a );
				}
				break;
			}
			case LITERAL_register:
			{
				b = (TNode)_t;
				match(_t,LITERAL_register);
				_t = _t.getNextSibling();
				if ( inputState.guessing==0 ) {
					print( b );
				}
				break;
			}
			case LITERAL_typedef:
			{
				c = (TNode)_t;
				match(_t,LITERAL_typedef);
				_t = _t.getNextSibling();
				if ( inputState.guessing==0 ) {
					print( c );
				}
				break;
			}
			case LITERAL_extern:
			case LITERAL_static:
			case LITERAL_inline:
			case LITERAL___inline:
			{
				functionStorageClassSpecifier(_t);
				_t = _retTree;
				break;
			}
			default:
			{
				throw new NoViableAltException(_t);
			}
			}
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				if (_t!=null) {_t = _t.getNextSibling();}
			} else {
			  throw ex;
			}
		}
		_retTree = _t;
	}
	
	public final void typeQualifier(AST _t) throws RecognitionException {
		
		TNode typeQualifier_AST_in = (_t == ASTNULL) ? null : (TNode)_t;
		TNode a = null;
		TNode b = null;
		
		try {      // for error handling
			if (_t==null) _t=ASTNULL;
			switch ( _t.getType()) {
			case LITERAL_const:
			{
				a = (TNode)_t;
				match(_t,LITERAL_const);
				_t = _t.getNextSibling();
				if ( inputState.guessing==0 ) {
					print( a );
				}
				break;
			}
			case LITERAL_volatile:
			{
				b = (TNode)_t;
				match(_t,LITERAL_volatile);
				_t = _t.getNextSibling();
				if ( inputState.guessing==0 ) {
					print( b );
				}
				break;
			}
			default:
			{
				throw new NoViableAltException(_t);
			}
			}
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				if (_t!=null) {_t = _t.getNextSibling();}
			} else {
			  throw ex;
			}
		}
		_retTree = _t;
	}
	
	public final void typeSpecifier(AST _t) throws RecognitionException {
		
		TNode typeSpecifier_AST_in = (_t == ASTNULL) ? null : (TNode)_t;
		TNode a = null;
		TNode b = null;
		TNode c = null;
		TNode d = null;
		TNode e = null;
		TNode f = null;
		TNode g = null;
		TNode h = null;
		TNode j = null;
		TNode i = null;
		TNode n = null;
		TNode lp = null;
		TNode rp = null;
		TNode p = null;
		
		try {      // for error handling
			if (_t==null) _t=ASTNULL;
			switch ( _t.getType()) {
			case LITERAL_void:
			{
				a = (TNode)_t;
				match(_t,LITERAL_void);
				_t = _t.getNextSibling();
				if ( inputState.guessing==0 ) {
					print( a );
				}
				break;
			}
			case LITERAL_char:
			{
				b = (TNode)_t;
				match(_t,LITERAL_char);
				_t = _t.getNextSibling();
				if ( inputState.guessing==0 ) {
					print( b );
				}
				break;
			}
			case LITERAL_short:
			{
				c = (TNode)_t;
				match(_t,LITERAL_short);
				_t = _t.getNextSibling();
				if ( inputState.guessing==0 ) {
					print( c );
				}
				break;
			}
			case LITERAL_int:
			{
				d = (TNode)_t;
				match(_t,LITERAL_int);
				_t = _t.getNextSibling();
				if ( inputState.guessing==0 ) {
					print( d );
				}
				break;
			}
			case LITERAL_long:
			{
				e = (TNode)_t;
				match(_t,LITERAL_long);
				_t = _t.getNextSibling();
				if ( inputState.guessing==0 ) {
					print( e );
				}
				break;
			}
			case LITERAL_float:
			{
				f = (TNode)_t;
				match(_t,LITERAL_float);
				_t = _t.getNextSibling();
				if ( inputState.guessing==0 ) {
					print( f );
				}
				break;
			}
			case LITERAL_double:
			{
				g = (TNode)_t;
				match(_t,LITERAL_double);
				_t = _t.getNextSibling();
				if ( inputState.guessing==0 ) {
					print( g );
				}
				break;
			}
			case LITERAL_signed:
			{
				h = (TNode)_t;
				match(_t,LITERAL_signed);
				_t = _t.getNextSibling();
				if ( inputState.guessing==0 ) {
					print( h );
				}
				break;
			}
			case LITERAL___builtin_va_list:
			{
				j = (TNode)_t;
				match(_t,LITERAL___builtin_va_list);
				_t = _t.getNextSibling();
				if ( inputState.guessing==0 ) {
					print( j );
				}
				break;
			}
			case LITERAL_unsigned:
			{
				i = (TNode)_t;
				match(_t,LITERAL_unsigned);
				_t = _t.getNextSibling();
				if ( inputState.guessing==0 ) {
					print( i );
				}
				break;
			}
			case LITERAL_struct:
			{
				structSpecifier(_t);
				_t = _retTree;
				{
				_loop25:
				do {
					if (_t==null) _t=ASTNULL;
					if ((_t.getType()==NAsmAttribute||_t.getType()==LITERAL___attribute)) {
						attributeDecl(_t);
						_t = _retTree;
					}
					else {
						break _loop25;
					}
					
				} while (true);
				}
				break;
			}
			case LITERAL_union:
			{
				unionSpecifier(_t);
				_t = _retTree;
				{
				_loop27:
				do {
					if (_t==null) _t=ASTNULL;
					if ((_t.getType()==NAsmAttribute||_t.getType()==LITERAL___attribute)) {
						attributeDecl(_t);
						_t = _retTree;
					}
					else {
						break _loop27;
					}
					
				} while (true);
				}
				break;
			}
			case LITERAL_enum:
			{
				enumSpecifier(_t);
				_t = _retTree;
				break;
			}
			case NTypedefName:
			{
				typedefName(_t);
				_t = _retTree;
				break;
			}
			case LITERAL_typeof:
			{
				AST __t28 = _t;
				n = _t==ASTNULL ? null :(TNode)_t;
				match(_t,LITERAL_typeof);
				_t = _t.getFirstChild();
				lp = (TNode)_t;
				match(_t,LPAREN);
				_t = _t.getNextSibling();
				if ( inputState.guessing==0 ) {
					print( n ); print( lp );
				}
				{
				if (_t==null) _t=ASTNULL;
				switch ( _t.getType()) {
				case LITERAL_volatile:
				case LITERAL_struct:
				case LITERAL_union:
				case LITERAL_enum:
				case LITERAL_const:
				case LITERAL_void:
				case LITERAL_char:
				case LITERAL_short:
				case LITERAL_int:
				case LITERAL_long:
				case LITERAL_float:
				case LITERAL_double:
				case LITERAL_signed:
				case LITERAL___builtin_va_list:
				case LITERAL_unsigned:
				case NTypedefName:
				case LITERAL_typeof:
				case LITERAL___complex:
				{
					typeName(_t);
					_t = _retTree;
					break;
				}
				case ID:
				case ASSIGN:
				case STAR:
				case LPAREN:
				case DIV_ASSIGN:
				case PLUS_ASSIGN:
				case MINUS_ASSIGN:
				case STAR_ASSIGN:
				case MOD_ASSIGN:
				case RSHIFT_ASSIGN:
				case LSHIFT_ASSIGN:
				case BAND_ASSIGN:
				case BOR_ASSIGN:
				case BXOR_ASSIGN:
				case QUESTION:
				case LOR:
				case LAND:
				case BOR:
				case BXOR:
				case BAND:
				case EQUAL:
				case NOT_EQUAL:
				case LT:
				case LTE:
				case GT:
				case GTE:
				case LSHIFT:
				case RSHIFT:
				case PLUS:
				case MINUS:
				case DIV:
				case MOD:
				case INC:
				case DEC:
				case LITERAL_sizeof:
				case CharLiteral:
				case NCast:
				case NExpressionGroup:
				case NInitializer:
				case NEmptyExpression:
				case NCommaExpr:
				case NUnaryExpr:
				case NPostfixExpr:
				case NRangeExpr:
				case NStringSeq:
				case NLcurlyInitializer:
				case NGnuAsmExpr:
				case Number:
				case LITERAL___alignof:
				{
					expr(_t);
					_t = _retTree;
					break;
				}
				default:
				{
					throw new NoViableAltException(_t);
				}
				}
				}
				rp = (TNode)_t;
				match(_t,RPAREN);
				_t = _t.getNextSibling();
				if ( inputState.guessing==0 ) {
					print( rp );
				}
				_t = __t28;
				_t = _t.getNextSibling();
				break;
			}
			case LITERAL___complex:
			{
				p = (TNode)_t;
				match(_t,LITERAL___complex);
				_t = _t.getNextSibling();
				if ( inputState.guessing==0 ) {
					print( p );
				}
				break;
			}
			default:
			{
				throw new NoViableAltException(_t);
			}
			}
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				if (_t!=null) {_t = _t.getNextSibling();}
			} else {
			  throw ex;
			}
		}
		_retTree = _t;
	}
	
	public final void functionStorageClassSpecifier(AST _t) throws RecognitionException {
		
		TNode functionStorageClassSpecifier_AST_in = (_t == ASTNULL) ? null : (TNode)_t;
		TNode a = null;
		TNode b = null;
		TNode c = null;
		TNode d = null;
		
		try {      // for error handling
			if (_t==null) _t=ASTNULL;
			switch ( _t.getType()) {
			case LITERAL_extern:
			{
				a = (TNode)_t;
				match(_t,LITERAL_extern);
				_t = _t.getNextSibling();
				if ( inputState.guessing==0 ) {
					print( a );
				}
				break;
			}
			case LITERAL_static:
			{
				b = (TNode)_t;
				match(_t,LITERAL_static);
				_t = _t.getNextSibling();
				if ( inputState.guessing==0 ) {
					print( b );
				}
				break;
			}
			case LITERAL_inline:
			{
				c = (TNode)_t;
				match(_t,LITERAL_inline);
				_t = _t.getNextSibling();
				if ( inputState.guessing==0 ) {
					print( c );
				}
				break;
			}
			case LITERAL___inline:
			{
				d = (TNode)_t;
				match(_t,LITERAL___inline);
				_t = _t.getNextSibling();
				if ( inputState.guessing==0 ) {
					print( d );
				}
				break;
			}
			default:
			{
				throw new NoViableAltException(_t);
			}
			}
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				if (_t!=null) {_t = _t.getNextSibling();}
			} else {
			  throw ex;
			}
		}
		_retTree = _t;
	}
	
	public final void structSpecifier(AST _t) throws RecognitionException {
		
		TNode structSpecifier_AST_in = (_t == ASTNULL) ? null : (TNode)_t;
		TNode a = null;
		
		try {      // for error handling
			AST __t35 = _t;
			a = _t==ASTNULL ? null :(TNode)_t;
			match(_t,LITERAL_struct);
			_t = _t.getFirstChild();
			if ( inputState.guessing==0 ) {
				print( a );
			}
			structOrUnionBody(_t);
			_t = _retTree;
			_t = __t35;
			_t = _t.getNextSibling();
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				if (_t!=null) {_t = _t.getNextSibling();}
			} else {
			  throw ex;
			}
		}
		_retTree = _t;
	}
	
	public final void attributeDecl(AST _t) throws RecognitionException {
		
		TNode attributeDecl_AST_in = (_t == ASTNULL) ? null : (TNode)_t;
		TNode a = null;
		TNode b = null;
		TNode n = null;
		TNode lp = null;
		TNode rp = null;
		
		try {      // for error handling
			if (_t==null) _t=ASTNULL;
			switch ( _t.getType()) {
			case LITERAL___attribute:
			{
				AST __t84 = _t;
				a = _t==ASTNULL ? null :(TNode)_t;
				match(_t,LITERAL___attribute);
				_t = _t.getFirstChild();
				if ( inputState.guessing==0 ) {
					print( a );
				}
				{
				_loop86:
				do {
					if (_t==null) _t=ASTNULL;
					if (((_t.getType() >= LITERAL_typedef && _t.getType() <= LITERAL___imag))) {
						b = (TNode)_t;
						if ( _t==null ) throw new MismatchedTokenException();
						_t = _t.getNextSibling();
						if ( inputState.guessing==0 ) {
							print( b );
						}
					}
					else {
						break _loop86;
					}
					
				} while (true);
				}
				_t = __t84;
				_t = _t.getNextSibling();
				break;
			}
			case NAsmAttribute:
			{
				AST __t87 = _t;
				n = _t==ASTNULL ? null :(TNode)_t;
				match(_t,NAsmAttribute);
				_t = _t.getFirstChild();
				if ( inputState.guessing==0 ) {
					print( n );
				}
				lp = (TNode)_t;
				match(_t,LPAREN);
				_t = _t.getNextSibling();
				if ( inputState.guessing==0 ) {
					print( lp );
				}
				expr(_t);
				_t = _retTree;
				if ( inputState.guessing==0 ) {
					print( ")" );
				}
				rp = (TNode)_t;
				match(_t,RPAREN);
				_t = _t.getNextSibling();
				if ( inputState.guessing==0 ) {
					print( rp );
				}
				_t = __t87;
				_t = _t.getNextSibling();
				break;
			}
			default:
			{
				throw new NoViableAltException(_t);
			}
			}
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				if (_t!=null) {_t = _t.getNextSibling();}
			} else {
			  throw ex;
			}
		}
		_retTree = _t;
	}
	
	public final void unionSpecifier(AST _t) throws RecognitionException {
		
		TNode unionSpecifier_AST_in = (_t == ASTNULL) ? null : (TNode)_t;
		TNode a = null;
		
		try {      // for error handling
			AST __t37 = _t;
			a = _t==ASTNULL ? null :(TNode)_t;
			match(_t,LITERAL_union);
			_t = _t.getFirstChild();
			if ( inputState.guessing==0 ) {
				print( a );
			}
			structOrUnionBody(_t);
			_t = _retTree;
			_t = __t37;
			_t = _t.getNextSibling();
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				if (_t!=null) {_t = _t.getNextSibling();}
			} else {
			  throw ex;
			}
		}
		_retTree = _t;
	}
	
	public final void enumSpecifier(AST _t) throws RecognitionException {
		
		TNode enumSpecifier_AST_in = (_t == ASTNULL) ? null : (TNode)_t;
		TNode a = null;
		TNode i = null;
		TNode lc = null;
		TNode p2 = null;
		TNode p3 = null;
		TNode rc = null;
		
		try {      // for error handling
			AST __t69 = _t;
			a = _t==ASTNULL ? null :(TNode)_t;
			match(_t,LITERAL_enum);
			_t = _t.getFirstChild();
			if ( inputState.guessing==0 ) {
				print( a );
			}
			{
			if (_t==null) _t=ASTNULL;
			switch ( _t.getType()) {
			case ID:
			{
				i = (TNode)_t;
				match(_t,ID);
				_t = _t.getNextSibling();
				if ( inputState.guessing==0 ) {
					print( i );
				}
				break;
			}
			case 3:
			case LCURLY:
			case NAsmAttribute:
			case LITERAL___attribute:
			{
				break;
			}
			default:
			{
				throw new NoViableAltException(_t);
			}
			}
			}
			{
			if (_t==null) _t=ASTNULL;
			switch ( _t.getType()) {
			case LCURLY:
			{
				lc = (TNode)_t;
				match(_t,LCURLY);
				_t = _t.getNextSibling();
				if ( inputState.guessing==0 ) {
					print( lc ); tabs++;
				}
				{
				_loop73:
				do {
					if (_t==null) _t=ASTNULL;
					if ((_t.getType()==PREPROC_DIRECTIVE)) {
						p2 = (TNode)_t;
						match(_t,PREPROC_DIRECTIVE);
						_t = _t.getNextSibling();
						if ( inputState.guessing==0 ) {
							print( p2 );
						}
					}
					else {
						break _loop73;
					}
					
				} while (true);
				}
				enumList(_t);
				_t = _retTree;
				{
				_loop75:
				do {
					if (_t==null) _t=ASTNULL;
					if ((_t.getType()==PREPROC_DIRECTIVE)) {
						p3 = (TNode)_t;
						match(_t,PREPROC_DIRECTIVE);
						_t = _t.getNextSibling();
						if ( inputState.guessing==0 ) {
							print( p3 );
						}
					}
					else {
						break _loop75;
					}
					
				} while (true);
				}
				rc = (TNode)_t;
				match(_t,RCURLY);
				_t = _t.getNextSibling();
				if ( inputState.guessing==0 ) {
					tabs--; print( rc );
				}
				break;
			}
			case 3:
			case NAsmAttribute:
			case LITERAL___attribute:
			{
				break;
			}
			default:
			{
				throw new NoViableAltException(_t);
			}
			}
			}
			{
			_loop77:
			do {
				if (_t==null) _t=ASTNULL;
				if ((_t.getType()==NAsmAttribute||_t.getType()==LITERAL___attribute)) {
					attributeDecl(_t);
					_t = _retTree;
				}
				else {
					break _loop77;
				}
				
			} while (true);
			}
			_t = __t69;
			_t = _t.getNextSibling();
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				if (_t!=null) {_t = _t.getNextSibling();}
			} else {
			  throw ex;
			}
		}
		_retTree = _t;
	}
	
	public final void typedefName(AST _t) throws RecognitionException {
		
		TNode typedefName_AST_in = (_t == ASTNULL) ? null : (TNode)_t;
		TNode i = null;
		
		try {      // for error handling
			AST __t33 = _t;
			TNode tmp4_AST_in = (TNode)_t;
			match(_t,NTypedefName);
			_t = _t.getFirstChild();
			i = (TNode)_t;
			match(_t,ID);
			_t = _t.getNextSibling();
			if ( inputState.guessing==0 ) {
				print( i );
			}
			_t = __t33;
			_t = _t.getNextSibling();
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				if (_t!=null) {_t = _t.getNextSibling();}
			} else {
			  throw ex;
			}
		}
		_retTree = _t;
	}
	
	public final void typeName(AST _t) throws RecognitionException {
		
		TNode typeName_AST_in = (_t == ASTNULL) ? null : (TNode)_t;
		
		try {      // for error handling
			specifierQualifierList(_t);
			_t = _retTree;
			{
			if (_t==null) _t=ASTNULL;
			switch ( _t.getType()) {
			case NNonemptyAbstractDeclarator:
			{
				nonemptyAbstractDeclarator(_t);
				_t = _retTree;
				break;
			}
			case RPAREN:
			{
				break;
			}
			default:
			{
				throw new NoViableAltException(_t);
			}
			}
			}
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				if (_t!=null) {_t = _t.getNextSibling();}
			} else {
			  throw ex;
			}
		}
		_retTree = _t;
	}
	
	public final void structOrUnionBody(AST _t) throws RecognitionException {
		
		TNode structOrUnionBody_AST_in = (_t == ASTNULL) ? null : (TNode)_t;
		TNode i1 = null;
		TNode lc1 = null;
		TNode rc1 = null;
		TNode p2 = null;
		TNode lc2 = null;
		TNode rc2 = null;
		TNode p5 = null;
		TNode i2 = null;
		
		try {      // for error handling
			{
			boolean synPredMatched41 = false;
			if (_t==null) _t=ASTNULL;
			if (((_t.getType()==ID))) {
				AST __t41 = _t;
				synPredMatched41 = true;
				inputState.guessing++;
				try {
					{
					TNode tmp5_AST_in = (TNode)_t;
					match(_t,ID);
					_t = _t.getNextSibling();
					TNode tmp6_AST_in = (TNode)_t;
					match(_t,LCURLY);
					_t = _t.getNextSibling();
					}
				}
				catch (RecognitionException pe) {
					synPredMatched41 = false;
				}
				_t = __t41;
inputState.guessing--;
			}
			if ( synPredMatched41 ) {
				i1 = (TNode)_t;
				match(_t,ID);
				_t = _t.getNextSibling();
				lc1 = (TNode)_t;
				match(_t,LCURLY);
				_t = _t.getNextSibling();
				if ( inputState.guessing==0 ) {
					print( i1 ); print ( "{" ); tabs++;
				}
				{
				if (_t==null) _t=ASTNULL;
				switch ( _t.getType()) {
				case PREPROC_DIRECTIVE:
				case LITERAL_volatile:
				case LITERAL_struct:
				case LITERAL_union:
				case LITERAL_enum:
				case LITERAL_const:
				case LITERAL_void:
				case LITERAL_char:
				case LITERAL_short:
				case LITERAL_int:
				case LITERAL_long:
				case LITERAL_float:
				case LITERAL_double:
				case LITERAL_signed:
				case LITERAL___builtin_va_list:
				case LITERAL_unsigned:
				case NTypedefName:
				case LITERAL_typeof:
				case LITERAL___complex:
				{
					structDeclarationList(_t);
					_t = _retTree;
					break;
				}
				case RCURLY:
				{
					break;
				}
				default:
				{
					throw new NoViableAltException(_t);
				}
				}
				}
				rc1 = (TNode)_t;
				match(_t,RCURLY);
				_t = _t.getNextSibling();
				if ( inputState.guessing==0 ) {
					tabs--; print( rc1 );
				}
				{
				_loop44:
				do {
					if (_t==null) _t=ASTNULL;
					if ((_t.getType()==PREPROC_DIRECTIVE)) {
						p2 = (TNode)_t;
						match(_t,PREPROC_DIRECTIVE);
						_t = _t.getNextSibling();
						if ( inputState.guessing==0 ) {
							print( p2 );
						}
					}
					else {
						break _loop44;
					}
					
				} while (true);
				}
			}
			else if ((_t.getType()==LCURLY)) {
				lc2 = (TNode)_t;
				match(_t,LCURLY);
				_t = _t.getNextSibling();
				if ( inputState.guessing==0 ) {
					print( "{" ); tabs++;
				}
				{
				if (_t==null) _t=ASTNULL;
				switch ( _t.getType()) {
				case PREPROC_DIRECTIVE:
				case LITERAL_volatile:
				case LITERAL_struct:
				case LITERAL_union:
				case LITERAL_enum:
				case LITERAL_const:
				case LITERAL_void:
				case LITERAL_char:
				case LITERAL_short:
				case LITERAL_int:
				case LITERAL_long:
				case LITERAL_float:
				case LITERAL_double:
				case LITERAL_signed:
				case LITERAL___builtin_va_list:
				case LITERAL_unsigned:
				case NTypedefName:
				case LITERAL_typeof:
				case LITERAL___complex:
				{
					structDeclarationList(_t);
					_t = _retTree;
					break;
				}
				case RCURLY:
				{
					break;
				}
				default:
				{
					throw new NoViableAltException(_t);
				}
				}
				}
				rc2 = (TNode)_t;
				match(_t,RCURLY);
				_t = _t.getNextSibling();
				if ( inputState.guessing==0 ) {
					tabs--; print( rc2 );
				}
				{
				_loop47:
				do {
					if (_t==null) _t=ASTNULL;
					if ((_t.getType()==PREPROC_DIRECTIVE)) {
						p5 = (TNode)_t;
						match(_t,PREPROC_DIRECTIVE);
						_t = _t.getNextSibling();
						if ( inputState.guessing==0 ) {
							print( p5);
						}
					}
					else {
						break _loop47;
					}
					
				} while (true);
				}
			}
			else if ((_t.getType()==ID)) {
				i2 = (TNode)_t;
				match(_t,ID);
				_t = _t.getNextSibling();
				if ( inputState.guessing==0 ) {
					print( i2 );
				}
			}
			else {
				throw new NoViableAltException(_t);
			}
			
			}
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				if (_t!=null) {_t = _t.getNextSibling();}
			} else {
			  throw ex;
			}
		}
		_retTree = _t;
	}
	
	public final void structDeclarationList(AST _t) throws RecognitionException {
		
		TNode structDeclarationList_AST_in = (_t == ASTNULL) ? null : (TNode)_t;
		TNode p2 = null;
		TNode p1 = null;
		
		try {      // for error handling
			{
			_loop50:
			do {
				if (_t==null) _t=ASTNULL;
				if ((_t.getType()==PREPROC_DIRECTIVE)) {
					p2 = (TNode)_t;
					match(_t,PREPROC_DIRECTIVE);
					_t = _t.getNextSibling();
					if ( inputState.guessing==0 ) {
						print( p2 );
					}
				}
				else {
					break _loop50;
				}
				
			} while (true);
			}
			{
			int _cnt54=0;
			_loop54:
			do {
				if (_t==null) _t=ASTNULL;
				if ((_tokenSet_1.member(_t.getType()))) {
					structDeclaration(_t);
					_t = _retTree;
					if ( inputState.guessing==0 ) {
						print( ";" );
					}
					{
					_loop53:
					do {
						if (_t==null) _t=ASTNULL;
						if ((_t.getType()==PREPROC_DIRECTIVE)) {
							p1 = (TNode)_t;
							match(_t,PREPROC_DIRECTIVE);
							_t = _t.getNextSibling();
							if ( inputState.guessing==0 ) {
								print( p1);
							}
						}
						else {
							break _loop53;
						}
						
					} while (true);
					}
				}
				else {
					if ( _cnt54>=1 ) { break _loop54; } else {throw new NoViableAltException(_t);}
				}
				
				_cnt54++;
			} while (true);
			}
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				if (_t!=null) {_t = _t.getNextSibling();}
			} else {
			  throw ex;
			}
		}
		_retTree = _t;
	}
	
	public final void structDeclaration(AST _t) throws RecognitionException {
		
		TNode structDeclaration_AST_in = (_t == ASTNULL) ? null : (TNode)_t;
		
		try {      // for error handling
			specifierQualifierList(_t);
			_t = _retTree;
			structDeclaratorList(_t);
			_t = _retTree;
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				if (_t!=null) {_t = _t.getNextSibling();}
			} else {
			  throw ex;
			}
		}
		_retTree = _t;
	}
	
	public final void specifierQualifierList(AST _t) throws RecognitionException {
		
		TNode specifierQualifierList_AST_in = (_t == ASTNULL) ? null : (TNode)_t;
		
		try {      // for error handling
			{
			int _cnt58=0;
			_loop58:
			do {
				if (_t==null) _t=ASTNULL;
				switch ( _t.getType()) {
				case LITERAL_struct:
				case LITERAL_union:
				case LITERAL_enum:
				case LITERAL_void:
				case LITERAL_char:
				case LITERAL_short:
				case LITERAL_int:
				case LITERAL_long:
				case LITERAL_float:
				case LITERAL_double:
				case LITERAL_signed:
				case LITERAL___builtin_va_list:
				case LITERAL_unsigned:
				case NTypedefName:
				case LITERAL_typeof:
				case LITERAL___complex:
				{
					typeSpecifier(_t);
					_t = _retTree;
					break;
				}
				case LITERAL_volatile:
				case LITERAL_const:
				{
					typeQualifier(_t);
					_t = _retTree;
					break;
				}
				default:
				{
					if ( _cnt58>=1 ) { break _loop58; } else {throw new NoViableAltException(_t);}
				}
				}
				_cnt58++;
			} while (true);
			}
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				if (_t!=null) {_t = _t.getNextSibling();}
			} else {
			  throw ex;
			}
		}
		_retTree = _t;
	}
	
	public final void structDeclaratorList(AST _t) throws RecognitionException {
		
		TNode structDeclaratorList_AST_in = (_t == ASTNULL) ? null : (TNode)_t;
		
		try {      // for error handling
			structDeclarator(_t);
			_t = _retTree;
			{
			_loop61:
			do {
				if (_t==null) _t=ASTNULL;
				if ((_t.getType()==NStructDeclarator)) {
					if ( inputState.guessing==0 ) {
						print(",");
					}
					structDeclarator(_t);
					_t = _retTree;
				}
				else {
					break _loop61;
				}
				
			} while (true);
			}
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				if (_t!=null) {_t = _t.getNextSibling();}
			} else {
			  throw ex;
			}
		}
		_retTree = _t;
	}
	
	public final void structDeclarator(AST _t) throws RecognitionException {
		
		TNode structDeclarator_AST_in = (_t == ASTNULL) ? null : (TNode)_t;
		TNode c = null;
		
		try {      // for error handling
			AST __t63 = _t;
			TNode tmp7_AST_in = (TNode)_t;
			match(_t,NStructDeclarator);
			_t = _t.getFirstChild();
			{
			if (_t==null) _t=ASTNULL;
			switch ( _t.getType()) {
			case NDeclarator:
			{
				declarator(_t);
				_t = _retTree;
				break;
			}
			case 3:
			case COLON:
			case NAsmAttribute:
			case LITERAL___attribute:
			{
				break;
			}
			default:
			{
				throw new NoViableAltException(_t);
			}
			}
			}
			{
			if (_t==null) _t=ASTNULL;
			switch ( _t.getType()) {
			case COLON:
			{
				c = (TNode)_t;
				match(_t,COLON);
				_t = _t.getNextSibling();
				if ( inputState.guessing==0 ) {
					print( c );
				}
				expr(_t);
				_t = _retTree;
				break;
			}
			case 3:
			case NAsmAttribute:
			case LITERAL___attribute:
			{
				break;
			}
			default:
			{
				throw new NoViableAltException(_t);
			}
			}
			}
			{
			_loop67:
			do {
				if (_t==null) _t=ASTNULL;
				if ((_t.getType()==NAsmAttribute||_t.getType()==LITERAL___attribute)) {
					attributeDecl(_t);
					_t = _retTree;
				}
				else {
					break _loop67;
				}
				
			} while (true);
			}
			_t = __t63;
			_t = _t.getNextSibling();
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				if (_t!=null) {_t = _t.getNextSibling();}
			} else {
			  throw ex;
			}
		}
		_retTree = _t;
	}
	
	public final void declarator(AST _t) throws RecognitionException {
		
		TNode declarator_AST_in = (_t == ASTNULL) ? null : (TNode)_t;
		TNode re = null;
		TNode id = null;
		TNode lp = null;
		TNode rp = null;
		TNode n = null;
		TNode r = null;
		TNode p = null;
		TNode lb = null;
		TNode p2 = null;
		TNode p1 = null;
		TNode rb = null;
		
		try {      // for error handling
			AST __t119 = _t;
			TNode tmp8_AST_in = (TNode)_t;
			match(_t,NDeclarator);
			_t = _t.getFirstChild();
			{
			if (_t==null) _t=ASTNULL;
			switch ( _t.getType()) {
			case NPointerGroup:
			{
				pointerGroup(_t);
				_t = _retTree;
				break;
			}
			case 3:
			case ID:
			case LITERAL___restrict:
			case LPAREN:
			case LBRACKET:
			case NParameterTypeList:
			case NAsmAttribute:
			case LITERAL___attribute:
			{
				break;
			}
			default:
			{
				throw new NoViableAltException(_t);
			}
			}
			}
			{
			if (_t==null) _t=ASTNULL;
			switch ( _t.getType()) {
			case LITERAL___restrict:
			{
				re = (TNode)_t;
				match(_t,LITERAL___restrict);
				_t = _t.getNextSibling();
				if ( inputState.guessing==0 ) {
					print(re);
				}
				break;
			}
			case 3:
			case ID:
			case LPAREN:
			case LBRACKET:
			case NParameterTypeList:
			case NAsmAttribute:
			case LITERAL___attribute:
			{
				break;
			}
			default:
			{
				throw new NoViableAltException(_t);
			}
			}
			}
			{
			_loop123:
			do {
				if (_t==null) _t=ASTNULL;
				if ((_t.getType()==NAsmAttribute||_t.getType()==LITERAL___attribute)) {
					attributeDecl(_t);
					_t = _retTree;
				}
				else {
					break _loop123;
				}
				
			} while (true);
			}
			{
			if (_t==null) _t=ASTNULL;
			switch ( _t.getType()) {
			case ID:
			{
				id = (TNode)_t;
				match(_t,ID);
				_t = _t.getNextSibling();
				if ( inputState.guessing==0 ) {
					print( id ); a = id.getText();
				}
				break;
			}
			case LPAREN:
			{
				lp = (TNode)_t;
				match(_t,LPAREN);
				_t = _t.getNextSibling();
				if ( inputState.guessing==0 ) {
					print( lp );
				}
				declarator(_t);
				_t = _retTree;
				rp = (TNode)_t;
				match(_t,RPAREN);
				_t = _t.getNextSibling();
				if ( inputState.guessing==0 ) {
					print( rp );
				}
				break;
			}
			case 3:
			case LBRACKET:
			case NParameterTypeList:
			{
				break;
			}
			default:
			{
				throw new NoViableAltException(_t);
			}
			}
			}
			{
			_loop136:
			do {
				if (_t==null) _t=ASTNULL;
				switch ( _t.getType()) {
				case NParameterTypeList:
				{
					AST __t126 = _t;
					n = _t==ASTNULL ? null :(TNode)_t;
					match(_t,NParameterTypeList);
					_t = _t.getFirstChild();
					if ( inputState.guessing==0 ) {
						print( n ); func_name = a; 
									if(func_name.compareTo("SimSchedulerBasicP$TaskBasic$runTask")==0)
									{func_name="SchedulerBasicP$TaskBasic$runTask";}
					}
					{
					if (_t==null) _t=ASTNULL;
					switch ( _t.getType()) {
					case PREPROC_DIRECTIVE:
					case NParameterDeclaration:
					{
						parameterTypeList(_t);
						_t = _retTree;
						break;
					}
					case ID:
					case RPAREN:
					{
						{
						if (_t==null) _t=ASTNULL;
						switch ( _t.getType()) {
						case ID:
						{
							idList(_t);
							_t = _retTree;
							break;
						}
						case RPAREN:
						{
							break;
						}
						default:
						{
							throw new NoViableAltException(_t);
						}
						}
						}
						break;
					}
					default:
					{
						throw new NoViableAltException(_t);
					}
					}
					}
					r = (TNode)_t;
					match(_t,RPAREN);
					_t = _t.getNextSibling();
					if ( inputState.guessing==0 ) {
						print( r );
					}
					{
					_loop130:
					do {
						if (_t==null) _t=ASTNULL;
						if ((_t.getType()==PREPROC_DIRECTIVE)) {
							p = (TNode)_t;
							match(_t,PREPROC_DIRECTIVE);
							_t = _t.getNextSibling();
							if ( inputState.guessing==0 ) {
								print( p );check=true; lineDir = p.getText();        									check_func=true;parseLine(3);
							}
						}
						else {
							break _loop130;
						}
						
					} while (true);
					}
					_t = __t126;
					_t = _t.getNextSibling();
					break;
				}
				case LBRACKET:
				{
					lb = (TNode)_t;
					match(_t,LBRACKET);
					_t = _t.getNextSibling();
					if ( inputState.guessing==0 ) {
						print( lb );
					}
					{
					_loop132:
					do {
						if (_t==null) _t=ASTNULL;
						if ((_t.getType()==PREPROC_DIRECTIVE)) {
							p2 = (TNode)_t;
							match(_t,PREPROC_DIRECTIVE);
							_t = _t.getNextSibling();
							if ( inputState.guessing==0 ) {
								print( p2 );lineDir = p2.getText(); 											check=true;parseLine(1);
							}
						}
						else {
							break _loop132;
						}
						
					} while (true);
					}
					{
					if (_t==null) _t=ASTNULL;
					switch ( _t.getType()) {
					case ID:
					case ASSIGN:
					case STAR:
					case LPAREN:
					case DIV_ASSIGN:
					case PLUS_ASSIGN:
					case MINUS_ASSIGN:
					case STAR_ASSIGN:
					case MOD_ASSIGN:
					case RSHIFT_ASSIGN:
					case LSHIFT_ASSIGN:
					case BAND_ASSIGN:
					case BOR_ASSIGN:
					case BXOR_ASSIGN:
					case QUESTION:
					case LOR:
					case LAND:
					case BOR:
					case BXOR:
					case BAND:
					case EQUAL:
					case NOT_EQUAL:
					case LT:
					case LTE:
					case GT:
					case GTE:
					case LSHIFT:
					case RSHIFT:
					case PLUS:
					case MINUS:
					case DIV:
					case MOD:
					case INC:
					case DEC:
					case LITERAL_sizeof:
					case CharLiteral:
					case NCast:
					case NExpressionGroup:
					case NInitializer:
					case NEmptyExpression:
					case NCommaExpr:
					case NUnaryExpr:
					case NPostfixExpr:
					case NRangeExpr:
					case NStringSeq:
					case NLcurlyInitializer:
					case NGnuAsmExpr:
					case Number:
					case LITERAL___alignof:
					{
						expr(_t);
						_t = _retTree;
						break;
					}
					case PREPROC_DIRECTIVE:
					case RBRACKET:
					{
						break;
					}
					default:
					{
						throw new NoViableAltException(_t);
					}
					}
					}
					{
					_loop135:
					do {
						if (_t==null) _t=ASTNULL;
						if ((_t.getType()==PREPROC_DIRECTIVE)) {
							p1 = (TNode)_t;
							match(_t,PREPROC_DIRECTIVE);
							_t = _t.getNextSibling();
							if ( inputState.guessing==0 ) {
								print( p1 );check=true; lineDir = p1.getText(); 													parseLine(1);
							}
						}
						else {
							break _loop135;
						}
						
					} while (true);
					}
					rb = (TNode)_t;
					match(_t,RBRACKET);
					_t = _t.getNextSibling();
					if ( inputState.guessing==0 ) {
						print( rb );
					}
					break;
				}
				default:
				{
					break _loop136;
				}
				}
			} while (true);
			}
			_t = __t119;
			_t = _t.getNextSibling();
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				if (_t!=null) {_t = _t.getNextSibling();}
			} else {
			  throw ex;
			}
		}
		_retTree = _t;
	}
	
	public final void enumList(AST _t) throws RecognitionException {
		
		TNode enumList_AST_in = (_t == ASTNULL) ? null : (TNode)_t;
		
		try {      // for error handling
			enumerator(_t);
			_t = _retTree;
			{
			_loop80:
			do {
				if (_t==null) _t=ASTNULL;
				if ((_t.getType()==ID)) {
					if ( inputState.guessing==0 ) {
						print(",");
					}
					enumerator(_t);
					_t = _retTree;
				}
				else {
					break _loop80;
				}
				
			} while (true);
			}
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				if (_t!=null) {_t = _t.getNextSibling();}
			} else {
			  throw ex;
			}
		}
		_retTree = _t;
	}
	
	public final void enumerator(AST _t) throws RecognitionException {
		
		TNode enumerator_AST_in = (_t == ASTNULL) ? null : (TNode)_t;
		TNode i = null;
		TNode b = null;
		
		try {      // for error handling
			i = (TNode)_t;
			match(_t,ID);
			_t = _t.getNextSibling();
			if ( inputState.guessing==0 ) {
				print( i );
			}
			{
			if (_t==null) _t=ASTNULL;
			switch ( _t.getType()) {
			case ASSIGN:
			{
				b = (TNode)_t;
				match(_t,ASSIGN);
				_t = _t.getNextSibling();
				if ( inputState.guessing==0 ) {
					print( b );
				}
				expr(_t);
				_t = _retTree;
				break;
			}
			case PREPROC_DIRECTIVE:
			case RCURLY:
			case ID:
			{
				break;
			}
			default:
			{
				throw new NoViableAltException(_t);
			}
			}
			}
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				if (_t!=null) {_t = _t.getNextSibling();}
			} else {
			  throw ex;
			}
		}
		_retTree = _t;
	}
	
	public final void initDecl(AST _t) throws RecognitionException {
		
		TNode initDecl_AST_in = (_t == ASTNULL) ? null : (TNode)_t;
		TNode a = null;
		TNode b = null;
		String declName = "";
		
		try {      // for error handling
			AST __t92 = _t;
			TNode tmp9_AST_in = (TNode)_t;
			match(_t,NInitDecl);
			_t = _t.getFirstChild();
			declarator(_t);
			_t = _retTree;
			{
			_loop94:
			do {
				if (_t==null) _t=ASTNULL;
				if ((_t.getType()==NAsmAttribute||_t.getType()==LITERAL___attribute)) {
					attributeDecl(_t);
					_t = _retTree;
				}
				else {
					break _loop94;
				}
				
			} while (true);
			}
			{
			if (_t==null) _t=ASTNULL;
			switch ( _t.getType()) {
			case ASSIGN:
			{
				a = (TNode)_t;
				match(_t,ASSIGN);
				_t = _t.getNextSibling();
				if ( inputState.guessing==0 ) {
					print( a );
				}
				initializer(_t);
				_t = _retTree;
				break;
			}
			case COLON:
			{
				b = (TNode)_t;
				match(_t,COLON);
				_t = _t.getNextSibling();
				if ( inputState.guessing==0 ) {
					print( b );
				}
				expr(_t);
				_t = _retTree;
				break;
			}
			case 3:
			{
				break;
			}
			default:
			{
				throw new NoViableAltException(_t);
			}
			}
			}
			_t = __t92;
			_t = _t.getNextSibling();
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				if (_t!=null) {_t = _t.getNextSibling();}
			} else {
			  throw ex;
			}
		}
		_retTree = _t;
	}
	
	public final void initializer(AST _t) throws RecognitionException {
		
		TNode initializer_AST_in = (_t == ASTNULL) ? null : (TNode)_t;
		
		try {      // for error handling
			if (_t==null) _t=ASTNULL;
			switch ( _t.getType()) {
			case NInitializer:
			{
				AST __t106 = _t;
				TNode tmp10_AST_in = (TNode)_t;
				match(_t,NInitializer);
				_t = _t.getFirstChild();
				{
				if (_t==null) _t=ASTNULL;
				switch ( _t.getType()) {
				case NInitializerElementLabel:
				{
					initializerElementLabel(_t);
					_t = _retTree;
					break;
				}
				case ID:
				case ASSIGN:
				case STAR:
				case LPAREN:
				case DIV_ASSIGN:
				case PLUS_ASSIGN:
				case MINUS_ASSIGN:
				case STAR_ASSIGN:
				case MOD_ASSIGN:
				case RSHIFT_ASSIGN:
				case LSHIFT_ASSIGN:
				case BAND_ASSIGN:
				case BOR_ASSIGN:
				case BXOR_ASSIGN:
				case QUESTION:
				case LOR:
				case LAND:
				case BOR:
				case BXOR:
				case BAND:
				case EQUAL:
				case NOT_EQUAL:
				case LT:
				case LTE:
				case GT:
				case GTE:
				case LSHIFT:
				case RSHIFT:
				case PLUS:
				case MINUS:
				case DIV:
				case MOD:
				case INC:
				case DEC:
				case LITERAL_sizeof:
				case CharLiteral:
				case NCast:
				case NExpressionGroup:
				case NInitializer:
				case NEmptyExpression:
				case NCommaExpr:
				case NUnaryExpr:
				case NPostfixExpr:
				case NRangeExpr:
				case NStringSeq:
				case NLcurlyInitializer:
				case NGnuAsmExpr:
				case Number:
				case LITERAL___alignof:
				{
					break;
				}
				default:
				{
					throw new NoViableAltException(_t);
				}
				}
				}
				expr(_t);
				_t = _retTree;
				_t = __t106;
				_t = _t.getNextSibling();
				break;
			}
			case NLcurlyInitializer:
			{
				lcurlyInitializer(_t);
				_t = _retTree;
				break;
			}
			default:
			{
				throw new NoViableAltException(_t);
			}
			}
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				if (_t!=null) {_t = _t.getNextSibling();}
			} else {
			  throw ex;
			}
		}
		_retTree = _t;
	}
	
	public final void pointerGroup(AST _t) throws RecognitionException {
		
		TNode pointerGroup_AST_in = (_t == ASTNULL) ? null : (TNode)_t;
		TNode a = null;
		
		try {      // for error handling
			AST __t97 = _t;
			TNode tmp11_AST_in = (TNode)_t;
			match(_t,NPointerGroup);
			_t = _t.getFirstChild();
			{
			int _cnt101=0;
			_loop101:
			do {
				if (_t==null) _t=ASTNULL;
				if ((_t.getType()==STAR)) {
					a = (TNode)_t;
					match(_t,STAR);
					_t = _t.getNextSibling();
					if ( inputState.guessing==0 ) {
						print( a );
					}
					{
					_loop100:
					do {
						if (_t==null) _t=ASTNULL;
						if ((_t.getType()==LITERAL_volatile||_t.getType()==LITERAL_const)) {
							typeQualifier(_t);
							_t = _retTree;
						}
						else {
							break _loop100;
						}
						
					} while (true);
					}
				}
				else {
					if ( _cnt101>=1 ) { break _loop101; } else {throw new NoViableAltException(_t);}
				}
				
				_cnt101++;
			} while (true);
			}
			_t = __t97;
			_t = _t.getNextSibling();
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				if (_t!=null) {_t = _t.getNextSibling();}
			} else {
			  throw ex;
			}
		}
		_retTree = _t;
	}
	
	public final void idList(AST _t) throws RecognitionException {
		
		TNode idList_AST_in = (_t == ASTNULL) ? null : (TNode)_t;
		TNode i = null;
		TNode c = null;
		TNode id = null;
		
		try {      // for error handling
			i = (TNode)_t;
			match(_t,ID);
			_t = _t.getNextSibling();
			if ( inputState.guessing==0 ) {
				print( i );
			}
			{
			_loop104:
			do {
				if (_t==null) _t=ASTNULL;
				if ((_t.getType()==COMMA)) {
					c = (TNode)_t;
					match(_t,COMMA);
					_t = _t.getNextSibling();
					if ( inputState.guessing==0 ) {
						print( c );
					}
					id = (TNode)_t;
					match(_t,ID);
					_t = _t.getNextSibling();
					if ( inputState.guessing==0 ) {
						print( id );
					}
				}
				else {
					break _loop104;
				}
				
			} while (true);
			}
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				if (_t!=null) {_t = _t.getNextSibling();}
			} else {
			  throw ex;
			}
		}
		_retTree = _t;
	}
	
	public final void initializerElementLabel(AST _t) throws RecognitionException {
		
		TNode initializerElementLabel_AST_in = (_t == ASTNULL) ? null : (TNode)_t;
		TNode l = null;
		TNode r = null;
		TNode a1 = null;
		TNode i1 = null;
		TNode c = null;
		TNode d = null;
		TNode i2 = null;
		TNode a2 = null;
		
		try {      // for error handling
			AST __t109 = _t;
			TNode tmp12_AST_in = (TNode)_t;
			match(_t,NInitializerElementLabel);
			_t = _t.getFirstChild();
			{
			if (_t==null) _t=ASTNULL;
			switch ( _t.getType()) {
			case LBRACKET:
			{
				{
				l = (TNode)_t;
				match(_t,LBRACKET);
				_t = _t.getNextSibling();
				if ( inputState.guessing==0 ) {
					print( l );
				}
				expr(_t);
				_t = _retTree;
				r = (TNode)_t;
				match(_t,RBRACKET);
				_t = _t.getNextSibling();
				if ( inputState.guessing==0 ) {
					print( r );
				}
				{
				if (_t==null) _t=ASTNULL;
				switch ( _t.getType()) {
				case ASSIGN:
				{
					a1 = (TNode)_t;
					match(_t,ASSIGN);
					_t = _t.getNextSibling();
					if ( inputState.guessing==0 ) {
						print( a1 );
					}
					break;
				}
				case 3:
				{
					break;
				}
				default:
				{
					throw new NoViableAltException(_t);
				}
				}
				}
				}
				break;
			}
			case ID:
			{
				i1 = (TNode)_t;
				match(_t,ID);
				_t = _t.getNextSibling();
				c = (TNode)_t;
				match(_t,COLON);
				_t = _t.getNextSibling();
				if ( inputState.guessing==0 ) {
					print( i1 ); print( c );
				}
				break;
			}
			case DOT:
			{
				d = (TNode)_t;
				match(_t,DOT);
				_t = _t.getNextSibling();
				i2 = (TNode)_t;
				match(_t,ID);
				_t = _t.getNextSibling();
				a2 = (TNode)_t;
				match(_t,ASSIGN);
				_t = _t.getNextSibling();
				if ( inputState.guessing==0 ) {
					print( d ); print( i2 ); print( a2 );
				}
				break;
			}
			default:
			{
				throw new NoViableAltException(_t);
			}
			}
			}
			_t = __t109;
			_t = _t.getNextSibling();
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				if (_t!=null) {_t = _t.getNextSibling();}
			} else {
			  throw ex;
			}
		}
		_retTree = _t;
	}
	
	public final void lcurlyInitializer(AST _t) throws RecognitionException {
		
		TNode lcurlyInitializer_AST_in = (_t == ASTNULL) ? null : (TNode)_t;
		TNode n = null;
		TNode rc = null;
		
		try {      // for error handling
			AST __t114 = _t;
			n = _t==ASTNULL ? null :(TNode)_t;
			match(_t,NLcurlyInitializer);
			_t = _t.getFirstChild();
			if ( inputState.guessing==0 ) {
				print( n ); tabs++;
			}
			initializerList(_t);
			_t = _retTree;
			rc = (TNode)_t;
			match(_t,RCURLY);
			_t = _t.getNextSibling();
			if ( inputState.guessing==0 ) {
				tabs--; print( rc );
			}
			_t = __t114;
			_t = _t.getNextSibling();
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				if (_t!=null) {_t = _t.getNextSibling();}
			} else {
			  throw ex;
			}
		}
		_retTree = _t;
	}
	
	public final void initializerList(AST _t) throws RecognitionException {
		
		TNode initializerList_AST_in = (_t == ASTNULL) ? null : (TNode)_t;
		TNode i = null;
		
		try {      // for error handling
			{
			_loop117:
			do {
				if (_t==null) _t=ASTNULL;
				if ((_t.getType()==NInitializer||_t.getType()==NLcurlyInitializer)) {
					i = _t==ASTNULL ? null : (TNode)_t;
					initializer(_t);
					_t = _retTree;
					if ( inputState.guessing==0 ) {
						commaSep( i );
					}
				}
				else {
					break _loop117;
				}
				
			} while (true);
			}
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				if (_t!=null) {_t = _t.getNextSibling();}
			} else {
			  throw ex;
			}
		}
		_retTree = _t;
	}
	
	public final void parameterTypeList(AST _t) throws RecognitionException {
		
		TNode parameterTypeList_AST_in = (_t == ASTNULL) ? null : (TNode)_t;
		TNode p2 = null;
		TNode c = null;
		TNode s = null;
		TNode v = null;
		
		try {      // for error handling
			{
			int _cnt142=0;
			_loop142:
			do {
				if (_t==null) _t=ASTNULL;
				if ((_t.getType()==PREPROC_DIRECTIVE||_t.getType()==NParameterDeclaration)) {
					{
					_loop140:
					do {
						if (_t==null) _t=ASTNULL;
						if ((_t.getType()==PREPROC_DIRECTIVE)) {
							p2 = (TNode)_t;
							match(_t,PREPROC_DIRECTIVE);
							_t = _t.getNextSibling();
							if ( inputState.guessing==0 ) {
								print( p2 );check=true; lineDir = p2.getText(); parseLine(1);
							}
						}
						else {
							break _loop140;
						}
						
					} while (true);
					}
					parameterDeclaration(_t);
					_t = _retTree;
					{
					if (_t==null) _t=ASTNULL;
					switch ( _t.getType()) {
					case COMMA:
					{
						c = (TNode)_t;
						match(_t,COMMA);
						_t = _t.getNextSibling();
						if ( inputState.guessing==0 ) {
							print( c );
						}
						break;
					}
					case SEMI:
					{
						s = (TNode)_t;
						match(_t,SEMI);
						_t = _t.getNextSibling();
						if ( inputState.guessing==0 ) {
							print( s );
						}
						break;
					}
					case PREPROC_DIRECTIVE:
					case RPAREN:
					case VARARGS:
					case NParameterDeclaration:
					{
						break;
					}
					default:
					{
						throw new NoViableAltException(_t);
					}
					}
					}
				}
				else {
					if ( _cnt142>=1 ) { break _loop142; } else {throw new NoViableAltException(_t);}
				}
				
				_cnt142++;
			} while (true);
			}
			{
			if (_t==null) _t=ASTNULL;
			switch ( _t.getType()) {
			case VARARGS:
			{
				v = (TNode)_t;
				match(_t,VARARGS);
				_t = _t.getNextSibling();
				if ( inputState.guessing==0 ) {
					print( v );
				}
				break;
			}
			case RPAREN:
			{
				break;
			}
			default:
			{
				throw new NoViableAltException(_t);
			}
			}
			}
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				if (_t!=null) {_t = _t.getNextSibling();}
			} else {
			  throw ex;
			}
		}
		_retTree = _t;
	}
	
	public final void parameterDeclaration(AST _t) throws RecognitionException {
		
		TNode parameterDeclaration_AST_in = (_t == ASTNULL) ? null : (TNode)_t;
		
		try {      // for error handling
			AST __t145 = _t;
			TNode tmp13_AST_in = (TNode)_t;
			match(_t,NParameterDeclaration);
			_t = _t.getFirstChild();
			declSpecifiers(_t);
			_t = _retTree;
			{
			if (_t==null) _t=ASTNULL;
			switch ( _t.getType()) {
			case NDeclarator:
			{
				declarator(_t);
				_t = _retTree;
				break;
			}
			case NNonemptyAbstractDeclarator:
			{
				nonemptyAbstractDeclarator(_t);
				_t = _retTree;
				break;
			}
			case 3:
			{
				break;
			}
			default:
			{
				throw new NoViableAltException(_t);
			}
			}
			}
			_t = __t145;
			_t = _t.getNextSibling();
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				if (_t!=null) {_t = _t.getNextSibling();}
			} else {
			  throw ex;
			}
		}
		_retTree = _t;
	}
	
	public final void nonemptyAbstractDeclarator(AST _t) throws RecognitionException {
		
		TNode nonemptyAbstractDeclarator_AST_in = (_t == ASTNULL) ? null : (TNode)_t;
		TNode lp1 = null;
		TNode rp1 = null;
		TNode lb1 = null;
		TNode rb1 = null;
		TNode lp2 = null;
		TNode rp2 = null;
		TNode lb2 = null;
		TNode rb2 = null;
		
		try {      // for error handling
			AST __t232 = _t;
			TNode tmp14_AST_in = (TNode)_t;
			match(_t,NNonemptyAbstractDeclarator);
			_t = _t.getFirstChild();
			{
			if (_t==null) _t=ASTNULL;
			switch ( _t.getType()) {
			case NPointerGroup:
			{
				pointerGroup(_t);
				_t = _retTree;
				{
				_loop239:
				do {
					if (_t==null) _t=ASTNULL;
					switch ( _t.getType()) {
					case LPAREN:
					{
						{
						lp1 = (TNode)_t;
						match(_t,LPAREN);
						_t = _t.getNextSibling();
						if ( inputState.guessing==0 ) {
							print( lp1 );
						}
						{
						if (_t==null) _t=ASTNULL;
						switch ( _t.getType()) {
						case NNonemptyAbstractDeclarator:
						{
							nonemptyAbstractDeclarator(_t);
							_t = _retTree;
							break;
						}
						case PREPROC_DIRECTIVE:
						case NParameterDeclaration:
						{
							parameterTypeList(_t);
							_t = _retTree;
							break;
						}
						case RPAREN:
						{
							break;
						}
						default:
						{
							throw new NoViableAltException(_t);
						}
						}
						}
						rp1 = (TNode)_t;
						match(_t,RPAREN);
						_t = _t.getNextSibling();
						if ( inputState.guessing==0 ) {
							print( rp1 );
						}
						}
						break;
					}
					case LBRACKET:
					{
						{
						lb1 = (TNode)_t;
						match(_t,LBRACKET);
						_t = _t.getNextSibling();
						if ( inputState.guessing==0 ) {
							print( lb1 );
						}
						{
						if (_t==null) _t=ASTNULL;
						switch ( _t.getType()) {
						case ID:
						case ASSIGN:
						case STAR:
						case LPAREN:
						case DIV_ASSIGN:
						case PLUS_ASSIGN:
						case MINUS_ASSIGN:
						case STAR_ASSIGN:
						case MOD_ASSIGN:
						case RSHIFT_ASSIGN:
						case LSHIFT_ASSIGN:
						case BAND_ASSIGN:
						case BOR_ASSIGN:
						case BXOR_ASSIGN:
						case QUESTION:
						case LOR:
						case LAND:
						case BOR:
						case BXOR:
						case BAND:
						case EQUAL:
						case NOT_EQUAL:
						case LT:
						case LTE:
						case GT:
						case GTE:
						case LSHIFT:
						case RSHIFT:
						case PLUS:
						case MINUS:
						case DIV:
						case MOD:
						case INC:
						case DEC:
						case LITERAL_sizeof:
						case CharLiteral:
						case NCast:
						case NExpressionGroup:
						case NInitializer:
						case NEmptyExpression:
						case NCommaExpr:
						case NUnaryExpr:
						case NPostfixExpr:
						case NRangeExpr:
						case NStringSeq:
						case NLcurlyInitializer:
						case NGnuAsmExpr:
						case Number:
						case LITERAL___alignof:
						{
							expr(_t);
							_t = _retTree;
							break;
						}
						case RBRACKET:
						{
							break;
						}
						default:
						{
							throw new NoViableAltException(_t);
						}
						}
						}
						rb1 = (TNode)_t;
						match(_t,RBRACKET);
						_t = _t.getNextSibling();
						if ( inputState.guessing==0 ) {
							print( rb1 );
						}
						}
						break;
					}
					default:
					{
						break _loop239;
					}
					}
				} while (true);
				}
				break;
			}
			case LPAREN:
			case LBRACKET:
			{
				{
				int _cnt245=0;
				_loop245:
				do {
					if (_t==null) _t=ASTNULL;
					switch ( _t.getType()) {
					case LPAREN:
					{
						{
						lp2 = (TNode)_t;
						match(_t,LPAREN);
						_t = _t.getNextSibling();
						if ( inputState.guessing==0 ) {
							print( lp2 );
						}
						{
						if (_t==null) _t=ASTNULL;
						switch ( _t.getType()) {
						case NNonemptyAbstractDeclarator:
						{
							nonemptyAbstractDeclarator(_t);
							_t = _retTree;
							break;
						}
						case PREPROC_DIRECTIVE:
						case NParameterDeclaration:
						{
							parameterTypeList(_t);
							_t = _retTree;
							break;
						}
						case RPAREN:
						{
							break;
						}
						default:
						{
							throw new NoViableAltException(_t);
						}
						}
						}
						rp2 = (TNode)_t;
						match(_t,RPAREN);
						_t = _t.getNextSibling();
						if ( inputState.guessing==0 ) {
							print( rp2 );
						}
						}
						break;
					}
					case LBRACKET:
					{
						{
						lb2 = (TNode)_t;
						match(_t,LBRACKET);
						_t = _t.getNextSibling();
						if ( inputState.guessing==0 ) {
							print( lb2 );
						}
						{
						if (_t==null) _t=ASTNULL;
						switch ( _t.getType()) {
						case ID:
						case ASSIGN:
						case STAR:
						case LPAREN:
						case DIV_ASSIGN:
						case PLUS_ASSIGN:
						case MINUS_ASSIGN:
						case STAR_ASSIGN:
						case MOD_ASSIGN:
						case RSHIFT_ASSIGN:
						case LSHIFT_ASSIGN:
						case BAND_ASSIGN:
						case BOR_ASSIGN:
						case BXOR_ASSIGN:
						case QUESTION:
						case LOR:
						case LAND:
						case BOR:
						case BXOR:
						case BAND:
						case EQUAL:
						case NOT_EQUAL:
						case LT:
						case LTE:
						case GT:
						case GTE:
						case LSHIFT:
						case RSHIFT:
						case PLUS:
						case MINUS:
						case DIV:
						case MOD:
						case INC:
						case DEC:
						case LITERAL_sizeof:
						case CharLiteral:
						case NCast:
						case NExpressionGroup:
						case NInitializer:
						case NEmptyExpression:
						case NCommaExpr:
						case NUnaryExpr:
						case NPostfixExpr:
						case NRangeExpr:
						case NStringSeq:
						case NLcurlyInitializer:
						case NGnuAsmExpr:
						case Number:
						case LITERAL___alignof:
						{
							expr(_t);
							_t = _retTree;
							break;
						}
						case RBRACKET:
						{
							break;
						}
						default:
						{
							throw new NoViableAltException(_t);
						}
						}
						}
						rb2 = (TNode)_t;
						match(_t,RBRACKET);
						_t = _t.getNextSibling();
						if ( inputState.guessing==0 ) {
							print( rb2 );
						}
						}
						break;
					}
					default:
					{
						if ( _cnt245>=1 ) { break _loop245; } else {throw new NoViableAltException(_t);}
					}
					}
					_cnt245++;
				} while (true);
				}
				break;
			}
			default:
			{
				throw new NoViableAltException(_t);
			}
			}
			}
			_t = __t232;
			_t = _t.getNextSibling();
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				if (_t!=null) {_t = _t.getNextSibling();}
			} else {
			  throw ex;
			}
		}
		_retTree = _t;
	}
	
	public final void functionDeclSpecifiers(AST _t) throws RecognitionException {
		
		TNode functionDeclSpecifiers_AST_in = (_t == ASTNULL) ? null : (TNode)_t;
		
		try {      // for error handling
			{
			int _cnt156=0;
			_loop156:
			do {
				if (_t==null) _t=ASTNULL;
				switch ( _t.getType()) {
				case LITERAL_extern:
				case LITERAL_static:
				case LITERAL_inline:
				case LITERAL___inline:
				{
					functionStorageClassSpecifier(_t);
					_t = _retTree;
					break;
				}
				case LITERAL_volatile:
				case LITERAL_const:
				{
					typeQualifier(_t);
					_t = _retTree;
					break;
				}
				case LITERAL_struct:
				case LITERAL_union:
				case LITERAL_enum:
				case LITERAL_void:
				case LITERAL_char:
				case LITERAL_short:
				case LITERAL_int:
				case LITERAL_long:
				case LITERAL_float:
				case LITERAL_double:
				case LITERAL_signed:
				case LITERAL___builtin_va_list:
				case LITERAL_unsigned:
				case NTypedefName:
				case LITERAL_typeof:
				case LITERAL___complex:
				{
					typeSpecifier(_t);
					_t = _retTree;
					break;
				}
				default:
				{
					if ( _cnt156>=1 ) { break _loop156; } else {throw new NoViableAltException(_t);}
				}
				}
				_cnt156++;
			} while (true);
			}
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				if (_t!=null) {_t = _t.getNextSibling();}
			} else {
			  throw ex;
			}
		}
		_retTree = _t;
	}
	
	public final void compoundStatement(AST _t) throws RecognitionException {
		
		TNode compoundStatement_AST_in = (_t == ASTNULL) ? null : (TNode)_t;
		TNode cs = null;
		TNode p = null;
		TNode rc = null;
		
		try {      // for error handling
			AST __t167 = _t;
			cs = _t==ASTNULL ? null :(TNode)_t;
			match(_t,NCompoundStatement);
			_t = _t.getFirstChild();
			if ( inputState.guessing==0 ) {
				print( cs );  adjustWhile(compoundStatement_AST_in);tabs++;
											if(isFunction){
												isFunction=false;
												adjustReturn(compoundStatement_AST_in);}
											
			}
			{
			_loop169:
			do {
				if (_t==null) _t=ASTNULL;
				if ((_t.getType()==PREPROC_DIRECTIVE)) {
					p = (TNode)_t;
					match(_t,PREPROC_DIRECTIVE);
					_t = _t.getNextSibling();
					if ( inputState.guessing==0 ) {
						print( p );check=true;lineDir = p.getText(); parseLine(1);
					}
				}
				else {
					break _loop169;
				}
				
			} while (true);
			}
			{
			_loop171:
			do {
				if (_t==null) _t=ASTNULL;
				switch ( _t.getType()) {
				case NDeclaration:
				case LITERAL___label__:
				{
					declarationList(_t);
					_t = _retTree;
					break;
				}
				case NFunctionDef:
				{
					functionDef(_t);
					_t = _retTree;
					break;
				}
				default:
				{
					break _loop171;
				}
				}
			} while (true);
			}
			{
			if (_t==null) _t=ASTNULL;
			switch ( _t.getType()) {
			case PREPROC_DIRECTIVE:
			case SEMI:
			case LITERAL_while:
			case LITERAL_do:
			case LITERAL_for:
			case LITERAL_goto:
			case LITERAL_continue:
			case LITERAL_break:
			case LITERAL_return:
			case LITERAL_case:
			case LITERAL_default:
			case LITERAL_if:
			case LITERAL_switch:
			case NStatementExpr:
			case NCompoundStatement:
			case NLabel:
			{
				statementList(_t);
				_t = _retTree;
				break;
			}
			case RCURLY:
			{
				break;
			}
			default:
			{
				throw new NoViableAltException(_t);
			}
			}
			}
			rc = (TNode)_t;
			match(_t,RCURLY);
			_t = _t.getNextSibling();
			if ( inputState.guessing==0 ) {
				tabs--; print( rc );
			}
			_t = __t167;
			_t = _t.getNextSibling();
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				if (_t!=null) {_t = _t.getNextSibling();}
			} else {
			  throw ex;
			}
		}
		_retTree = _t;
	}
	
	public final void declarationList(AST _t) throws RecognitionException {
		
		TNode declarationList_AST_in = (_t == ASTNULL) ? null : (TNode)_t;
		TNode p = null;
		
		try {      // for error handling
			{
			int _cnt161=0;
			_loop161:
			do {
				if (_t==null) _t=ASTNULL;
				if ((_t.getType()==LITERAL___label__)) {
					localLabelDecl(_t);
					_t = _retTree;
				}
				else if ((_t.getType()==NDeclaration)) {
					declaration(_t);
					_t = _retTree;
					{
					_loop160:
					do {
						if (_t==null) _t=ASTNULL;
						if ((_t.getType()==PREPROC_DIRECTIVE)) {
							p = (TNode)_t;
							match(_t,PREPROC_DIRECTIVE);
							_t = _t.getNextSibling();
							if ( inputState.guessing==0 ) {
								print( p );check=true; lineDir = p.getText(); parseLine(1);
							}
						}
						else {
							break _loop160;
						}
						
					} while (true);
					}
				}
				else {
					if ( _cnt161>=1 ) { break _loop161; } else {throw new NoViableAltException(_t);}
				}
				
				_cnt161++;
			} while (true);
			}
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				if (_t!=null) {_t = _t.getNextSibling();}
			} else {
			  throw ex;
			}
		}
		_retTree = _t;
	}
	
	public final void localLabelDecl(AST _t) throws RecognitionException {
		
		TNode localLabelDecl_AST_in = (_t == ASTNULL) ? null : (TNode)_t;
		TNode a = null;
		TNode i = null;
		
		try {      // for error handling
			AST __t163 = _t;
			a = _t==ASTNULL ? null :(TNode)_t;
			match(_t,LITERAL___label__);
			_t = _t.getFirstChild();
			if ( inputState.guessing==0 ) {
				print( a );
			}
			{
			int _cnt165=0;
			_loop165:
			do {
				if (_t==null) _t=ASTNULL;
				if ((_t.getType()==ID)) {
					i = (TNode)_t;
					match(_t,ID);
					_t = _t.getNextSibling();
					if ( inputState.guessing==0 ) {
						commaSep( i );
					}
				}
				else {
					if ( _cnt165>=1 ) { break _loop165; } else {throw new NoViableAltException(_t);}
				}
				
				_cnt165++;
			} while (true);
			}
			if ( inputState.guessing==0 ) {
				print( ";" );
			}
			_t = __t163;
			_t = _t.getNextSibling();
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				if (_t!=null) {_t = _t.getNextSibling();}
			} else {
			  throw ex;
			}
		}
		_retTree = _t;
	}
	
	public final void statementList(AST _t) throws RecognitionException {
		
		TNode statementList_AST_in = (_t == ASTNULL) ? null : (TNode)_t;
		
		try {      // for error handling
			if ( inputState.guessing==0 ) {
				
						
						if(check_func){
							check_func=false;
							preTransform();
					    	}
						if(loopInsideFlag){
							loopInsideFlag = false;
							if(loop2Flag){
								loop2Flag=false;
								System.out.println("");
								//System.out.println ("printf(\"" + p2 + ":" + l2 + "\\n\");" + "//LoopingMagic");
								System.out.println("//LoopingMagic");
								System.out.print("check_time(" + printString2 + ");");
								printString2 = "";
								
								
					    		}
						}
						if(check){
							check=false;
							for(int i=0;i<dirCnt;i++){
								path=paths[i];
								line=lines[i];
								transform();
								paths[i]="";
								lines[i]="";
								
							}
							dirCnt=0;
					    	}
					    
					
			}
			{
			int _cnt175=0;
			_loop175:
			do {
				if (_t==null) _t=ASTNULL;
				if ((_tokenSet_2.member(_t.getType()))) {
					statement(_t);
					_t = _retTree;
				}
				else {
					if ( _cnt175>=1 ) { break _loop175; } else {throw new NoViableAltException(_t);}
				}
				
				_cnt175++;
			} while (true);
			}
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				if (_t!=null) {_t = _t.getNextSibling();}
			} else {
			  throw ex;
			}
		}
		_retTree = _t;
	}
	
	public final void statement(AST _t) throws RecognitionException {
		
		TNode statement_AST_in = (_t == ASTNULL) ? null : (TNode)_t;
		
		try {      // for error handling
			statementBody(_t);
			_t = _retTree;
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				if (_t!=null) {_t = _t.getNextSibling();}
			} else {
			  throw ex;
			}
		}
		_retTree = _t;
	}
	
	public final void statementBody(AST _t) throws RecognitionException {
		
		TNode statementBody_AST_in = (_t == ASTNULL) ? null : (TNode)_t;
		TNode s = null;
		TNode p = null;
		TNode w = null;
		TNode d = null;
		TNode pl = null;
		TNode f = null;
		TNode g = null;
		TNode c = null;
		TNode b = null;
		TNode r = null;
		TNode ni = null;
		TNode ca = null;
		TNode de = null;
		TNode i = null;
		TNode pp = null;
		TNode e = null;
		TNode pc = null;
		TNode sw = null;
		
		try {      // for error handling
			if (_t==null) _t=ASTNULL;
			switch ( _t.getType()) {
			case SEMI:
			{
				s = (TNode)_t;
				match(_t,SEMI);
				_t = _t.getNextSibling();
				if ( inputState.guessing==0 ) {
					print( s );
				}
				break;
			}
			case NCompoundStatement:
			{
				compoundStatement(_t);
				_t = _retTree;
				break;
			}
			case PREPROC_DIRECTIVE:
			{
				p = (TNode)_t;
				match(_t,PREPROC_DIRECTIVE);
				_t = _t.getNextSibling();
				if ( inputState.guessing==0 ) {
					print( p ); lineDir = p.getText(); parseLine(2);
				}
				break;
			}
			case NStatementExpr:
			{
				AST __t178 = _t;
				TNode tmp15_AST_in = (TNode)_t;
				match(_t,NStatementExpr);
				_t = _t.getFirstChild();
				expr(_t);
				_t = _retTree;
				if ( inputState.guessing==0 ) {
					print( ";" );
				}
				_t = __t178;
				_t = _t.getNextSibling();
				break;
			}
			case LITERAL_while:
			{
				AST __t179 = _t;
				w = _t==ASTNULL ? null :(TNode)_t;
				match(_t,LITERAL_while);
				_t = _t.getFirstChild();
				if ( inputState.guessing==0 ) {
					print( w ); print( "(" );
				}
				expr(_t);
				_t = _retTree;
				if ( inputState.guessing==0 ) {
					print( ")" );
				}
				statement(_t);
				_t = _retTree;
				_t = __t179;
				_t = _t.getNextSibling();
				break;
			}
			case LITERAL_do:
			{
				AST __t180 = _t;
				d = _t==ASTNULL ? null :(TNode)_t;
				match(_t,LITERAL_do);
				_t = _t.getFirstChild();
				if ( inputState.guessing==0 ) {
					print( d );
				}
				statement(_t);
				_t = _retTree;
				{
				_loop182:
				do {
					if (_t==null) _t=ASTNULL;
					if ((_t.getType()==PREPROC_DIRECTIVE)) {
						pl = (TNode)_t;
						match(_t,PREPROC_DIRECTIVE);
						_t = _t.getNextSibling();
						if ( inputState.guessing==0 ) {
							print(pl);System.out.println();
						}
					}
					else {
						break _loop182;
					}
					
				} while (true);
				}
				if ( inputState.guessing==0 ) {
					print( " while ( " );
				}
				expr(_t);
				_t = _retTree;
				if ( inputState.guessing==0 ) {
					print( " );" );
				}
				_t = __t180;
				_t = _t.getNextSibling();
				break;
			}
			case LITERAL_for:
			{
				AST __t183 = _t;
				f = _t==ASTNULL ? null :(TNode)_t;
				match(_t,LITERAL_for);
				_t = _t.getFirstChild();
				if ( inputState.guessing==0 ) {
					print( f ); print( "(" );
				}
				expr(_t);
				_t = _retTree;
				if ( inputState.guessing==0 ) {
					print( ";" );
				}
				expr(_t);
				_t = _retTree;
				if ( inputState.guessing==0 ) {
					print( ";" );
				}
				expr(_t);
				_t = _retTree;
				if ( inputState.guessing==0 ) {
					print( ")" );
				}
				if ( inputState.guessing==0 ) {
					loopInsideFlag = true;printString2=printString;printString = "";
							if(loopFlag){loopFlag=false;loop2Flag=true;}
					
							
				}
				statement(_t);
				_t = _retTree;
				_t = __t183;
				_t = _t.getNextSibling();
				break;
			}
			case LITERAL_goto:
			{
				AST __t184 = _t;
				g = _t==ASTNULL ? null :(TNode)_t;
				match(_t,LITERAL_goto);
				_t = _t.getFirstChild();
				if ( inputState.guessing==0 ) {
					print( g );
				}
				expr(_t);
				_t = _retTree;
				if ( inputState.guessing==0 ) {
					print( ";" );
				}
				_t = __t184;
				_t = _t.getNextSibling();
				break;
			}
			case LITERAL_continue:
			{
				c = (TNode)_t;
				match(_t,LITERAL_continue);
				_t = _t.getNextSibling();
				if ( inputState.guessing==0 ) {
					print( c ); print( ";" );
				}
				break;
			}
			case LITERAL_break:
			{
				b = (TNode)_t;
				match(_t,LITERAL_break);
				_t = _t.getNextSibling();
				if ( inputState.guessing==0 ) {
					print( b ); print( ";" );
				}
				break;
			}
			case LITERAL_return:
			{
				AST __t185 = _t;
				r = _t==ASTNULL ? null :(TNode)_t;
				match(_t,LITERAL_return);
				_t = _t.getFirstChild();
				if ( inputState.guessing==0 ) {
						if(returnAlert){
												String temp1 = previousLine;
												String temp2 = previousPath;
												lineDir = forReturn; parseLine(2);
												previousLine=temp1;
												previousPath = temp2;
											}
										print( r );
				}
				{
				if (_t==null) _t=ASTNULL;
				switch ( _t.getType()) {
				case ID:
				case ASSIGN:
				case STAR:
				case LPAREN:
				case DIV_ASSIGN:
				case PLUS_ASSIGN:
				case MINUS_ASSIGN:
				case STAR_ASSIGN:
				case MOD_ASSIGN:
				case RSHIFT_ASSIGN:
				case LSHIFT_ASSIGN:
				case BAND_ASSIGN:
				case BOR_ASSIGN:
				case BXOR_ASSIGN:
				case QUESTION:
				case LOR:
				case LAND:
				case BOR:
				case BXOR:
				case BAND:
				case EQUAL:
				case NOT_EQUAL:
				case LT:
				case LTE:
				case GT:
				case GTE:
				case LSHIFT:
				case RSHIFT:
				case PLUS:
				case MINUS:
				case DIV:
				case MOD:
				case INC:
				case DEC:
				case LITERAL_sizeof:
				case CharLiteral:
				case NCast:
				case NExpressionGroup:
				case NInitializer:
				case NEmptyExpression:
				case NCommaExpr:
				case NUnaryExpr:
				case NPostfixExpr:
				case NRangeExpr:
				case NStringSeq:
				case NLcurlyInitializer:
				case NGnuAsmExpr:
				case Number:
				case LITERAL___alignof:
				{
					expr(_t);
					_t = _retTree;
					break;
				}
				case 3:
				{
					break;
				}
				default:
				{
					throw new NoViableAltException(_t);
				}
				}
				}
				if ( inputState.guessing==0 ) {
					print( ";" );
				}
				_t = __t185;
				_t = _t.getNextSibling();
				break;
			}
			case NLabel:
			{
				AST __t187 = _t;
				TNode tmp16_AST_in = (TNode)_t;
				match(_t,NLabel);
				_t = _t.getFirstChild();
				ni = (TNode)_t;
				match(_t,ID);
				_t = _t.getNextSibling();
				if ( inputState.guessing==0 ) {
					print( ni ); print( ":" );
				}
				{
				if (_t==null) _t=ASTNULL;
				switch ( _t.getType()) {
				case PREPROC_DIRECTIVE:
				case SEMI:
				case LITERAL_while:
				case LITERAL_do:
				case LITERAL_for:
				case LITERAL_goto:
				case LITERAL_continue:
				case LITERAL_break:
				case LITERAL_return:
				case LITERAL_case:
				case LITERAL_default:
				case LITERAL_if:
				case LITERAL_switch:
				case NStatementExpr:
				case NCompoundStatement:
				case NLabel:
				{
					statement(_t);
					_t = _retTree;
					break;
				}
				case 3:
				{
					break;
				}
				default:
				{
					throw new NoViableAltException(_t);
				}
				}
				}
				_t = __t187;
				_t = _t.getNextSibling();
				break;
			}
			case LITERAL_case:
			{
				AST __t189 = _t;
				ca = _t==ASTNULL ? null :(TNode)_t;
				match(_t,LITERAL_case);
				_t = _t.getFirstChild();
				if ( inputState.guessing==0 ) {
					print( ca );
				}
				expr(_t);
				_t = _retTree;
				if ( inputState.guessing==0 ) {
					print( ":" );
				}
				{
				if (_t==null) _t=ASTNULL;
				switch ( _t.getType()) {
				case PREPROC_DIRECTIVE:
				case SEMI:
				case LITERAL_while:
				case LITERAL_do:
				case LITERAL_for:
				case LITERAL_goto:
				case LITERAL_continue:
				case LITERAL_break:
				case LITERAL_return:
				case LITERAL_case:
				case LITERAL_default:
				case LITERAL_if:
				case LITERAL_switch:
				case NStatementExpr:
				case NCompoundStatement:
				case NLabel:
				{
					statement(_t);
					_t = _retTree;
					break;
				}
				case 3:
				{
					break;
				}
				default:
				{
					throw new NoViableAltException(_t);
				}
				}
				}
				_t = __t189;
				_t = _t.getNextSibling();
				break;
			}
			case LITERAL_default:
			{
				AST __t191 = _t;
				de = _t==ASTNULL ? null :(TNode)_t;
				match(_t,LITERAL_default);
				_t = _t.getFirstChild();
				if ( inputState.guessing==0 ) {
					print( de ); print( ":" );
				}
				{
				if (_t==null) _t=ASTNULL;
				switch ( _t.getType()) {
				case PREPROC_DIRECTIVE:
				case SEMI:
				case LITERAL_while:
				case LITERAL_do:
				case LITERAL_for:
				case LITERAL_goto:
				case LITERAL_continue:
				case LITERAL_break:
				case LITERAL_return:
				case LITERAL_case:
				case LITERAL_default:
				case LITERAL_if:
				case LITERAL_switch:
				case NStatementExpr:
				case NCompoundStatement:
				case NLabel:
				{
					statement(_t);
					_t = _retTree;
					break;
				}
				case 3:
				{
					break;
				}
				default:
				{
					throw new NoViableAltException(_t);
				}
				}
				}
				_t = __t191;
				_t = _t.getNextSibling();
				break;
			}
			case LITERAL_if:
			{
				AST __t193 = _t;
				i = _t==ASTNULL ? null :(TNode)_t;
				match(_t,LITERAL_if);
				_t = _t.getFirstChild();
				if ( inputState.guessing==0 ) {
					print( i ); print( "(" );
				}
				expr(_t);
				_t = _retTree;
				if ( inputState.guessing==0 ) {
					print( ")" );
				}
				{
				_loop195:
				do {
					if (_t==null) _t=ASTNULL;
					if ((_t.getType()==PREPROC_DIRECTIVE)) {
						pp = (TNode)_t;
						match(_t,PREPROC_DIRECTIVE);
						_t = _t.getNextSibling();
						if ( inputState.guessing==0 ) {
							print( pp ); lineDir = pp.getText(); parseLine(1);
						}
					}
					else {
						break _loop195;
					}
					
				} while (true);
				}
				statement(_t);
				_t = _retTree;
				{
				if (_t==null) _t=ASTNULL;
				switch ( _t.getType()) {
				case LITERAL_else:
				{
					e = (TNode)_t;
					match(_t,LITERAL_else);
					_t = _t.getNextSibling();
					if ( inputState.guessing==0 ) {
						print( e );
					}
					{
					_loop198:
					do {
						if (_t==null) _t=ASTNULL;
						if ((_t.getType()==PREPROC_DIRECTIVE)) {
							pc = (TNode)_t;
							match(_t,PREPROC_DIRECTIVE);
							_t = _t.getNextSibling();
							if ( inputState.guessing==0 ) {
								print( pc ); lineDir = pc.getText(); parseLine(1);
							}
						}
						else {
							break _loop198;
						}
						
					} while (true);
					}
					statement(_t);
					_t = _retTree;
					break;
				}
				case 3:
				{
					break;
				}
				default:
				{
					throw new NoViableAltException(_t);
				}
				}
				}
				_t = __t193;
				_t = _t.getNextSibling();
				break;
			}
			case LITERAL_switch:
			{
				AST __t199 = _t;
				sw = _t==ASTNULL ? null :(TNode)_t;
				match(_t,LITERAL_switch);
				_t = _t.getFirstChild();
				if ( inputState.guessing==0 ) {
					print( sw ); print( "(" );
				}
				expr(_t);
				_t = _retTree;
				if ( inputState.guessing==0 ) {
					print( ")" );
				}
				statement(_t);
				_t = _retTree;
				_t = __t199;
				_t = _t.getNextSibling();
				break;
			}
			default:
			{
				throw new NoViableAltException(_t);
			}
			}
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				if (_t!=null) {_t = _t.getNextSibling();}
			} else {
			  throw ex;
			}
		}
		_retTree = _t;
	}
	
	public final void binaryExpr(AST _t) throws RecognitionException {
		
		TNode binaryExpr_AST_in = (_t == ASTNULL) ? null : (TNode)_t;
		TNode b = null;
		
		try {      // for error handling
			b = _t==ASTNULL ? null : (TNode)_t;
			binaryOperator(_t);
			_t = _retTree;
			if ( inputState.guessing==0 ) {
				TNode e1, e2;
				e1 = (TNode) b.getFirstChild();
				e2 = (TNode) e1.getNextSibling();
				expr( e1 );
				print( b );
				expr( e2 );
				
			}
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				if (_t!=null) {_t = _t.getNextSibling();}
			} else {
			  throw ex;
			}
		}
		_retTree = _t;
	}
	
	public final void conditionalExpr(AST _t) throws RecognitionException {
		
		TNode conditionalExpr_AST_in = (_t == ASTNULL) ? null : (TNode)_t;
		TNode q = null;
		TNode c = null;
		
		try {      // for error handling
			AST __t225 = _t;
			q = _t==ASTNULL ? null :(TNode)_t;
			match(_t,QUESTION);
			_t = _t.getFirstChild();
			expr(_t);
			_t = _retTree;
			if ( inputState.guessing==0 ) {
				print( q );
			}
			{
			if (_t==null) _t=ASTNULL;
			switch ( _t.getType()) {
			case ID:
			case ASSIGN:
			case STAR:
			case LPAREN:
			case DIV_ASSIGN:
			case PLUS_ASSIGN:
			case MINUS_ASSIGN:
			case STAR_ASSIGN:
			case MOD_ASSIGN:
			case RSHIFT_ASSIGN:
			case LSHIFT_ASSIGN:
			case BAND_ASSIGN:
			case BOR_ASSIGN:
			case BXOR_ASSIGN:
			case QUESTION:
			case LOR:
			case LAND:
			case BOR:
			case BXOR:
			case BAND:
			case EQUAL:
			case NOT_EQUAL:
			case LT:
			case LTE:
			case GT:
			case GTE:
			case LSHIFT:
			case RSHIFT:
			case PLUS:
			case MINUS:
			case DIV:
			case MOD:
			case INC:
			case DEC:
			case LITERAL_sizeof:
			case CharLiteral:
			case NCast:
			case NExpressionGroup:
			case NInitializer:
			case NEmptyExpression:
			case NCommaExpr:
			case NUnaryExpr:
			case NPostfixExpr:
			case NRangeExpr:
			case NStringSeq:
			case NLcurlyInitializer:
			case NGnuAsmExpr:
			case Number:
			case LITERAL___alignof:
			{
				expr(_t);
				_t = _retTree;
				break;
			}
			case COLON:
			{
				break;
			}
			default:
			{
				throw new NoViableAltException(_t);
			}
			}
			}
			c = (TNode)_t;
			match(_t,COLON);
			_t = _t.getNextSibling();
			if ( inputState.guessing==0 ) {
				print( c );
			}
			expr(_t);
			_t = _retTree;
			_t = __t225;
			_t = _t.getNextSibling();
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				if (_t!=null) {_t = _t.getNextSibling();}
			} else {
			  throw ex;
			}
		}
		_retTree = _t;
	}
	
	public final void castExpr(AST _t) throws RecognitionException {
		
		TNode castExpr_AST_in = (_t == ASTNULL) ? null : (TNode)_t;
		TNode c = null;
		TNode rp = null;
		
		try {      // for error handling
			AST __t228 = _t;
			c = _t==ASTNULL ? null :(TNode)_t;
			match(_t,NCast);
			_t = _t.getFirstChild();
			if ( inputState.guessing==0 ) {
				print( c );
			}
			typeName(_t);
			_t = _retTree;
			rp = (TNode)_t;
			match(_t,RPAREN);
			_t = _t.getNextSibling();
			if ( inputState.guessing==0 ) {
				print( rp );
			}
			expr(_t);
			_t = _retTree;
			_t = __t228;
			_t = _t.getNextSibling();
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				if (_t!=null) {_t = _t.getNextSibling();}
			} else {
			  throw ex;
			}
		}
		_retTree = _t;
	}
	
	public final void unaryExpr(AST _t) throws RecognitionException {
		
		TNode unaryExpr_AST_in = (_t == ASTNULL) ? null : (TNode)_t;
		TNode i = null;
		TNode d = null;
		TNode u = null;
		TNode s = null;
		TNode lps = null;
		TNode rps = null;
		TNode a = null;
		TNode lpa = null;
		TNode rpa = null;
		
		try {      // for error handling
			if (_t==null) _t=ASTNULL;
			switch ( _t.getType()) {
			case INC:
			{
				AST __t247 = _t;
				i = _t==ASTNULL ? null :(TNode)_t;
				match(_t,INC);
				_t = _t.getFirstChild();
				if ( inputState.guessing==0 ) {
					print( i );
				}
				expr(_t);
				_t = _retTree;
				_t = __t247;
				_t = _t.getNextSibling();
				break;
			}
			case DEC:
			{
				AST __t248 = _t;
				d = _t==ASTNULL ? null :(TNode)_t;
				match(_t,DEC);
				_t = _t.getFirstChild();
				if ( inputState.guessing==0 ) {
					print( d );
				}
				expr(_t);
				_t = _retTree;
				_t = __t248;
				_t = _t.getNextSibling();
				break;
			}
			case NUnaryExpr:
			{
				AST __t249 = _t;
				TNode tmp17_AST_in = (TNode)_t;
				match(_t,NUnaryExpr);
				_t = _t.getFirstChild();
				u = _t==ASTNULL ? null : (TNode)_t;
				unaryOperator(_t);
				_t = _retTree;
				if ( inputState.guessing==0 ) {
					print( u );
				}
				expr(_t);
				_t = _retTree;
				_t = __t249;
				_t = _t.getNextSibling();
				break;
			}
			case LITERAL_sizeof:
			{
				AST __t250 = _t;
				s = _t==ASTNULL ? null :(TNode)_t;
				match(_t,LITERAL_sizeof);
				_t = _t.getFirstChild();
				if ( inputState.guessing==0 ) {
					print( s );
				}
				{
				boolean synPredMatched253 = false;
				if (_t==null) _t=ASTNULL;
				if (((_t.getType()==LPAREN))) {
					AST __t253 = _t;
					synPredMatched253 = true;
					inputState.guessing++;
					try {
						{
						TNode tmp18_AST_in = (TNode)_t;
						match(_t,LPAREN);
						_t = _t.getNextSibling();
						typeName(_t);
						_t = _retTree;
						}
					}
					catch (RecognitionException pe) {
						synPredMatched253 = false;
					}
					_t = __t253;
inputState.guessing--;
				}
				if ( synPredMatched253 ) {
					lps = (TNode)_t;
					match(_t,LPAREN);
					_t = _t.getNextSibling();
					if ( inputState.guessing==0 ) {
						print( lps );
					}
					typeName(_t);
					_t = _retTree;
					rps = (TNode)_t;
					match(_t,RPAREN);
					_t = _t.getNextSibling();
					if ( inputState.guessing==0 ) {
						print( rps );
					}
				}
				else if ((_tokenSet_3.member(_t.getType()))) {
					expr(_t);
					_t = _retTree;
				}
				else {
					throw new NoViableAltException(_t);
				}
				
				}
				_t = __t250;
				_t = _t.getNextSibling();
				break;
			}
			case LITERAL___alignof:
			{
				AST __t254 = _t;
				a = _t==ASTNULL ? null :(TNode)_t;
				match(_t,LITERAL___alignof);
				_t = _t.getFirstChild();
				if ( inputState.guessing==0 ) {
					print( a );
				}
				{
				boolean synPredMatched257 = false;
				if (_t==null) _t=ASTNULL;
				if (((_t.getType()==LPAREN))) {
					AST __t257 = _t;
					synPredMatched257 = true;
					inputState.guessing++;
					try {
						{
						TNode tmp19_AST_in = (TNode)_t;
						match(_t,LPAREN);
						_t = _t.getNextSibling();
						typeName(_t);
						_t = _retTree;
						}
					}
					catch (RecognitionException pe) {
						synPredMatched257 = false;
					}
					_t = __t257;
inputState.guessing--;
				}
				if ( synPredMatched257 ) {
					lpa = (TNode)_t;
					match(_t,LPAREN);
					_t = _t.getNextSibling();
					if ( inputState.guessing==0 ) {
						print( lpa );
					}
					typeName(_t);
					_t = _retTree;
					rpa = (TNode)_t;
					match(_t,RPAREN);
					_t = _t.getNextSibling();
					if ( inputState.guessing==0 ) {
						print( rpa );
					}
				}
				else if ((_tokenSet_3.member(_t.getType()))) {
					expr(_t);
					_t = _retTree;
				}
				else {
					throw new NoViableAltException(_t);
				}
				
				}
				_t = __t254;
				_t = _t.getNextSibling();
				break;
			}
			default:
			{
				throw new NoViableAltException(_t);
			}
			}
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				if (_t!=null) {_t = _t.getNextSibling();}
			} else {
			  throw ex;
			}
		}
		_retTree = _t;
	}
	
	public final void postfixExpr(AST _t) throws RecognitionException {
		
		TNode postfixExpr_AST_in = (_t == ASTNULL) ? null : (TNode)_t;
		TNode a = null;
		TNode b = null;
		TNode c = null;
		TNode d = null;
		TNode n = null;
		TNode rp = null;
		TNode lb = null;
		TNode rb = null;
		TNode f = null;
		TNode g = null;
		
		try {      // for error handling
			AST __t260 = _t;
			TNode tmp20_AST_in = (TNode)_t;
			match(_t,NPostfixExpr);
			_t = _t.getFirstChild();
			primaryExpr(_t);
			_t = _retTree;
			{
			int _cnt264=0;
			_loop264:
			do {
				if (_t==null) _t=ASTNULL;
				switch ( _t.getType()) {
				case PTR:
				{
					a = (TNode)_t;
					match(_t,PTR);
					_t = _t.getNextSibling();
					b = (TNode)_t;
					match(_t,ID);
					_t = _t.getNextSibling();
					if ( inputState.guessing==0 ) {
						print( a ); print( b );
					}
					break;
				}
				case DOT:
				{
					c = (TNode)_t;
					match(_t,DOT);
					_t = _t.getNextSibling();
					d = (TNode)_t;
					match(_t,ID);
					_t = _t.getNextSibling();
					if ( inputState.guessing==0 ) {
						print( c ); print( d );
					}
					break;
				}
				case NFunctionCallArgs:
				{
					AST __t262 = _t;
					n = _t==ASTNULL ? null :(TNode)_t;
					match(_t,NFunctionCallArgs);
					_t = _t.getFirstChild();
					if ( inputState.guessing==0 ) {
						print( n );
					}
					{
					if (_t==null) _t=ASTNULL;
					switch ( _t.getType()) {
					case ID:
					case ASSIGN:
					case STAR:
					case LPAREN:
					case DIV_ASSIGN:
					case PLUS_ASSIGN:
					case MINUS_ASSIGN:
					case STAR_ASSIGN:
					case MOD_ASSIGN:
					case RSHIFT_ASSIGN:
					case LSHIFT_ASSIGN:
					case BAND_ASSIGN:
					case BOR_ASSIGN:
					case BXOR_ASSIGN:
					case QUESTION:
					case LOR:
					case LAND:
					case BOR:
					case BXOR:
					case BAND:
					case EQUAL:
					case NOT_EQUAL:
					case LT:
					case LTE:
					case GT:
					case GTE:
					case LSHIFT:
					case RSHIFT:
					case PLUS:
					case MINUS:
					case DIV:
					case MOD:
					case INC:
					case DEC:
					case LITERAL_sizeof:
					case CharLiteral:
					case NCast:
					case NExpressionGroup:
					case NInitializer:
					case NEmptyExpression:
					case NCommaExpr:
					case NUnaryExpr:
					case NPostfixExpr:
					case NRangeExpr:
					case NStringSeq:
					case NLcurlyInitializer:
					case NGnuAsmExpr:
					case Number:
					case LITERAL___alignof:
					{
						argExprList(_t);
						_t = _retTree;
						break;
					}
					case RPAREN:
					{
						break;
					}
					default:
					{
						throw new NoViableAltException(_t);
					}
					}
					}
					rp = (TNode)_t;
					match(_t,RPAREN);
					_t = _t.getNextSibling();
					if ( inputState.guessing==0 ) {
						print( rp );
					}
					_t = __t262;
					_t = _t.getNextSibling();
					break;
				}
				case LBRACKET:
				{
					lb = (TNode)_t;
					match(_t,LBRACKET);
					_t = _t.getNextSibling();
					if ( inputState.guessing==0 ) {
						print( lb );
					}
					expr(_t);
					_t = _retTree;
					rb = (TNode)_t;
					match(_t,RBRACKET);
					_t = _t.getNextSibling();
					if ( inputState.guessing==0 ) {
						print( rb );
					}
					break;
				}
				case INC:
				{
					f = (TNode)_t;
					match(_t,INC);
					_t = _t.getNextSibling();
					if ( inputState.guessing==0 ) {
						print( f );
					}
					break;
				}
				case DEC:
				{
					g = (TNode)_t;
					match(_t,DEC);
					_t = _t.getNextSibling();
					if ( inputState.guessing==0 ) {
						print( g );
					}
					break;
				}
				default:
				{
					if ( _cnt264>=1 ) { break _loop264; } else {throw new NoViableAltException(_t);}
				}
				}
				_cnt264++;
			} while (true);
			}
			_t = __t260;
			_t = _t.getNextSibling();
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				if (_t!=null) {_t = _t.getNextSibling();}
			} else {
			  throw ex;
			}
		}
		_retTree = _t;
	}
	
	public final void primaryExpr(AST _t) throws RecognitionException {
		
		TNode primaryExpr_AST_in = (_t == ASTNULL) ? null : (TNode)_t;
		TNode i = null;
		TNode n = null;
		TNode eg = null;
		
		try {      // for error handling
			if (_t==null) _t=ASTNULL;
			switch ( _t.getType()) {
			case ID:
			{
				i = (TNode)_t;
				match(_t,ID);
				_t = _t.getNextSibling();
				if ( inputState.guessing==0 ) {
					print( i );
				}
				break;
			}
			case Number:
			{
				n = (TNode)_t;
				match(_t,Number);
				_t = _t.getNextSibling();
				if ( inputState.guessing==0 ) {
					print( n );
				}
				break;
			}
			case CharLiteral:
			{
				charConst(_t);
				_t = _retTree;
				break;
			}
			case NStringSeq:
			{
				stringConst(_t);
				_t = _retTree;
				break;
			}
			case NExpressionGroup:
			{
				AST __t266 = _t;
				eg = _t==ASTNULL ? null :(TNode)_t;
				match(_t,NExpressionGroup);
				_t = _t.getFirstChild();
				if ( inputState.guessing==0 ) {
					print( eg );
				}
				expr(_t);
				_t = _retTree;
				if ( inputState.guessing==0 ) {
					print( ")" );
				}
				_t = __t266;
				_t = _t.getNextSibling();
				break;
			}
			default:
			{
				throw new NoViableAltException(_t);
			}
			}
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				if (_t!=null) {_t = _t.getNextSibling();}
			} else {
			  throw ex;
			}
		}
		_retTree = _t;
	}
	
	public final void emptyExpr(AST _t) throws RecognitionException {
		
		TNode emptyExpr_AST_in = (_t == ASTNULL) ? null : (TNode)_t;
		
		try {      // for error handling
			TNode tmp21_AST_in = (TNode)_t;
			match(_t,NEmptyExpression);
			_t = _t.getNextSibling();
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				if (_t!=null) {_t = _t.getNextSibling();}
			} else {
			  throw ex;
			}
		}
		_retTree = _t;
	}
	
	public final void compoundStatementExpr(AST _t) throws RecognitionException {
		
		TNode compoundStatementExpr_AST_in = (_t == ASTNULL) ? null : (TNode)_t;
		TNode l = null;
		TNode r = null;
		
		try {      // for error handling
			AST __t203 = _t;
			l = _t==ASTNULL ? null :(TNode)_t;
			match(_t,LPAREN);
			_t = _t.getFirstChild();
			if ( inputState.guessing==0 ) {
				print( l );
			}
			compoundStatement(_t);
			_t = _retTree;
			r = (TNode)_t;
			match(_t,RPAREN);
			_t = _t.getNextSibling();
			if ( inputState.guessing==0 ) {
				print( r );
			}
			_t = __t203;
			_t = _t.getNextSibling();
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				if (_t!=null) {_t = _t.getNextSibling();}
			} else {
			  throw ex;
			}
		}
		_retTree = _t;
	}
	
	public final void rangeExpr(AST _t) throws RecognitionException {
		
		TNode rangeExpr_AST_in = (_t == ASTNULL) ? null : (TNode)_t;
		TNode v = null;
		
		try {      // for error handling
			AST __t205 = _t;
			TNode tmp22_AST_in = (TNode)_t;
			match(_t,NRangeExpr);
			_t = _t.getFirstChild();
			expr(_t);
			_t = _retTree;
			v = (TNode)_t;
			match(_t,VARARGS);
			_t = _t.getNextSibling();
			if ( inputState.guessing==0 ) {
				print( v );
			}
			expr(_t);
			_t = _retTree;
			_t = __t205;
			_t = _t.getNextSibling();
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				if (_t!=null) {_t = _t.getNextSibling();}
			} else {
			  throw ex;
			}
		}
		_retTree = _t;
	}
	
	public final void gnuAsmExpr(AST _t) throws RecognitionException {
		
		TNode gnuAsmExpr_AST_in = (_t == ASTNULL) ? null : (TNode)_t;
		TNode n = null;
		TNode v = null;
		TNode lp = null;
		TNode c1 = null;
		TNode c2 = null;
		TNode c3 = null;
		TNode c4 = null;
		TNode c5 = null;
		TNode c6 = null;
		TNode rp = null;
		
		try {      // for error handling
			AST __t207 = _t;
			n = _t==ASTNULL ? null :(TNode)_t;
			match(_t,NGnuAsmExpr);
			_t = _t.getFirstChild();
			if ( inputState.guessing==0 ) {
				print( n );
			}
			{
			if (_t==null) _t=ASTNULL;
			switch ( _t.getType()) {
			case LITERAL_volatile:
			{
				v = (TNode)_t;
				match(_t,LITERAL_volatile);
				_t = _t.getNextSibling();
				if ( inputState.guessing==0 ) {
					print( v );
				}
				break;
			}
			case LPAREN:
			{
				break;
			}
			default:
			{
				throw new NoViableAltException(_t);
			}
			}
			}
			lp = (TNode)_t;
			match(_t,LPAREN);
			_t = _t.getNextSibling();
			if ( inputState.guessing==0 ) {
				print( lp );
			}
			stringConst(_t);
			_t = _retTree;
			{
			if (_t==null) _t=ASTNULL;
			if ((_t.getType()==COLON)) {
				c1 = (TNode)_t;
				match(_t,COLON);
				_t = _t.getNextSibling();
				if ( inputState.guessing==0 ) {
					print( c1 );
				}
				{
				if (_t==null) _t=ASTNULL;
				switch ( _t.getType()) {
				case NStringSeq:
				{
					strOptExprPair(_t);
					_t = _retTree;
					{
					_loop212:
					do {
						if (_t==null) _t=ASTNULL;
						if ((_t.getType()==COMMA)) {
							c2 = (TNode)_t;
							match(_t,COMMA);
							_t = _t.getNextSibling();
							if ( inputState.guessing==0 ) {
								print( c2 );
							}
							strOptExprPair(_t);
							_t = _retTree;
						}
						else {
							break _loop212;
						}
						
					} while (true);
					}
					break;
				}
				case COLON:
				case RPAREN:
				{
					break;
				}
				default:
				{
					throw new NoViableAltException(_t);
				}
				}
				}
				{
				if (_t==null) _t=ASTNULL;
				if ((_t.getType()==COLON)) {
					c3 = (TNode)_t;
					match(_t,COLON);
					_t = _t.getNextSibling();
					if ( inputState.guessing==0 ) {
						print( c3 );
					}
					{
					if (_t==null) _t=ASTNULL;
					switch ( _t.getType()) {
					case NStringSeq:
					{
						strOptExprPair(_t);
						_t = _retTree;
						{
						_loop216:
						do {
							if (_t==null) _t=ASTNULL;
							if ((_t.getType()==COMMA)) {
								c4 = (TNode)_t;
								match(_t,COMMA);
								_t = _t.getNextSibling();
								if ( inputState.guessing==0 ) {
									print( c4 );
								}
								strOptExprPair(_t);
								_t = _retTree;
							}
							else {
								break _loop216;
							}
							
						} while (true);
						}
						break;
					}
					case COLON:
					case RPAREN:
					{
						break;
					}
					default:
					{
						throw new NoViableAltException(_t);
					}
					}
					}
				}
				else if ((_t.getType()==COLON||_t.getType()==RPAREN)) {
				}
				else {
					throw new NoViableAltException(_t);
				}
				
				}
			}
			else if ((_t.getType()==COLON||_t.getType()==RPAREN)) {
			}
			else {
				throw new NoViableAltException(_t);
			}
			
			}
			{
			if (_t==null) _t=ASTNULL;
			switch ( _t.getType()) {
			case COLON:
			{
				c5 = (TNode)_t;
				match(_t,COLON);
				_t = _t.getNextSibling();
				if ( inputState.guessing==0 ) {
					print( c5 );
				}
				stringConst(_t);
				_t = _retTree;
				{
				_loop219:
				do {
					if (_t==null) _t=ASTNULL;
					if ((_t.getType()==COMMA)) {
						c6 = (TNode)_t;
						match(_t,COMMA);
						_t = _t.getNextSibling();
						if ( inputState.guessing==0 ) {
							print( c6 );
						}
						stringConst(_t);
						_t = _retTree;
					}
					else {
						break _loop219;
					}
					
				} while (true);
				}
				break;
			}
			case RPAREN:
			{
				break;
			}
			default:
			{
				throw new NoViableAltException(_t);
			}
			}
			}
			rp = (TNode)_t;
			match(_t,RPAREN);
			_t = _t.getNextSibling();
			if ( inputState.guessing==0 ) {
				print( rp );
			}
			_t = __t207;
			_t = _t.getNextSibling();
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				if (_t!=null) {_t = _t.getNextSibling();}
			} else {
			  throw ex;
			}
		}
		_retTree = _t;
	}
	
	protected final void stringConst(AST _t) throws RecognitionException {
		
		TNode stringConst_AST_in = (_t == ASTNULL) ? null : (TNode)_t;
		TNode s = null;
		
		try {      // for error handling
			AST __t272 = _t;
			TNode tmp23_AST_in = (TNode)_t;
			match(_t,NStringSeq);
			_t = _t.getFirstChild();
			{
			int _cnt274=0;
			_loop274:
			do {
				if (_t==null) _t=ASTNULL;
				if ((_t.getType()==StringLiteral)) {
					s = (TNode)_t;
					match(_t,StringLiteral);
					_t = _t.getNextSibling();
					if ( inputState.guessing==0 ) {
						print( s );
					}
				}
				else {
					if ( _cnt274>=1 ) { break _loop274; } else {throw new NoViableAltException(_t);}
				}
				
				_cnt274++;
			} while (true);
			}
			_t = __t272;
			_t = _t.getNextSibling();
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				if (_t!=null) {_t = _t.getNextSibling();}
			} else {
			  throw ex;
			}
		}
		_retTree = _t;
	}
	
	public final void strOptExprPair(AST _t) throws RecognitionException {
		
		TNode strOptExprPair_AST_in = (_t == ASTNULL) ? null : (TNode)_t;
		TNode l = null;
		TNode r = null;
		
		try {      // for error handling
			stringConst(_t);
			_t = _retTree;
			{
			if (_t==null) _t=ASTNULL;
			switch ( _t.getType()) {
			case LPAREN:
			{
				l = (TNode)_t;
				match(_t,LPAREN);
				_t = _t.getNextSibling();
				if ( inputState.guessing==0 ) {
					print( l );
				}
				expr(_t);
				_t = _retTree;
				r = (TNode)_t;
				match(_t,RPAREN);
				_t = _t.getNextSibling();
				if ( inputState.guessing==0 ) {
					print( r );
				}
				break;
			}
			case COMMA:
			case COLON:
			case RPAREN:
			{
				break;
			}
			default:
			{
				throw new NoViableAltException(_t);
			}
			}
			}
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				if (_t!=null) {_t = _t.getNextSibling();}
			} else {
			  throw ex;
			}
		}
		_retTree = _t;
	}
	
	public final void binaryOperator(AST _t) throws RecognitionException {
		
		TNode binaryOperator_AST_in = (_t == ASTNULL) ? null : (TNode)_t;
		
		try {      // for error handling
			if (_t==null) _t=ASTNULL;
			switch ( _t.getType()) {
			case ASSIGN:
			{
				TNode tmp24_AST_in = (TNode)_t;
				match(_t,ASSIGN);
				_t = _t.getNextSibling();
				break;
			}
			case DIV_ASSIGN:
			{
				TNode tmp25_AST_in = (TNode)_t;
				match(_t,DIV_ASSIGN);
				_t = _t.getNextSibling();
				break;
			}
			case PLUS_ASSIGN:
			{
				TNode tmp26_AST_in = (TNode)_t;
				match(_t,PLUS_ASSIGN);
				_t = _t.getNextSibling();
				break;
			}
			case MINUS_ASSIGN:
			{
				TNode tmp27_AST_in = (TNode)_t;
				match(_t,MINUS_ASSIGN);
				_t = _t.getNextSibling();
				break;
			}
			case STAR_ASSIGN:
			{
				TNode tmp28_AST_in = (TNode)_t;
				match(_t,STAR_ASSIGN);
				_t = _t.getNextSibling();
				break;
			}
			case MOD_ASSIGN:
			{
				TNode tmp29_AST_in = (TNode)_t;
				match(_t,MOD_ASSIGN);
				_t = _t.getNextSibling();
				break;
			}
			case RSHIFT_ASSIGN:
			{
				TNode tmp30_AST_in = (TNode)_t;
				match(_t,RSHIFT_ASSIGN);
				_t = _t.getNextSibling();
				break;
			}
			case LSHIFT_ASSIGN:
			{
				TNode tmp31_AST_in = (TNode)_t;
				match(_t,LSHIFT_ASSIGN);
				_t = _t.getNextSibling();
				break;
			}
			case BAND_ASSIGN:
			{
				TNode tmp32_AST_in = (TNode)_t;
				match(_t,BAND_ASSIGN);
				_t = _t.getNextSibling();
				break;
			}
			case BOR_ASSIGN:
			{
				TNode tmp33_AST_in = (TNode)_t;
				match(_t,BOR_ASSIGN);
				_t = _t.getNextSibling();
				break;
			}
			case BXOR_ASSIGN:
			{
				TNode tmp34_AST_in = (TNode)_t;
				match(_t,BXOR_ASSIGN);
				_t = _t.getNextSibling();
				break;
			}
			case LOR:
			{
				TNode tmp35_AST_in = (TNode)_t;
				match(_t,LOR);
				_t = _t.getNextSibling();
				break;
			}
			case LAND:
			{
				TNode tmp36_AST_in = (TNode)_t;
				match(_t,LAND);
				_t = _t.getNextSibling();
				break;
			}
			case BOR:
			{
				TNode tmp37_AST_in = (TNode)_t;
				match(_t,BOR);
				_t = _t.getNextSibling();
				break;
			}
			case BXOR:
			{
				TNode tmp38_AST_in = (TNode)_t;
				match(_t,BXOR);
				_t = _t.getNextSibling();
				break;
			}
			case BAND:
			{
				TNode tmp39_AST_in = (TNode)_t;
				match(_t,BAND);
				_t = _t.getNextSibling();
				break;
			}
			case EQUAL:
			{
				TNode tmp40_AST_in = (TNode)_t;
				match(_t,EQUAL);
				_t = _t.getNextSibling();
				break;
			}
			case NOT_EQUAL:
			{
				TNode tmp41_AST_in = (TNode)_t;
				match(_t,NOT_EQUAL);
				_t = _t.getNextSibling();
				break;
			}
			case LT:
			{
				TNode tmp42_AST_in = (TNode)_t;
				match(_t,LT);
				_t = _t.getNextSibling();
				break;
			}
			case LTE:
			{
				TNode tmp43_AST_in = (TNode)_t;
				match(_t,LTE);
				_t = _t.getNextSibling();
				break;
			}
			case GT:
			{
				TNode tmp44_AST_in = (TNode)_t;
				match(_t,GT);
				_t = _t.getNextSibling();
				break;
			}
			case GTE:
			{
				TNode tmp45_AST_in = (TNode)_t;
				match(_t,GTE);
				_t = _t.getNextSibling();
				break;
			}
			case LSHIFT:
			{
				TNode tmp46_AST_in = (TNode)_t;
				match(_t,LSHIFT);
				_t = _t.getNextSibling();
				break;
			}
			case RSHIFT:
			{
				TNode tmp47_AST_in = (TNode)_t;
				match(_t,RSHIFT);
				_t = _t.getNextSibling();
				break;
			}
			case PLUS:
			{
				TNode tmp48_AST_in = (TNode)_t;
				match(_t,PLUS);
				_t = _t.getNextSibling();
				break;
			}
			case MINUS:
			{
				TNode tmp49_AST_in = (TNode)_t;
				match(_t,MINUS);
				_t = _t.getNextSibling();
				break;
			}
			case STAR:
			{
				TNode tmp50_AST_in = (TNode)_t;
				match(_t,STAR);
				_t = _t.getNextSibling();
				break;
			}
			case DIV:
			{
				TNode tmp51_AST_in = (TNode)_t;
				match(_t,DIV);
				_t = _t.getNextSibling();
				break;
			}
			case MOD:
			{
				TNode tmp52_AST_in = (TNode)_t;
				match(_t,MOD);
				_t = _t.getNextSibling();
				break;
			}
			case NCommaExpr:
			{
				TNode tmp53_AST_in = (TNode)_t;
				match(_t,NCommaExpr);
				_t = _t.getNextSibling();
				break;
			}
			default:
			{
				throw new NoViableAltException(_t);
			}
			}
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				if (_t!=null) {_t = _t.getNextSibling();}
			} else {
			  throw ex;
			}
		}
		_retTree = _t;
	}
	
	public final void unaryOperator(AST _t) throws RecognitionException {
		
		TNode unaryOperator_AST_in = (_t == ASTNULL) ? null : (TNode)_t;
		
		try {      // for error handling
			if (_t==null) _t=ASTNULL;
			switch ( _t.getType()) {
			case BAND:
			{
				TNode tmp54_AST_in = (TNode)_t;
				match(_t,BAND);
				_t = _t.getNextSibling();
				break;
			}
			case STAR:
			{
				TNode tmp55_AST_in = (TNode)_t;
				match(_t,STAR);
				_t = _t.getNextSibling();
				break;
			}
			case PLUS:
			{
				TNode tmp56_AST_in = (TNode)_t;
				match(_t,PLUS);
				_t = _t.getNextSibling();
				break;
			}
			case MINUS:
			{
				TNode tmp57_AST_in = (TNode)_t;
				match(_t,MINUS);
				_t = _t.getNextSibling();
				break;
			}
			case BNOT:
			{
				TNode tmp58_AST_in = (TNode)_t;
				match(_t,BNOT);
				_t = _t.getNextSibling();
				break;
			}
			case LNOT:
			{
				TNode tmp59_AST_in = (TNode)_t;
				match(_t,LNOT);
				_t = _t.getNextSibling();
				break;
			}
			case LAND:
			{
				TNode tmp60_AST_in = (TNode)_t;
				match(_t,LAND);
				_t = _t.getNextSibling();
				break;
			}
			case LITERAL___real:
			{
				TNode tmp61_AST_in = (TNode)_t;
				match(_t,LITERAL___real);
				_t = _t.getNextSibling();
				break;
			}
			case LITERAL___imag:
			{
				TNode tmp62_AST_in = (TNode)_t;
				match(_t,LITERAL___imag);
				_t = _t.getNextSibling();
				break;
			}
			case PREPROC_DIRECTIVE:
			{
				TNode tmp63_AST_in = (TNode)_t;
				match(_t,PREPROC_DIRECTIVE);
				_t = _t.getNextSibling();
				break;
			}
			default:
			{
				throw new NoViableAltException(_t);
			}
			}
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				if (_t!=null) {_t = _t.getNextSibling();}
			} else {
			  throw ex;
			}
		}
		_retTree = _t;
	}
	
	public final void argExprList(AST _t) throws RecognitionException {
		
		TNode argExprList_AST_in = (_t == ASTNULL) ? null : (TNode)_t;
		
		try {      // for error handling
			expr(_t);
			_t = _retTree;
			{
			_loop269:
			do {
				if (_t==null) _t=ASTNULL;
				if ((_tokenSet_3.member(_t.getType()))) {
					if ( inputState.guessing==0 ) {
						print( "," );
					}
					expr(_t);
					_t = _retTree;
				}
				else {
					break _loop269;
				}
				
			} while (true);
			}
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				if (_t!=null) {_t = _t.getNextSibling();}
			} else {
			  throw ex;
			}
		}
		_retTree = _t;
	}
	
	protected final void charConst(AST _t) throws RecognitionException {
		
		TNode charConst_AST_in = (_t == ASTNULL) ? null : (TNode)_t;
		TNode c = null;
		
		try {      // for error handling
			c = (TNode)_t;
			match(_t,CharLiteral);
			_t = _t.getNextSibling();
			if ( inputState.guessing==0 ) {
				print( c );
			}
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				if (_t!=null) {_t = _t.getNextSibling();}
			} else {
			  throw ex;
			}
		}
		_retTree = _t;
	}
	
	protected final void intConst(AST _t) throws RecognitionException {
		
		TNode intConst_AST_in = (_t == ASTNULL) ? null : (TNode)_t;
		
		try {      // for error handling
			if (_t==null) _t=ASTNULL;
			switch ( _t.getType()) {
			case IntOctalConst:
			{
				TNode tmp64_AST_in = (TNode)_t;
				match(_t,IntOctalConst);
				_t = _t.getNextSibling();
				break;
			}
			case LongOctalConst:
			{
				TNode tmp65_AST_in = (TNode)_t;
				match(_t,LongOctalConst);
				_t = _t.getNextSibling();
				break;
			}
			case UnsignedOctalConst:
			{
				TNode tmp66_AST_in = (TNode)_t;
				match(_t,UnsignedOctalConst);
				_t = _t.getNextSibling();
				break;
			}
			case IntIntConst:
			{
				TNode tmp67_AST_in = (TNode)_t;
				match(_t,IntIntConst);
				_t = _t.getNextSibling();
				break;
			}
			case LongIntConst:
			{
				TNode tmp68_AST_in = (TNode)_t;
				match(_t,LongIntConst);
				_t = _t.getNextSibling();
				break;
			}
			case UnsignedIntConst:
			{
				TNode tmp69_AST_in = (TNode)_t;
				match(_t,UnsignedIntConst);
				_t = _t.getNextSibling();
				break;
			}
			case IntHexConst:
			{
				TNode tmp70_AST_in = (TNode)_t;
				match(_t,IntHexConst);
				_t = _t.getNextSibling();
				break;
			}
			case LongHexConst:
			{
				TNode tmp71_AST_in = (TNode)_t;
				match(_t,LongHexConst);
				_t = _t.getNextSibling();
				break;
			}
			case UnsignedHexConst:
			{
				TNode tmp72_AST_in = (TNode)_t;
				match(_t,UnsignedHexConst);
				_t = _t.getNextSibling();
				break;
			}
			default:
			{
				throw new NoViableAltException(_t);
			}
			}
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				if (_t!=null) {_t = _t.getNextSibling();}
			} else {
			  throw ex;
			}
		}
		_retTree = _t;
	}
	
	protected final void floatConst(AST _t) throws RecognitionException {
		
		TNode floatConst_AST_in = (_t == ASTNULL) ? null : (TNode)_t;
		
		try {      // for error handling
			if (_t==null) _t=ASTNULL;
			switch ( _t.getType()) {
			case FloatDoubleConst:
			{
				TNode tmp73_AST_in = (TNode)_t;
				match(_t,FloatDoubleConst);
				_t = _t.getNextSibling();
				break;
			}
			case DoubleDoubleConst:
			{
				TNode tmp74_AST_in = (TNode)_t;
				match(_t,DoubleDoubleConst);
				_t = _t.getNextSibling();
				break;
			}
			case LongDoubleConst:
			{
				TNode tmp75_AST_in = (TNode)_t;
				match(_t,LongDoubleConst);
				_t = _t.getNextSibling();
				break;
			}
			default:
			{
				throw new NoViableAltException(_t);
			}
			}
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				if (_t!=null) {_t = _t.getNextSibling();}
			} else {
			  throw ex;
			}
		}
		_retTree = _t;
	}
	
	public final void commaExpr(AST _t) throws RecognitionException {
		
		TNode commaExpr_AST_in = (_t == ASTNULL) ? null : (TNode)_t;
		
		try {      // for error handling
			AST __t278 = _t;
			TNode tmp76_AST_in = (TNode)_t;
			match(_t,NCommaExpr);
			_t = _t.getFirstChild();
			expr(_t);
			_t = _retTree;
			expr(_t);
			_t = _retTree;
			_t = __t278;
			_t = _t.getNextSibling();
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				if (_t!=null) {_t = _t.getNextSibling();}
			} else {
			  throw ex;
			}
		}
		_retTree = _t;
	}
	
	public final void assignExpr(AST _t) throws RecognitionException {
		
		TNode assignExpr_AST_in = (_t == ASTNULL) ? null : (TNode)_t;
		
		try {      // for error handling
			if (_t==null) _t=ASTNULL;
			switch ( _t.getType()) {
			case ASSIGN:
			{
				AST __t280 = _t;
				TNode tmp77_AST_in = (TNode)_t;
				match(_t,ASSIGN);
				_t = _t.getFirstChild();
				expr(_t);
				_t = _retTree;
				expr(_t);
				_t = _retTree;
				_t = __t280;
				_t = _t.getNextSibling();
				break;
			}
			case DIV_ASSIGN:
			{
				AST __t281 = _t;
				TNode tmp78_AST_in = (TNode)_t;
				match(_t,DIV_ASSIGN);
				_t = _t.getFirstChild();
				expr(_t);
				_t = _retTree;
				expr(_t);
				_t = _retTree;
				_t = __t281;
				_t = _t.getNextSibling();
				break;
			}
			case PLUS_ASSIGN:
			{
				AST __t282 = _t;
				TNode tmp79_AST_in = (TNode)_t;
				match(_t,PLUS_ASSIGN);
				_t = _t.getFirstChild();
				expr(_t);
				_t = _retTree;
				expr(_t);
				_t = _retTree;
				_t = __t282;
				_t = _t.getNextSibling();
				break;
			}
			case MINUS_ASSIGN:
			{
				AST __t283 = _t;
				TNode tmp80_AST_in = (TNode)_t;
				match(_t,MINUS_ASSIGN);
				_t = _t.getFirstChild();
				expr(_t);
				_t = _retTree;
				expr(_t);
				_t = _retTree;
				_t = __t283;
				_t = _t.getNextSibling();
				break;
			}
			case STAR_ASSIGN:
			{
				AST __t284 = _t;
				TNode tmp81_AST_in = (TNode)_t;
				match(_t,STAR_ASSIGN);
				_t = _t.getFirstChild();
				expr(_t);
				_t = _retTree;
				expr(_t);
				_t = _retTree;
				_t = __t284;
				_t = _t.getNextSibling();
				break;
			}
			case MOD_ASSIGN:
			{
				AST __t285 = _t;
				TNode tmp82_AST_in = (TNode)_t;
				match(_t,MOD_ASSIGN);
				_t = _t.getFirstChild();
				expr(_t);
				_t = _retTree;
				expr(_t);
				_t = _retTree;
				_t = __t285;
				_t = _t.getNextSibling();
				break;
			}
			case RSHIFT_ASSIGN:
			{
				AST __t286 = _t;
				TNode tmp83_AST_in = (TNode)_t;
				match(_t,RSHIFT_ASSIGN);
				_t = _t.getFirstChild();
				expr(_t);
				_t = _retTree;
				expr(_t);
				_t = _retTree;
				_t = __t286;
				_t = _t.getNextSibling();
				break;
			}
			case LSHIFT_ASSIGN:
			{
				AST __t287 = _t;
				TNode tmp84_AST_in = (TNode)_t;
				match(_t,LSHIFT_ASSIGN);
				_t = _t.getFirstChild();
				expr(_t);
				_t = _retTree;
				expr(_t);
				_t = _retTree;
				_t = __t287;
				_t = _t.getNextSibling();
				break;
			}
			case BAND_ASSIGN:
			{
				AST __t288 = _t;
				TNode tmp85_AST_in = (TNode)_t;
				match(_t,BAND_ASSIGN);
				_t = _t.getFirstChild();
				expr(_t);
				_t = _retTree;
				expr(_t);
				_t = _retTree;
				_t = __t288;
				_t = _t.getNextSibling();
				break;
			}
			case BOR_ASSIGN:
			{
				AST __t289 = _t;
				TNode tmp86_AST_in = (TNode)_t;
				match(_t,BOR_ASSIGN);
				_t = _t.getFirstChild();
				expr(_t);
				_t = _retTree;
				expr(_t);
				_t = _retTree;
				_t = __t289;
				_t = _t.getNextSibling();
				break;
			}
			case BXOR_ASSIGN:
			{
				AST __t290 = _t;
				TNode tmp87_AST_in = (TNode)_t;
				match(_t,BXOR_ASSIGN);
				_t = _t.getFirstChild();
				expr(_t);
				_t = _retTree;
				expr(_t);
				_t = _retTree;
				_t = __t290;
				_t = _t.getNextSibling();
				break;
			}
			default:
			{
				throw new NoViableAltException(_t);
			}
			}
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				if (_t!=null) {_t = _t.getNextSibling();}
			} else {
			  throw ex;
			}
		}
		_retTree = _t;
	}
	
	public final void logicalOrExpr(AST _t) throws RecognitionException {
		
		TNode logicalOrExpr_AST_in = (_t == ASTNULL) ? null : (TNode)_t;
		
		try {      // for error handling
			AST __t292 = _t;
			TNode tmp88_AST_in = (TNode)_t;
			match(_t,LOR);
			_t = _t.getFirstChild();
			expr(_t);
			_t = _retTree;
			expr(_t);
			_t = _retTree;
			_t = __t292;
			_t = _t.getNextSibling();
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				if (_t!=null) {_t = _t.getNextSibling();}
			} else {
			  throw ex;
			}
		}
		_retTree = _t;
	}
	
	public final void logicalAndExpr(AST _t) throws RecognitionException {
		
		TNode logicalAndExpr_AST_in = (_t == ASTNULL) ? null : (TNode)_t;
		
		try {      // for error handling
			AST __t294 = _t;
			TNode tmp89_AST_in = (TNode)_t;
			match(_t,LAND);
			_t = _t.getFirstChild();
			expr(_t);
			_t = _retTree;
			expr(_t);
			_t = _retTree;
			_t = __t294;
			_t = _t.getNextSibling();
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				if (_t!=null) {_t = _t.getNextSibling();}
			} else {
			  throw ex;
			}
		}
		_retTree = _t;
	}
	
	public final void inclusiveOrExpr(AST _t) throws RecognitionException {
		
		TNode inclusiveOrExpr_AST_in = (_t == ASTNULL) ? null : (TNode)_t;
		
		try {      // for error handling
			AST __t296 = _t;
			TNode tmp90_AST_in = (TNode)_t;
			match(_t,BOR);
			_t = _t.getFirstChild();
			expr(_t);
			_t = _retTree;
			expr(_t);
			_t = _retTree;
			_t = __t296;
			_t = _t.getNextSibling();
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				if (_t!=null) {_t = _t.getNextSibling();}
			} else {
			  throw ex;
			}
		}
		_retTree = _t;
	}
	
	public final void exclusiveOrExpr(AST _t) throws RecognitionException {
		
		TNode exclusiveOrExpr_AST_in = (_t == ASTNULL) ? null : (TNode)_t;
		
		try {      // for error handling
			AST __t298 = _t;
			TNode tmp91_AST_in = (TNode)_t;
			match(_t,BXOR);
			_t = _t.getFirstChild();
			expr(_t);
			_t = _retTree;
			expr(_t);
			_t = _retTree;
			_t = __t298;
			_t = _t.getNextSibling();
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				if (_t!=null) {_t = _t.getNextSibling();}
			} else {
			  throw ex;
			}
		}
		_retTree = _t;
	}
	
	public final void bitAndExpr(AST _t) throws RecognitionException {
		
		TNode bitAndExpr_AST_in = (_t == ASTNULL) ? null : (TNode)_t;
		
		try {      // for error handling
			AST __t300 = _t;
			TNode tmp92_AST_in = (TNode)_t;
			match(_t,BAND);
			_t = _t.getFirstChild();
			expr(_t);
			_t = _retTree;
			expr(_t);
			_t = _retTree;
			_t = __t300;
			_t = _t.getNextSibling();
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				if (_t!=null) {_t = _t.getNextSibling();}
			} else {
			  throw ex;
			}
		}
		_retTree = _t;
	}
	
	public final void equalityExpr(AST _t) throws RecognitionException {
		
		TNode equalityExpr_AST_in = (_t == ASTNULL) ? null : (TNode)_t;
		
		try {      // for error handling
			if (_t==null) _t=ASTNULL;
			switch ( _t.getType()) {
			case EQUAL:
			{
				AST __t302 = _t;
				TNode tmp93_AST_in = (TNode)_t;
				match(_t,EQUAL);
				_t = _t.getFirstChild();
				expr(_t);
				_t = _retTree;
				expr(_t);
				_t = _retTree;
				_t = __t302;
				_t = _t.getNextSibling();
				break;
			}
			case NOT_EQUAL:
			{
				AST __t303 = _t;
				TNode tmp94_AST_in = (TNode)_t;
				match(_t,NOT_EQUAL);
				_t = _t.getFirstChild();
				expr(_t);
				_t = _retTree;
				expr(_t);
				_t = _retTree;
				_t = __t303;
				_t = _t.getNextSibling();
				break;
			}
			default:
			{
				throw new NoViableAltException(_t);
			}
			}
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				if (_t!=null) {_t = _t.getNextSibling();}
			} else {
			  throw ex;
			}
		}
		_retTree = _t;
	}
	
	public final void relationalExpr(AST _t) throws RecognitionException {
		
		TNode relationalExpr_AST_in = (_t == ASTNULL) ? null : (TNode)_t;
		
		try {      // for error handling
			if (_t==null) _t=ASTNULL;
			switch ( _t.getType()) {
			case LT:
			{
				AST __t305 = _t;
				TNode tmp95_AST_in = (TNode)_t;
				match(_t,LT);
				_t = _t.getFirstChild();
				expr(_t);
				_t = _retTree;
				expr(_t);
				_t = _retTree;
				_t = __t305;
				_t = _t.getNextSibling();
				break;
			}
			case LTE:
			{
				AST __t306 = _t;
				TNode tmp96_AST_in = (TNode)_t;
				match(_t,LTE);
				_t = _t.getFirstChild();
				expr(_t);
				_t = _retTree;
				expr(_t);
				_t = _retTree;
				_t = __t306;
				_t = _t.getNextSibling();
				break;
			}
			case GT:
			{
				AST __t307 = _t;
				TNode tmp97_AST_in = (TNode)_t;
				match(_t,GT);
				_t = _t.getFirstChild();
				expr(_t);
				_t = _retTree;
				expr(_t);
				_t = _retTree;
				_t = __t307;
				_t = _t.getNextSibling();
				break;
			}
			case GTE:
			{
				AST __t308 = _t;
				TNode tmp98_AST_in = (TNode)_t;
				match(_t,GTE);
				_t = _t.getFirstChild();
				expr(_t);
				_t = _retTree;
				expr(_t);
				_t = _retTree;
				_t = __t308;
				_t = _t.getNextSibling();
				break;
			}
			default:
			{
				throw new NoViableAltException(_t);
			}
			}
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				if (_t!=null) {_t = _t.getNextSibling();}
			} else {
			  throw ex;
			}
		}
		_retTree = _t;
	}
	
	public final void shiftExpr(AST _t) throws RecognitionException {
		
		TNode shiftExpr_AST_in = (_t == ASTNULL) ? null : (TNode)_t;
		
		try {      // for error handling
			if (_t==null) _t=ASTNULL;
			switch ( _t.getType()) {
			case LSHIFT:
			{
				AST __t310 = _t;
				TNode tmp99_AST_in = (TNode)_t;
				match(_t,LSHIFT);
				_t = _t.getFirstChild();
				expr(_t);
				_t = _retTree;
				expr(_t);
				_t = _retTree;
				_t = __t310;
				_t = _t.getNextSibling();
				break;
			}
			case RSHIFT:
			{
				AST __t311 = _t;
				TNode tmp100_AST_in = (TNode)_t;
				match(_t,RSHIFT);
				_t = _t.getFirstChild();
				expr(_t);
				_t = _retTree;
				expr(_t);
				_t = _retTree;
				_t = __t311;
				_t = _t.getNextSibling();
				break;
			}
			default:
			{
				throw new NoViableAltException(_t);
			}
			}
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				if (_t!=null) {_t = _t.getNextSibling();}
			} else {
			  throw ex;
			}
		}
		_retTree = _t;
	}
	
	public final void additiveExpr(AST _t) throws RecognitionException {
		
		TNode additiveExpr_AST_in = (_t == ASTNULL) ? null : (TNode)_t;
		
		try {      // for error handling
			if (_t==null) _t=ASTNULL;
			switch ( _t.getType()) {
			case PLUS:
			{
				AST __t313 = _t;
				TNode tmp101_AST_in = (TNode)_t;
				match(_t,PLUS);
				_t = _t.getFirstChild();
				expr(_t);
				_t = _retTree;
				expr(_t);
				_t = _retTree;
				_t = __t313;
				_t = _t.getNextSibling();
				break;
			}
			case MINUS:
			{
				AST __t314 = _t;
				TNode tmp102_AST_in = (TNode)_t;
				match(_t,MINUS);
				_t = _t.getFirstChild();
				expr(_t);
				_t = _retTree;
				expr(_t);
				_t = _retTree;
				_t = __t314;
				_t = _t.getNextSibling();
				break;
			}
			default:
			{
				throw new NoViableAltException(_t);
			}
			}
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				if (_t!=null) {_t = _t.getNextSibling();}
			} else {
			  throw ex;
			}
		}
		_retTree = _t;
	}
	
	public final void multExpr(AST _t) throws RecognitionException {
		
		TNode multExpr_AST_in = (_t == ASTNULL) ? null : (TNode)_t;
		
		try {      // for error handling
			if (_t==null) _t=ASTNULL;
			switch ( _t.getType()) {
			case STAR:
			{
				AST __t316 = _t;
				TNode tmp103_AST_in = (TNode)_t;
				match(_t,STAR);
				_t = _t.getFirstChild();
				expr(_t);
				_t = _retTree;
				expr(_t);
				_t = _retTree;
				_t = __t316;
				_t = _t.getNextSibling();
				break;
			}
			case DIV:
			{
				AST __t317 = _t;
				TNode tmp104_AST_in = (TNode)_t;
				match(_t,DIV);
				_t = _t.getFirstChild();
				expr(_t);
				_t = _retTree;
				expr(_t);
				_t = _retTree;
				_t = __t317;
				_t = _t.getNextSibling();
				break;
			}
			case MOD:
			{
				AST __t318 = _t;
				TNode tmp105_AST_in = (TNode)_t;
				match(_t,MOD);
				_t = _t.getFirstChild();
				expr(_t);
				_t = _retTree;
				expr(_t);
				_t = _retTree;
				_t = __t318;
				_t = _t.getNextSibling();
				break;
			}
			default:
			{
				throw new NoViableAltException(_t);
			}
			}
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				if (_t!=null) {_t = _t.getNextSibling();}
			} else {
			  throw ex;
			}
		}
		_retTree = _t;
	}
	
	
	public static final String[] _tokenNames = {
		"<0>",
		"EOF",
		"<2>",
		"NULL_TREE_LOOKAHEAD",
		"\"typedef\"",
		"a line directive",
		"\"asm\"",
		"\"volatile\"",
		"LCURLY",
		"RCURLY",
		"SEMI",
		"\"struct\"",
		"\"union\"",
		"\"enum\"",
		"\"auto\"",
		"\"register\"",
		"\"extern\"",
		"\"static\"",
		"\"const\"",
		"\"void\"",
		"\"char\"",
		"\"short\"",
		"\"int\"",
		"\"long\"",
		"\"float\"",
		"\"double\"",
		"\"signed\"",
		"\"__builtin_va_list\"",
		"\"unsigned\"",
		"ID",
		"COMMA",
		"COLON",
		"ASSIGN",
		"STAR",
		"\"__restrict\"",
		"LPAREN",
		"RPAREN",
		"LBRACKET",
		"RBRACKET",
		"VARARGS",
		"\"while\"",
		"\"do\"",
		"\"for\"",
		"\"goto\"",
		"\"continue\"",
		"\"break\"",
		"\"return\"",
		"\"case\"",
		"\"default\"",
		"\"if\"",
		"\"else\"",
		"\"switch\"",
		"DIV_ASSIGN",
		"PLUS_ASSIGN",
		"MINUS_ASSIGN",
		"STAR_ASSIGN",
		"MOD_ASSIGN",
		"RSHIFT_ASSIGN",
		"LSHIFT_ASSIGN",
		"BAND_ASSIGN",
		"BOR_ASSIGN",
		"BXOR_ASSIGN",
		"QUESTION",
		"LOR",
		"LAND",
		"BOR",
		"BXOR",
		"BAND",
		"EQUAL",
		"NOT_EQUAL",
		"LT",
		"LTE",
		"GT",
		"GTE",
		"LSHIFT",
		"RSHIFT",
		"PLUS",
		"MINUS",
		"DIV",
		"MOD",
		"INC",
		"DEC",
		"\"sizeof\"",
		"BNOT",
		"LNOT",
		"PTR",
		"DOT",
		"CharLiteral",
		"StringLiteral",
		"IntOctalConst",
		"LongOctalConst",
		"UnsignedOctalConst",
		"IntIntConst",
		"LongIntConst",
		"UnsignedIntConst",
		"IntHexConst",
		"LongHexConst",
		"UnsignedHexConst",
		"FloatDoubleConst",
		"DoubleDoubleConst",
		"LongDoubleConst",
		"NTypedefName",
		"NInitDecl",
		"NDeclarator",
		"NStructDeclarator",
		"NDeclaration",
		"NCast",
		"NPointerGroup",
		"NExpressionGroup",
		"NFunctionCallArgs",
		"NNonemptyAbstractDeclarator",
		"NInitializer",
		"NStatementExpr",
		"NEmptyExpression",
		"NParameterTypeList",
		"NFunctionDef",
		"NCompoundStatement",
		"NParameterDeclaration",
		"NCommaExpr",
		"NUnaryExpr",
		"NLabel",
		"NPostfixExpr",
		"NRangeExpr",
		"NStringSeq",
		"NInitializerElementLabel",
		"NLcurlyInitializer",
		"NAsmAttribute",
		"NGnuAsmExpr",
		"NTypeMissing",
		"Vocabulary",
		"Whitespace",
		"Comment",
		"CPPComment",
		"Space",
		"LineDirective",
		"BadStringLiteral",
		"Escape",
		"Digit",
		"LongSuffix",
		"UnsignedSuffix",
		"FloatSuffix",
		"Exponent",
		"Number",
		"\"__label__\"",
		"\"inline\"",
		"\"__inline\"",
		"\"typeof\"",
		"\"__complex\"",
		"\"__attribute\"",
		"\"__alignof\"",
		"\"__real\"",
		"\"__imag\""
	};
	
	private static final long[] mk_tokenSet_0() {
		long[] data = { 1120L, 2253998836940800L, 1L, 0L, 0L, 0L};
		return data;
	}
	public static final BitSet _tokenSet_0 = new BitSet(mk_tokenSet_0());
	private static final long[] mk_tokenSet_1() {
		long[] data = { 536623232L, 137438953472L, 786432L, 0L, 0L, 0L};
		return data;
	}
	public static final BitSet _tokenSet_1 = new BitSet(mk_tokenSet_1());
	private static final long[] mk_tokenSet_2() {
		long[] data = { 3376600208901152L, 76842668642009088L, 0L, 0L};
		return data;
	}
	public static final BitSet _tokenSet_2 = new BitSet(mk_tokenSet_2());
	private static final long[] mk_tokenSet_3() {
		long[] data = { -4503551845859328L, -5853953837898399745L, 2113536L, 0L, 0L, 0L};
		return data;
	}
	public static final BitSet _tokenSet_3 = new BitSet(mk_tokenSet_3());
	}
	
