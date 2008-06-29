package nescdt.scanner;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import nescdt.ColorManager;
import nescdt.INescColorConstants;
import nescdt.constants.NescKeywords;

import org.eclipse.jface.text.TextAttribute;
import org.eclipse.jface.text.rules.IRule;
import org.eclipse.jface.text.rules.IToken;
import org.eclipse.jface.text.rules.IWordDetector;
import org.eclipse.jface.text.rules.MultiLineRule;
import org.eclipse.jface.text.rules.RuleBasedScanner;
import org.eclipse.jface.text.rules.SingleLineRule;
import org.eclipse.jface.text.rules.Token;
import org.eclipse.jface.text.rules.WhitespaceRule;
import org.eclipse.jface.text.rules.WordRule;
import org.eclipse.swt.SWT;


/**
 * The rules that are used to partition the default the default partition.
 */
public class NescScanner extends RuleBasedScanner {

	/**
	 * It sets up the scanner using the keywords, the comments, the types, and
	 * the preprocessing statements.
	 * 
	 * @param manager
	 */
	public NescScanner(ColorManager manager) {

		NescKeywords.setupKeywords();

		List<IRule> rules = new ArrayList<IRule>();

		IToken comInstr = new Token(new TextAttribute(manager
				.getColor(INescColorConstants.COMMENT)));

		// Add rule for processing instructions
		rules.add(new MultiLineRule("/*", "*/", comInstr));
		rules.add(new SingleLineRule("//", "", comInstr));

		IToken strTok = new Token(new TextAttribute(manager
				.getColor(INescColorConstants.STRING)));
		// Add rule for strings and character constants.
		rules.add(new SingleLineRule("'", "'", strTok, '\\')); //$NON-NLS-1$ //$NON-NLS-2$
		rules.add(new SingleLineRule("\"", "\"", strTok, '\\')); //$NON-NLS-1$ //$NON-NLS-2$

		// Add generic whitespace rule.
		rules.add(new WhitespaceRule(new NescWhitespaceDetector()));

		WordRule rule = new WordRule(new IWordDetector() {
			public boolean isWordStart(char c) {
				return Character.isJavaIdentifierStart(c);
			}

			public boolean isWordPart(char c) {
				return Character.isJavaIdentifierPart(c);
			}
		});

		rules.add(rule);

		// Add rules for keyword1
		Token token = new Token(new TextAttribute(manager
				.getColor(INescColorConstants.KEYWORDS), null, SWT.BOLD));
		Iterator<String> itr = NescKeywords.KEYWORDS.iterator();
		while (itr.hasNext()) {
			rule.addWord(itr.next(), token);
		}

		// Add rules for types
		token = new Token(new TextAttribute(manager
				.getColor(INescColorConstants.TYPES), null, SWT.BOLD));
		itr = NescKeywords.TYPES.iterator();
		while (itr.hasNext()) {
			rule.addWord(itr.next(), token);
		}

		// Add rules for preproc
		token = new Token(new TextAttribute(manager
				.getColor(INescColorConstants.PREPROC), null, SWT.BOLD));
		PreprocessorRule preprocessorRule = new PreprocessorRule(
				new CPreProcWordDetector(), token);
		itr = NescKeywords.PREPROC.iterator();
		while (itr.hasNext()) {
			preprocessorRule.addWord(itr.next(), token);
		}
		rules.add(preprocessorRule);

		IRule[] result = new IRule[rules.size()];
		rules.toArray(result);

		setRules(result);
	}


}
