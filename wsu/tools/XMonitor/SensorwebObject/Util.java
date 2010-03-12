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
 * This class provides the utility functions.
 *
 * Original version by:
 *    @author Matt Welsh
 * Modified by:
 *    @author Fenghua Yuan <yuan@vancouver.wsu.edu>
 *    @author Mingsen XU
 */


package SensorwebObject;


import java.lang.String;
import java.lang.Math;
import java.util.*;
import java.text.*;
import java.awt.*;
import java.awt.event.*;
import javax.swing.*;
import java.io.*;
import java.nio.ByteBuffer;
import java.nio.channels.FileChannel;

//9/2/2008 Sendmail
import java.util.Properties;
import java.util.*;
import java.io.*;
import java.security.Security;
//9/2/2008 End

public class Util {

  public static final int VALUE_BAR_WIDTH = 50;
  public static final int VALUE_BAR_HEIGHT = 5;

  static int colorIndex = 0; 
  static Color plotColors[];
  
//Decompression parameters and class variable member
  public static int decodepacketbitpointer = 0;
  public static int decodepacketbytepointer = 0;
  public static int[] decodedfoldedsamples ;
  public static int[] decodedunfoldedsamples ;
  public static int[] decodedweightquant = new int[10];
  public static int[] weight_r = new int[10]; 
  public static int[] packetdebiasedsamples;
  public static byte[][] destination = new byte[32][84];
  public static byte[] destination_last_row;
  public static int bitdepth = 16;
  public static long[] time = new long [2];
  public static long timeinterval = 0;
  public static long timestamp = 0;
  public static int TOS_length = 0;
  public static int APP_length = 0;
  public static int APP_seqo = 0;
  public static int minsamplevalue = 0;
  public static int maxsamplevalue = 0xffff;
  public static int codeoverheadbits = 4;
  public static int timestampbits = 32;
  public static int capexponent = 2;
  public static int	weightquantbits = 10;
  public static int biasquantbits = 10;
  public static int denomexponent = 10;
  public static int almosthalf = ((1<<(denomexponent-1)) - 1);
  public static int decoderbiasestimate_r = 0; // bias estimate (rational number)
  public static int order = 3;  // prediction order

  //Application DATA Type;
  public static final int TYPE_DATA_SEISMIC = 0;	
  public static final int TYPE_DATA_INFRASONIC = 1;
  public static int rbitvalue =0 ;
  public static File compress_logfile;
  public static String time_s ="";


  static { 
	plotColors    = new Color[15];
	plotColors[0] = Color.red;
	plotColors[1] = Color.magenta;
	plotColors[2] = Color.yellow;
	plotColors[3] = Color.green;
	plotColors[4] = Color.blue;
	plotColors[5] = Color.cyan;
	plotColors[6] = Color.pink;
	plotColors[7] = Color.blue;
	plotColors[8] = Color.orange;
	plotColors[9] = Color.white;
	plotColors[10] = Color.red;
	plotColors[11] = Color.magenta;
	plotColors[12] = Color.yellow;
	plotColors[13] = Color.green;
	plotColors[14] = Color.blue;
 }

  private static DecimalFormat df;

  static {
    df = new DecimalFormat();
    df.applyPattern("#.##");
  }

  public static String format(double value) {
    return df.format(value);
  }

  public static Color gradientColor(double value) {
    if (value < 0.0) return Color.gray;
    if (value > 1.0) value = 1.0;
    int red = Math.min(255,(int)(512.0 - (value * 512.0)));
    int green = Math.min(255,(int)(value * 512.0));
    int blue = 0;
    return new Color(red, green, blue);
  }

  public static Color GetColor(int index){
	  return plotColors[index];
  }

  


//YFH========================================
//functions: related drawing a arrowed line
    static int al = 16;		// Arrow length
    static int aw = 10;		// Arrow width
    static int haw = aw/2;	// Half arrow width
    static int xValues[] = new int[3];
    static int yValues[] = new int[3];

