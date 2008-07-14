package com.rincon.util;

/*
 * Copyright (c) 2004-2006 Rincon Research Corporation.  
 * All rights reserved.
 * 
 * Rincon Research will permit distribution and use by others subject to
 * the restrictions of a licensing agreement which contains (among other things)
 * the following restrictions:
 * 
 *  1. No credit will be taken for the Work of others.
 *  2. It will not be resold for a price in excess of reproduction and 
 *      distribution costs.
 *  3. Others are not restricted from copying it or using it except as 
 *      set forward in the licensing agreement.
 *  4. Commented source code of any modifications or additions will be 
 *      made available to Rincon Research on the same terms.
 *  5. This notice will remain intact and displayed prominently.
 * 
 * Copies of the complete licensing agreement may be obtained by contacting 
 * Rincon Research, 101 N. Wilmot, Suite 101, Tucson, AZ 85711.
 * 
 * There is no warranty with this product, either expressed or implied.  
 * Use at your own risk.  Rincon Research is not liable or responsible for 
 * damage or loss incurred or resulting from the use or misuse of this software.
 */

/**
 * This is my CLI progress bar hack from Blackbook, but actually it works just
 * fine.
 * 
 * @author David Moss (dmm@rincon.com)
 * 
 */
public class TransferProgress {

  /** The total number of characters written last time */
  private int lastCharsWritten;

  /** The total amount to do */
  private long totalAmount;

  /**
   * Constructor
   * 
   * @param total
   */
  public TransferProgress(long total) {
    lastCharsWritten = 0;
    totalAmount = total;
  }

  public void update(long currentAmount) {
    // Erase the last stuff.
    if (currentAmount == 0) {
      return;
    }

    for (int i = 0; i < lastCharsWritten; i++) {
      System.out.print('\b');
    }

    String output = "  [";

    int progressPercentage = ((int) (((float) currentAmount)
        / ((float) totalAmount) * 100));

    // Check bounds
    if (progressPercentage < 0) {
      progressPercentage = 0;
    }

    if (progressPercentage > 100) {
      progressPercentage = 100;
    }

    for (int i = 0; i < 100; i++) {
      if (i % 2 == 0) {
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

    if (progressPercentage == 100) {
      System.out.println('\n');
    }
  }
}
