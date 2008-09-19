/*
* Copyright (c) 2007 #### RWTH Aachen Universtiy ####.
* All rights reserved.
*
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions
* are met:
* - Redistributions of source code must retain the above copyright
*   notice, this list of conditions and the following disclaimer.
* - Redistributions in binary form must reproduce the above copyright
*   notice, this list of conditions and the following disclaimer in the
*   documentation and/or other materials provided with the
*   distribution.
* - Neither the name of #### RWTH Aachen University ####  nor the names of
*   its contributors may be used to endorse or promote products derived
*   from this software without specific prior written permission.
*
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
* ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
* LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
* FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL STANFORD
* UNIVERSITY OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
* INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
* (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
* HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
* STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
* ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
* OF THE POSSIBILITY OF SUCH DAMAGE.
*
* @author Muhammad Hamad Alizai <hamad.alizai@rwth-aachen.de>
*/


import java.io.*;

public class Postmartem{

	public BufferedReader asmReader;
	

public Postmartem(String s) 
{
	try{
		
		asmReader=  new BufferedReader(new FileReader(s));
	}
	catch(FileNotFoundException e){
		System.out.println("trace file not found");
		System.exit(1);
	}
}


public static void main(String args[])throws FileNotFoundException,IOException
{
	Postmartem prp=new Postmartem(args[0]);
	prp.parse();
		
}







void parse() 
{

	String str;
	String start = "start";
	int sIndex;
	int eIndex;
	Line curr;
	long startValueAvrora=0;
	long startValueTossim=0;
	long offset=0;
        long temp =0;
	
	
	

	try{	
		
		while((str = asmReader.readLine()).compareTo(start) != 0)
		{	
			System.out.println(str);
		}
		System.out.println(str);
		str = asmReader.readLine();
		System.out.println(str);
		startValueAvrora = Long.valueOf(str);
		str = asmReader.readLine();
		sIndex = str.indexOf(":");
		eIndex = str.indexOf(":",sIndex+1);
		startValueTossim = Long.valueOf(str.substring(sIndex+1,eIndex));
		offset = startValueAvrora - startValueTossim;
		temp = startValueTossim + offset; 
		System.out.println("\"" + temp + "\" " + str );
		

		while((str = asmReader.readLine())!= null)
		{	
			sIndex = str.indexOf(":");
			eIndex = str.indexOf(":",sIndex+1);
			startValueTossim = Long.valueOf(str.substring(sIndex+1,eIndex));
			temp = startValueTossim+offset; 
			System.out.println("\"" + temp + "\" " + str );	
		}
	}
	catch(IOException e){
		System.out.println("io exception");
		System.exit(1);
	}


}
	
}

