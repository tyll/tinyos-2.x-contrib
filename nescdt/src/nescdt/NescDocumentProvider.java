package nescdt;

import nescdt.scanner.NescPartitionScanner;

import org.eclipse.core.runtime.CoreException;
import org.eclipse.jface.text.IDocument;
import org.eclipse.jface.text.IDocumentPartitioner;
import org.eclipse.jface.text.rules.FastPartitioner;
import org.eclipse.ui.editors.text.FileDocumentProvider;


/**
 * Provides the document.
 */
public class NescDocumentProvider extends FileDocumentProvider {

	/**
	 * Creates the document using a Fastpartitioner and the
	 * <code>NescPartitioner</code>.
	 */
	protected IDocument createDocument(Object element) throws CoreException {
		IDocument document = super.createDocument(element);
		if (document != null) {
			IDocumentPartitioner partitioner = new FastPartitioner(
					new NescPartitionScanner(), null);
			partitioner.connect(document);
			document.setDocumentPartitioner(partitioner);
		}
		return document;
	}
}
