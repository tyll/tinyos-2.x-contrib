package net.tinyos.tools;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.HashMap;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class SensorSchemeUtils {

	// Copied from http://www.javapractices.com/topic/TopicAction.do?Id=42
	public static String getContents(File aFile) {
		StringBuilder contents = new StringBuilder();
		try {
			// use buffering, reading one line at a time
			// FileReader always assumes default encoding is OK!
			BufferedReader input = new BufferedReader(new FileReader(aFile));
			try {
				String line = null; // not declared within while loop
				/*
				 * readLine is a bit quirky : it returns the content of a line
				 * MINUS the newline. it returns null only for the END of the
				 * stream. it returns an empty String if two newlines appear in
				 * a row.
				 */
				while ((line = input.readLine()) != null) {
					contents.append(line);
					contents.append(System.getProperty("line.separator"));
				}
			} finally {
				input.close();
			}
		} catch (IOException ex) {
			ex.printStackTrace();
		}

		return contents.toString();
	}

	public static HashMap<Integer, String> loadSymbols(String fileName) throws IOException {
		File symbolsFile = new File(fileName);
		if (!symbolsFile.exists()) {
			throw new IOException("File does not exist: " + fileName);
		} else if (!symbolsFile.canRead()) {
			throw new IOException("Permission denied: " + fileName);
		}

		String unparsedSymbolsMap = getContents(symbolsFile);

		Pattern getSymbolsPattern = Pattern.compile("\\(+\"?(.*?)\"?[\\s](-?[0-9]+)\\)+");
		Matcher getSymbolsMatcher = getSymbolsPattern.matcher(unparsedSymbolsMap);
		HashMap<Integer, String> buildMap = new HashMap<Integer, String>();
		while (getSymbolsMatcher.find()) {
			buildMap.put(Integer.valueOf(getSymbolsMatcher.group(2)),
					getSymbolsMatcher.group(1));
		}
		return buildMap;
	}
	
	public static String expandSymbols(String input, HashMap<Integer, String> symbols){
		int start=0;
		String expandedString="";
	    Pattern symbolPattern=Pattern.compile("\\%s(-?[0-9]+)");
	    Matcher symbolMatcher=symbolPattern.matcher(input);
	    while (symbolMatcher.find()){
	    	expandedString+=input.subSequence(start, symbolMatcher.start());
	    	expandedString+=symbols.get(Integer.valueOf(symbolMatcher.group(1)));
	    	start=symbolMatcher.end();
	    }
	    expandedString+=input.subSequence(start, input.length());
	    return expandedString;
	}
}