    public static void drawArrow(Graphics g, int x1, int y1, int x2, int y2, int lineWidth ) 
	{
    // Draw line using user defined drawline() which can specify line width
	drawLine(g, x1,y1,x2,y2, lineWidth);
	// Calculate x-y values for arrow head
	calcValues(x1,y1,x2,y2);
	g.fillPolygon(xValues,yValues,3);
	}

   
	/* CALC VALUES: Calculate x-y values. */
    public static void calcValues(int x1, int y1, int x2, int y2)
	{

	// North or south	
	if (x1 == x2) { 
	    // North
	    if (y2 < y1) arrowCoords(x2,y2,x2-haw,y2+al,x2+haw,y2+al);
	    // South
	    else arrowCoords(x2,y2,x2-haw,y2-al,x2+haw,y2-al);
	    return;
	    }	
	// East or West	
	if (y1 == y2) {
	    // East
	    if (x2 > x1) arrowCoords(x2,y2,x2-al,y2-haw,x2-al,y2+haw);
	    // West
	    else arrowCoords(x2,y2,x2+al,y2-haw,x2+al,y2+haw);
	    return;
	    }
	// Calculate quadrant
	
	calcValuesQuad(x1,y1,x2,y2);
	}

    
	/* CALCULATE VALUES QUADRANTS: Calculate x-y values where direction is not
    parallel to eith x or y axis. */    
	public static void calcValuesQuad(int x1, int y1, int x2, int y2) 
	{ 
	double arrowAng = Math.toDegrees (Math.atan((double) haw/(double) al));
	double dist = Math.sqrt(al*al + aw);
	double lineAng = Math.toDegrees(Math.atan(((double) Math.abs(x1-x2))/
                            ((double) Math.abs(y1-y2))));
				
	// Adjust line angle for quadrant
	if (x1 > x2) {
	    // South East
	    if (y1 > y2) lineAng = 180.0-lineAng;
	    }
	else {
	    // South West
	    if (y1 > y2) lineAng = 180.0+lineAng;
	    // North West
	    else lineAng = 360.0-lineAng;
	    }
	
	// Calculate coords	
	xValues[0] = x2;
	yValues[0] = y2;	
	calcCoords(1,x2,y2,dist,lineAng-arrowAng);
	calcCoords(2,x2,y2,dist,lineAng+arrowAng);
	}
    

    /* CALCULATE COORDINATES: Determine new x-y coords given a start x-y and
    a distance and direction */
	public static void calcCoords(int index, int x, int y, double dist, double dirn) 
	{
	while(dirn < 0.0)   dirn = 360.0+dirn;
	while(dirn > 360.0) dirn = dirn-360.0;
	// System.out.println("dirn = " + dirn);
		
	// North-East
	if (dirn <= 90.0) {
	    xValues[index] = x + (int) (Math.sin(Math.toRadians(dirn))*dist);
	    yValues[index] = y - (int) (Math.cos(Math.toRadians(dirn))*dist);
	    return;
	    }
	// South-East
	if (dirn <= 180.0) {
	    xValues[index] = x + (int) (Math.cos(Math.toRadians(dirn-90))*dist);
	    yValues[index] = y + (int) (Math.sin(Math.toRadians(dirn-90))*dist);
	    return;
	    }
	// South-West
	if (dirn <= 90.0) {
	    xValues[index] = x - (int) (Math.sin(Math.toRadians(dirn-180))*dist);
	    yValues[index] = y + (int) (Math.cos(Math.toRadians(dirn-180))*dist);
	    }
	// Nort-West    
	else {
	    xValues[index] = x - (int) (Math.cos(Math.toRadians(dirn-270))*dist);
	    yValues[index] = y - (int) (Math.sin(Math.toRadians(dirn-270))*dist);
	    }
	}      
    
   
	// ARROW COORDS: Load x-y value arrays */    
    public static void arrowCoords(int x1, int y1, int x2, int y2, int x3, int y3) 
	{
        xValues[0] = x1;
		yValues[0] = y1;
		xValues[1] = x2;
		yValues[1] = y2;
		xValues[2] = x3;
		yValues[2] = y3;
    }

//YFH========================================    

   public static void drawLine(Graphics g,
		  int x1, int y1,
		  int x2, int y2,
		  int lineWidth) {
	if (lineWidth == 1)
	    g.drawLine(x1, y1, x2, y2);
	else {
	    double angle;
	    double halfWidth = ((double)lineWidth)/2.0;
	    double deltaX = (double)(x2 - x1);
	    double deltaY = (double)(y2 - y1);
	    if (x1 == x2)
		angle=Math.PI;
	    else
		angle=Math.atan(deltaY/deltaX)+Math.PI/2;
	    int xOffset = (int)(halfWidth*Math.cos(angle));
	    int yOffset = (int)(halfWidth*Math.sin(angle));
	    int[] xCorners = { x1-xOffset, x2-xOffset+1,
			       x2+xOffset+1, x1+xOffset };
	    int[] yCorners = { y1-yOffset, y2-yOffset,
			       y2+yOffset+1, y1+yOffset+1 };
	    g.fillPolygon(xCorners, yCorners, 4);
	}
    }


	public static  void writeLogFile(String descript, String filename)
	{
		File file;
		FileOutputStream  outstream;
		//BufferedWriter outstream;
		Date time = new Date();
		long bytes = 30000000;
		try {
			//Get log file
			String logfile = "C:\\" + filename + ".txt";
			file = new File(logfile);
			boolean exists = file.exists();
			if (!exists){
				//create a new, empty node file
				try {	
					file = new File(logfile);
					boolean success = file.createNewFile();
				} 
				catch (IOException e) {
					System.out.println("Create Event Log file failed!");
				}
			}
			try {
				descript = descript + "\n";
				outstream = new FileOutputStream(file,true);  
				for (int i=0; i<descript.length();++i){
					outstream.write((byte)descript.charAt(i));
				}
				outstream.close();
			} catch (IOException e) {
			}
		}
		catch (java.lang.Exception e) {
	}		
	
	}


