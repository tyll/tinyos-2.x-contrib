package nescdt;

import nescdt.scanner.NescScanner;

import org.eclipse.jface.text.IDocument;
import org.eclipse.jface.text.TextAttribute;
import org.eclipse.jface.text.contentassist.ContentAssistant;
import org.eclipse.jface.text.contentassist.IContentAssistant;
import org.eclipse.jface.text.presentation.IPresentationReconciler;
import org.eclipse.jface.text.presentation.PresentationReconciler;
import org.eclipse.jface.text.rules.DefaultDamagerRepairer;
import org.eclipse.jface.text.rules.Token;
import org.eclipse.jface.text.source.ISourceViewer;
import org.eclipse.jface.text.source.SourceViewerConfiguration;
import org.eclipse.swt.graphics.RGB;


/**
 * Sets up a source viewer. It uses only one type of content. The 
 */
public class NescSourceViewerConfiguration extends SourceViewerConfiguration {
	private NescScanner scanner;
	private ColorManager colorManager;

	public NescSourceViewerConfiguration(ColorManager colorManager) {
		this.colorManager = colorManager;
	}

	/**
	 * Returns the default content (<code>IDocument.DEFAULT_CONTENT_TYPE</code>)
	 * type, which is the one used here.
	 * 
	 * @param sourceViewer
	 *            not used in this method
	 */
	public String[] getConfiguredContentTypes(ISourceViewer sourceViewer) {
		return new String[] { IDocument.DEFAULT_CONTENT_TYPE };
	}

	/**
	 * Return the scanner and create it if necessary.
	 * 
	 * @return the scanner
	 */
	protected NescScanner getNescScanner() {
		if (scanner == null) {
			scanner = new NescScanner(colorManager);
			scanner.setDefaultReturnToken(new Token(new TextAttribute(
					colorManager.getColor(INescColorConstants.DEFAULT))));
		}
		return scanner;
	}

	/**
	 * The presentation reconciler that uses a
	 * <code>DefaultDamagerRepairer</code> to calculate which part of the
	 * current partition is damaged. The <code>DefaultDamagerRepairer</code>
	 * knows the content type(s) and the associated repairer(s).
	 * 
	 * @param sourceViewer
	 *            not used here
	 * @return the presentation reconciler
	 */
	public IPresentationReconciler getPresentationReconciler(
			ISourceViewer sourceViewer) {
		PresentationReconciler reconciler = new PresentationReconciler();

		DefaultDamagerRepairer dr = new DefaultDamagerRepairer(getNescScanner());
		reconciler.setDamager(dr, IDocument.DEFAULT_CONTENT_TYPE);
		reconciler.setRepairer(dr, IDocument.DEFAULT_CONTENT_TYPE);

		return reconciler;
	}
	
	
	/* (non-Javadoc)
	 * Method declared on SourceViewerConfiguration
	 */
	public IContentAssistant getContentAssistant(ISourceViewer sourceViewer) {

		ContentAssistant assistant= new ContentAssistant();
		assistant.setDocumentPartitioning(getConfiguredDocumentPartitioning(sourceViewer));
		assistant.setContentAssistProcessor(NescPlugin.getCompProc(), IDocument.DEFAULT_CONTENT_TYPE);
		
		assistant.enableAutoActivation(true);
		assistant.setAutoActivationDelay(500);
		assistant.setProposalPopupOrientation(IContentAssistant.PROPOSAL_OVERLAY);
		assistant.setContextInformationPopupOrientation(IContentAssistant.CONTEXT_INFO_ABOVE);
		assistant.setContextInformationPopupBackground(NescPlugin.getDefault().getColorManager().getColor(new RGB(150, 150, 0)));

		return assistant;
	}
}