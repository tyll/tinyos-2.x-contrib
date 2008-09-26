package edu.umass.eflux;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Hashtable;
import java.util.Map;
import java.util.Set;

public class VirtualDirectory {
	String root;

	Hashtable<String, PrintWriter> writers;

	Hashtable<String, FileWriter> files;

	public VirtualDirectory(String root) {
		this.root = root;
		writers = new Hashtable<String, PrintWriter>();
		files = new Hashtable<String, FileWriter>();
	}

	public PrintWriter getWriter(String file) {
		PrintWriter result;

		result = writers.get(file);
		if (result == null) {
			try {
				FileWriter fw = new FileWriter(root + File.separator + file);
				files.put(file, fw);
				result = new PrintWriter(fw);
				writers.put(file, result);
			} catch (IOException ex) {
				ex.printStackTrace();
			}
		}
		return result;
	}

	public void flushAndClose() throws IOException {
		Set<Map.Entry<String, PrintWriter>> entries = writers.entrySet();
		for (Map.Entry<String, PrintWriter> e : entries)
			e.getValue().flush();

		Set<Map.Entry<String, FileWriter>> fileEntries = files.entrySet();
		for (Map.Entry<String, FileWriter> e : fileEntries)
			e.getValue().flush();

		for (Map.Entry<String, PrintWriter> e : entries)
			e.getValue().close();
	}
}