	public static void writeByteBuffer(ByteBuffer bbuf, String filename)
	{
		// Write bbuf to filename
		File file;
 		 try {
			//Get log file
			String logfile = "C:\\" + filename + ".txt";
			file = new File(logfile);
			boolean exists = file.exists();
			if (!exists){
				//create a new, empty node file
				try {	
					file = new File(logfile);
					boolean success = file.createNewFile();
				} 
				catch (IOException e) {
					System.out.println("Create Event Log file failed!");
				}
			}
			try {
       			 // Create a writable file channel
   			     	FileChannel wChannel = new FileOutputStream(file, true).getChannel();
        				 // Write the ByteBuffer contents; the bytes between the ByteBuffer's
      				  // position and the limit is written to the file
     				   wChannel.write(bbuf);
    
     				   // Close the file
      				  wChannel.close();
   				 } catch (IOException e) {
   	 		}
 		 	}
		 catch (java.lang.Exception e) {
	}		
	

  }
	public static String getDateTime() {
				DateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
				Date date = new Date();
				return dateFormat.format(date);
		}
     /******************************************************Main process of decompression with Linear Prediction**************************/

	public static int decompress_action(byte[] source) {
		int numbits = 8;
		int i = 0;
	    int value =0;
		/*
		for (i=0; i<numbits; i++)
		{
			if (((source[20])&(1<<i))==1){
				value |= (1<<i);
			}			
		}*/
		//System.out.println("value!:" + source[20] + "\n");
		if (source[20] == 0)
			return 1;
		else
			return 0;
	}
	
	public static byte[][] decompress_done()
		{
			return destination;
		}
	public static byte[] decompress_last_row()
		{
			return destination_last_row;
		}

	public static int decompress(byte[] source)
		{
			
			int codingparameter, lengthofpacket;
			int numdecodedsamples;
			int packetbytes_length;
			int weightqshift = denomexponent + capexponent - weightquantbits + 1;
			int denomexponent =10;
			int muexponent = 15;
			int biasscalebits = 8;
			int halfmu = (1<<(muexponent-1))-1;
			int biasscalealmosthalf = (1<<(biasscalebits-1))-1;
			int Msg_head = 24; //Message header in bytes
			packetbytes_length = source.length - Msg_head; 
			
			decodepacketbitpointer = 0;
            decodepacketbytepointer = 0;
			for (int i=0;i<4 ;i++ )
			{
				for (int j=0;j<84 ;j++ )
				{
					destination[i][j] = 0;
				}
			}
			decodedfoldedsamples = new int[2048];
			decodedunfoldedsamples = new int[2048];
			packetdebiasedsamples = new int[2048];
			for (int k=0;k<2048;k++)
			{
				decodedfoldedsamples[k] = 0;
				decodedunfoldedsamples[k] = 0;
				packetdebiasedsamples [k]= 0;
			}
			// Create a logfile

			String logfile = "C:\\" + "test_compression_ratio" + ".txt";
			compress_logfile = new File(logfile);
			boolean exists = compress_logfile.exists();
			if (!exists){
				//create a new, empty node file
				try {	
					compress_logfile = new File(logfile);
					boolean success = compress_logfile.createNewFile();
				} 
				catch (IOException e) {
					System.out.println("Create Event Log file failed!");
				}
			}
			
			time_s ="";
			//System.out.println("--------Decompressing start************************************************************************"  + "\n"); 
			
			numdecodedsamples = decodepacket(codeoverheadbits, packetbytes_length,  source , Msg_head); // 1 sample costs 2 bytes
			//System.out.println("The number of source packet =" + source.length); 
			//System.out.println("The decoded number of sample in the packet =" + numdecodedsamples); 

			// reset bias estimate based on quantized value just read from packet
			int biasestimate_r = decoderbiasestimate_r;

			// reset weight vector based on quantized components just read from packet
			for (int i=0; i<order; i++){
				if (decodedweightquant[i]>0)
					weight_r[i] = (decodedweightquant[i])<<weightqshift;
				else if (decodedweightquant[i]<0)
					weight_r[i] = -((-decodedweightquant[i])<<weightqshift);
				else
					weight_r[i] = 0;
			}
			
			// At this point we have bias estimate and weight vector, and a packet of folded samples.
			// follow the prediction procedure to decode each sample given the folded value
			for (int i=0; i<numdecodedsamples; i++){
			    int j;
				int predicteddebiased_r;
				long predictedsample_r;
				int err_r;  // error in prediction of de-biased signal
				int maxsample_r = ((1<<(bitdepth-1))-1)<<denomexponent;
				int minsample_r = (-(1<<(bitdepth-1)))<<denomexponent;

				predicteddebiased_r = predictdebiasedsample_r(i);
				predictedsample_r = predicteddebiased_r + biasestimate_r;

				// predicted sample value cannot exceed the known instrument dynamic range
				if (predictedsample_r > maxsample_r)
				    predictedsample_r = maxsample_r;
				if (predictedsample_r < minsample_r)
				    predictedsample_r = minsample_r;
				
				decodedunfoldedsamples[i] = unfoldsample(decodedfoldedsamples[i], predictedsample_r);

				packetdebiasedsamples[i] = decodedunfoldedsamples[i] - ((biasestimate_r+almosthalf)>>denomexponent);
				
				/* update weight vector if we have sufficient samples in the packet */
				if (i>=order){
				    err_r = predicteddebiased_r - (packetdebiasedsamples[i]<<denomexponent);

					if (err_r<0)
					    for (j=1; j<=order; j++)
						    weight_r[j-1] += ((packetdebiasedsamples[i-j]<<denomexponent)+halfmu)>>muexponent;
					else
						for (j=1; j<=order; j++)
							weight_r[j-1] -= ((packetdebiasedsamples[i-j]<<denomexponent)+halfmu)>>muexponent;
				}

				/* update bias estimate */
				biasestimate_r -= (biasestimate_r - (decodedunfoldedsamples[i]<<denomexponent) + biasscalealmosthalf) >> biasscalebits;
				
				/* At this point, decodedsample is our decoded sample value and the prediction information
				has been updated to decode the next sample. */
				
				/* process the next sample in the packet */
			}

			write_Byte_array(Msg_head, packetbytes_length, numdecodedsamples,source); // judge whether the generated array is contained in one packet ...
			
			/*int arr_num = (numdecodedsamples / 28 )+1;
				for (int k=0;k<arr_num-1 ;k++ )
				{
				decodepacketbitpointer = 0;
				decodepacketbytepointer = 28;
				for (int i=0;i<28 ;i++ )
				{
					System.out.println("***Samples decompressed from each packet:  " + readint(16,destination[k]) + "\n");
				}
				}
				if ((numdecodedsamples % 28) != 0)
				{
					decodepacketbitpointer = 0;
					decodepacketbytepointer = 28;
					for (int k=0;k< numdecodedsamples % 28 ;k++ )
					{
						System.out.println("***Samples decompressed from each packet:  " + readint(16,destination_last_row) + "\n");
					}
				}
				*/
			
			return numdecodedsamples;
	}


