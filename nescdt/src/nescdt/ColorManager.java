package nescdt;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import org.eclipse.swt.graphics.Color;
import org.eclipse.swt.graphics.RGB;
import org.eclipse.swt.widgets.Display;

/**
 * Returns SWT <code>Color</code> objects for RGB color codes. Caches on the
 * fly.
 */
public class ColorManager {

	/**
	 * Storage for the <code>Color</code> objects.
	 */
	protected Map fColorTable = new HashMap(10);

	/**
	 * Remove the <code>Color</code> objects.
	 */
	public void dispose() {
		Iterator e = fColorTable.values().iterator();
		while (e.hasNext())
			((Color) e.next()).dispose();
	}

	/**
	 * Get a <code>Color</code> object in return for a RGB code.
	 * 
	 * @param rgb
	 *            the RGB code
	 * @return the (cached) <code>Color</code> object
	 */
	public Color getColor(RGB rgb) {
		Color color = (Color) fColorTable.get(rgb);
		if (color == null) {
			color = new Color(Display.getCurrent(), rgb);
			fColorTable.put(rgb, color);
		}
		return color;
	}
}
