package nescdt.completor;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.StringTokenizer;

import nescdt.NescPlugin;
import nescdt.utils.NU;

import org.eclipse.core.resources.IFile;
import org.eclipse.core.resources.IProject;
import org.eclipse.core.resources.IProjectDescription;
import org.eclipse.core.resources.IResource;
import org.eclipse.core.resources.IResourceVisitor;
import org.eclipse.core.resources.IWorkspace;
import org.eclipse.core.resources.IWorkspaceRoot;
import org.eclipse.core.resources.ResourcesPlugin;
import org.eclipse.core.runtime.CoreException;
import org.eclipse.core.runtime.IProgressMonitor;

/**
 * It visit all files in the project (including linkes source folders). Then it
 * scans the nesc files for strings.
 */
public class NescParser {
	public static ArrayList<NescInterface> interfaces = new ArrayList<NescInterface>();

	public static int NESCINTERFACE = 0;
	public static int NESCCONFIGURATION = 1;
	public static int NESCMODULE = 2;

	public static int cnt = 0;

	private static IProgressMonitor myipm;

	// True if scanning of a multiline comment is taking place
	private static boolean comment;
	private static int parsecnt = 0;

	public static void parse(IProgressMonitor ipm) {
		myipm = ipm;

		// Count files and set it here...
		myipm.beginTask("Completion Scanner", 10000);

		System.out.println("Parsing...");

		IResourceVisitor visitor = new IResourceVisitor() {

			public boolean visit(IResource resource) throws CoreException {
				// System.out.println("visiting:" + resource.getName());

				if (NU.isNescFile(resource)) {
					// System.out.println("---parsecnt:"+parsecnt);
					// myipm.subTask(resource.getName());
					myipm.worked(parsecnt++);
					parse((IFile) resource);
					if(NU.isNescInterfaceFile((IFile) resource))
						NescPlugin.getCompProc().addIProposal(new NescInterface((IFile) resource));
				}

				return true;
			}
		};

		IWorkspace workspace = ResourcesPlugin.getWorkspace();
		IWorkspaceRoot root = workspace.getRoot();
		IProject ip[] = root.getProjects();

		for (int j = 0; j < ip.length; j++) {
			try {
				if (NescPlugin.isNescdtProject(ip[j])) {
					ip[j].accept(visitor);
				}
			} catch (CoreException e) {
				e.printStackTrace();
			}
		}
		myipm.done();
	}

	/*
	 * Scans a file and calls other functions for detailed scanning.
	 */
	public static void parse(IFile ncf) {
		cnt++;
		comment = false;
		// System.out.println("Parsing (" + cnt + "):" + ncf.getName());
		try {
			BufferedReader bufin = new BufferedReader(new InputStreamReader(ncf
					.getContents()));
			parseContent(bufin);
		} catch (CoreException e) {
			e.printStackTrace();
		}
		System.out.println(" ");
		// interfaces.add(new NescInterface(ncf));
	}

	/**
	 * Scans the content of a file (represented by a buffer).
	 * 
	 * @param bufin
	 */
	private static void parseContent(BufferedReader bufin) {
		String line;
		try {
			while ((line = bufin.readLine()) != null) {
				// System.out.print(" :");
				// System.out.println(line);
				parseLine(line);
			}
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	/**
	 * Scans each line by tokenizing it. It will try to clean the words
	 * encountered. For example it will split words with punction marks and
	 * remove trailing symbols.
	 * 
	 * @param line
	 */
	private static void parseLine(String line) {
		if (line.trim().startsWith("/*")) {
			comment = true;
		} else if (line.trim().endsWith("*/")) {
			comment = false;
		}

		// go on if it is not a multiline comment and it is not a single line
		// comment
		if (!comment && !line.trim().startsWith("//")) {
			// Allow: _ # .
			StringTokenizer tok = new StringTokenizer(line,
					" \t\n\r\f!,;:+-*/\\<>\"¤%&/(){}[]=?`´|^¨~'$£@", false);

			ArrayList<String> al = new ArrayList<String>();
			while (tok.hasMoreElements()) {
				String str = (String) tok.nextElement();
				str = parseWord(str);
				if (str != null) {
					al.add(str);
				}
			}
			NescPlugin.getCompProc().addProposals(
					al.toArray(new String[al.size()]));
		}
	}

	/**
	 * All the rules for scanning a word.
	 * 
	 * @param word
	 * @return
	 */
	private static String parseWord(String word) {
		// System.out.print("ord:");
		// System.out.println(word);
		return word;
		// if(Character.isJavaIdentifierStart(str.charAt(0))) {
		// al.add(str);
		// }

	}

}
