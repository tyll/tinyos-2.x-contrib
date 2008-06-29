package nescdt.constants;

import java.util.Iterator;
import java.util.TreeSet;

// See various nescC.syn, vim, and emacs syntax files
public class NescKeywords {
	public static boolean setup = false;

	// public static TreeSet<String> SAFEKEYWORDS = new TreeSet<String>();
	public static final String AT_SAFE = "@safe"; //$NON-NLS-1
	public static final String SAFE_COUNT = "*COUNT"; //$NON-NLS-1$
	public static final String SAFE_SAFE = "*SAFE"; //$NON-NLS-1$
	public static final String SAFE_SIZE = "*SIZE"; //$NON-NLS-1$

	public static TreeSet<String> KEYWORDS = new TreeSet<String>();
	public static final String AS = "as"; //$NON-NLS-1$	
	public static final String ASM = "asm"; //$NON-NLS-1$	
	public static final String ASYNC = "async"; //$NON-NLS-1$
	public static final String ATOMIC = "atomic"; //$NON-NLS-1$
	public static final String BREAK = "break"; //$NON-NLS-1$
	public static final String CALL = "call"; //$NON-NLS-1$	
	public static final String CASE = "case"; //$NON-NLS-1$
	public static final String COMMAND = "command"; //$NON-NLS-1$	
	public static final String COMPONENTS = "components"; //$NON-NLS-1$
	public static final String CONFIGURATION = "configuration"; //$NON-NLS-1$	
	public static final String CONTINUE = "continue"; //$NON-NLS-1$
	public static final String DBG = "dbg"; //$NON-NLS-1$	
	public static final String DEFAULT = "default"; //$NON-NLS-1$
	public static final String DO = "do"; //$NON-NLS-1$	
	public static final String ELSE = "else"; //$NON-NLS-1$
	public static final String ENUM = "enum"; //$NON-NLS-1$
	public static final String EVENT = "event"; //$NON-NLS-1$	
	public static final String FOR = "for"; //$NON-NLS-1$
	public static final String GENERIC = "generic"; //$NON-NLS-1$
	public static final String GOTO = "goto"; //$NON-NLS-1$	
	public static final String IF = "if"; //$NON-NLS-1$
	public static final String IMPLEMENTATION = "implementation"; //$NON-NLS-1$	
	public static final String INCLUDES = "includes"; //$NON-NLS-1$
	public static final String INTERFACE = "interface"; //$NON-NLS-1$
	public static final String MODULE = "module"; //$NON-NLS-1$	
	public static final String NEW = "new"; //$NON-NLS-1$
	public static final String NORACE = "norace"; //$NON-NLS-1$
	public static final String POST = "post"; //$NON-NLS-1$	
	public static final String PROVIDES = "provides"; //$NON-NLS-1$
	public static final String RETURN = "return"; //$NON-NLS-1$
	public static final String SAFE = "@safe"; //$NON-NLS-1$	
	public static final String SIGNAL = "signal"; //$NON-NLS-1$
	public static final String SIZEOF = "sizeof"; //$NON-NLS-1$	
	public static final String STRUCT = "struct"; //$NON-NLS-1$
	public static final String SWITCH = "switch"; //$NON-NLS-1$
	public static final String TASK = "task"; //$NON-NLS-1$	
	public static final String UNSAFE = "@unsafe"; //$NON-NLS-1$
	public static final String USES = "uses"; //$NON-NLS-1$