	/* Decode the current encoded packet, storing the result (folded sample values) in the decodedfoldedsamples array
	returns the number of samples in the packet, or -1 on error. */

	public static int decodepacket(int codeoverheadbits, int packetbytes_length, byte[] source, int start)
		{
			int i;
			int codingparameter = 0;
			int thefoldedsamplevalue = 0;
			int biasquantindex=0;
			TOS_length = source[0]; // length of tos_message head
			//System.out.println("The length head of source packet =" + TOS_length); 
			//System.out.println("The length =" + TOS_length); 
			//decodepacketbytepointer = 21;
			APP_length = source[21]; // length of app_message head
			decodepacketbytepointer = start-2;
			APP_seqo = readint(16,source);
			//System.out.println("The sequ_no of received compressed packet =" + APP_seqo + "\n"); 
			
			time= read_time_stamp(source,start,4);
			timestamp= time[0];
			timeinterval=time[1];
			//System.out.println("The timestamp =" + time[0]); 
			decodepacketbytepointer = start+4; // Move the decodepacketbytepointer 4 bytes forward

			/* get the quantized biasestimated value */
			biasquantindex = readsignmagnitude(biasquantbits,source);	// get the bias quantizer index
			decoderbiasestimate_r = reconquantized_r(biasquantindex,biasquantbits);
			
			/* get the quantized weight components */
			/* coding method depends on whether weight components were normal or non-normal, which is flagged by a single bit */
			if (readbit(source)!=0) { // non-normal weight components
				for (i=0; i<order; i++)
					decodedweightquant[i] = readsignmagnitude(weightquantbits,source);
			} else { // normal weight components
				int thissign = 1;
				int magnitudebits = weightquantbits-1;
				int magnitude;
		
				for (i=0; i<order; i++){
					magnitude = readunsignedint(magnitudebits,source);
					decodedweightquant[i] = thissign*magnitude;
					thissign = -thissign;
					magnitudebits = 0;
					while (magnitude > 0){
						magnitude >>= 1;
						magnitudebits++;
					}
					if (magnitudebits==0)
						magnitudebits=1;
				}
			}

			/* get the coding parameter */
			for (i=0; i<codeoverheadbits; i++){
	    		if (decodepacketbytepointer < source.length)
				{
					if (readbit(source)==1) {
						//System.out.println("The codingparameter readbit is 1" + "\n");
						codingparameter |= (1<<i);
		    		
					} 
				}
			}

			/* if coding parameter is all ones, then it indicates uncoded data */
			if (codingparameter == ((1<<codeoverheadbits)-1))
	    		codingparameter=-1;
			
			//System.out.println("The codingparameter is ***   " + codingparameter + "\n"); 

			/* Decode the first folded sample, which was sent uncoded */
			//decodedfoldedsamples[0] = readint(bitdepth,source);
	    	//decodedunfoldedsamples[0] = unfoldsample(decodedfoldedsamples[0],0);

			/* Decode the remaining folded samples from the packet */
			i=0;
			while ((thefoldedsamplevalue = decodevalue(codingparameter,packetbytes_length,source)) != -1){
	    		//System.out.println("The decodevalue is ***   " + thefoldedsamplevalue + "\n"); 
				decodedfoldedsamples[i] = thefoldedsamplevalue;
				//decodedunfoldedsamples[i] = unfoldsample(thefoldedsamplevalue,((long)decodedunfoldedsamples[i-1])<<denomexponent);
				i++;
			}

			/* reset variables for next packet read */
			decodepacketbitpointer = 0;
			decodepacketbytepointer = 0;
		
			return i;
	}

