package nescdt;

import java.util.MissingResourceException;
import java.util.ResourceBundle;

/**
 * Provides the messages defined in the NescEditorMessages.properties file.
 */
public class NescEditorMessages {

	private static final String RESOURCE_BUNDLE= "nescdt.NescEditorMessages";//$NON-NLS-1$

	private static ResourceBundle fgResourceBundle= ResourceBundle.getBundle(RESOURCE_BUNDLE);

	// It should not be instanciated
	private NescEditorMessages() {
	}

	public static String getString(String key) {
		try {
			return fgResourceBundle.getString(key);
		} catch (MissingResourceException e) {
			return "!" + key + "!";//$NON-NLS-2$ //$NON-NLS-1$
		}
	}
	
	public static ResourceBundle getResourceBundle() {
		return fgResourceBundle;
	}
}
