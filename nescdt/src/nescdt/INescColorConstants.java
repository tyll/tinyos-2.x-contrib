package nescdt;

import org.eclipse.swt.graphics.RGB;

/** The colors for the different types of text. 
 *  Examples of colors are here (with RGB codes): http://www.pitt.edu/~nisg/cis/web/cgi/rgb.html
 * */
public interface INescColorConstants {
	/** RGB color of the comments. */
	public static final RGB COMMENT = new RGB(63, 127, 95);
	/** RGB color of the strings. */
	public static final RGB STRING = new RGB(0, 0, 255);
	/** RGB color of the default. */	
	public static final RGB DEFAULT = new RGB(0, 0, 0);
	/** RGB color of the keywords. */
	public static final RGB KEYWORDS = new RGB(127, 0, 85);
	/** RGB color of the types. */
	public static final RGB TYPES = new RGB(127, 0, 85);// (255, 128, 64);
	/** RGB color of the pre processing statements. */
	public static final RGB PREPROC = new RGB(127, 0, 85);// (255, 128, 64);
}
