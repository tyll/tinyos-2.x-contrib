/*
 * "Copyright (c) 2008 The Regents of the University  of California.
 * All rights reserved."
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 *
 * IN NO EVENT SHALL THE UNIVERSITY OF CALIFORNIA BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE UNIVERSITY OF
 * CALIFORNIA HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * THE UNIVERSITY OF CALIFORNIA SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE UNIVERSITY OF CALIFORNIA HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS."
 *
 */
#ifndef SFSOURCE_H
#define SFSOURCE_H

#ifdef __cplusplus
extern "C" {
#endif

int open_sf_source(const char *host, int port);
/* Returns: file descriptor for TinyOS 2.0 serial forwarder at host:port, or
     -1 for failure
 */

int init_sf_source(int fd);
/* Effects: Checks that fd is following the TinyOS 2.0 serial forwarder 
     protocol. Use this if you obtain your file descriptor from some other
     source than open_sf_source (e.g., you're a server)
   Returns: 0 if it is, -1 otherwise
 */

void *read_sf_packet(int fd, int *len);
/* Effects: reads packet from serial forwarder on file descriptor fd
   Returns: the packet read (in newly allocated memory), and *len is
     set to the packet length
*/

int write_sf_packet(int fd, const void *packet, int len);
/* Effects: writes len byte packet to serial forwarder on file descriptor
     fd
   Returns: 0 if packet successfully written, -1 otherwise
*/

#ifdef __cplusplus
}
#endif

#endif
