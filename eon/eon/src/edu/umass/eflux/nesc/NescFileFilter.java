/**
 * 
 */
package edu.umass.eflux.nesc;

import java.io.File;
import java.io.FilenameFilter;

/**
 * @author sorber
 *
 */
public class NescFileFilter implements FilenameFilter {

	/**
	 * 
	 */
	public NescFileFilter() {
		// TODO Auto-generated constructor stub
	}

	/* (non-Javadoc)
	 * @see java.io.FilenameFilter#accept(java.io.File, java.lang.String)
	 */
	public boolean accept(File dir, String name) {
		
		if (name.toLowerCase().endsWith(".nc") && new File(dir,name).isFile())
		{
			return true;
		}
		
		return false;
	}

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub

	}

}
