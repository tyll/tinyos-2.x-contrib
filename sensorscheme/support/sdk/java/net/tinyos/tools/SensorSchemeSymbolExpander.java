package net.tinyos.tools;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.HashMap;

public class SensorSchemeSymbolExpander {

	  private static void usage() {
		    System.err.println("usage: SensorSchemeSymbolExpander [-sym <symfile>]");
	  }
	
	  public static void main(String[] args) throws Exception {
		    String symFileName = "ssgw/symbols.map";
		    if (args.length == 2) {
		      if (args[0].equals("-sym")) {
		      	symFileName = args[1];
		      }else{
		       usage();
		       System.exit(1);
		      }
		    } else if (args.length!=0){
		       usage();
		       System.exit(1);
		    }
		    
		    HashMap<Integer, String> buildMap=null;
		    try{
		    	buildMap=SensorSchemeUtils.loadSymbols(symFileName);
		    } catch (IOException ioe){
		    	System.err.println(ioe.getMessage());
		    	System.exit(1);
		    }
		    BufferedReader stdInReader=new BufferedReader(new InputStreamReader(System.in));
		    String unexpandedLine=stdInReader.readLine();
		    while (unexpandedLine != null){
		    	System.out.println(SensorSchemeUtils.expandSymbols(unexpandedLine, buildMap));
		    	unexpandedLine=stdInReader.readLine();
		    }
	}

}