	/* Decode the unsigned integer value using the indicated GPO2 code, or uncoded.	Return -1 if decoding failed. */
	public static int decodevalue (int thecodeparameter,int packetbytes_length, byte[] source )
		{
			int i;
			int thisdecodedvalue=0;
			int gotbit=0;
		
			if (thecodeparameter==-1){  // code parameter value of -1 indicates that value was sent uncoded
				if ((decodepacketbytepointer < source.length)&&(8*(packetbytes_length-decodepacketbytepointer-1)+(8-decodepacketbitpointer))>=bitdepth)
				{
					for (i=0; i<bitdepth; i++){
		    			thisdecodedvalue <<= 1; // read one time and left-shift to store the next bit
						thisdecodedvalue |= readbit(source);
				    }
				}
				else
					thisdecodedvalue = -1;
			} else { // the value was encoded using the indicated GPO2 code, or else there are no more values in the packet
	    	// decode the unary part
				while ((decodepacketbytepointer < source.length) && ((gotbit=readbit(source))==0))
					thisdecodedvalue++;
						
				if ((gotbit==1) &&(decodepacketbytepointer < source.length))
				{ // We have a vaild sample, now read the k least significant bits
					thisdecodedvalue <<= thecodeparameter;
					for(i=0; i<thecodeparameter; i++){
						if (decodepacketbytepointer < source.length)
						{
							if (readbit(source)==1)
				   			thisdecodedvalue |= (1<<i);
						}
						else
							thisdecodedvalue = -1;
					}
				} else
				{ // we're at the end of the packet
		    		thisdecodedvalue = -1;
				}
			}
			return thisdecodedvalue;	
	}

	/* Function to predict the value of a sample. */
	/* This is a function to predict the sample value AFTER THE ESTIMATED BIAS HAS BEEN REMOVED.
	I.e.., take the output of this function and add back in the estimated bias if you want to predict the next sample value. */
	/* The argument "numpacketsamples" is the number of samples in the packet that have already been encoded.
	(so, e.g., numpacketsamples is zero when we're trying to predict the first sample value.)  */
	/* The value returned is to be interpreted as the numerator N of a rational number */
	public static int predictdebiasedsample_r(int numpacketsamples){
		int predictedvalue_r = 0;
		int i;
		
		if (numpacketsamples >= order){ // regular prediction
	
			for (i=0; i<order; i++)
				predictedvalue_r += weight_r[i]*packetdebiasedsamples[numpacketsamples-i-1];
	
		} else if (numpacketsamples > 0) { // at least one sample for prediction, but not enough for regular prediction
			for (i=0; i<numpacketsamples; i++)
				predictedvalue_r += (weight_r[i]*packetdebiasedsamples[numpacketsamples-i-1]);
			// repeat the first sample value to make up for the lack of samples
			for (i=numpacketsamples; i<order; i++)
				predictedvalue_r += (weight_r[i]*packetdebiasedsamples[0]);
		}
		
		return predictedvalue_r;
	}


