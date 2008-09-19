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

public class Preprocessor{

	public BufferedReader asmReader;
	public Line fList;
	public Line eList;

public Preprocessor(String s) 
{
	try{
		fList = new Line();
		asmReader=  new BufferedReader(new FileReader(s));
	}
	catch(FileNotFoundException e){
		System.out.println("C Source-file not found");
		System.exit(1);
	}
}


public static void main(String args[])throws FileNotFoundException,IOException
{
	Preprocessor prp=new Preprocessor(args[0]);
	prp.parse();
		
}







void parse() 
{

	String str;
	String start = "static inline void init_heap(heap_t *heap)";
	int sIndex;
	int eIndex;
	Line curr;
	int ln=0;
	
	
	

	try{	
		curr=this.fList;
		while((str = asmReader.readLine()).compareTo(start) != 0)
		{
			System.out.println(str);	
		}
		System.out.println("// ***Start point for adding missing line directives****");
		System.out.println(str);
		while(!((str = asmReader.readLine()).startsWith("#")))
		{
			System.out.println(str);	
		}
		
		curr.line = str;
		curr.isDirective = true;
		sIndex = curr.line.indexOf("\"");
		eIndex = curr.line.indexOf("\"",sIndex+1);
		curr.path = curr.line.substring(sIndex+1,eIndex);
		curr.lineNum = Integer.valueOf(curr.line.substring(2,sIndex-1));
		

		while((str = asmReader.readLine()) != null)
		{
			if(str.startsWith("#")){
				curr.nextLine = new Line();
				curr = curr.nextLine;
				curr.line = str;
				curr.isDirective = true;
				sIndex = curr.line.indexOf("\"");
				eIndex = curr.line.indexOf("\"",sIndex+1);
				curr.path = curr.line.substring(sIndex+1,eIndex);
				curr.lineNum = Integer.valueOf(curr.line.substring(2,sIndex-1));
				eList = curr;
				this.print();
				fList = this.eList ;
				curr  = this.fList;
				eList = null;
			}
			else{
				curr.nextLine = new Line();
				curr = curr.nextLine;
				curr.line = str;
				curr.isDirective = false;
			}
		}
		// do remaining printing here
		curr = fList;
		while(curr != null){
			if(curr.isDirective){
				System.out.println(curr.line);
				ln = curr.lineNum;
				curr=curr.nextLine;

			}
			else{
				ln++;
				System.out.println(curr.line);
				if((curr.nextLine != null)&& (curr.nextLine.line.indexOf("else") == -1))
				System.out.println("# " + ln + " \"" + this.fList.path + "\"" );
				curr = curr.nextLine;
			}
		}
		
	}
	catch(IOException e){
		System.out.println("io exception");
		System.exit(1);
	}
}




void print()
{
	String s = "\"";
	Line curr;
	int l=0;
	curr = this.fList;
	if((this.fList.lineNum == this.eList.lineNum) && (this.fList.path.compareTo(this.eList.path)==0)){
		while(curr != this.eList){
			System.out.println(curr.line);
			curr = curr.nextLine;
		}
	}
	else{
		while(curr != eList){
			if(curr.isDirective){
				System.out.println(curr.line);
				l = curr.lineNum;
				curr = curr.nextLine;
			}
			else{
				l++;
				if((l < eList.lineNum) && (this.fList.path.compareTo(this.eList.path)==0)){
					System.out.println(curr.line);
					if(!(curr.nextLine == this.eList)&& (curr.nextLine.line.indexOf("else") == -1))
						System.out.println("# " + l + " " + s + this.fList.path + s );
				}
				else if(this.fList.path.compareTo(this.eList.path)!=0){
					System.out.println(curr.line);
					if(!(curr.nextLine == this.eList) && (curr.nextLine.line.indexOf("else") == -1))
						System.out.println("# " + l + " " + s + this.fList.path + s );
				}
				else{
					System.out.println(curr.line);
				}
				curr = curr.nextLine;
			}
		}
		
	}
}



}
	


