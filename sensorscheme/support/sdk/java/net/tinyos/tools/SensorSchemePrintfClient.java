/*
 * "Copyright (c) 2006 Washington University in St. Louis.
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 *
 * IN NO EVENT SHALL WASHINGTON UNIVERSITY IN ST. LOUIS BE LIABLE TO ANY PARTY
 * FOR DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING
 * OUT OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF WASHINGTON
 * UNIVERSITY IN ST. LOUIS HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * WASHINGTON UNIVERSITY IN ST. LOUIS SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND WASHINGTON UNIVERSITY IN ST. LOUIS HAS NO
 * OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR
 * MODIFICATIONS."
 */

/**
 * @author Kevin Klues (klueska@cs.wustl.edu)
 * @version $Revision$
 * @date $Date$
 */

package net.tinyos.tools;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.HashMap;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import net.tinyos.message.*;
import net.tinyos.tools.*;
import net.tinyos.packet.*;
import net.tinyos.util.*;

public class SensorSchemePrintfClient implements MessageListener {

  private MoteIF moteIF;
  private HashMap<Integer, String> symbolsMap;
  
  public SensorSchemePrintfClient(MoteIF moteIF, HashMap<Integer, String> symbols) {
    this.moteIF = moteIF;
    this.moteIF.registerListener(new PrintfMsg(), this);
    this.symbolsMap=symbols;
  }

  public void messageReceived(int to, Message message) {
	int start=0;
	String expandedString="";
    PrintfMsg msg = (PrintfMsg)message;
    StringBuilder msgContents=new StringBuilder();
    
    for(int i=0; i<msg.totalSize_buffer(); i++) {
      char nextChar = (char)(msg.getElement_buffer(i));
      if(nextChar != 0)
    	  msgContents.append(nextChar);
    }
    String msgString=msgContents.toString();
    Pattern symbolPattern=Pattern.compile("\\%s(-?[0-9]+)");
    Matcher symbolMatcher=symbolPattern.matcher(msgString);
    while (symbolMatcher.find()){
    	expandedString+=msgString.subSequence(start, symbolMatcher.start());
    	expandedString+=this.symbolsMap.get(Integer.valueOf(symbolMatcher.group(1)));
    	start=symbolMatcher.end();
    }
    expandedString+=msgString.subSequence(start, msgString.length());
    System.out.print(expandedString);
  }
  
  // Copied from http://www.javapractices.com/topic/TopicAction.do?Id=42
  static public String getContents(File aFile) {
	    //...checks on aFile are elided
	    StringBuilder contents = new StringBuilder();
	    
	    try {
	      //use buffering, reading one line at a time
	      //FileReader always assumes default encoding is OK!
	      BufferedReader input =  new BufferedReader(new FileReader(aFile));
	      try {
	        String line = null; //not declared within while loop
	        /*
	        * readLine is a bit quirky :
	        * it returns the content of a line MINUS the newline.
	        * it returns null only for the END of the stream.
	        * it returns an empty String if two newlines appear in a row.
	        */
	        while (( line = input.readLine()) != null){
	          contents.append(line);
	          contents.append(System.getProperty("line.separator"));
	        }
	      }
	      finally {
	        input.close();
	      }
	    }
	    catch (IOException ex){
	      ex.printStackTrace();
	    }
	    
	    return contents.toString();
	  }
  
  
  private static void usage() {
    System.err.println("usage: PrintfClient [-comm <source>] [-sym <symfile>]");
  }
  
  public static void main(String[] args) throws Exception {
    String source = null;
    String symFileName = "ssgw/symbols.map";
    if (args.length == 4) {
    	if(args[0].equals("-comm") && args[2].equals("-sym")){
    		source=args[1];
    		symFileName=args[3];
    	}else if(args[0].equals("-sym") && args[2].equals("-comm")){
    		source=args[3];
    		symFileName=args[1];
    	}else{
    	       usage();
    	       System.exit(1);
    	}
    } else if (args.length == 2) {
      if (args[0].equals("-comm")) {
      	source = args[1];
      }else if (args[0].equals("-sym")){
    	  symFileName=args[1];
      }else{
       usage();
       System.exit(1);
      }
    } else if (args.length!=0){
       usage();
       System.exit(1);
    }
    
    PhoenixSource phoenix;
    if (source == null) {
      phoenix = BuildSource.makePhoenix(PrintStreamMessenger.err);
    }
    else {
      phoenix = BuildSource.makePhoenix(source, PrintStreamMessenger.err);
    }
    
    File symbolsFile=new File(symFileName);
    if(!symbolsFile.exists()){
    	System.err.println("File does not exist: "+symFileName);
    	System.exit(1);
    }else if(!symbolsFile.canRead()){
    	System.err.println("Permission denied: "+symFileName);
    	System.exit(1);
    }
    
    String unparsedSymbolsMap=getContents(symbolsFile);
    
    Pattern getSymbolsPattern=Pattern.compile("\\(+\"?(.*?)\"?[\\s](-?[0-9]+)\\)+");
    Matcher getSymbolsMatcher=getSymbolsPattern.matcher(unparsedSymbolsMap);
    HashMap<Integer,String> buildMap=new HashMap<Integer,String>();
    while(getSymbolsMatcher.find()){
    	buildMap.put(Integer.valueOf(getSymbolsMatcher.group(2)), getSymbolsMatcher.group(1));
    }
    
    System.out.print(phoenix);
    MoteIF mif = new MoteIF(phoenix);
    SensorSchemePrintfClient client = new SensorSchemePrintfClient(mif,buildMap);
  }
}
