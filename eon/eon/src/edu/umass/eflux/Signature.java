
package edu.umass.eflux;

import java.*;
import java.util.*;
import java.io.*;

public class Signature {

	String args[];
	String state;
	
	public Signature(String str)
	{
		String s;
		String halves[], arg_arr[];
		String state_raw, args_raw;
		//System.out.println("str="+str);
		s = str.replace("[","");
		//System.out.println("s="+s);
		s = s.replace("]","");
		//System.out.println("s="+s);
		s = s.replace("|","-");
		halves = s.split("-");
		if (halves == null)
		{
			args = null;
			state = null;
		} else {
			if (halves.length > 0)
			{
				//System.out.println("h[0] : " + halves[0]);
				args_raw = halves[0];
				arg_arr = args_raw.split(",");
				for (int i=0; i < arg_arr.length; i++)
				{
					arg_arr[i] = arg_arr[i].trim();
					this.args = arg_arr;
				}
				
			}
			if (halves.length > 1)
			{
				//System.out.println("h[1] : " + halves[1]);
				state_raw = halves[1].trim();
				this.state = state_raw;
			}
		}
		if (state == null)
		{
			state = "*";
		}
		
	}
	
	public boolean equals(Signature s)
	{
		return this.toString().equals(s.toString());
	}
	
	public String toString()
	{
		String argstr = "";
		if (args != null)
		{
			for (int i=0; i < args.length; i++)
			{
				argstr = argstr + "," + args[i];
			}
		}
		return ("[" + argstr + "|" + state + "]");
	}
	
	public static void main(String args[]) throws Exception
	{
		Signature s = new Signature("[ *, *, *, accept | *]");
		Signature s2 = new Signature("[*,*,*,accept]");
		System.out.println(s + " == "+s2);
	}
}