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
  char *s;
  const char *p;
  int i;
  uint16_t len = 0;
  error_t rval;
  uint8_t buf[PRINT_BUF_SIZE];
  va_list ap;

  if (print_rsvp() == SUCCESS) {
    va_start(ap, fmt);
    p = fmt;
    while(*p != '\0') {
      if (*p != '%') {
        buf[len++] = *p;
      }
      else {
        switch(*(++p)) {
        case 'c':
          i = va_arg(ap, int);
          buf[len++] = i;
          break;
        case 'd':
          i = va_arg(ap, int);
          s = itoa(i, &buf[len], 10);
          len += strlen(s);
          break;
        case 's':
          s = va_arg(ap, char*);
          strcpy(&buf[len], s);
          len += strlen(s);
	  break;
        case 'x':
          i = va_arg(ap, int);
          s = itoa(i, &buf[len], 16);
          len += strlen(s);
          break;
        case '%':
          buf[len++] = '%';
          break;
        }
      }
      p++;
    }
    va_end(ap);
    rval = print_spool(buf, len);
  }
  else {
    rval = EBUSY;
  }
  return rval;
}

#endif
