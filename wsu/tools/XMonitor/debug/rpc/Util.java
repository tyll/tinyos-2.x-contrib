//$Id$

/**
 * Copyright (C) 2006 WSU All Rights Reserved
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 * 
 * IN NO EVENT SHALL THE WASHINGTON STATE UNIVERSITY BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE WASHINGTON 
 * STATE UNIVERSITY HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * 
 * THE WASHINGTON STATE UNIVERSITY SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE WASHINGTON STATE UNIVERSITY HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS."
 */


/**
 * Function Description:
 * This class provides the utility functions to do the conversion
 * between binary array and java data type.
 *
 * @author Fenghua Yuan <yuan@vancouver.wsu.edu>
 *
 *
 *  Goal of this Util:
 *  Convert between nesC type and java type
 *
 *  Basics:
 *
 *  a. Java has fixed size for primitive types
 *
 *     -------------------------------
 *      Size(bytes) | Java data type | 
 *     -------------------------------
 *           1      |    byte        |  
 *     -------------------------------
 *           2      |    short       | 
 *                  |    char        |
 *     -------------------------------
 *           4      |    int         |  
 *                  |    float       | 
 *     -------------------------------
 *           8      |    long        |
 *                  |    double      | 
 *     -------------------------------
 *
 *  b. When convert data type between java and nesC,
 *     base on the size of data type.
 *
 *  c. Java has no unsigned type, and all primitive types have
 *      1-bit sign bit. So when convert unsigned nesC type
 *      into java type, should upgrade to another java data type 
 *      which has larger size.
 *   
 */


package debug.rpc;

import java.lang.Math;
import java.util.BitSet;
import java.lang.Integer;
import monitor.*;


public class Util {

	public static int sHour;
	public static int sMinute;
	public static int sSecond;
	public static int sMilisecond;

	// 10/16/2007 Yang-
	public static int sInterval;

    /*******************************************************
	 *          Binary array ==> Java data type             
	 *******************************************************/
  
	/**
	 * Get n-byte value stored in byte array 
	 * 
	 * @param arr	the original array from which to get the subarray to
	 *              do the convertion
	 * @param start	start position of subarray in arr
	 * @param len	the length of subarray to be converted
	 * @return      the value stored in len-byte array
	 *
	 * Note: after the convertion, you can cast the return value to the exact
	 *       java type with len-byte size
	 */
	//public static long mBytes2Value(byte[] arr, int start, int len) {
	public static long mBytes2Value(byte[] arr, int start, int len, char convert) {
	 	try {

			if (arr.length < (start + len)){
				String temp = monitor.Util.getDateTime() + "In mBytesValue: invalid data length, received length is " + arr.length + " , real length" + (start + len);
				System.out.println(temp);
				try {
					MainClass.eventLogger.write(temp +"\n");
					MainClass.eventLogger.flush();			
				}
				catch (Exception ex){}
				return 0;
				//System.exit(0);
			}
		
			int i = 0;
			int cnt = 0;
			if (len <= 0) {
				String temp = monitor.Util.getDateTime() + "In mBytesValue: invalid length, should >0.";
				try {
					MainClass.eventLogger.write(temp +"\n");
					MainClass.eventLogger.flush();			
				}
				catch (Exception ex){}
				
				//System.exit(0);
			}
			if (len > 4){
				String temp = monitor.Util.getDateTime() + "In mBytesValue: There is no corresponding data type for value with len ="+ len + " bytes.";
				System.out.println(temp);
				try {
					MainClass.eventLogger.write(temp +"\n");
					MainClass.eventLogger.flush();			
				}
				catch (Exception ex){}
				//System.exit(0);
			}

			//get specified subarray from arr
			byte[] tmp = new byte[len];
			for (i = start; i < (start + len); i++) {
				tmp[cnt] = arr[i];
				cnt++;
			}

			//Get unsigned value
			long accum = 0;
			i = 0;
			for ( int shiftBy = 0; shiftBy < len*8; shiftBy += 8 ) {
				accum |= ( (long)( tmp[i] & 0xff ) ) << shiftBy;
				i++;
			}

			//Get signed value if is a signed type
			long adjust = getConvertStr(convert);
			if (adjust != 0){
				if (tmp[cnt-1]<0){
					accum =accum - adjust - 1;
				}
			}
			return accum;
	 		}
			catch (Exception ex){ex.printStackTrace();}
			return 0;
		
	}


