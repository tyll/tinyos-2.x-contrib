/**
 * 
 */
package edu.umass.eflux.nesc;

import java.io.*;


/**
 * @author sorber
 *
 */
public class TestConfig {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		parser p = null;
		
		PrintStream oldout = System.out;
		PrintStream olderr = System.err;
		
		try 
		{
			p = new parser(new Yylex(new FileInputStream("src/runtime/tinyos/EvaluatorC.nc")));
			if (p == null) {
				System.out.println("Could not create parser!");
				System.exit(3);
			}
			
			System.out.println("About to parse...");
			
			System.setOut(new PrintStream(new ByteArrayOutputStream()));
			System.setErr(new PrintStream(new ByteArrayOutputStream()));
			
			NESCConfig nc = (NESCConfig) p.parse().value;
			
			System.setOut(oldout);
			System.setErr(olderr);
			if (nc != null)
			{
				System.out.println("parsed file successfully! : "+nc);
			} else {
				System.out.println("Not a valid configuration! : "+nc);
			}
			
			return;
		}
		catch (Exception e)
		{
			System.setOut(oldout);
			System.setErr(olderr);
			
			System.out.println("Exception: ");
			e.printStackTrace();
			System.exit(2);
		}
		
	}

}
