/**
 * 
 */
package edu.umass.eflux.nesc;

import java.io.File;
import java.net.URI;

/**
 * @author sorber
 *
 */
public class NESCFile extends File {
	private Object nesc_data;
	
	public NESCFile(File afile, Object parseddata) {
		super(afile.getPath());
		
		nesc_data = parseddata;
		
	}

	public Object getNescData()
	{
		return nesc_data;
	}
	
	
	
	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub

	}

}
