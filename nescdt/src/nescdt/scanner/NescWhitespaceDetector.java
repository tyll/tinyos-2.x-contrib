package nescdt.scanner;

import org.eclipse.jface.text.rules.IWhitespaceDetector;

/**
 * Whitespace detector.
 */
public class NescWhitespaceDetector implements IWhitespaceDetector {

	/**
	 * Checks if a character is a whitespace (space, tab, or newline).
	 * 
	 * @param c
	 *            the character to check
	 * @return true if the character is a whitespace
	 */
	public boolean isWhitespace(char c) {
		return (c == ' ' || c == '\t' || c == '\n' || c == '\r');
	}
}
