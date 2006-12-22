package com.rincon.progress.standalone;

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


/**
 * This is my CLI progress bar hack from Blackbook, but actually
 * it works just fine.
 * @author David Moss (dmm@rincon.com)
 *
 */
public class CliTransferProgress {

	/** The total number of characters written last time */
	private int lastCharsWritten;
	
	/** The total amount to do */
	private long totalAmount;
	
	/**
	 * Constructor
	 * @param total
	 */
	public CliTransferProgress(long total) {
		lastCharsWritten = 0;
		totalAmount = total;
	}
	
	public void update(long currentAmount) {
		// Erase the last stuff.
		for(int i = 0; i < lastCharsWritten; i++) {
			System.out.print('\b');
		}
		
		String output = "  [";
		
		int progressPercentage = ((int) (((float) currentAmount) / ((float) totalAmount)*100));
		
		// Check bounds
		if(progressPercentage < 0) {
			progressPercentage = 0;
		}
		
		if(progressPercentage > 100) {
			progressPercentage = 100;
		}

		for(int i = 0; i < 100; i++) {
			if(i % 2 == 0) {
				if (i <= progressPercentage) {
					output += '#';
				} else {
					output += ' ';
				}
			}
		}
		
		output += "] ";
		output += progressPercentage + "%";
		lastCharsWritten = output.length();
		System.out.print(output);
		
		if(progressPercentage == 100) {
			System.out.println('\n');
		}
	}
}
