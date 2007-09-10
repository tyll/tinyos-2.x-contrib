/*
 * "Copyright (c) 2007 The Regents of the University of California.
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and
 * its documentation for any purpose, without fee, and without written
 * agreement is hereby granted, provided that the above copyright
 * notice, the following two paragraphs and the author appear in all
 * copies of this software.
 * 
 * IN NO EVENT SHALL THE UNIVERSITY OF CALIFORNIA BE LIABLE TO ANY
 * PARTY FOR DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL
 * DAMAGES ARISING OUT OF THE USE OF THIS SOFTWARE AND ITS
 * DOCUMENTATION, EVEN IF THE UNIVERSITY OF CALIFORNIA HAS BEEN
 * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * 
 * THE UNIVERSITY OF CALIFORNIA SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE
 * PROVIDED HEREUNDER IS ON AN "AS IS" BASIS, AND THE UNIVERSITY OF
 * CALIFORNIA HAS NO OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT,
 * UPDATES, ENHANCEMENTS, OR MODIFICATIONS."
 *
 */

/**
 * A simple printf-like utility that writes to the raw serial port
 * using the standard TinyOS 2.0 UART libraries, so it should be
 * portable to any T2-compliant platform.
 *
 * @author Prabal Dutta <prabal@cs.berkeley.edu>
 */
#ifndef PRINT_H
#define PRINT_H
#include <stdio.h>
#include <stdarg.h>

enum {
  PRINT_BUF_SIZE = 80
};

// nesC entry point for C calls.
error_t print_rsvp();
error_t print_spool(uint8_t *buf, uint16_t len);

/**
 * The nesC entry point for <code>printf</code>.  Calling this from
 * nesC will output the expanded <code>fmt</code> string to the mote's
 * default UART with default UART parameters.
 *
 * @param  fmt   A printf-style format string: %c, %d, %s, %x supported.
 * @param  ...   Comma-separated parameter list matching fmt parameters.
 * @return SUCCESS if the call was queued for transmission.
 *         EBUSY   if the call failed because the transport is busy.
 *         FAIL    if the call failed for an indeterminate reason.
 */
error_t print(const char *fmt, ...) {
  error_t rval;
  char buf[PRINT_BUF_SIZE];
  int len = 0;
  va_list ap;

  if (print_rsvp() == SUCCESS) {
    va_start(ap, fmt);
    len = vsnprintf(buf, PRINT_BUF_SIZE, fmt, ap);
    va_end(ap);
    if (len > -1 && len < PRINT_BUF_SIZE) {
      // Fits in the buffer
    }
    else {
      // Will get truncated
    }
    rval = print_spool((uint8_t*)buf, len);
  }
  else {
    rval = EBUSY;
  }
  return rval;
}

#endif