	/* Inverse of the foldsample() function.  (Given folded value and predicted value, recover the sample value.) */
	public static int unfoldsample(int foldedvalue, long theprediction)
		{
  			int roundprediction;
			int delta, theta;
			int thesamplevalue;
	
			/* round the predicted value to the nearest integer */
			//roundprediction = (theprediction + almosthalf)>>denomexponent;
			roundprediction = min(max((int)((theprediction + almosthalf)>>denomexponent),minsamplevalue),maxsamplevalue);

			theta = min(roundprediction-minsamplevalue, maxsamplevalue-roundprediction);
	
		if (foldedvalue > (theta<<1)) { // outside the usual range
	   		if (theta == maxsamplevalue-roundprediction) // delta must have been negative
		    	delta = theta - foldedvalue;
			else
		    	delta = foldedvalue - theta;
		} else {
			/* mapping depends on whether we rounded the predicted value up or down */
			if ((roundprediction<<denomexponent)>theprediction){
				// we rounded up, so negative differences should be slightly more likely than positive ones
				if ((foldedvalue & 1)==1)
			    	delta = -((foldedvalue+1)>>1);   // folded value is odd
				else
			    	delta = foldedvalue>>1;         // folded value is even
			} else {
				// we rounded down
				if ((foldedvalue & 1)==1)
			    	delta = (foldedvalue+1)>>1;   // folded value is odd
				else
			    	delta = -(foldedvalue>>1);   // folded value is even
			}
		}
	
		thesamplevalue = delta + roundprediction;

		return thesamplevalue;
	}

	public static int readbit(byte[] source){
		int i=0;
		if (decodepacketbytepointer < source.length)
		{
			if ((source[decodepacketbytepointer]&(1<<decodepacketbitpointer)) != 0)
				i =1;
			else
				i =0;
			//System.out.println("bitvalue "+ i +"\n");

		    decodepacketbitpointer++;
			if (decodepacketbitpointer==8){
	    		decodepacketbitpointer=0;
				decodepacketbytepointer++;
			}
		}
		else
			System.out.println("Error! Attempted read past end of packet!\n");
			//System.out.println("bitvalue after "+ i +"\n");
		return i;
	}

	public static int readint(int numbits, byte[] source){
		int i = 0;
		int readvalue = 0;
		for (i=0; i<numbits; i++){
			if (decodepacketbytepointer < source.length)
			{
				if (readbit(source)==1)
					readvalue |= (1<<i);
			}
	}
		return readvalue;
	}

