package nescdt.scanner;

import org.eclipse.jface.text.rules.RuleBasedPartitionScanner;

public /**
 * The scanner to divide the full text into partitions, but only one partition is used now. The NescScanner 
 * divides this default partition into smaller partitions.
 */
class NescPartitionScanner extends RuleBasedPartitionScanner {
	public NescPartitionScanner() {
		setPredicateRules(null);
	}
}
