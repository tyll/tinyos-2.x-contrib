package edu.umass.eflux.nesc;

import java_cup.runtime.*;

public class nesc_parser extends parser {

	/** Default constructor. */
	  public nesc_parser() {super();}

	  /** Constructor which sets the default scanner. */
	  public nesc_parser(java_cup.runtime.Scanner s) {super(s);}

	
	public void report_error(String arg0, Object arg1)
	{
		System.out.println("a0 : "+arg0);
		System.out.println("a1 : "+arg1);
		
	}
	
	public void syntax_error(Symbol cur)
	{
		
		System.out.println("cur:"+cur.sym+" : ");		
	}
	
	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
	
	}

}