	public static void write_Byte_array (int Msg_head, int packetbytes_length,int numdecodedsamples, byte[] source)	{
			int i = 0;
			int k=0;
			int quote=0;
			int residule = 0;
			long min,sec,millisec,time_pre;
			String descript_string = "";

			//System.out.println("#####The Number of decompressed packets =  " + numdecodedsamples + " "  + "\n"); 
			//System.out.println("Destination[0][0]:" + destination[0][0] + "\n " );
			//System.out.println("decodepacketbytepointer " + decodepacketbytepointer + " " + decodepacketbitpointer + "\n " );
			// decompressed data less than packetbytes_length
			if (numdecodedsamples <= (packetbytes_length/2-2)) // one sample is stored by two bytes
			{
				// change length here
				TOS_length = (Msg_head-10 + 4 + numdecodedsamples*2);
				APP_length = (TOS_length - 14);
				source[0] &= ~(0xff);  //TOS_Msg length
				source[21] &= ~(0xff); //APP_Msg length
				source[0] |= (TOS_length&0xff); // only one byte can be written 
				source[21] |= (APP_length&0xff); // only one byte can be written 
				//System.out.println(" Length ****** " + source[0] + " " + source[21] + " "+ k + "\n " );
				for (i=0;i<(Msg_head+timestampbits/8);i++ )
				{
					//System.out.println(Msg_head + " " + timestampbits);
					//System.out.println(source[i] + " " + i);
					writeint(0,8,source[i]);
				}
				//writeint(0,4,source[i]);//codingparameter written
				for (i=0;i<numdecodedsamples;i++)
				{
					writeint(0,16,decodedunfoldedsamples[i]);
				}
			    //System.out.println("decodepacketbytepointer " + decodepacketbytepointer + " " + decodepacketbitpointer + "\n " );
				/* reset variables for next packet read */
				decodepacketbitpointer = 0;
				decodepacketbytepointer = 0;
				//System.out.println("Destination[0][0]:" + destination[0][0] + "\n " );
				//Write to a file with the timestamp and numdecodedsamples
				//descript_string  += time_s;
				//descript_string += " ";
				descript_string += numdecodedsamples;
				//descript_string += " ";
				//descript_string +=decodedfoldedsamples[5];
				//descript_string += " ";
				//descript_string += decodedunfoldedsamples[1];
				//descript_string += " ";
				//descript_string += decodedunfoldedsamples[numdecodedsamples-2];
				descript_string += "\r\n";
				try {
					FileOutputStream  outstream;
					outstream = new FileOutputStream(compress_logfile,true);  
					for (int m=0; m<descript_string.length();++m){
						outstream.write((byte)descript_string.charAt(m));
					}
				outstream.close();
				} catch (IOException e) {
			}
				
				
			}
			 // the bytes after decompression is longer than the compressed one, it should be seperated into several packets
			else {	
				try{
				 FileOutputStream  outstream;
				outstream = new FileOutputStream(compress_logfile,true);

				quote = numdecodedsamples / (packetbytes_length/2-2);
				for (k=0;k<quote;k++)
				{
					for (i=0;i<Msg_head;i++ )
					{
						writeint(k,8,source[i]);
					}
					//System.out.println("Changing Time ******** " + timestamp + "\n " );
					if (k > 0)
					{
						// change time_stamp here
						timestamp += ((packetbytes_length)/2)*timeinterval;
					}
					time_pre = timestamp;
					min = (timestamp/60000);
					writeint(k,6,min);  //write minute byte
					timestamp = timestamp % 60000;
					sec = (timestamp/1000);
					writeint(k,6,sec);  //write second byte
					timestamp = timestamp %1000;
					millisec = timestamp;
					writeint(k,10,millisec);  //write millisecond byte
					writeint(k,10,timeinterval); //write time interval
					timestamp = time_pre;
					//writeint(k,4,source[28]);//codingparameter written
					
					for (i=k*(packetbytes_length/2-2);i<(k+1)*(packetbytes_length/2-2);i++)
					{
						writeint(k,16,decodedunfoldedsamples[i]); // one sample costs two bytes
					}
				//System.out.println("decodepacketbytepointer " + decodepacketbytepointer + " " + decodepacketbitpointer + "\n " );
				// reset variables for next packet read
				decodepacketbitpointer = 0;
				decodepacketbytepointer = 0;
				
				//System.out.println("Destination[0][0]:" + destination[0][0] + "\n " );
				
				}
				//Write to a file with the timestamp and numdecodedsamples
				descript_string  += time_s;
				descript_string += " ";
				descript_string += numdecodedsamples;
				descript_string += " ";
				descript_string +=decodedfoldedsamples[1];
				descript_string += " ";
				descript_string += decodedunfoldedsamples[1];
				descript_string += " ";
				descript_string += decodedunfoldedsamples[numdecodedsamples-2];
				descript_string += "\r\n";
				  
				for (int m=0; m<descript_string.length();++m){
					outstream.write((byte)descript_string.charAt(m));
				}
				descript_string = "";

				if ((residule = (numdecodedsamples) % (packetbytes_length/2-2)) !=0)
				{
					//System.out.println("For the residule***************"  + "\n " );
					// change length here
					TOS_length = (Msg_head-10 + 4 + residule*2);
					APP_length = (TOS_length - 14);
					source[0] &= ~(0xff);  //TOS_Msg length
					source[21] &= ~(0xff); //APP_Msg length
					source[0] |= (TOS_length&0xff); // only one byte can be written 
					source[21] |= (APP_length&0xff); // only one byte can be written 
					//System.out.println("Changing Length ******TOS_length " + source[0] + "\n " );
					destination_last_row = new byte[TOS_length+10];

					for (i=0;i<Msg_head;i++ )
					{
						writeint_last_row(8,source[i]);
					}
					
					// change time_stamp here
					timestamp += ((packetbytes_length)/2)*timeinterval;
					time_pre = timestamp;
					min = (timestamp/60000);
					writeint_last_row(6,min);  //write minute byte
					timestamp = timestamp % 60000;
					sec = (timestamp/1000);
					writeint_last_row(6,sec);  //write second byte
					timestamp = timestamp %1000;
					millisec = timestamp;
					writeint_last_row(10,millisec);  //write millisecond byte
					writeint_last_row(10,timeinterval); //write time interval
					timestamp = time_pre;
					
					for (i=quote*(packetbytes_length/2-2);i<((quote)*(packetbytes_length/2-2)+residule);i++)
					{
						writeint_last_row(16,decodedunfoldedsamples[i]);
					}
					// reset variables for next packet read 
					decodepacketbitpointer = 0;
					decodepacketbytepointer = 0;
					//Write to a file with the timestamp and numdecodedsamples
					/*descript_string  += time_s;
					descript_string += " ";
					descript_string += residule;
					descript_string += "\r\n";
					for (int m=0; m<descript_string.length();++m){
						outstream.write((byte)descript_string.charAt(m));
					}
					descript_string = "";*/
				}
				
			outstream.close();
			} catch (IOException e) {
			}
			//return 1;
			}
	}
	
	public static void writeint(int index_num, int numbits, long writevalue){
		int i=0;
		long j=0;
		for (i=0;i<numbits ;i++ )
		{	j = writevalue&(1<<i);
			if ( j != 0)
			{
				writebit(index_num,1);
			}
			else
				writebit(index_num, 0);
		}
	
	}

	public static void writeint(int index_num, int numbits, int writevalue){
		int i=0;
		int j=0;
		for (i=0;i<numbits ;i++ )
		{	
			j = writevalue&(1<<i);
			if (j!=0)
			{
				writebit(index_num, 1);
				//System.out.println("INTO writeint:" + "decodepacketbytepointer " + decodepacketbytepointer + " " + decodepacketbitpointer + "\n " );
			}
			else{
				writebit(index_num, 0);
			}
		
		}
		//System.out.println("Destination[index_num][0]:" + destination[index_num][0] + "\n " );
	}

