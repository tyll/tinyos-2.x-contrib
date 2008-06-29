package nescdt.completor;

import java.text.MessageFormat;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.Set;
import java.util.TreeMap;
import java.util.TreeSet;
import java.util.Vector;

import nescdt.NescEditorMessages;
import nescdt.constants.NescKeywords;

import org.eclipse.jface.text.FindReplaceDocumentAdapter;
import org.eclipse.jface.text.IDocument;
import org.eclipse.jface.text.ITextViewer;
import org.eclipse.jface.text.TextPresentation;
import org.eclipse.jface.text.contentassist.*;

/**
 * nesC completion processor, which uses a list of words to help the user with
 * content assistance.
 */
public class NescCompletionProcessor implements IContentAssistProcessor {

	/**
	 * This list is filled by the NescParser class.
	 */
	protected TreeMap<String, CompletionToken> fgProposals;

	// Interface props
	protected TreeMap<String, NescInterface> fgIProposals;

	public NescCompletionProcessor() {
		fgProposals = new TreeMap<String, CompletionToken>();
		fgIProposals = new TreeMap<String, NescInterface>();
	}

	/**
	 * Simple content assist tip closer. The tip is valid in a range of 5
	 * characters around its popup location.
	 */
	protected static class Validator implements IContextInformationValidator,
			IContextInformationPresenter {

		protected int fInstallOffset;

		/*
		 * @see IContextInformationValidator#isContextInformationValid(int)
		 */
		public boolean isContextInformationValid(int offset) {
			return Math.abs(fInstallOffset - offset) < 5;
		}

		/*
		 * @see IContextInformationValidator#install(IContextInformation,
		 *      ITextViewer, int)
		 */
		public void install(IContextInformation info, ITextViewer viewer,
				int offset) {
			fInstallOffset = offset;
		}

		/*
		 * @see org.eclipse.jface.text.contentassist.IContextInformationPresenter#updatePresentation(int,
		 *      TextPresentation)
		 */
		public boolean updatePresentation(int documentPosition,
				TextPresentation presentation) {
			return false;
		}
	}

	protected IContextInformationValidator fValidator = new Validator();

	/*
	 * (non-Javadoc) Method declared on IContentAssistProcessor
	 */
	/**
	 * It looks for all proposal strings that matches the beginning of a word
	 * from where the completion was started with CTRL + SPACE.
	 */
	public ICompletionProposal[] computeCompletionProposals(ITextViewer viewer,
			int documentOffset) {
		boolean dotActivation = false;

		Vector<ICompletionProposal> result = new Vector<ICompletionProposal>();
		// ICompletionProposal[] result= new
		// ICompletionProposal[fgProposals.length];
		IDocument doc = viewer.getDocument();

		FindReplaceDocumentAdapter frd = new FindReplaceDocumentAdapter(doc);

		int pos = documentOffset;
		do {
			pos--;
		} while (pos >= 0 && !Character.isWhitespace(frd.charAt(pos)));
		pos++;

		String stp = "";
		if (pos >= 0)
			stp = frd.subSequence(pos, documentOffset).toString();

		// See if we have . activation
		if (frd.charAt(documentOffset - 1) == '.') {
			String props[] = dotActivation(stp, result);
			for (int i = 0; i < props.length; i++) {
				String val = props[i];
				IContextInformation info = new ContextInformation(
						val,
						MessageFormat
								.format(
										"CompletionProcessor.Proposal.ContextInfo.pattern", new Object[] { val })); //$NON-NLS-1$
				// result.add(new CompletionProposal(fgProposals[i],
				// documentOffset, 0, fgProposals[i].length(), null,
				// fgProposals[i], info,
				// MessageFormat.format("CompletionProcessor.Proposal.hoverinfo.pattern",
				// new Object[] { fgProposals[i]}))); //$NON-NLS-1$
				result.add(new CompletionProposal(val, documentOffset, 0,
						val.length(), null, val, null, null)); //$NON-NLS-1$
			}

		} else {
			// System.out.println("String part:" + stp);
			Set<String> comps = fgProposals.keySet();
			Iterator<String> compitr = comps.iterator();
			while (compitr.hasNext()) {
				// CompletionToken comp = comps.nextElement();
				// String val = comp.getKey();
				String val = compitr.next();
				// If there are too many matches (and it becomes annoying) then
				// remove the two calls to toLowerCase() below
				// if (val.toLowerCase().startsWith(stp.toLowerCase())) {
				if (val.startsWith(stp)) {

					String rep = val.substring(stp.length());
					IContextInformation info = new ContextInformation(
							val,
							MessageFormat
									.format(
											"CompletionProcessor.Proposal.ContextInfo.pattern", new Object[] { val })); //$NON-NLS-1$
					// result.add(new CompletionProposal(fgProposals[i],
					// documentOffset, 0, fgProposals[i].length(), null,
					// fgProposals[i], info,
					// MessageFormat.format("CompletionProcessor.Proposal.hoverinfo.pattern",
					// new Object[] { fgProposals[i]}))); //$NON-NLS-1$
					
					// Do not show proposals with . if the stump does not have a .
					if(!((stp.indexOf('.') == -1) && val.indexOf('.') != -1)) {
						result.add(new CompletionProposal(rep, documentOffset, 0,
								rep.length(), null, val, null, null)); //$NON-NLS-1$
					}
					
				}
			}
		}

		// adding an empty string to ensure that the completion dialog appears
		if (result.size() == 0) {
			result.add(new CompletionProposal(
					"", documentOffset, 0, 0, null, "", null, null)); //$NON-NLS-1$
		}

		return result.toArray(new ICompletionProposal[result.size()]);
	}

