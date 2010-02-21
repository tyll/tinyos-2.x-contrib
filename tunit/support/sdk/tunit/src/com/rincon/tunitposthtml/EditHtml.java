package com.rincon.tunitposthtml;


/*
 * Copyright (c) 2005-2006 Rincon Research Corporation
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * - Redistributions of source code must retain the above copyright
 *   notice, this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in the
 *   documentation and/or other materials provided with the
 *   distribution.
 * - Neither the name of the Rincon Research Corporation nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE
 * RINCON RESEARCH OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE
 */

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.FilenameFilter;
import java.io.IOException;
import java.io.PrintWriter;

import com.rincon.tunit.TUnit;

public class EditHtml {

	/**
	 * Insert all the PNG's found in the png directory into the given HTML file
	 * 
	 * @param htmlFile
	 * @param pngDir
	 */
	public static void insert(File htmlFile, File pngDir) {
		if (!htmlFile.exists() || !htmlFile.isFile() || !pngDir.exists()) {
			System.err.println("Couldn't locate one of the paths:");
			System.err.println(htmlFile.getAbsolutePath());
			System.err.println(pngDir.getAbsolutePath());
			return;
		}

		/*
		 * 1. See if this HTML file even needs to be edited
		 */
		File[] pngFiles = pngDir.listFiles(new FilenameFilter() {
			public boolean accept(File dir, String name) {
				return name.endsWith(".png");
			}
		});

		if (pngFiles.length == 0) {
			return;
		}

		/*
		 * 2. Read in the current HTML file, without the </body> or </html> tags
		 */
		String fileContents = "";

		try {
			BufferedReader in = new BufferedReader(new FileReader(htmlFile));
			String line;

			// Read in everything from the file except for </body> and </html>
			// Make sure we add in TUnit to the "Designed for use with" tag ;)
			// We won't get all the pages, but that's ok.
			while ((line = in.readLine()) != null) {
				line = line.replace("Designed for use with",
					"Designed for use with <a href=\"http://docs.tinyos.net/index.php/TUnit\">TUnit</a>,");
				if (!line.contains("</body>") && !line.contains("</html>")) {
					fileContents += line + "\n";
				}
			}

			in.close();

		} catch (IOException e) {
			System.err.println(e.getMessage());
		}

		/*
		 * 3. Add in image tags to our .png files
		 */
		fileContents += "<center>\n";

		for (int i = 0; i < pngFiles.length; i++) {
			fileContents += "  <br><br>\n";
			fileContents += "  <img src=\""
					+ getRelativePath(htmlFile, pngFiles[i]) + "\">\n";
		}

		fileContents += "</center>\n";
		fileContents += "</body>\n";
		fileContents += "</html>\n";

		/*
		 * Write the new file
		 */
		try {
			PrintWriter out = new PrintWriter(new BufferedWriter(
					new FileWriter(htmlFile)));
			out.write(fileContents);
			out.close();

		} catch (IOException e) {
			System.err.println(e.getMessage());
		}
	}

	/**
	 * Produce a relative path
	 * 
	 * @param htmlFile
	 * @param pngFile
	 * @return
	 */
	private static String getRelativePath(File htmlFile, File pngFile) {
		File htmlPath = new File(htmlFile.getParent());

		String path = "";
		while (TUnit.getBaseReportDirectory().compareTo(htmlPath) != 0) {
			path += "../";
			htmlPath = new File(htmlPath.getParent());
		}

		path += pngFile.getAbsolutePath().substring(
				TUnit.getBaseReportDirectory().getAbsolutePath().length() + 1)
				.replace('\\', '/');

		return path;
	}

}