	/* Write a single bit value to the packet. If bitvalue is nonzero, a one will be encoded, otherwise a zero will be encoded. */
	public static void writebit(int index_num, int bitvalue){
		if (decodepacketbytepointer >= 84){
			System.out.println("Error! Attempted read past end of packet!\n");
			//exit(1);
		}
		
		if (bitvalue==1)
		{	
			destination[index_num][decodepacketbytepointer] |= (1<<decodepacketbitpointer);	// write a 1 bit
			//System.out.println("INTO writebit:" + "bitvalue " + bitvalue + " " + decodepacketbytepointer + " " + decodepacketbitpointer + " " +index_num + "\n " );
		}
		else 
			destination[index_num][decodepacketbytepointer] &= ~(1<<decodepacketbitpointer);   // write a 0 bit 
	
		/* point to next bit in the packet */
		decodepacketbitpointer++;
		if (decodepacketbitpointer==8){
			decodepacketbitpointer=0;
			decodepacketbytepointer++;
	    }

	}

	public static void writeint_last_row(int numbits, int writevalue){
		int i=0;
		int j=0;
		for (i=0;i<numbits ;i++ )
		{	
			j = writevalue&(1<<i);
			if (j!=0)
			{
				writebit_last_row(1);
			}
			else{
				writebit_last_row(0);
			}
		
		}
	}

	public static void writeint_last_row(int numbits, long writevalue){
		int i=0;
		long j=0;
		for (i=0;i<numbits ;i++ )
		{	
			j = writevalue&(1<<i);
			if (j!=0)
			{
				writebit_last_row(1);
			}
			else{
				writebit_last_row(0);
			}
		
		}
	}

	public static void writebit_last_row(int bitvalue){
		if (decodepacketbytepointer >= 84){
			System.out.println("Error! Attempted read past end of packet!\n");
		}
		
		if (bitvalue==1)
		{	
			destination_last_row[decodepacketbytepointer] |= (1<<decodepacketbitpointer);	// write a 1 bit
		}
		else 
			destination_last_row[decodepacketbytepointer] &= ~(1<<decodepacketbitpointer);   // write a 0 bit 
	
		/* point to next bit in the packet */
		decodepacketbitpointer++;
		if (decodepacketbitpointer==8){
			decodepacketbitpointer=0;
			decodepacketbytepointer++;
	    }

	}

	public static int min (int a, int b)
		{
		if (a < b)
			return a;
		else
			return b;

	}
	
	public static int max (int a, int b)
		{
		if (a > b)
			return a;
		else
			return b;
	
	}

	public static long[] read_time_stamp(byte[] arr, int start, int len) {
		try {
			int i = 0;
			int cnt = 0;
			long hours,minutes,seconds,milisecond, interval;
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
				}    //reverse first time;
				
				for (int k=0; k<temp.length(); k++) {
              			  reversed = temp.substring(k, k+1) + reversed;			
       			}   //reverse second time;
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
			
			time_s +=minutes;
			time_s +=":";
			time_s +=seconds;
			time_s +=":";
			time_s +=milisecond;

			time[0] = startTimeCalculation;
			time[1] = interval;
			return time;
		}
		catch (Exception ex){ex.printStackTrace();}
		time[0]=0;
		time[1]=1;
		return time;
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





/* Read a signed integer that was encoded using magnitude/sign representation, using the nominal given number of bits */
public static int readsignmagnitude(int numbits, byte[] source){
    int decodedvalue;
	int i;
	
	// get the magnitude
	decodedvalue = readunsignedint(numbits-1,source);
	
	// get the sign bit and adjust accordingly if the magnitude is nonzero
	if (decodedvalue > 0)
	    if (readbit(source)!=0)
		    decodedvalue = -decodedvalue;

	return decodedvalue;
}


/* read a non-negative integer that was encoded using the given number of bits */
public static int readunsignedint(int numbits, byte[] source){
    int i;
	int decodedvalue=0;
	
	for (i=0; i<numbits; i++)
	    if (readbit(source)!=0)
		    decodedvalue |= (1<<i);

	return decodedvalue;
}



/* reconstruct a given quantized value (as a rational number) given the quantizer bin index */
public static int reconquantized_r(int quantizedvalue, int resolutionbits){
	int reconvalue_r;
	
	if (quantizedvalue!=0)
	    if (quantizedvalue<0)
		    reconvalue_r = -((-quantizedvalue)<<(denomexponent + bitdepth - resolutionbits));
		else
		    reconvalue_r = quantizedvalue<<(denomexponent + bitdepth - resolutionbits);
	else
	    reconvalue_r=0;

	return reconvalue_r;
}



	
}





