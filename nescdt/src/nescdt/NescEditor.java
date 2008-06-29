package nescdt;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.TreeSet;

import org.eclipse.jface.action.IAction;
import org.eclipse.jface.text.source.ISourceViewer;
import org.eclipse.ui.editors.text.TextEditor;
import org.eclipse.ui.texteditor.ITextEditorActionDefinitionIds;
import org.eclipse.ui.texteditor.TextOperationAction;

/**
 * Eclipse editor for nesC. The document (the .nc file) is partitioned into
 * non-overlapping regions. Each partition is associated with a scanner, which
 * formats the text in that region. Most text belongs to the default region.
 * Both the partitioner and the parsers use rules to determine matches. Eclipse
 * Public License.
 */
public class NescEditor extends TextEditor {

	private ColorManager colorManager;

	/**
	 * Overrides selected methods of the super class to set things like the 
	 * color manager, the source viewer configuration, and the document provider.
	 */
	public NescEditor() {
		super();
		colorManager = new ColorManager();
		NescPlugin.setColorManager(colorManager);
		
		setSourceViewerConfiguration(new NescSourceViewerConfiguration(
				colorManager));
		setDocumentProvider(new NescDocumentProvider());
	}
	
	/**
	 * Creates the content/context assistance. See also the NescCompletionProcessor.
	 */
	protected void createActions() {
		super.createActions();
		
		IAction a= new TextOperationAction(NescEditorMessages.getResourceBundle(), "ContentAssistProposal.", this, ISourceViewer.CONTENTASSIST_PROPOSALS); //$NON-NLS-1$
		a.setActionDefinitionId(ITextEditorActionDefinitionIds.CONTENT_ASSIST_PROPOSALS);
		setAction("ContentAssistProposal", a); //$NON-NLS-1$
		
		a= new TextOperationAction(NescEditorMessages.getResourceBundle(), "ContentAssistTip.", this, ISourceViewer.CONTENTASSIST_CONTEXT_INFORMATION);  //$NON-NLS-1$
		a.setActionDefinitionId(ITextEditorActionDefinitionIds.CONTENT_ASSIST_CONTEXT_INFORMATION);
		setAction("ContentAssistTip", a); //$NON-NLS-1$
		
	}
	
	public void dispose() {
		colorManager.dispose();
		super.dispose();
	}

}