	public String[] dotActivation(String dotStr, Vector<ICompletionProposal> vi) {
		String dotst = dotStr.substring(0, dotStr.length() - 1);
		NescInterface ni = fgIProposals.get(dotst);
		return ni.getIFuncs();
	}

	/*
	 * (non-Javadoc) Method declared on IContentAssistProcessor
	 */
	public IContextInformation[] computeContextInformation(ITextViewer viewer,
			int documentOffset) {
		IContextInformation[] result = new IContextInformation[5];
		for (int i = 0; i < result.length; i++)
			result[i] = new ContextInformation(
					MessageFormat
							.format(
									NescEditorMessages
											.getString("CompletionProcessor.ContextInfo.display.pattern"), new Object[] { new Integer(i), new Integer(documentOffset) }), //$NON-NLS-1$
					MessageFormat
							.format(
									NescEditorMessages
											.getString("CompletionProcessor.ContextInfo.value.pattern"), new Object[] { new Integer(i), new Integer(documentOffset - 5), new Integer(documentOffset + 5) })); //$NON-NLS-1$
		return result;
	}

	/*
	 * (non-Javadoc) Method declared on IContentAssistProcessor
	 */
	public char[] getCompletionProposalAutoActivationCharacters() {
		// return new char[] { '.', '(' };
		return new char[] { '.' };
	}

	/*
	 * (non-Javadoc) Method declared on IContentAssistProcessor
	 */
	public char[] getContextInformationAutoActivationCharacters() {
		return new char[] { '#' };
	}

	/*
	 * (non-Javadoc) Method declared on IContentAssistProcessor
	 */
	public IContextInformationValidator getContextInformationValidator() {
		return fValidator;
	}

	/*
	 * (non-Javadoc) Method declared on IContentAssistProcessor
	 */
	public String getErrorMessage() {
		return null;
	}

	public void addProposals(String[] propstrs) {
		for (int i = 0; i < propstrs.length; i++) {
			addProposal(propstrs[i]);
		}
	}

	public void addProposal(String propstr) {
		if (!fgProposals.containsKey(propstr)) {
			fgProposals.put(propstr, new CompletionToken(propstr, propstr));
		}
	}

	public void addIProposal(NescInterface ni) {
		if (!fgIProposals.containsKey(ni.getIName())) {
			fgIProposals.put(ni.getIName(), ni);
		}
	}

	/**
	 * Call this to sort the proposals after the last one has been added.
	 */
	public void sortProposals() {

	}
}
