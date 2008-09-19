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

public class AsmParser
{

	public static BufferedReader asmReader;
	public static FileList fList;

public AsmParser(String s) 
{
	try{
	fList = new FileList();
	asmReader=  new BufferedReader(new FileReader(s));
	}
	catch(FileNotFoundException e){
		System.out.println("asm file not found");
		System.exit(1);
	}
}

/*
public static void main(String args[])throws FileNotFoundException,IOException
{
	AsmParser asm=new AsmParser(args[0]);
	asm.parse();
	asm.print();
		
}
*/






public void parse() 
{
	boolean b = true;
	boolean c = true;
	boolean d = true;
	String str;
	String temp;
	String tempPath;
	String tempLine;
	String tempComp;
	String start = "__bad_interrupt():";
	String functionName = "";
	int sIndex;
	int eIndex;
	SourceFile currF;
	SourceLine currL;

	SourceFile curr2F;
	SourceLine curr2L;

	try{	
		fList.first = new SourceFile();
		fList.first.line = new SourceLine();

		currF = fList.first;
		currL= currF.line;
		curr2L = currL;
		while((str = asmReader.readLine()).compareTo(start) != 0)
		{
		
		}
	
		while((str = asmReader.readLine()) != null)
		{
			if(((sIndex = str.indexOf("/"))) != -1)
			{
				d = true;
				eIndex = str.indexOf(":");
				if(b)
				{
					
					currF.path = str.substring(sIndex,eIndex);
					currF.component = str.substring(str.lastIndexOf("/")+1,eIndex);
					currL.lineNum = str.substring(eIndex+1);
					//System.out.println(currF.functionName);
					b = false;
					curr2L = currL;	
				}
				else
				{
					
					curr2F = fList.first;
					tempPath = str.substring(sIndex,eIndex);
					tempComp = str.substring(str.lastIndexOf("/")+1,eIndex);
					tempLine = str.substring(eIndex+1);
					while(curr2F != null)
					{
						if(tempPath.compareTo(curr2F.path) == 0)
						{
							curr2L = curr2F.line;
							while(curr2L.nextLine != null)
							{
								curr2L = curr2L.nextLine;
							}
							curr2L.nextLine = new SourceLine();
							curr2L = curr2L.nextLine;
							curr2L.lineNum = tempLine;
							curr2L.inFunction = functionName;
							c = false;
							break;
						}
						curr2F = curr2F.nextFile;
					}
					if(c)
					{
						currF.nextFile = new SourceFile();
						currF = currF.nextFile;
						currF.path = tempPath;
						currF.component = tempComp;
						//System.out.println(currF.functionName);
						currF.line = new SourceLine();
						currL = currF.line;
						currL.lineNum = tempLine;
						currL.inFunction = functionName;
						curr2L = currL;
						
					}
					c = true;

					
				}
			
				
			}

			
			else if((sIndex = str.indexOf("\t", str.indexOf("\t")+1)) != -1)
			{
				if((eIndex = str.indexOf("\t", sIndex+1)) != -1)
				{
					temp = str.substring(sIndex+1,eIndex);
					

				}
				else
				{	
					temp = str.substring(sIndex+1);
				}
				for(int i=0; i < SourceLine.cc.length; i++)
				{
					if(temp.compareTo(SourceLine.op[i]) == 0)
					{
						if(d)
						curr2L.numOfCycles += SourceLine.cc[i]; 
						break;
					}
				}

				
			}
			else
			{
				if((sIndex = str.indexOf("<")) != -1)
				{
					eIndex = str.indexOf(">");
					functionName = str.substring(sIndex+1,eIndex);
				}
				d = false;
			}
					
					

		}


	}
	catch(IOException e){
		System.out.println("io exception");
		System.exit(1);
	}
}




public static void print()
{



	SourceFile currF;
	SourceLine currL;

	currF = fList.first;


	while (currF != null)
	{
		currL= currF.line;
		while (currL != null)
		{
			System.out.println(currF.path + ":" + currF.component + ":"+ currL.lineNum + "\t\t" + 			        currL.numOfCycles + "\t\t" + currL.inFunction);
			currL = currL.nextLine;		
		}
		currF = currF.nextFile; 	
	}







}

}
	


/*
	
	while((str = asmReader.readLine()) != null)
	{

		if (str == "")
		{
			continue;
		}	
		else
		{

			if(((sIndex = str.indexOf("/"))) != -1)
			{
				if(b)
				{
					eIndex = str.indexOf(":");
					currF.path = str.substring(sIndex,eIndex);
					//System.out.println(currF.functionName);
					b = false;	
				}
				else
				{
					currF.nextFile = new SourceFile();
					currF = currF.nextFile;
					eIndex = str.indexOf(">");
					currF.path = str.substring(sIndex+1,eIndex);
					//System.out.println(currF.functionName);
					currF.line = new SourceLine();
					currI = currF.instructions;
					c = true;
					

				}
			}
			
			if((sIndex = str.indexOf("\t", str.indexOf("\t")+1)) != -1)
			{
				if((eIndex = str.indexOf("\t", sIndex+1)) != -1)
				{
					temp = str.substring(sIndex+1,eIndex);
					//System.out.println(temp);

				}
				else
				{	
					temp = str.substring(sIndex+1,str.length());
					//System.out.println(temp);
				}

					if(c)
					{	
						currI.opcode = temp;
						c = false;
					}			
					else{
						currI.nextInstruction = new AsmInstruction();
						currI = currI.nextInstruction;
						currI.opcode = temp;

					}
			}

				
		}
	}

	
	countCycles(); 
	

public void countCycles()
{

	AsmFunction currF;
	AsmInstruction currI;


	currF = fList.first;



	while(currF != null)
	{
		//System.out.println(currF.functionName);
		currI= currF.instructions;
		while(currI != null)
		{
			for(int i=0; i < AsmInstruction.cc.length; i++)
			{
				if(currI.opcode.compareTo(AsmInstruction.op[i]) == 0)
				{
					currI.numOfCycles = AsmInstruction.cc[i];
					currF.cycleCount += AsmInstruction.cc[i]; 
					break;
				}
			}
			//System.out.println(currI.opcode + "\t" + currI.numOfCycles);	
			currI = currI.nextInstruction;	
		}
		//System.out.println("Total=" + "\t" + currF.cycleCount);
		currF = currF.nextFunction;
		
	}

}


*/
