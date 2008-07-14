package com.rincon.util;

import java.io.*;

/*
 * Copyright (c) 2004-2007 Rincon Research Corporation.  
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
 * Compares two files, byte by byte to determine if they are identical or not.
 * 
 * @author Jon Wyant (jrwy@rincon.com)
 * 
 */

public class FileCompare {
  /**
   * Compares two files, byte by byte to see if they are identical.
   * 
   * @param file1 -
   *          first file to compare
   * @param file2 -
   *          second file to compare
   * 
   * @return true if files are equal, false if not
   */
  public boolean compare(String file1, String file2) {
    int tmp1, tmp2;
    InputStream input1 = null;
    InputStream input2 = null;

    // check if files exist
    if (!new File(file1).exists() || !new File(file2).exists()) {
      return false;
    }

    try {

      // if comparing same files, return true
      if (file1 == file2) {
        return true;
      }

      // try to open files
      input1 = new FileInputStream(file1);
      input2 = new FileInputStream(file2);

      // neither input has any content to compare
      if (input1 == null && input2 == null) {
        return true;
      }

      // only one input has contents, so nothing to compare
      if (input1 == null || input2 == null) {
        return false;
      }

      // read in a byte at a time and compare from each input
      while (true) {
        tmp1 = input1.read();
        tmp2 = input2.read();

        // current bytes are not identical, so inputs are not equal
        if (tmp1 != tmp2) {
          break;
        }

        // at end of both inputs and everything identical to this
        // point, so inputs are equal
        if (tmp1 == -1 && tmp2 == -1) {
          return true;
        }
      }
    } catch (IOException ioe) {
    } finally {
      try {
        if (input1 != null) {
          input1.close();
        }

        if (input2 != null) {
          input2.close();
        }
      } catch (IOException ioe) {
      }
    }
    return false;
  }
}
