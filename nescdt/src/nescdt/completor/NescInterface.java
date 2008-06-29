package nescdt.completor;

import nescdt.utils.*;
import java.util.ArrayList;

import org.eclipse.core.resources.IFile;

/**
 * Represents a interface. It will build up a list of functions. (Not in use
 * yet).
 */
public class NescInterface {
	String iName = "";

	ArrayList<String> functions;

	IFile ifile;

	public NescInterface(IFile file) {
		ifile = file;
		functions = new ArrayList<String>();
		// if (ifile.getName().equalsIgnoreCase("At45db.nc")) // use this line to filter when debugging
		{
			//System.out.println("interface scan:" + ifile.getName());
			parse();
		}
	}

	public void parse() {
		String[] lines = NU.getAllLines(ifile, false);
        boolean interfacefound = false;
		for (int i = 0; i < lines.length; i++) {
			String line = lines[i];

			
			if (!interfacefound && line.trim().startsWith("interface")) {
				int interfacenamestart = "interface".length();
				while (interfacenamestart < line.length()
						&& line.charAt(interfacenamestart++) != ' ')
					;

				int interfaceend = interfacenamestart;

				while (interfaceend < line.length()
						&& line.charAt(interfaceend++) != '{')
					;

				String interfacesig = line.substring(interfacenamestart,
						interfaceend-1).trim();
				iName = interfacesig;
				//System.out.println("interfacesig:" + interfacesig);
				interfacefound = true;
			} 
			
			if(interfacefound) {

				int paranPos = line.indexOf('(');
				int startPos = paranPos;
				if (paranPos != -1) {
					while (startPos >= 0 && line.charAt(--startPos) != ' ')
						;

					String func = line.substring(startPos, line.length() - 1).trim();
					functions.add(func);
					//System.out.println("func:" + func);
				}
			}

		}
		//System.out.println("lines:" + lines.length);
	}

	public String getIName() {
		return iName;
	}

	public String[] getIFuncs() {
		return functions.toArray(new String[functions.size()]);
	}
}
