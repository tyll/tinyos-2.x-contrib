
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
 * ARCHED ROCK OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE
 */

package com.rincon.comports;

import java.util.Comparator;
import java.util.Enumeration;
import java.util.Iterator;
import java.util.Set;
import java.util.TreeSet;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.comm.CommPortIdentifier;



public class ComPorts {

	/** Currently connected COM port */
	private String comPort;


	/**
	 * Constructor
	 * 
	 * @param printStatus
	 *            Print the status to the console if true
	 */
	public ComPorts() {
		Set comPorts = getComPorts();
		
		for (Iterator comIt = comPorts.iterator(); comIt.hasNext(); ) {
			comPort = (String) comIt.next();
			System.out.print(comPort + "\t");
		}
		System.out.println("");
	}

	/**
	 * Get a list of Strings with each available COMx port name
	 * 
	 * @return List of Strings
	 */
	private Set getComPorts() {
		Enumeration ports = CommPortIdentifier.getPortIdentifiers();

		Set listports = new TreeSet(
			// The following anonymous Comparator class ensures the
			// COMMPortIdentifier String names beginning with "COM"
			// are sorted by their integer COM port id value rather
			// than lexigraphically, e.g. COM2 < COM10.
			new Comparator() {
				public final int compare(Object p1, Object p2) {
					Pattern p = Pattern.compile("^(.*)(\\d+)$");
					Matcher m1 = p.matcher((String) p1);
					Matcher m2 = p.matcher((String) p2);
					if (m1.matches() && m2.matches()) {
						if (m1.group(1).equals(m2.group(1))) {
							p1 = new Integer(Integer.parseInt(m1.group(2)));
							p2 = new Integer(Integer.parseInt(m2.group(2)));
						} else {
							p1 = new String(m1.group(1));
							p2 = new String(m2.group(1));
						}
					}
					return ((Comparable) p1).compareTo(p2);
				}
			});

		while (ports.hasMoreElements()) {
			CommPortIdentifier current = (CommPortIdentifier) ports
					.nextElement();
			if (current.getPortType() == CommPortIdentifier.PORT_SERIAL) {
				if (!current.isCurrentlyOwned()) {
					listports.add(current.getName());
				}
			}
		}

		if (listports.size() == 0) {
			System.err.println("No COM ports found. Is win32comm.dll in the correct location?");
		}

		return listports;
	}

	public static void main(String[] args) {
		new ComPorts();
	}
}