	public static long getConvertStr(char convert){
		int len = 0;
		long strValue = 0;
		switch (convert)
		{
		case 'b': len = 1;
			break;		
		case 'h': len = 2;
			break;		
		case 'l': len = 4;
			break;		
		//case 'q': len = 8;
		//	break;	
		default: len = 0;
		}

		for ( int shiftBy = 0; shiftBy < len*8; shiftBy += 8 ) {
			strValue |= ( (long)(0xff) ) << shiftBy;
		}	
		return strValue;
	}


	public static long startTimeCalculation(byte[] arr, int start, int len) {
		try {
			int i = 0;
			int cnt = 0;
			int hours,minutes,seconds,milisecond, interval;
			String reversed = "";
			long startTimeCalculation = 0;
			BitSet bits = new BitSet();

			if (len != 4) {
				System.out.println("Invalid time length, should be 4.");
				//System.exit(0);
			}
			//get specified subarray from arr
			byte[] tmp = new byte[len];
			for (i = start; i < (start + len); i++) {
				tmp[cnt] = arr[i];
				cnt++;

				//Get bits and convert to time
				byte bobTheByte = arr[i];
				String temp = "";
				for( int j = 0; j<8;j++) {
					if (( ( bobTheByte & (1 <<j ) ) > 0 ))
			 	 		  temp += 1;
					else temp += 0;
				}
				
				for (int k=0; k<temp.length(); k++) {
              			  reversed = temp.substring(k, k+1) + reversed;			
       			}
				//System.out.println(reversed);
			}
			// 10/16/2007 Yang-
			// remove hour information in data packet, do not calculate hour anymore
			/*
			hours = binaryString2Long(reversed.substring(reversed.length()-5,reversed.length()));
			minutes = binaryString2Long(reversed.substring(reversed.length()-11,reversed.length()-5));
			seconds = binaryString2Long(reversed.substring(reversed.length()-17,reversed.length()-11));
			milisecond = binaryString2Long(reversed.substring(reversed.length()-24,reversed.length()-17));
			*/
			hours = 0;
			minutes = binaryString2Long(reversed.substring(reversed.length()-6,reversed.length()));
			seconds = binaryString2Long(reversed.substring(reversed.length()-12,reversed.length()-6));
			milisecond = binaryString2Long(reversed.substring(reversed.length()-22,reversed.length()-12));
			interval = binaryString2Long(reversed.substring(reversed.length()-32,reversed.length()-22));
			//System.out.println(hours + " " + minutes + " " + seconds + " " + milisecond);
			startTimeCalculation = hours*60*60*1000 + minutes*60*1000 + seconds*1000 + milisecond;
		
			sHour = hours;
			sMinute = minutes;
			sSecond = seconds;
			sMilisecond = milisecond;
			sInterval = interval;

			return startTimeCalculation;
		}
		catch (Exception ex){ex.printStackTrace();}
		return 0;
	}

	public static int binaryString2Long(String binString)
		{	
			int value = 0;
			int count = 1;
			
			for (int i = binString.length() ; i > 0 ; i --)
				{					
					if (Integer.parseInt(binString.substring(i-1, i)) == 1)
						{
							value = value + count;
						}
					count = count * 2;
				}
			return value;
		}


    /*******************************************************
	 *          Binary array <== Java data type             
	 *******************************************************/

	/**
	 * Write value n into a byte array 
	 * 
	 * @param n		the value to write to array
	 * @param len	the length of array to write into
	 * @return      len-byte array with value stored in it
	 *
	 * Note: before the convertion, you can copy the value n to long type variable,
	 *       then specify the original type size of n by parameter len
	 */
	public static byte[] value2mBytes(long n, int len) {
		byte[] ret = new byte[len];
        for (int i=0; i<len; i++){
			ret[i] = (byte)( n >>(i*8) );
        }
		return ret;
	}


        //YFH test:
		/*byte [] arr = new byte[8];
		byte [] arr2;
        for (int m=0; m<8; m++)
        {
			arr[m] = 1;
        }
        for (int n=1; n<=8; n++)
        {
			long test = Util.mBytes2Value(arr, 0, n);
			System.out.println(" "+ n +"-byte value = " + test);

			arr2 = Util.value2mBytes(test, n);
			for (int t=0; t<n; t++){
				System.out.print("  arr2["+ t +"]= " + arr2[t]);
			}
			System.out.print("\n");
        }*/


	//public static byte[] convertRpcData(byte[] data, 	




  }

