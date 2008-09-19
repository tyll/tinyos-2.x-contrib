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

public class PreMica2{

	public BufferedReader asmReader;


public PreMica2(String s) 
{
	try{
		asmReader=  new BufferedReader(new FileReader(s));
	}
	catch(FileNotFoundException e){
		System.out.println("C Source-file not found");
		System.exit(1);
	}
}


public static void main(String args[])throws FileNotFoundException,IOException
{
	PreMica2 prp=new PreMica2(args[0]);
	prp.parse();
		
}







void parse() 
{

	String str;
	//String start = "inline static  void SchedulerBasicP$TaskBasic$runTask(uint8_t arg_0x402c94e0){";
	//String start = "static  void SchedulerBasicP$TaskBasic$runTask(uint8_t arg_0x402c9e10){";
        String str1 = "static  void SchedulerBasicP$TaskBasic$runTask";
        String str2 = "{";
	int counter=0;
	
	
	

	try{	
		
		while(!(((str = asmReader.readLine()).indexOf(str1) != -1) && (str.indexOf(str2) != -1)))
		{
			System.out.println(str);	
		}
		System.out.println("// ***Start point for deleting line directives****");
		//System.out.println("inline static  void SchedulerBasicP$TaskBasic$runTask(uint8_t arg_0x402c9e10)");
		//System.out.println("static  void SchedulerBasicP$TaskBasic$runTask(uint8_t arg_0x402c9e10)");
                String printString = str.substring(0, str.indexOf("{"));
                System.out.println(printString);
		System.out.println("# 64 \"/opt/tinyos-2.x/tos/interfaces/TaskBasic.nc\"");
		System.out.println("{");

		while((str = asmReader.readLine()) != null)
		{
			
		
			if((str.startsWith("#")) && (str.indexOf("#line 64") != -1)){
				continue;
			}
			if((str.startsWith("#")) && (str.indexOf("#line 64") == -1)){
				System.out.println("// ***End point for deleting line directives****");
				break;
			}
			System.out.println(str);	
		
		}
		System.out.println(str);
		while((str = asmReader.readLine()) != null)
		{
			System.out.println(str);	
		}
		
	}
	catch(IOException e){
		System.out.println("io exception");
		System.exit(1);
	}
}


}
	


