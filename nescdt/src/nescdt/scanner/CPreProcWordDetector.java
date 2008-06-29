package nescdt.scanner;

import org.eclipse.jface.text.rules.IWordDetector;

/**
 * A C aware word detector.
 */
public class CPreProcWordDetector implements IWordDetector {

	/**
	 * @see IWordDetector#isWordIdentifierStart
	 */
	public boolean isWordStart(char c) {
		return c == '#';
	}

	/**
	 * @see IWordDetector#isWordIdentifierPart
	 */
	public boolean isWordPart(char c) {
		return Character.isJavaIdentifierPart(c);
	}
}