	// TYPES
	public static TreeSet<String> TYPES = new TreeSet<String>();
	public static final String AUTO = "auto"; //$NON-NLS-1$	
	public static final String BOOL = "bool"; //$NON-NLS-1$
	public static final String CHAR = "char"; //$NON-NLS-1$	
	public static final String CONST = "const"; //$NON-NLS-1$
	public static final String DOUBLE = "double"; //$NON-NLS-1$	
	public static final String ERRORT = "error_t"; //$NON-NLS-1$
	public static final String EXTERN = "extern"; //$NON-NLS-1$	
	public static final String FLOAT = "float"; //$NON-NLS-1$
	public static final String INLINE = "inline"; //$NON-NLS-1$	
	public static final String INT = "int"; //$NON-NLS-1$
	public static final String INT16T = "int16_t"; //$NON-NLS-1$	
	public static final String INT32T = "int32_t"; //$NON-NLS-1$
	public static final String INT8T = "int8_t"; //$NON-NLS-1$	
	public static final String LONG = "long"; //$NON-NLS-1$
	public static final String MESSAGET = "message_t"; //$NON-NLS-1$
	public static final String REGISTER = "register"; //$NON-NLS-1$	
	public static final String RESTRICT = "restrict"; //$NON-NLS-1$
	public static final String RESULTT = "result_t"; //$NON-NLS-1$	
	public static final String SHORT = "short"; //$NON-NLS-1$
	public static final String SIGNED = "signed"; //$NON-NLS-1$	
	public static final String STATIC = "static"; //$NON-NLS-1$
	public static final String TYPEDEF = "typedef"; //$NON-NLS-1$
	public static final String UINT16T = "uint16_t"; //$NON-NLS-1$	
	public static final String UINT32T = "uint32_t"; //$NON-NLS-1$
	public static final String UINT8T = "uint8_t"; //$NON-NLS-1$
	public static final String UNION = "union"; //$NON-NLS-1$	
	public static final String UNSIGNED = "unsigned"; //$NON-NLS-1$
	public static final String VOID = "void"; //$NON-NLS-1$	
	public static final String VOLATILE = "volatile"; //$NON-NLS-1$

	// PREPROC
	public static TreeSet<String> PREPROC = new TreeSet<String>();
	public static final String PNDDEFINE = "#define"; //$NON-NLS-1$
	public static final String PNDELIF = "#elif"; //$NON-NLS-1$	
	public static final String PNDELSE = "#else"; //$NON-NLS-1$
	public static final String PNDENDIF = "#endif"; //$NON-NLS-1$	
	public static final String PNDERROR = "#error"; //$NON-NLS-1$
	public static final String PNDIF = "#if"; //$NON-NLS-1$	
	public static final String PNDIFDEF = "#ifdef"; //$NON-NLS-1$
	public static final String PNDIFNDEF = "#ifndef"; //$NON-NLS-1$	
	public static final String PNDINCLUDE = "#include"; //$NON-NLS-1$
	public static final String PNDLINE = "#line"; //$NON-NLS-1$	
	public static final String PNDPRAGMA = "#pragma"; //$NON-NLS-1$
	public static final String PNDUNDEF = "#undef"; //$NON-NLS-1$	
	public static final String FALSE = "FALSE"; //$NON-NLS-1$
	public static final String MAX = "MAX"; //$NON-NLS-1$	
	public static final String MIN = "MIN"; //$NON-NLS-1$
	public static final String NULL = "NULL"; //$NON-NLS-1$	
	public static final String TRUE = "TRUE"; //$NON-NLS-1$
	public static final String USDATA = "__DATA__"; //$NON-NLS-1$	
	public static final String USFILE = "__FILE__"; //$NON-NLS-1$
	public static final String USLINE = "__LINE__"; //$NON-NLS-1$	
	public static final String USSTDC = "__STDC__"; //$NON-NLS-1$
	public static final String USTIME = "__TIME__"; //$NON-NLS-1$	
	public static final String USFUNC = "__FUNC__"; //$NON-NLS-1$

	// Decorator patterns
	public static final String DECO_MODULE = "module"; //$NON-NLS-1$
	public static final String DECO_GENERIC_MODULE = "generic module"; //$NON-NLS-1$
	public static final String DECO_CONFIGURATION = "configuration"; //$NON-NLS-1$
	public static final String DECO_GENERIC_CONFIGURATION = "generic configuration"; //$NON-NLS-1$
	public static final String DECO_INTERFACE = "interface"; //$NON-NLS-1$

