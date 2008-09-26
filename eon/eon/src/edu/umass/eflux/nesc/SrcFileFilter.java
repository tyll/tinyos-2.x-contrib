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
public class SrcFileFilter implements FilenameFilter {

	/**
	 * 
	 */
	public SrcFileFilter() {
		// TODO Auto-generated constructor stub
	}

	/* (non-Javadoc)
	 * @see java.io.FilenameFilter#accept(java.io.File, java.lang.String)
	 */
	public boolean accept(File dir, String name) {
		return ((name.endsWith(".nc") || name.endsWith("h")) && new File(dir,name).isFile());
	}

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub

	}

}
