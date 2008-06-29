package nescdt.utils;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.StringTokenizer;

import nescdt.NescPlugin;
import nescdt.constants.NescImages;
import nescdt.constants.NescKeywords;
import nescdt.constants.NescStrings;

import org.eclipse.core.resources.IFile;
import org.eclipse.core.resources.IResource;
import org.eclipse.core.runtime.CoreException;

// Utils
public class NU {

	// is the file a nc file
	public static boolean isNescFile(IResource resource) {
		boolean ret;
		if (resource.getType() == IResource.FILE) {
			IFile fileobj = (IFile) resource;
			String ext = fileobj.getFileExtension();

			if (ext == null) {
				ret = false;
			} else {
				// only interested in nc files
				if (ext.equals(NescStrings.NCFILEEXT)) {
					ret = true;
				} else {
					ret = false;
				}
			}
		} else {
			ret = false;
		}
		return ret;
	}

	// is the file an interface
	public static boolean isNescInterfaceFile(IFile ifile) {
		boolean ret = false;
		String[] lines = NU.getAllLines(ifile, false);

		for (int i = 0; i < lines.length; i++) {
			String line = lines[i];
			if (line.trim().startsWith("module")
					|| line.trim().startsWith("configuration")
					|| line.trim().startsWith("generic module")
					|| line.trim().startsWith("generic configuration"))
				break;

			if (line.trim().startsWith("interface")) {
				ret = true;
				break;
			}
		}

		return ret;
	}

	public static String[] getAllLines(IFile fileobj, boolean comments) {
		ArrayList<String> lines = new ArrayList<String>();
		try {
			BufferedReader nccontent = new BufferedReader(
					new InputStreamReader(fileobj.getContents()));
			try {
				// Read a line of the file as long as there are lines to read
				String ncline;
				boolean comment = false;
				while ((ncline = nccontent.readLine()) != null) {

					if (ncline.trim().startsWith("/*")) {
						comment = true;
					} else if (ncline.trim().endsWith("*/")) {
						comment = false;
					}

					// go on if it is not a multiline comment and it is not a
					// single line
					// comment
					if (comments
							|| (!comment && !ncline.trim().startsWith("//"))) {
						lines.add(ncline.trim());
					}
				}
			} catch (IOException e) {
				e.printStackTrace();
			}
			nccontent.close();
		} catch (CoreException ce) {
			ce.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}

		return lines.toArray(new String[lines.size()]);

	}

}