	/**
	 * The keyword, types and preproc treesets are set up.
	 */
	public static void setupKeywords() {
		if (!(setup)) {
			NescKeywords.KEYWORDS.add(NescKeywords.AS);
			NescKeywords.KEYWORDS.add(NescKeywords.ASM);
			NescKeywords.KEYWORDS.add(NescKeywords.ASYNC);
			NescKeywords.KEYWORDS.add(NescKeywords.ATOMIC);
			NescKeywords.KEYWORDS.add(NescKeywords.BREAK);
			NescKeywords.KEYWORDS.add(NescKeywords.CALL);
			NescKeywords.KEYWORDS.add(NescKeywords.CASE);
			NescKeywords.KEYWORDS.add(NescKeywords.COMMAND);
			NescKeywords.KEYWORDS.add(NescKeywords.COMPONENTS);
			NescKeywords.KEYWORDS.add(NescKeywords.CONFIGURATION);
			NescKeywords.KEYWORDS.add(NescKeywords.CONTINUE);
			NescKeywords.KEYWORDS.add(NescKeywords.DBG);
			NescKeywords.KEYWORDS.add(NescKeywords.DEFAULT);
			NescKeywords.KEYWORDS.add(NescKeywords.DO);
			NescKeywords.KEYWORDS.add(NescKeywords.ELSE);
			NescKeywords.KEYWORDS.add(NescKeywords.ENUM);
			NescKeywords.KEYWORDS.add(NescKeywords.EVENT);
			NescKeywords.KEYWORDS.add(NescKeywords.FOR);
			NescKeywords.KEYWORDS.add(NescKeywords.GENERIC);
			NescKeywords.KEYWORDS.add(NescKeywords.GOTO);
			NescKeywords.KEYWORDS.add(NescKeywords.IF);
			NescKeywords.KEYWORDS.add(NescKeywords.IMPLEMENTATION);
			NescKeywords.KEYWORDS.add(NescKeywords.INTERFACE);
			NescKeywords.KEYWORDS.add(NescKeywords.INCLUDES);
			NescKeywords.KEYWORDS.add(NescKeywords.MODULE);
			NescKeywords.KEYWORDS.add(NescKeywords.NEW);
			NescKeywords.KEYWORDS.add(NescKeywords.NORACE);
			NescKeywords.KEYWORDS.add(NescKeywords.POST);
			NescKeywords.KEYWORDS.add(NescKeywords.PROVIDES);
			NescKeywords.KEYWORDS.add(NescKeywords.RETURN);
			NescKeywords.KEYWORDS.add(NescKeywords.SAFE);
			NescKeywords.KEYWORDS.add(NescKeywords.SIGNAL);
			NescKeywords.KEYWORDS.add(NescKeywords.SIZEOF);
			NescKeywords.KEYWORDS.add(NescKeywords.STRUCT);
			NescKeywords.KEYWORDS.add(NescKeywords.SWITCH);
			NescKeywords.KEYWORDS.add(NescKeywords.TASK);
			NescKeywords.KEYWORDS.add(NescKeywords.UNSAFE);
			NescKeywords.KEYWORDS.add(NescKeywords.USES);

			NescKeywords.TYPES.add(NescKeywords.AUTO);
			NescKeywords.TYPES.add(NescKeywords.BOOL);
			NescKeywords.TYPES.add(NescKeywords.CHAR);
			NescKeywords.TYPES.add(NescKeywords.CONST);
			NescKeywords.TYPES.add(NescKeywords.DOUBLE);
			NescKeywords.TYPES.add(NescKeywords.ERRORT);
			NescKeywords.TYPES.add(NescKeywords.EXTERN);
			NescKeywords.TYPES.add(NescKeywords.FLOAT);
			NescKeywords.TYPES.add(NescKeywords.INLINE);
			NescKeywords.TYPES.add(NescKeywords.INT);
			NescKeywords.TYPES.add(NescKeywords.INT16T);
			NescKeywords.TYPES.add(NescKeywords.INT32T);
			NescKeywords.TYPES.add(NescKeywords.INT8T);
			NescKeywords.TYPES.add(NescKeywords.LONG);
			NescKeywords.TYPES.add(NescKeywords.MESSAGET);
			NescKeywords.TYPES.add(NescKeywords.REGISTER);
			NescKeywords.TYPES.add(NescKeywords.RESTRICT);
			NescKeywords.TYPES.add(NescKeywords.RESULTT);
			NescKeywords.TYPES.add(NescKeywords.SHORT);
			NescKeywords.TYPES.add(NescKeywords.SIGNED);
			NescKeywords.TYPES.add(NescKeywords.STATIC);
			NescKeywords.TYPES.add(NescKeywords.TYPEDEF);
			NescKeywords.TYPES.add(NescKeywords.UINT16T);
			NescKeywords.TYPES.add(NescKeywords.UINT32T);
			NescKeywords.TYPES.add(NescKeywords.UINT8T);
			NescKeywords.TYPES.add(NescKeywords.UNION);
			NescKeywords.TYPES.add(NescKeywords.UNSIGNED);
			NescKeywords.TYPES.add(NescKeywords.VOID);
			NescKeywords.TYPES.add(NescKeywords.VOLATILE);

			NescKeywords.PREPROC.add(NescKeywords.PNDDEFINE);
			NescKeywords.PREPROC.add(NescKeywords.PNDELIF);
			NescKeywords.PREPROC.add(NescKeywords.PNDELSE);
			NescKeywords.PREPROC.add(NescKeywords.PNDENDIF);
			NescKeywords.PREPROC.add(NescKeywords.PNDERROR);
			NescKeywords.PREPROC.add(NescKeywords.PNDIF);
			NescKeywords.PREPROC.add(NescKeywords.PNDIFDEF);
			NescKeywords.PREPROC.add(NescKeywords.PNDIFNDEF);
			NescKeywords.PREPROC.add(NescKeywords.PNDINCLUDE);
			NescKeywords.PREPROC.add(NescKeywords.PNDLINE);
			NescKeywords.PREPROC.add(NescKeywords.PNDPRAGMA);
			NescKeywords.PREPROC.add(NescKeywords.PNDUNDEF);
			NescKeywords.PREPROC.add(NescKeywords.FALSE);
			NescKeywords.PREPROC.add(NescKeywords.MAX);
			NescKeywords.PREPROC.add(NescKeywords.MIN);
			NescKeywords.PREPROC.add(NescKeywords.NULL);
			NescKeywords.PREPROC.add(NescKeywords.TRUE);
			NescKeywords.PREPROC.add(NescKeywords.USDATA);
			NescKeywords.PREPROC.add(NescKeywords.USFILE);
			NescKeywords.PREPROC.add(NescKeywords.USLINE);
			NescKeywords.PREPROC.add(NescKeywords.USSTDC);
			NescKeywords.PREPROC.add(NescKeywords.USTIME);
			NescKeywords.PREPROC.add(NescKeywords.USFUNC);
		}
		setup = true;
	}

	public static String[] getKeyWordsasStringArray() {
		if(!setup)
			setupKeywords();
		
		String allkeys[] = new String[NescKeywords.KEYWORDS.size()
				+ NescKeywords.TYPES.size() + NescKeywords.PREPROC.size()];

		int i = 0;
		Iterator<String> its = NescKeywords.KEYWORDS.iterator();
		while (its.hasNext()) {
			allkeys[i++] = its.next();
		}

		its = NescKeywords.TYPES.iterator();
		while (its.hasNext()) {
			allkeys[i++] = its.next();
		}
		its = NescKeywords.PREPROC.iterator();

		while (its.hasNext()) {
			allkeys[i++] = its.next();
		}

		return allkeys;
	}

}