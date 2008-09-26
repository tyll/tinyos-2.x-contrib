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
public class DirectoryFilter implements FilenameFilter {

	/**
	 * 
	 */
	public DirectoryFilter() {
		// TODO Auto-generated constructor stub
	}

	/* (non-Javadoc)
	 * @see java.io.FilenameFilter#accept(java.io.File, java.lang.String)
	 */
	public boolean accept(File dir, String name) {
		//System.out.println("accept("+dir.getPath()+"..."+name+") ?");
		if (new File(dir,name).isDirectory() && 
				!name.equals("..") && 
				!name.startsWith("."))
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
